# 数据完整性规范

> 聚焦数据库设计、数据操作的正确性、性能和一致性

---

## 一、数据库建表设计

### Requirement: 表命名规范

数据库表和字段命名 SHALL 遵循统一规范。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 表名使用 `snake_case`，有业务前缀（如 `b_order`, `sys_config`）
- MUST: 字段名使用 `snake_case`
- MUST: 每个字段 MUST 有 COMMENT 注释说明业务含义
- MUST: 表 MUST 有 COMMENT 说明用途
- MUST NOT: 使用拼音或无意义缩写

---

### Requirement: 主键设计

每张表 SHALL 有且仅有一个主键。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 主键类型为 `BIGINT`，自增或 ID 生成器
- MUST: 主键字段命名为 `id`
- MUST: 主键单调递增（利于索引性能）
- MUST NOT: 使用业务字段作主键（如手机号、订单号）
- MUST NOT: 使用 UUID 作主键（索引效率差）
- MUST NOT: 使用复合主键

---

### Requirement: 审计字段

业务表 SHALL 包含标准审计字段。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 包含创建时间（`created_at` / `create_time`）
- MUST: 包含更新时间（`updated_at` / `update_time`）
- SHOULD: 包含创建人、修改人字段
- SHOULD: 包含版本号字段（`version`，用于乐观锁）
- SHOULD: 包含软删标记（`deleted_at` / `delete_flag`）
- MUST: 审计字段放在表定义末尾，顺序统一

---

### Requirement: 索引设计

索引 SHALL 遵循命名规范和数量限制。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 普通索引用 `idx_` 前缀（如 `idx_user_id`）
- MUST: 唯一索引用 `uniq_` 前缀（如 `uniq_phone`）
- MUST: 索引数量 ≤ 5 个/表
- SHOULD: 优先使用联合索引（满足最左前缀原则）
- MUST NOT: 创建冗余索引（已被其他索引包含的）
- SHOULD: WHERE 中高频查询字段加索引

---

### Requirement: 禁止使用高级数据库特性

数据一致性 SHALL 通过应用层保证。

**优先级**: 【强制】

#### MUST 条目速查

- MUST NOT: 使用外键约束（FK）— 阻碍分库分表、增加死锁风险
- MUST NOT: 使用触发器（Trigger）— 调试困难、行为隐蔽
- MUST NOT: 使用存储过程/函数 — 不利于版本控制
- MUST NOT: 使用视图（View）— 用应用层 ORM/QueryBuilder 实现复杂查询

**原因**:
- 外键增加写操作开销，使分库分表困难
- 触发器隐藏业务逻辑，增加排查难度
- 存储过程/视图不在代码仓库版本控制内

---

### Requirement: 字段类型规范

字段类型 SHALL 选型合理。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 金额/价格使用 `DECIMAL`，不用 `FLOAT`/`DOUBLE`（精度丢失）
- MUST: 状态/类型使用 `TINYINT`/`SMALLINT` + 注释说明值含义
- MUST: 字符串指定合理长度（`VARCHAR(50)` 而非默认 `VARCHAR(255)`）
- MUST: 时间字段使用 `DATETIME`/`TIMESTAMP`
- SHOULD: 字段设置 `NOT NULL DEFAULT` 默认值
- MUST NOT: 使用 `TEXT`/`BLOB` 存储结构化数据（用 `JSON` 类型或拆表）

---

## 二、数据操作规范

### Requirement: 使用 ORM / QueryBuilder

数据库操作 SHALL 使用 ORM 或 QueryBuilder。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 使用框架提供的 ORM / QueryBuilder 执行查询
- MUST NOT: 拼接原生 SQL 字符串（注入风险 + 不可移植）
- SHOULD: 复杂查询可用原生 SQL 但必须参数化

---

### Requirement: 禁止 N+1 查询

循环中 SHALL NOT 执行单条数据库查询。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 使用批量查询替代循环单条查询
- MUST: 批量查询结果用 Map 关联（按 ID 映射）
- MUST NOT: 在 for/while/foreach 循环中执行数据库查询

**✅ 模式**

```
// 1. 收集所有需要查询的 ID
ids = items.map(item => item.relatedId).unique()
// 2. 批量查询
relatedItems = db.findByIds(ids)
relatedMap = relatedItems.toMap(item => item.id)
// 3. 内存关联
items.forEach(item => item.related = relatedMap[item.relatedId])
```

**❌ 反例**

```
// ❌ 每次循环都查数据库
for item in items:
  related = db.findById(item.relatedId) // N+1 !
  item.related = related
```

---

### Requirement: 事务保证原子性

多表写操作 SHALL 包裹在事务中。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 多表写操作在同一事务中 🧠
- MUST: 事务失败时完整回滚
- MUST NOT: 手动 commit 后再做可能失败的操作
- SHOULD: 事务范围尽量小（不在事务中做 HTTP 调用、文件 IO 等慢操作）

---

### Requirement: 并发安全

共享数据访问 SHALL 考虑并发安全。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 更新竞争资源时使用乐观锁（version 字段）或悲观锁 🧠
- MUST: "检查再操作"模式必须原子化（不能先 SELECT 再 UPDATE）
- SHOULD: 扣减库存/余额使用条件更新 `UPDATE ... SET amount = amount - ? WHERE amount >= ?`
- SHOULD: 使用唯一索引防止重复插入

---

### Requirement: 幂等性

可重试的操作 SHALL 保证幂等。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 消息消费/回调接口保证幂等 🧠
- SHOULD: 使用唯一业务 ID + 状态机防止重复处理
- SHOULD: INSERT 操作使用 INSERT IGNORE 或 ON DUPLICATE KEY

---

### Requirement: 批量操作优先

大量数据处理 SHALL 使用批量操作。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 批量插入替代循环单条插入
- MUST: 批量更新替代循环单条更新（`WHERE id IN (...)`）
- SHOULD: 批量操作数量设上限（如每批 500 条）
- MUST NOT: 在循环中执行 INSERT/UPDATE/DELETE

---

## 三、数据层代码组织

### Requirement: DAO 层标准结构

每个数据表对应的数据访问代码 SHALL 结构一致。

**优先级**: 【建议】

#### MUST 条目速查

- SHOULD: 每个表有标准的 DAO 层文件：Entity/Model → Repository/Mapper → Service
- SHOULD: Entity/Model 类只包含字段定义和简单映射，不含业务逻辑
- SHOULD: Repository/Mapper 只包含数据访问方法（CRUD + 自定义查询）
- SHOULD: 查询方法统一命名：`findByXxx` / `listByXxx` / `pageByXxx` / `getAndCheck`
- MUST NOT: 在 Entity/Model 中写业务逻辑
- MUST NOT: 在 Repository/Mapper 中做业务判断

### Requirement: QueryWrapper / 查询条件封装

复杂查询条件 SHALL 封装为查询对象。

**优先级**: 【建议】

#### MUST 条目速查

- SHOULD: 使用 QueryDTO 封装查询参数（分页 + 筛选条件）
- SHOULD: QueryWrapper/查询构建器的组装封装为私有方法（`buildQueryWrapper`）
- MUST NOT: 在 Controller/BizService 层直接拼接查询条件
