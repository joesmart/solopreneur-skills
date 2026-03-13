# 日志规范

> 极简日志原则：日志是给排查问题的人看的，不是给代码写注释的

---

### Requirement: 极简日志

日志 SHALL 极度克制，只在关键节点记录。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 入口方法记录最终结果（成功/失败 + 关键业务 ID）
- MUST: 异常/错误必须记录
- MUST: 第三方调用必须记录（入参摘要 + 结果/耗时）
- MUST NOT: 记录过程性日志（"开始处理..."、"正在校验..."、"保存成功"）🧠
- MUST NOT: 在循环/批量操作中逐条记录日志 🤖 `check-logging.sh`
- MUST NOT: 使用 debug 级别（生产环境无用）
- MUST NOT: 记录敏感信息（token/密码/密钥/完整身份证/手机号）🤖

---

### Requirement: 结构化日志

日志内容 SHALL 包含结构化的上下文信息。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 使用参数化日志（`log.info("msg {}", var)`），不用字符串拼接 🤖 `check-logging.sh`
- MUST: 包含业务 ID（userId, orderId 等可定位到具体数据的标识）
- MUST: 异常日志传递异常对象（保留堆栈）
- MUST NOT: 只记录 "Error occurred" 而无上下文

**✅ 正例**

```
// 入口方法最终结果
log.info("User created: id={}, email={}", user.id, user.email)

// 批量操作汇总
log.info("Users processed: total={}, success={}, failed={}", total, success, failed)

// 异常日志（含上下文 + 堆栈）
log.error("HTTP request failed: url={}, status={}", url, e.statusCode, e)
```

**❌ 反例**

```
// ❌ 过程性日志
log.info("Creating user...")
log.info("Normalizing input...")
log.info("Validating payload...")
log.info("User created successfully")

// ❌ 循环内日志
for user in users:
  log.info("Processing user: {}", user.id)

// ❌ 无上下文
log.error("Error occurred")
log.error("Processing failed: {}", e.message)  // 丢失堆栈
```
