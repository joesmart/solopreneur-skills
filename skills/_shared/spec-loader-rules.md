# Spec Loader Rules

根据任务类型加载对应的通用规范。

## 按任务类型加载

| 任务类型 | 必须加载的规范 |
|---------|---------------|
| **编写代码** | `clean-function`, `clean-naming`, `error-handling` |
| **代码审查** | 全部（先加载 `code-smells` 快速扫描） |
| **详细设计** | `clean-structure`, `data-integrity` |
| **代码重构** | `code-smells`, `clean-function`, `clean-structure` |
| **Bug 修复** | `error-handling`, `data-integrity` |
| **提交检查** | `code-smells` 快速检查清单（底部表格） |

## 按检查维度加载

| 维度 | 规范 |
|------|------|
| 函数设计 | `clean-function` |
| 命名质量 | `clean-naming` |
| 架构/职责 | `clean-structure` |
| 错误处理 | `error-handling` |
| 数据/DB | `data-integrity` |
| 安全 | `security` |
| 日志 | `logging` |
| 坏味道检测 | `code-smells` |

## 如何加载

从 Skill 目录加载：`../../specs/{spec-id}/spec.md`
