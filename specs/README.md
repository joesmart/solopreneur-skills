# OpenSpec 通用规范索引

> AI 必须读取此文件，根据检查维度加载对应规范

## 规范体系

基于 Clean Code、代码坏味道、重构方法论，提供语言无关的通用编码规范。

| 规范 ID | 名称 | 核心关注 |
|---------|------|---------|
| `clean-function` | 函数整洁规范 | 函数长度、参数、职责、抽象层次 |
| `clean-naming` | 命名整洁规范 | 自文档化命名、一致性、意图表达 |
| `clean-structure` | 结构整洁规范 | 类职责、模块边界、依赖方向 |
| `error-handling` | 错误处理规范 | 异常策略、卫语句、错误传播 |
| `data-integrity` | 数据完整性规范 | 事务、并发、幂等、N+1、批量 |
| `security` | 安全编码规范 | 注入、XSS、敏感数据、鉴权 |
| `logging` | 日志规范 | 极简日志、结构化、敏感信息 |
| `code-smells` | 代码坏味道检测清单 | 22 类坏味道识别与重构手法 |

## 使用方式

### code-implementer 使用
编写代码时加载：`clean-function`、`clean-naming`、`clean-structure`、`error-handling`

### code-reviewer 使用
审查代码时加载：全部规范（先读 `code-smells` 做快速扫描，再深入具体规范）

### detail-designer 使用
设计时加载：`clean-structure`、`data-integrity`

### commit-checker 使用
快速检查时加载：`code-smells`（仅 MUST 条目）

## Spec 关键字

| 关键字 | 含义 |
|--------|------|
| MUST | 必须遵守，违反即为错误 |
| MUST NOT | 禁止，违反即为错误 |
| SHOULD | 建议遵守，有理由可例外 |
| MAY | 可选，视上下文决定 |

## 自动化检查标注

- 🤖 = 已有脚本自动检查（`_shared/scripts/` 中）
- 🧠 = 需要 AI 或人工判断
