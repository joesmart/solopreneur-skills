---
name: detail-designer
description: >
  Generate detailed technical design with database DDL, end-to-end ASCII
  flow diagrams, and implementation task list. Use when user needs a detailed
  design for a specific feature with class/method level granularity. Triggers
  on "详细设计", "技术设计方案", "设计方案", "design". Does NOT do overall/
  high-level design — use overall-designer for that. Does NOT implement code
  — use code-implementer for that.
argument-hint: "<requirement description>"
---

# Technical Design Generator

Output a design document with: Database DDL + E2E Flow + Implementation Tasks.

**Before starting**: Check if `PROJECT_MAP.md` exists at project root. If yes, read it first.

## Step 1: Deep Requirement Understanding

### 1.1 Translate Requirements to Questions

- Parse requirement sentence by sentence
- For each business concept: what class/table/field/enum does it map to?
- For each action verb: where's the entry point? What data flows? What's affected?
- Mark questions as "known" / "to investigate" / "need user confirmation"

### 1.2 Code Exploration

```bash
SHARED="$(dirname "${CLAUDE_SKILL_DIR}")/_shared/scripts"
bash "$SHARED/scan-dependencies.sh" .
```

- Trace from entry (Controller/API/Task) down the call chain
- Find the most similar existing module as **reference module**
- Read reference module code to understand architecture patterns

### 1.3 Verify Understanding

- Can you explain the complete data flow in your own words?
- Can you predict potential pitfalls? If not → keep exploring.
- If anything unclear → **ask the user**.

## Step 2: Design Solution

### 2.1 Brainstorm 2-3 candidates
Each with: one-sentence summary, files to create/modify, core change.

### 2.2 Validate against quality gates
Check each candidate against ALL 10 gates: [quality-gates.md](../_shared/quality-gates.md)
Select the best. State why others were rejected.

## Step 3: Detailed Design

### 3.1 Database Design

Follow `../../specs/database-design-common/spec.md` strictly.
- Complete CREATE TABLE DDL with all fields, indexes, comments
- 9 audit fields in spec order
- BIGINT AUTO_INCREMENT primary key
- Indexes ≤ 5 with idx_/uniq_ prefix
- No foreign keys, triggers, stored procedures, views

### 3.2 End-to-End Flow

Draw ASCII flow using node protocol:
```
┌──────────────────────────────────────────────────────────┐
│ [Service]: [Layer] [Status: New/Modify/Extend]           │
├──────────────────────────────────────────────────────────┤
│  [#] ClassName                                           │
│      File: full/file/path                                │
│      Method: name(params) → ReturnType                   │
│      Responsibility: one sentence                        │
│      Input: data structure                               │
│      Output: data structure                              │
│      ├── Step 1: description                             │
│      └── Step 2: description                             │
└────────────────────────┬─────────────────────────────────┘
                         │ [Communication: HTTP POST /path | Method call | MQ]
                         ▼
```

### 3.3 Data Trace Verification (internal only)

Construct 2+ test data sets (normal + edge case), trace through E2E flow mentally.
**Do NOT include in output document.** Fix any design issues found.

### 3.4 Implementation Tasks

List in layer order: Database → Entity → Mapper → Service → BizService → Controller → DTO/VO → Enum/Config

Each task:
- Status: [New] / [Modify]
- File path, class name, method list with signatures
- Each method's responsibility
- Done When criteria
- Related Specs

## Output Template

```markdown
# Design: [Feature Name]

## 需求
**用户需求**: [one sentence]
**范围**: 做什么 / 不做什么
**参考模块**: [similar module name and path]

## Database Design
### Table: [table_name]
(Complete CREATE TABLE DDL)

## End-to-End Flow
(ASCII flow with node protocol)

## Implementation Tasks
(Layer-ordered task list)

## 待确认
[Open questions or "N/A"]
```

## Thinking Discipline

After each step, apply [thinking discipline](../_shared/thinking-discipline.md).
