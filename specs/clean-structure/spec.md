# 结构整洁规范

> 源自 Clean Code 第十章（类）+ SOLID 原则 + 分层架构 + 调用链路管理

---

### Requirement: 单一职责原则（SRP）

类和模块 SHALL 只有一个改变的理由。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 每个类/模块只负责一个业务概念 🧠
- MUST: 能用一句话描述类的职责（不含"和"/"并且"）
- MUST NOT: 单个类超过 300 行（强烈的 SRP 违反信号）🤖 `check-method-length.sh`
- SHOULD: 类的公开方法数 ≤ 7 个

#### Scenario: 职责判定方法

- **WHEN** 审查类的设计
- **THEN** 提问："哪些变化原因会导致修改这个类？"
- **AND** 如果原因 > 1 个 → 违反 SRP → 需要拆分

---

### Requirement: 分层调用架构

代码 SHALL 遵守分层架构的职责边界和调用规范。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 分层职责清晰，每层只做该层的事 🧠
- MUST: 调用方向严格向下，禁止反向或跨层调用 🧠
- MUST NOT: 表现层包含业务逻辑
- MUST NOT: 数据层包含业务判断
- MUST NOT: 跨层调用（表现层直接调用数据层）
- MUST NOT: 下层反向调用上层

#### Scenario: 三层职责定义

| 层级 | 职责 | 允许做 | 禁止做 |
|------|------|--------|--------|
| **表现层** (Controller/Handler) | 接收请求 → 调用业务层 → 封装响应 | 参数校验、DTO→业务对象转换、响应包装 | 业务判断、DB操作、调用其他服务 |
| **业务层** (BizService/UseCase) | 业务流程编排 | 组合多个领域服务、业务规则判断、事务控制 | 直接 DB 操作、HTTP 响应封装 |
| **数据层** (Repository/DAO/Mapper) | 数据持久化与查询 | CRUD、SQL 组装、结果映射 | 业务逻辑、参数校验 |

#### Scenario: 调用链路必须可追踪

- **WHEN** 从入口方法（Controller 接口）开始追踪
- **THEN** 必须能在 3 步以内（Controller → BizService → Service/DAO）到达持久化层
- **AND** 每个调用步骤的方法名 MUST 清晰表达该步在做什么
- **AND** MUST NOT 出现"穿透调用"——A 调 B 只为了调 C（A 应该直接调 C）

**✅ 正例**

```
// 清晰的 3 层调用链路
Controller.createOrder(dto)
  → orderBizService.createOrderAndNotify(dto)
      → orderService.save(order)           // 持久化
      → inventoryService.deduct(items)     // 领域服务
      → notificationService.send(event)    // 通知
```

**❌ 反例**

```
// ❌ 穿透调用：BizService 只是透传，没有编排价值
Controller.createOrder(dto)
  → orderBizService.createOrder(dto)       // 只转发
      → orderHelper.doCreate(dto)          // 再转发
          → orderProcessor.process(dto)    // 再转发
              → orderService.save(order)   // 终于到持久化
```

---

### Requirement: 类内代码组织

类内部的代码 SHALL 遵循自顶向下的"报纸式"排布。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 类内方法按"自顶向下"排列——公共方法在前，私有方法在后 🧠
- MUST: 被调用的方法紧跟在调用者下方（阅读时顺序流畅）
- MUST: 相关操作放在一起（高内聚）
- MUST NOT: 相关逻辑分散在类的不同位置
- SHOULD: 方法声明顺序：静态工厂 → 构造 → public → protected → private

#### Scenario: 自顶向下阅读

- **WHEN** 从上往下阅读一个类
- **THEN** 应该像读报纸——先看标题（public 方法），再看细节（private 方法）
- **AND** 每个 public 方法的 private 辅助方法应紧跟其后

**✅ 正例**

```
class OrderService:
  // 公共入口方法（标题）
  public createOrder(input):
    payload = validateAndNormalize(input)
    order = buildOrder(payload)
    saveOrder(order)
    return order

  // 紧跟的私有方法（细节）
  private validateAndNormalize(input): ...
  private buildOrder(payload): ...
  private saveOrder(order): ...

  // 另一个公共方法
  public cancelOrder(orderId):
    order = findOrderOrThrow(orderId)
    ensureCancellable(order)
    doCancel(order)

  // 紧跟的私有方法
  private findOrderOrThrow(orderId): ...
  private ensureCancellable(order): ...
  private doCancel(order): ...
```

**❌ 反例**

```
class OrderService:
  // ❌ 所有 public 方法堆在一起，private 方法堆在另一处
  public createOrder(input): ...
  public cancelOrder(orderId): ...
  public updateOrder(input): ...
  // ... 看完 public 回头找 private，阅读不连贯
  private validateAndNormalize(input): ...
  private buildOrder(payload): ...
  private findOrderOrThrow(orderId): ...
```

---

### Requirement: 数据对象转换边界

DTO / VO / Entity 等数据对象的转换 SHALL 在明确的边界处完成。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 表现层入参使用 DTO，返回使用 VO 🧠
- MUST: DTO → Entity 的转换在业务层完成
- MUST: Entity → VO 的转换在业务层完成
- MUST NOT: Entity 直接暴露到表现层
- MUST NOT: DTO 直接穿透到数据层
- SHOULD: 转换逻辑封装在专用的 Converter/Assembler 中（而非散落在业务代码中）

#### Scenario: 数据对象流转

```
Controller               BizService                   DAO/Repository
接收 DTO ──→  DTO → Entity (转换) ──→  持久化 Entity
接收 VO  ←──  Entity → VO (转换)  ←──  查询 Entity
```

- **WHEN** 表现层接收请求
- **THEN** 使用 DTO 接收参数
- **AND** 在业务层将 DTO 转为 Entity 后传入数据层
- **AND** 在业务层将 Entity 转为 VO 后返回表现层

---

### Requirement: 避免循环依赖和隐式耦合

模块间 SHALL NOT 存在循环依赖或隐式耦合。

**优先级**: 【强制】

#### MUST 条目速查

- MUST NOT: A 依赖 B，B 又依赖 A（循环依赖）🧠
- MUST NOT: 通过静态方法/全局变量传递依赖（隐式耦合）
- MUST: 模块间通过构造注入的接口通信（显式依赖）
- SHOULD: 如果两个服务互相需要，提取共享逻辑到第三个服务

---

### Requirement: 开放封闭原则（OCP）

模块 SHOULD 对扩展开放，对修改关闭。

**优先级**: 【建议】

#### MUST 条目速查

- SHOULD: 新增功能通过扩展（新类/新方法）实现，而非修改已有代码
- SHOULD: 使用策略模式、模板方法等替代大量 if/else 或 switch
- SHOULD NOT: 在 switch/if-else 链中不断增加分支

---

### Requirement: 依赖倒置原则（DIP）

高层模块 SHOULD NOT 依赖低层模块的具体实现。

**优先级**: 【建议】

#### MUST 条目速查

- SHOULD: 高层模块依赖抽象（接口），不依赖具体实现类
- SHOULD: 通过依赖注入获取依赖，而非直接实例化
- SHOULD NOT: 在业务代码中 new 具体的基础设施类（DB连接、HTTP客户端等）

---

### Requirement: 模块内聚与松耦合

模块 SHALL 高内聚、松耦合。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 相关代码放在一起（高内聚）
- MUST NOT: 一个变更需要修改多个不相关的文件（散弹式修改——Shotgun Surgery）🧠
- SHOULD: 模块间通过明确的接口/契约通信
- SHOULD NOT: 模块间共享可变状态
