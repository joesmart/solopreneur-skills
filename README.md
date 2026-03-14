# Solopreneur Skills — 一人软件公司 AI 技能仓库

> 覆盖产品设计、软件研发、内容创作、视觉设计、工具和运维六大场景的 Claude Code Skills。
> 一个人 + AI = 一家软件公司。

## 🚀 快速安装

> **前提条件**：需要 [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview) CLI 工具。

### 方法一：Claude Code Plugin（推荐）

```bash
# 注册为插件市场
/plugin marketplace add joesmart/solopreneur-skills

# 安装 Skills
/plugin install dev-skills@solopreneur-skills
```

或者直接让 AI 帮你安装：

```
请从 github.com/joesmart/solopreneur-skills 安装 Skills
```

### 方法二：符号链接（本地开发推荐）

```bash
# 在你的项目根目录下执行
mkdir -p .claude/skills

# 链接所有 Skills
ln -s /path/to/solopreneur-skills/skills/* .claude/skills/

# 链接编码规范
ln -s /path/to/solopreneur-skills/specs .claude/specs
```

### 方法三：Git Submodule

```bash
git submodule add https://github.com/joesmart/solopreneur-skills.git .claude/solopreneur-skills
ln -s .claude/solopreneur-skills/skills/* .claude/skills/
```

---

## 📦 目录结构

```
solopreneur-skills/
├── CLAUDE.md                        # 项目指令
├── CHANGELOG.md                     # 变更日志
├── .claude-plugin/
│   ├── marketplace.json             # Marketplace 注册表（列出可安装 plugins）
│   └── plugin.json                  # Plugin manifest（声明 skills 等组件）
│
├── skills/                          # Skills（扁平排列，每个 Skill 一个目录）
│   ├── _shared/                     # 共享模块
│   │   ├── thinking-discipline.md   #   AI 思维纪律
│   │   ├── quality-gates.md         #   10 项质量验收条件
│   │   ├── spec-loader-rules.md     #   规范加载规则
│   │   └── scripts/                 #   14 个自动化检查脚本
│   │
│   ├── overall-designer/            # 🏗️  总体方案设计
│   ├── detail-designer/             # 📐  详细技术设计
│   ├── project-map/                 # 🗺️  项目架构地图
│   ├── code-implementer/            # ⌨️  代码实现
│   ├── bugfix/                      # 🐛  Bug 定位与修复
│   ├── refactorer/                  # ♻️  安全代码重构
│   ├── code-reviewer/               # 🔍  代码审查
│   ├── code-verifier/               # ✅  代码推演验证
│   └── commit-checker/              # 🚦  提交前检查
│
├── specs/                           # 通用编码规范（8 个，语言无关）
│   ├── clean-function/spec.md       #   函数整洁
│   ├── clean-naming/spec.md         #   命名整洁
│   ├── clean-structure/spec.md      #   结构整洁
│   ├── error-handling/spec.md       #   错误处理
│   ├── data-integrity/spec.md       #   数据完整性
│   ├── security/spec.md             #   安全编码
│   ├── logging/spec.md              #   日志规范
│   └── code-smells/spec.md          #   代码坏味道
│
├── docs/                            # 文档
│   └── creating-skills.md           #   Skill 编写指南
│
└── scripts/                         # 仓库维护脚本
    └── validate-skills.sh           #   Skill 格式校验
```

> **配置架构**：`marketplace.json` 是注册表（供 `/plugin marketplace add` 发现），`plugin.json` 是 manifest（声明 `"skills": "./skills/"` 供自动发现）。

---

## 🛠️ Skills 一览

### 💻 研发类（已就绪 · 9 个）

#### 设计阶段

| Skill | 触发词 | 用途 |
|-------|--------|------|
| **overall-designer** | `总体设计` `方案设计` | 大功能的高层设计：数据模型概要 + 核心流程 + 迭代计划 |
| **detail-designer** | `详细设计` `技术设计` | 具体功能的详设：DDL + E2E 流程图 + 实现任务列表 |
| **project-map** | `项目地图` `架构分析` | 生成 PROJECT_MAP.md 架构地图 |

#### 编码阶段

| Skill | 触发词 | 用途 |
|-------|--------|------|
| **code-implementer** | `实现代码` `写代码` | 按设计方案实现代码，逐步规范合规检查 |
| **bugfix** | `修bug` `排查问题` | 定位 Bug 根因 + 输出修复方案（不自动改代码） |
| **refactorer** | `重构` `优化代码结构` | 安全重构，保持行为不变 |

