# 函数整洁规范

> 源自 Clean Code 第三章：函数应该短小、只做一件事、保持单一抽象层次

---

### Requirement: 函数短小

函数体 SHALL 保持短小精悍。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 函数体实际代码行数 ≤ 25 行 🤖 `check-method-length.sh`
- MUST: 超过 25 行时按逻辑拆分为多个私有函数
- MUST NOT: 函数体超过 40 行

#### Scenario: 行数统计规则

- **WHEN** 统计函数体行数
- **THEN** 计入含可执行代码的行
- **AND** 不计函数签名行、纯空行、纯注释行、单独的括号行

#### Scenario: 超长函数拆分方法

- **WHEN** 函数体超过 25 行
- **THEN** MUST 按逻辑类别拆分为多个函数

| 逻辑类别 | 命名模式 |
|---------|---------|
| 数据归一化/转换 | `normalize*`, `convert*`, `transform*` |
| 数据校验 | `validate*`, `check*`, `ensure*` |
| 构建对象 | `build*`, `create*`, `compose*` |
| 持久化 | `save*`, `persist*`, `store*` |
| 通知/发送 | `notify*`, `send*`, `publish*` |
| 查询/获取 | `find*`, `get*`, `fetch*`, `load*` |

---

### Requirement: 函数只做一件事

每个函数 SHALL 只做一件事，并做好这件事。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 能用一句"做了 X"描述函数职责（不含"和"/"并且"）
- MUST: public 方法只做流程编排，不含业务实现细节 🧠
- MUST NOT: 在一个函数中混合不同抽象层次的操作
- MUST NOT: 函数名中包含 "And" 或 "Or"

#### Scenario: 入口方法只做流程编排

- **WHEN** 编写 public 入口方法
- **THEN** 方法体 MUST 只包含按序注释 + 方法调用
- **AND** 注释格式: `// n. 动词短语`
- **AND** 允许变量声明与传递、return
- **AND** MUST NOT 直接编写业务逻辑
- **AND** MUST NOT 包含多层嵌套的 if/for/try-catch

**✅ 正例**（伪代码）

```
public createUser(input):
  // 1. 规范化输入
  payload = normalizeInput(input)
  // 2. 校验数据
  validatePayload(payload)
  // 3. 检查唯一性
  ensureEmailUnique(payload.email)
  // 4. 保存用户
  user = saveUser(payload)
  // 5. 发送欢迎邮件
  sendWelcomeEmail(user)
  return user
```

**❌ 反例**

```
public createUser(input):
  // ❌ 在入口方法中直接编写所有细节
  payload = new Payload()
  payload.name = input.name != null ? input.name.trim() : null
  payload.email = input.email != null ? input.email.toLowerCase() : null
  if payload.name == null or payload.name.length < 2:
    throw ValidationException("姓名至少2个字符")
  user = new User()
  copyProperties(payload, user)
  db.insert(user)
  return user
```

---

### Requirement: 参数数量限制

函数参数 SHALL 尽量少。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 参数 ≥ 3 个时封装为对象
- SHOULD: 参数 ≤ 2 个（0 个最好，1 个次之）
- MUST NOT: 使用 boolean 标志参数（flag argument）——拆为两个函数

#### Scenario: 参数对象化

- **WHEN** 函数需要 3 个或以上参数
- **THEN** MUST 将参数封装为参数对象（DTO/Input/Params）

---

### Requirement: 避免副作用

函数 SHALL NOT 产生隐藏的副作用。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 函数名准确描述其所有行为（包括副作用）
- MUST NOT: 在 getter/查询方法中修改状态
- SHOULD: 命令与查询分离（CQS）——要么改变状态，要么返回数据，不同时做

---

### Requirement: 单一抽象层次（SLAP）

函数体内的语句 SHALL 处于同一抽象层次。

**优先级**: 【建议】

#### MUST 条目速查

- SHOULD: 函数体内所有语句处于同一抽象层次
- SHOULD NOT: 在高层编排代码中混入低层实现细节

**✅ 正例**

```
// 同一抽象层次：都是业务步骤调用
public processOrder(order):
  validateOrder(order)
  calculateTotal(order)
  applyDiscount(order)
  saveOrder(order)
```

**❌ 反例**

```
// ❌ 混合抽象层次：高层编排 + 低层数据库操作
public processOrder(order):
  validateOrder(order)                        // 高层
  total = 0                                   // 低层
  for item in order.items:                    // 低层
    total += item.price * item.quantity       // 低层
  order.total = total                         // 低层
  db.execute("UPDATE orders SET ...")         // 底层
```
