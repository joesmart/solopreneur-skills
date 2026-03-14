# 创建新 Skill 指南

## Skill 目录结构

所有 Skills 扁平排列在 `skills/` 目录下（参考 [baoyu-skills](https://github.com/JimLiu/baoyu-skills)）。
通过 `.claude-plugin/plugin.json` 注册为 Plugin，Claude Code 自动发现 `skills/` 下的所有 Skill。

```
skills/<skill-name>/
├── SKILL.md              # 主指令文件（YAML frontmatter + 说明）
├── steps/                # [可选] 详细步骤文档（渐进式加载）
│   ├── 1.1-xxx.md
│   └── 1.2-xxx.md
├── references/           # [可选] 参考资料
├── scripts/              # [可选] 自动化脚本
└── prompts/              # [可选] Prompt 模板
```

## Plugin 注册

Skill 放入 `skills/<skill-name>/` 目录后，Claude Code 会通过 `.claude-plugin/plugin.json` 的 `"skills": "./skills/"` 配置自动发现，无需手动注册路径。

## SKILL.md 模板

```yaml
---
name: <skill-name>
description: >
  第三人称描述。说明 Skill 的功能 + 使用时机。
  触发词："关键词1"、"关键词2"。
  不适用于：xxx。
argument-hint: "<参数说明>"
---
```

### 关键要求

| 要求 | 说明 |
|------|------|
| **name** | 小写字母+连字符，不超过 64 字符 |
| **description** | 第三人称，不超过 1024 字符，包含 what + when |
| **SKILL.md 正文** | 不超过 500 行，复杂内容用 `references/` |
| **引用深度** | 从 SKILL.md 只引用一层深度的文件 |

## 引用共享模块

研发类 Skills 可引用 `_shared/` 模块：

```bash
# 脚本引用（从 skills/<name>/ 出发）
SHARED="$(dirname "${CLAUDE_SKILL_DIR}")/_shared/scripts"
bash "$SHARED/check-method-length.sh" <files>
```

```markdown
<!-- Markdown 引用 -->
[thinking discipline](../_shared/thinking-discipline.md)
[quality gates](../_shared/quality-gates.md)
```

## 引用编码规范

```markdown
<!-- 从 skills/<name>/ 加载 spec -->
Load spec: `../../specs/{spec-id}/spec.md`
```

## 注册到 Plugin

只需将 Skill 目录放在 `skills/` 下，`plugin.json` 中 `"skills": "./skills/"` 会自动发现。无需手动添加路径。

## Checklist

- [ ] `SKILL.md` 包含正确的 YAML frontmatter
- [ ] description 使用第三人称
- [ ] 正文不超过 500 行
- [ ] 如有脚本，添加了 Script Directory 说明
- [ ] Skill 目录已放在 `skills/` 下（自动注册）
- [ ] 在 `README.md` 的 Skills 列表中添加