#### 质量保障阶段

| Skill | 触发词 | 用途 |
|-------|--------|------|
| **code-reviewer** | `review代码` `代码审查` | 脚本自动检查 + AI 深度审查 |
| **code-verifier** | `验证代码` `代码推演` | AI 逐行推演代码执行，找逻辑漏洞 |
| **commit-checker** | `提交检查` `检查一下` | 提交前快速扫描（90% 脚本驱动） |

---

### 🎯 产品设计类（规划中）

| Skill | 用途 |
|-------|------|
| **prd-generator** | 需求描述 → 结构化 PRD 文档 |
| **user-story** | 生成 Epic→Feature→Story 三层用户故事 |
| **competitor-analysis** | 竞品分析，输出对比表 + 差异化策略 |
| **mvp-planner** | MVP 范围划分，功能优先级矩阵 |

### 📝 内容创作类（规划中）

| Skill | 用途 |
|-------|------|
| **blog-writer** | 主题 → 大纲 → 技术博客全文 |
| **weekly-report** | 项目进展 → 结构化周报 |
| **copywriter** | 营销文案：产品介绍、落地页、社交媒体 |
| **tech-doc** | API 文档、架构文档、用户手册 |
| **seo-optimizer** | SEO 优化分析与建议 |

### 🎨 视觉创意类（规划中）

| Skill | 用途 |
|-------|------|
| **cover-image** | 文章封面图生成（多种风格） |
| **infographic** | 信息图生成 |
| **slide-deck** | PPT/演示文稿生成 |
| **screenshot-annotator** | 截图标注 |

### 🔧 工具类（规划中）

| Skill | 用途 |
|-------|------|
| **translator** | 多语言翻译（快速/标准/精修） |
| **url-to-markdown** | URL 内容提取为 Markdown |
| **markdown-to-html** | Markdown → 主题化 HTML |
| **image-compressor** | 图片压缩 |
| **format-markdown** | Markdown 格式化 |

### 🚀 运维运营类（规划中）

| Skill | 用途 |
|-------|------|
| **deploy-helper** | 部署辅助（Dockerfile / CI/CD 配置） |
| **log-analyzer** | 日志分析，提取异常模式 |
| **monitor-setup** | 监控配置生成 |
| **data-reporter** | 数据 → 可视化报表 |

---

## ⚙️ 设计理念

### 脚本做确定性的事，AI 做判断性的事

```
┌─────────────────────────────────────────────┐
│  🤖 脚本自动化（确定性检查）                   │
│  方法行数 · 命名规范 · 空值风险 · SQL 注入      │
│  禁止模式 · 日志规范 · 项目类型检测             │
└──────────────────────┬──────────────────────┘
                       ▼
┌─────────────────────────────────────────────┐
│  🧠 AI 深度分析（需要判断力）                   │
│  架构合理性 · 职责划分 · 设计方案评估            │
│  Bug 根因推演 · 代码逻辑验证 · 重构安全性        │
└─────────────────────────────────────────────┘
```

### 编码规范体系

基于 **Clean Code** + **代码坏味道** + **重构方法论**，语言无关：

| 规范 | 核心关注 |
|------|----------|
| `clean-function` | 函数短小、单一职责、SLAP 原则 |
| `clean-naming` | 意图表达、一致性、自文档化 |
| `clean-structure` | SOLID、分层调用、代码组织 |
| `error-handling` | 卫语句、异常分层、错误传播 |
| `data-integrity` | 事务、并发、幂等、N+1、批量 |
| `security` | 注入、XSS、敏感数据、鉴权 |
| `logging` | 极简日志、结构化、敏感信息 |
| `code-smells` | 22 类坏味道 + 重构手法 |

---

## 🔧 自定义扩展

### 添加新 Skill

详见 [docs/creating-skills.md](docs/creating-skills.md)。

### 添加新的检查脚本

在 `skills/_shared/scripts/` 下创建 `.sh` 脚本，遵循输出格式：

```bash
echo "## [Check Name]"
echo "| File | Line | Issue | Severity |"
echo "|------|------|-------|----------|"
# ... 检查逻辑，输出表格行 ...
echo "STATUS: PASS/WARN/FAIL"
```

### 添加新的规范

在 `specs/` 下新建目录和 `spec.md`，使用 Requirement/Scenario 格式。详见 [specs/README.md](specs/README.md)。

---

## 📄 License

MIT
