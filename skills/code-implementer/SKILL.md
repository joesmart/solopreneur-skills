---
name: code-implementer
description: >
  Implement code from design documents, requirements, or any guidance using
  spec-driven development with mandatory compliance checks. Use when user
  asks to implement code, write code from design, or execute implementation
  tasks. Triggers on "实现代码", "写代码", "按设计方案编码", "代码实现".
  Accepts any input format (design docs, PRDs, verbal instructions). Does
  NOT do design or debugging — use detail-designer or bugfix for those.
argument-hint: "<design doc path or requirement description>"
---

# Code Implementation Executor

Implement production-ready code through:
1. **Understand** design/requirements → generate implementation plan
2. **Implement** step by step with spec compliance
3. **Audit** all code with full-scope verification

## Phase 1: Understand & Plan

### Step 1.1: Deep Read

- Read all provided design docs, requirements, code snippets, SQL
- If the design references existing code, **read those files**
- If a reference module is mentioned, **read it** to understand style
- Mark all unclear points

If anything is unclear, **ask the user** before proceeding.

### Step 1.2: Generate Implementation Plan

- If design has Implementation Tasks → adopt them, check completeness
- If not → generate tasks in layer order:
  Database/SQL → Entity/Model → Mapper/DAO → Service → BizService → Controller → DTO/VO → Enum/Config
- Each task: file path, operation (new/modify), core changes

## Phase 2: Implement Step by Step

For each task in the plan, execute this cycle:

### Step 2.1: Load Specs

Determine applicable specs for the current file:

```bash
SHARED="$(dirname "${CLAUDE_SKILL_DIR}")/_shared/scripts"
bash "$SHARED/resolve-specs.sh" <target_file_path>
```

Load each spec file: `../../specs/{spec-id}/spec.md`
Extract all MUST / MUST NOT constraints.

See [spec-loader-rules.md](../_shared/spec-loader-rules.md) for mapping rules.

### Step 2.2: Write Code

- If modifying existing file → **read it first**
- Follow design exactly if code examples provided
- Check code against every MUST constraint
- Match existing naming/style conventions
- Add clear comments explaining intent

### Step 2.3: Compliance Check (mandatory)

Run automated checks:
```bash
SHARED="$(dirname "${CLAUDE_SKILL_DIR}")/_shared/scripts"
bash "$SHARED/check-method-length.sh" <implemented_files>
bash "$SHARED/check-naming.sh" <implemented_files>
bash "$SHARED/check-forbidden-patterns.sh" <implemented_files>
```

Then manually verify each MUST/MUST NOT item:
```
✅ [constraint]: satisfied — [evidence]
❌ [constraint]: violated — [fix needed]
```

If ANY ❌ → fix and re-check until 100%.

### Step 2.4: Correctness Verification

- Check syntax errors, type errors
- Check boundary conditions: null, empty, exceptions
- Check upstream/downstream code integration

If issues found → fix and re-verify.

**Repeat 2.1→2.4 for every task until all complete.**

## Phase 3: Full-Scope Audit

### Step 3.1: Inventory all changed files

List all new and modified files, grouped by type.

### Step 3.2: Per-file spec audit

Re-read each file, re-load its specs, check every MUST item.
Any violation → fix immediately and re-audit.

### Step 3.3: Cross-file consistency

- Naming consistency across files
- Interface contracts match (Controller ↔ BizService)
- Data flow integrity (type conversions, no missing transforms)
- Exception handling at correct layers

### Step 3.4: Output report

```
## 规范合规验证报告
| File | Specs | Status |
|------|-------|--------|

## 变更清单
### 新增文件
- [path]: [description]
### 修改文件
- [path]: [summary]
### SQL 变更
- [path]
```

## Thinking Discipline

After each step, apply [thinking discipline](../_shared/thinking-discipline.md).
