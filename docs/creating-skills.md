# 创建新 Skill 指南

## Skill 目录结构

所有 Skills 扁平排列在 `skills/` 目录下（参考 [baoyu-skills](https://github.com/JimLiu/baoyu-skills)）。
分类通过 `.claude-plugin/marketplace.json` 管理，不使用子目录嵌套。

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

## 分类（通过 marketplace.json 管理）

| 场景 | marketplace.json 分组 |
|------|----------------------|
| 编码、调试、审查、重构 | `dev-skills` |
| 产品设计、需求分析 | `product-skills` |
| 博客、周报、文案写作 | `content-skills` |
| 封面图、信息图、PPT | `visual-skills` |
| 翻译、格式转换、图片处理 | `utility-skills` |
| 部署、监控、日志分析 | `ops-skills` |

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

## 注册到 marketplace.json

在 `.claude-plugin/marketplace.json` 对应分类的 `skills` 数组中添加路径：

```json
"./skills/<skill-name>"
```

## Checklist

- [ ] `SKILL.md` 包含正确的 YAML frontmatter
- [ ] description 使用第三人称
- [ ] 正文不超过 500 行
- [ ] 如有脚本，添加了 Script Directory 说明
- [ ] 在 `marketplace.json` 中注册
- [ ] 在 `README.md` 的 Skills 列表中添加
