---
name: code-verifier
description: >
  Verify code correctness through AI-powered execution trace on staged git
  changes. Designs test cases (happy path + edge cases), then traces code
  line-by-line with concrete data to find logic errors. Use when user asks
  to verify code, test changes, or validate before commit. Triggers on
  "验证代码", "推演测试", "检查逻辑", "代码推演". Does NOT write unit tests —
  uses AI reasoning to simulate execution. Does NOT review code quality or
  style — use code-reviewer for that.
argument-hint: "[optional: specific files or feature to verify]"
---

# Code Verification via Execution Trace

## Context (auto-injected)

### Staged Changes
!`git diff --cached 2>/dev/null || git diff`

### Changed Files
!`git diff --cached --name-only 2>/dev/null || git diff --name-only`

## Step 1: Scan Changes

Analyze the injected diff above. For each changed file, record:
- File path, change type (new/modified/deleted)
- Change summary: what methods added/modified/deleted
- Core intent: what business purpose does this change serve

Run impact analysis:
```bash
SHARED="$(dirname "${CLAUDE_SKILL_DIR}")/_shared/scripts"
bash "$SHARED/analyze-diff.sh" --cached
```

Group changes by business feature. Identify entry points (Controller/API/Task).

Trace upstream callers for changed methods:
```bash
bash "$SHARED/trace-callers.sh" <changed_method_name>
```

### Output: Test Scope

```
## 测试范围分析
- 改动文件数: X
- 涉及功能点: [feature1], [feature2]

### 功能点 1: [name]
改动文件: [file]: [summary]
调用链: [entry] → [middle] → [change point] → [downstream]
分支路径数: X
边界条件数: X
```

## Step 2: Design Test Cases

### Happy Path (P-xx)
For each feature, design at least 1 positive case with:
- Preconditions (DB data, system state, external deps)
- Test data (concrete parameter values)
- Action (which entry method/API)
- Expected result (return value, DB changes, side effects)

### Edge Cases (N-xx)
For each branch point and boundary condition, design negative cases:
- Null/empty values, non-existent records
- State mismatches, type errors
- External dependency failures
- Concurrent/duplicate calls

### Output: Test Plan

```
| # | Case | Type | Intent | Status |
|---|------|------|--------|--------|
| 1 | P-01 | Happy | [desc] | Pending |
| 2 | N-01 | Edge  | [desc] | Pending |
```

## Step 3: Line-by-Line Execution Trace (Core)

For each test case:

### 3.1 Load virtual environment
Set DB data, system state, external deps from test case preconditions.

### 3.2 Trace execution
From entry method, trace line by line:
- Track every variable assignment
- Evaluate every condition (show: condition → true/false → which branch)
- Record every method call (input → output)
- Record every DB operation (SQL + affected data)
- Mark changed code lines with ★

### 3.3 Compare results
Compare actual trace result vs expected result for each dimension:
- Return value: expected vs actual → ✅/❌
- DB changes: expected vs actual → ✅/❌
- Side effects: expected vs actual → ✅/❌

### 3.4 Root cause analysis (if ❌)
For any failed comparison, locate precisely:
- File, method, line number
- What went wrong and why
- Impact assessment and fix suggestion

## Output: Test Report

```
## 推演测试报告
### 改动概览
- 文件: X, 功能点: [list]

### 测试结果
| # | Case | Type | Intent | Result |
|---|------|------|--------|--------|
通过: X/X, 失败: X/X

### 发现的问题
| # | Case | Location | Issue | Severity | Fix Suggestion |
|---|------|----------|-------|----------|----------------|

### 结论
[Can this change be safely committed? If not, what needs to be fixed first?]
```

## Thinking Discipline

After each step, apply [thinking discipline](../_shared/thinking-discipline.md).
