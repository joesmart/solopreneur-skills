---
name: overall-designer
description: >
  Generate high-level overall design for large features. Produces database
  model overview, core flow diagrams, and phased iteration plan. Use when
  user needs overall architecture planning for a big feature, not detailed
  class-level design. Triggers on "总体设计", "初步设计", "方案设计",
  "overall design". Does NOT do detailed design — use detail-designer for
  class/method level. Does NOT implement code.
argument-hint: "<feature requirement description>"
---

# Overall Design Generator

Output: Background + Database Overview + Core Flow + Phased Iteration Plan.

**Before starting**: Check if `PROJECT_MAP.md` exists at project root. If yes, read it first.

## Step 1: Understand & Clarify

### 1.1 Decompose Requirement

- Parse requirement, extract every business concept and action verb
- For each concept: does it exist in current system? Which table/service/module?
- For each action: which systems involved? Data flow?
- Mark: "known" / "to investigate (code)" / "need user confirmation"

### 1.2 Explore Current System

```bash
SHARED="$(dirname "${CLAUDE_SKILL_DIR}")/_shared/scripts"
bash "$SHARED/detect-project-type.sh" .
bash "$SHARED/detect-tech-stack.sh" .
bash "$SHARED/scan-dependencies.sh" .
```

- Find related existing features, trace data flows
- Identify reusable capabilities (existing APIs, services, queues)

### 1.3 Clarify with User (mandatory)

- Compile all "need confirmation" questions, prioritize
- **Ask the user**, wait for answers before proceeding
- If answers raise new questions → keep asking

### 1.4 Verify Understanding

- Can you explain the full picture: what problem, which systems, how data flows?
- Can you list the core challenges/risks?
- If not → keep exploring.

## Step 2: Design

### 2.1 Database Model Overview

For each new/modified table:
- Table name + one-sentence purpose
- Core business fields only (name + type + description)
- Table relationships diagram:
  ```
  b_lead (1) ──── (1) b_lead_element
     │
     └── sany_lead_id ──── inquiry_id (inquiry-service)
  ```
- Mark: [New] / [Modify existing]

### 2.2 Core Flow Diagrams

For each key path (normal flow, async callback, error flow):

```
┌──────────────────────────────────────────────────────┐
│ [System]: [Module] [Status: New/Modify/Existing]     │
├──────────────────────────────────────────────────────┤
│  Responsibility: one sentence                        │
│  Input: key data     Output: key data                │
│  Steps:                                              │
│      ├── Step 1: description                         │
│      └── Step 2: description                         │
└────────────────────────┬─────────────────────────────┘
                         │ [HTTP/MQ/Callback/Method call]
                         ▼
```

Mark new/changed parts with ★.

### 2.3 Data Trace (internal only)

Trace 2+ data sets through flows. Fix design issues. **Not in output.**

## Step 3: Phased Iteration Plan (Core Output)

Split by **end-to-end verifiable features**, not by tech layers.

Each Phase:
- **Number and name**
- **Goal**: one sentence
- **Deliverable**: what user/system can do after this Phase
- **Systems involved**
- **Steps**: system, change summary, verification method, dependencies
- **★ Milestone**: one sentence

Dependency diagram:
```
Phase 1: [name]
  ├── Step 1.1 ← no deps
  ├── Step 1.2 ← Step 1.1
  └── Step 1.3 ← Step 1.2
  ★ Milestone: [deliverable]
       │
       ▼
Phase 2: [name] ...
```

Verify: all DB models and flows are covered by Phases.

## Output Template

```markdown
# [Feature] - 初步设计方案
## 一、背景与问题
## 二、总体方案 (overview diagram + design principles)
## 三、数据库模型概要
## 四、核心流程链路 (ASCII flows)
## 五、迭代实施计划 (Phases + dependency diagram)
## 六、关键设计决策 (table: decision + rationale)
## 七、待确认事项
```

## Thinking Discipline

After each step, apply [thinking discipline](../_shared/thinking-discipline.md).
