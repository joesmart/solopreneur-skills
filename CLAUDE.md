# CLAUDE.md

面向软件研发全流程的 AI 技能仓库。Version: **2.0.0**。

## Architecture

Skills 扁平排列在 `skills/` 目录下，分类通过 `.claude-plugin/marketplace.json` 定义。

当前仅包含 `dev-skills` 一个分类（9 个 Skills），覆盖设计、编码、审查三个阶段：

| Skills | 阶段 |
|--------|------|
| `overall-designer`, `detail-designer`, `project-map` | 设计 |
| `code-implementer`, `bugfix`, `refactorer` | 编码 |
| `code-reviewer`, `code-verifier`, `commit-checker` | 质量保障 |

每个 Skill 目录包含 `SKILL.md`（YAML front matter + 指令），可选 `scripts/`、`references/`、`steps/`。

## Running Scripts

所有 Skills 通过 `_shared/scripts/` 下的 Bash 脚本执行自动化检查：

```bash
SHARED="$(dirname "${CLAUDE_SKILL_DIR}")/_shared/scripts"
bash "$SHARED/<script-name>.sh" [args]
```

可用脚本（14 个）：

| 脚本 | 用途 |
|------|------|
| `check-method-length.sh` | 方法行数检查 |
| `check-naming.sh` | 命名规范检查 |
| `check-forbidden-patterns.sh` | 禁止模式检查 |
| `check-null-safety.sh` | 空值安全检查 |
| `check-sql-injection.sh` | SQL 注入检查 |
| `check-logging.sh` | 日志规范检查 |
| `detect-project-type.sh` | 项目类型检测 |
| `detect-tech-stack.sh` | 技术栈检测 |
| `resolve-specs.sh` | 解析适用规范 |
| `scan-dependencies.sh` | 依赖扫描 |
| `trace-callers.sh` | 调用链追踪 |
| `search-error-source.sh` | 错误来源搜索 |
| `analyze-diff.sh` | Diff 分析 |
| `gen-dir-tree.sh` | 目录树生成 |

## Shared Module

`skills/_shared/` 下的共享资源被所有 Skills 引用：

- `thinking-discipline.md` — AI 思维纪律（每步执行后自检）
- `quality-gates.md` — 10 项质量验收条件
- `spec-loader-rules.md` — 根据任务类型加载对应编码规范

## Specs

`specs/` 下 8 个语言无关编码规范，基于 Clean Code + 代码坏味道 + 重构方法论：

`clean-function` · `clean-naming` · `clean-structure` · `error-handling` · `data-integrity` · `security` · `logging` · `code-smells`

加载路径：`../../specs/{spec-id}/spec.md`（从 Skill 目录出发）。

## Skill Loading Rules

| Rule | Description |
|------|-------------|
| **Project skills first** | 项目 `skills/` 目录下的 Skill 覆盖用户级同名 Skill |
| **Specs on demand** | 按 `_shared/spec-loader-rules.md` 中的任务-规范映射按需加载 |

## Reference Docs

| Topic | File |
|-------|------|
| Skill 编写指南 | [docs/creating-skills.md](docs/creating-skills.md) |
| 规范索引 | [specs/README.md](specs/README.md) |
| 规范加载规则 | [skills/_shared/spec-loader-rules.md](skills/_shared/spec-loader-rules.md) |
| 质量验收条件 | [skills/_shared/quality-gates.md](skills/_shared/quality-gates.md) |
