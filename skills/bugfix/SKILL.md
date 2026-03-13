---
name: bugfix
description: >
  Locate bug root cause with certainty through evidence-driven code tracing
  and design optimal fix plan for human review. Use when user asks to debug,
  troubleshoot, investigate a bug, or locate root cause. Triggers on "修bug",
  "排查问题", "定位bug", "调试错误". Does NOT auto-fix code — produces root
  cause analysis and fix plan. Does NOT apply to new feature development,
  design tasks, or code review.
argument-hint: "<bug description or error message>"
---

# Bug Root Cause Locator & Fix Planner

**Does NOT auto-modify code.** Output = root cause analysis + fix plan for human review.

## Phase 1: Locate Root Cause

**Before starting**: Check if `PROJECT_MAP.md` exists at project root. If yes, read it first.

### Step 1.1: Translate Bug to Questions

Parse the bug description sentence by sentence. Extract:
- Error messages, trigger conditions, expected vs actual behavior
- For each item: which class/method/branch does this correspond to?
- List all questions, mark as "known" or "to investigate"

If the bug description is unclear, **ask the user** for clarification.

For detailed checklist, load [steps/1.1-translate-bug-symptoms.md](steps/1.1-translate-bug-symptoms.md)

### Step 1.2: Trace Code Chain

Use scripts to accelerate code exploration:

```bash
SHARED="$(dirname "${CLAUDE_SKILL_DIR}")/_shared/scripts"
# Search for error message in codebase
bash "$SHARED/search-error-source.sh" "$ARGUMENTS"
# Trace callers of suspected methods
bash "$SHARED/trace-callers.sh" <method_name>
```

Then read identified code files and trace the full call chain:
Controller → BizService → Service → Mapper → DB

Record for each key node: file path, method signature, core logic, data transforms.

For detailed checklist, load [steps/1.2-trace-call-chain.md](steps/1.2-trace-call-chain.md)

### Step 1.3: Debug Trace (Core)

Using concrete trigger data, trace execution step by step.
Follow the format defined in [references/debug-trace-protocol.md](references/debug-trace-protocol.md)

**Key rules**:
- Every STEP has 5 fields: Input, Execute, Output, Expect, Actual
- ❌ steps must include ★ Root Cause
- All values must be concrete (e.g., `null`, `123`), never vague

For detailed checklist, load [steps/1.3-debug-trace.md](steps/1.3-debug-trace.md)

### Step 1.4: Verify Root Cause

Two verification criteria:
1. Can you state root cause in one sentence: "In [file].[method] line [N], when [condition], [variable] is [value], causing [error]"?
2. Can you explain why it didn't happen before but happens now?

If either fails → go back to Step 1.2. Output ROOT CAUSE card.

For detailed checklist, load [steps/1.4-verify-root-cause.md](steps/1.4-verify-root-cause.md)

## Phase 2: Design Fix Plan

### Step 2.1: Brainstorm 2+ candidate fixes

List at least 2 candidates, each with: files to modify, core change, one-sentence summary.

For detailed checklist, load [steps/2.1-brainstorm-fixes.md](steps/2.1-brainstorm-fixes.md)

### Step 2.2: Validate against quality gates

Check each candidate against ALL 10 gates defined in [quality gates](../_shared/quality-gates.md).
Any gate failure → reject. Select the best passing candidate.

For detailed checklist, load [steps/2.2-validate-acceptance.md](steps/2.2-validate-acceptance.md)

### Step 2.3: Post-fix trace

Trace the fix using same protocol in [debug-trace-protocol.md](references/debug-trace-protocol.md).
All steps should be ✅. Also trace 1+ edge case.

For detailed checklist, load [steps/2.3-post-fix-trace.md](steps/2.3-post-fix-trace.md)

### Step 2.4: Output fix plan

For detailed format, load [steps/2.4-output-fix-plan.md](steps/2.4-output-fix-plan.md)

```
Bug 修复方案 (待人工审查)
根因: [one sentence]
修复方案: [one sentence]
需要修改:
  1. [file] → [method]: [change]
验收条件: X/10 通过
风险评估: [impact, verified edges, residual risk]
⚠️ 请人工审查后再执行修复
```

## Thinking Discipline

After each step, apply [thinking discipline](../_shared/thinking-discipline.md).
