# 安全编码规范

> 聚焦常见安全漏洞预防

---

### Requirement: 防止注入攻击

代码 SHALL 防止所有类型的注入攻击。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: SQL 使用参数化查询/预编译语句 🤖 `check-sql-injection.sh`
- MUST NOT: 字符串拼接 SQL 🤖 `check-sql-injection.sh`
- MUST NOT: 在 ORM 模板中使用原始字符串插值（如 MyBatis 的 `${}`，应用 `#{}`）🤖
- MUST: 用户输入必须校验后再使用
- MUST NOT: 直接将用户输入拼入命令行、LDAP、XPath 等

---

### Requirement: 敏感数据保护

代码 SHALL 保护敏感数据不被泄露。

**优先级**: 【强制】

#### MUST 条目速查

- MUST NOT: 在日志中记录密码、token、密钥、完整身份证号、完整手机号 🤖 `check-logging.sh`
- MUST NOT: 在 API 响应中返回密码、密钥等敏感字段
- MUST: 敏感配置（数据库密码、API Key）使用环境变量或密钥管理服务
- MUST NOT: 将敏感信息硬编码在源代码中
- SHOULD: 敏感数据在日志中脱敏（手机号 `138****1234`）

---

### Requirement: 认证与鉴权

敏感接口 SHALL 有认证和鉴权保护。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 所有数据修改接口要求认证
- MUST: 数据访问接口检查用户权限（不能访问其他用户的数据）
- MUST NOT: 仅凭客户端传的 userId 等参数信任用户身份
- SHOULD: 批量接口设置数量上限（防止恶意大批量请求）

---

### Requirement: 输入校验

所有外部输入 SHALL 在信任边界处校验。

**优先级**: 【强制】

#### MUST 条目速查

- MUST: 在 Controller/入口层校验参数（非空、类型、范围、格式）
- MUST NOT: 信任任何客户端传入的数据
- SHOULD: 使用框架自带的校验注解/装饰器
- SHOULD: 对字符串输入限制长度
