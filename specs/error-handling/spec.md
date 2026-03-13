# 错误处理规范

> 源自 Clean Code 第七章：错误处理 + 防御性编程原则

---

### Requirement: 使用异常而非错误码

错误处理 SHALL 使用异常机制而非返回错误码。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 用异常表示错误状态，而非返回特殊值（-1, null, empty）
- MUST: 异常包含足够的上下文信息（what, where, why）
- MUST NOT: 返回 null 表示错误 — 用空集合或 Optional 表示"无数据"
- MUST NOT: 使用空 catch 块吞掉异常 🤖 `check-forbidden-patterns.sh`

---

### Requirement: 卫语句优先

可预见的错误条件 SHALL 用卫语句（Early Return）处理。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 使用卫语句处理前置条件（null 检查、权限检查、状态检查）
- MUST: 先处理异常情况，让正常流程成为函数主体
- MUST NOT: 用多层嵌套 if 处理异常情况
- SHOULD NOT: 用 try-catch 处理可预见的状况（如 null 检查）

**✅ 正例**

```
public processUser(userId):
  if userId == null:
    throw IllegalArgumentException("userId 不能为空")
  user = userService.getById(userId)
  if user == null:
    throw BusinessException("用户不存在")
  if not user.isActive():
    throw BusinessException("用户已停用")
  // 正常流程
  doProcess(user)
```

**❌ 反例**

```
// ❌ 嵌套地狱
public processUser(userId):
  if userId != null:
    user = userService.getById(userId)
    if user != null:
      if user.isActive():
        doProcess(user)
```

---

### Requirement: 异常日志必须有上下文

捕获异常时 SHALL 记录完整的上下文信息。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 日志包含上下文（谁在做什么、处理什么数据、为什么失败）
- MUST: 异常对象作为日志参数传递（保留堆栈）
- MUST NOT: 只记录 "Error occurred" 或 e.getMessage() 而无上下文
- MUST NOT: 使用 e.printStackTrace() 🤖 `check-forbidden-patterns.sh`

---

### Requirement: 异常分层与传播

异常 SHALL 在正确的层级被捕获和处理。

**优先级**: 【建议】

#### MUST 条目速查

- SHOULD: 底层抛出技术异常，上层转译为业务异常
- SHOULD: 在边界处（Controller/入口）统一处理异常
- SHOULD NOT: 在每个方法中都 try-catch
- SHOULD NOT: 捕获后又重新抛出相同异常（无意义的捕获）
