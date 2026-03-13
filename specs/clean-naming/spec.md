# 命名整洁规范

> 源自 Clean Code 第二章：名称应该表达意图，自文档化，避免误导

---

### Requirement: 名称表达意图

标识符命名 SHALL 表达其存在的理由、做什么、怎么用。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 变量/函数/类名无需注释即可理解用途 🤖 `check-naming.sh`
- MUST NOT: 使用单字母变量（循环变量 i/j/k 除外）
- MUST NOT: 使用含糊缩写（`cnt`, `mgr`, `tmp`, `buf`, `proc`）
- MUST NOT: 使用无意义名称（`data`, `info`, `flag`, `result`, `list`）
- MUST: 布尔型用 `is/has/can/should` 前缀表达判断语义

#### Scenario: 自文档化命名

- **WHEN** 命名变量
- **THEN** 名称 MUST 回答三个问题：它是什么？为什么存在？怎么用？

**✅ 正例**

```
activeUsers = findActiveUsers()
retryCount = 0
isEmailVerified = user.emailVerifiedAt != null
maxConnectionTimeout = 30 * 1000

// 方法命名表达意图
sendWelcomeEmail(user)
findLeadsByCustomerId(customerId)
hasPermission(user, permission)
```

**❌ 反例**

```
list = getUsers()           // list 是什么？
cnt = 0                     // cnt 是什么的计数？
flag = check()              // flag 表示什么？
process(u)                  // process 做什么？u 是谁？
get(id)                     // get 什么？
```

---

### Requirement: 命名一致性

同一代码库 SHALL 对相同概念使用相同名称。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 同一概念全局统一命名（不混用 `get/fetch/retrieve/find/load/query`）
- MUST: 选定项目词汇表后始终遵守
- MUST NOT: 同一概念使用不同名称
- MUST NOT: 不同概念使用相同名称

#### Scenario: 统一查询命名

- **WHEN** 项目约定 `find` 表示"按条件查询"
- **THEN** 所有按条件查询的方法 MUST 统一使用 `find`
- **AND** MUST NOT 在其他方法中混用 `search`, `query`, `get`, `fetch`

---

### Requirement: 类名用名词，方法名用动词

类和方法的命名 SHALL 遵循词性规则。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 类名使用名词或名词短语（`User`, `OrderProcessor`, `PaymentGateway`）
- MUST: 方法名使用动词或动词短语（`save`, `calculateTotal`, `sendEmail`）
- MUST NOT: 类名使用动词（`ProcessData`, `ManageUser`）
- MUST NOT: 方法名使用名词（`user()`, `total()`——除非是 getter）
- MUST: 类名使用 PascalCase 🤖 `check-naming.sh`

---

### Requirement: 避免编码和前缀

命名 SHALL NOT 包含不必要的类型编码或匈牙利命名法。

**优先级**: 【建议】

#### MUST 条目速查

- SHOULD NOT: 使用匈牙利命名法（`strName`, `iCount`, `bActive`）
- SHOULD NOT: 在接口/实现中重复类型信息（`IUserService`/`UserServiceImpl`——选一种风格即可）
- SHOULD NOT: 使用成员前缀（`m_`, `_`——除非是语言惯例）

---

### Requirement: 命名长度与作用域匹配

标识符长度 SHOULD 与其作用域成正比。

**优先级**: 【建议】

#### MUST 条目速查

- SHOULD: 局部变量短命名（`user`, `order`）
- SHOULD: 全局/类成员长命名（`connectionPoolMaxSize`, `defaultRetryIntervalMs`）
- SHOULD: 函数作用域越大名称越具体
