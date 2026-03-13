---
name: project-mapper
description: >
  Generate a PROJECT_MAP.md architecture map for AI and humans to quickly
  understand project structure, module responsibilities, and call
  relationships. Use when user asks to map a project, understand architecture,
  or generate project overview. Triggers on "项目地图", "架构分析",
  "了解项目", "project map". Read-only analysis — does NOT modify any code.
argument-hint: "[optional: specific service or module to focus on]"
---

# Project Architecture Map Generator

Generate `PROJECT_MAP.md` at project root. Read-only, no code changes.

## Step 1: Detect Project Profile

Run automated detection:

```bash
SHARED="$(dirname "${CLAUDE_SKILL_DIR}")/_shared/scripts"
bash "$SHARED/detect-project-type.sh" .
bash "$SHARED/detect-tech-stack.sh" .
bash "$SHARED/gen-dir-tree.sh" . 3
```

Record: project type (monolith/microservices), tech stack, special traits.

## Step 2: Strategic Scan

### For Microservices:

**2.1 Service inventory**
- Scan each service directory: name, responsibility, tech stack, code path
- Check for: API Gateway, shared libraries, config services

**2.2 Inter-service calls**

```bash
SHARED="$(dirname "${CLAUDE_SKILL_DIR}")/_shared/scripts"
bash "$SHARED/scan-dependencies.sh" .
```

Record each: caller → callee, protocol (HTTP/MQ/RPC), purpose.

**2.3 Directory structure**
List 2-3 levels per service with role annotations.

### For Monolith:

**2.1 Module inventory**
- By package (Java) or directory (PHP/Node): name, responsibility, path

**2.2 Directory structure & layers**
Identify architecture pattern (MVC / Controller-Service-DAO / DDD).

**2.3 Cross-module calls**
Search for cross-module imports and Service-layer injections.

### Stop Conditions
- [ ] Every service/module has name, responsibility, path
- [ ] Every direct communication pair has protocol and purpose
- [ ] Every service/module has 2-3 level directory structure

If any unchecked → continue scanning. If `[uncertain]` items → ask user.

## Step 3: Validate

- Every service in call diagram exists in inventory?
- Every inventory item has directory structure?
- Call relationships bidirectionally consistent?
- Mental test: can you locate code for a specific feature in ≤3 steps?

If issues found → go back to Step 2.

## Step 4: Generate PROJECT_MAP.md

Use template based on project type:

### Microservices Template
```markdown
# 项目架构地图
> 服务调用关系和代码定位指南

## 服务清单
- **[Service]** - [responsibility] - [lang/framework] - `[path]`

## 服务调用关系图
(ASCII diagram with: → sync, ⇢ async, ─ database)

## 服务目录结构
### [Service]
(2-3 level tree with role annotations)

## 维护说明
更新时机: 新增服务、修改调用关系、变更通信方式
```

### Monolith Template
```markdown
# 项目架构地图

## 项目信息
- 技术栈/架构模式

## 模块清单
## 目录结构
## 模块调用关系图
## 分层职责说明
## 核心业务流程

## 维护说明
```

Write to `PROJECT_MAP.md` at project root.

## Thinking Discipline

After each step, apply [thinking discipline](../_shared/thinking-discipline.md).
