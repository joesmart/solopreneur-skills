---
name: code-reviewer
description: >
  Systematic code review on changed files combining automated script checks
  with AI-powered architecture and logic review using project specs. Use
  when user asks to review code, check PR quality, or audit changes.
  Triggers on "review代码", "代码审查", "PR review", "审查代码". Does NOT
  fix code — produces review feedback only. Does NOT verify logic correctness
  — use code-verifier for execution trace testing.
argument-hint: "<file paths, branch name, or 'staged'>"
---

# Code Review

## Phase 1: Automated Checks (script-driven)

Determine target files:
```bash
FILES="$ARGUMENTS"
# If no specific files provided, use staged changes
if [ -z "$FILES" ]; then
  FILES=$(git diff --cached --name-only 2>/dev/null || git diff --name-only)
fi
echo "$FILES"
```

Run all check scripts:
```bash
SHARED="$(dirname "${CLAUDE_SKILL_DIR}")/_shared/scripts"
bash "$SHARED/check-method-length.sh" $FILES
bash "$SHARED/check-naming.sh" $FILES
bash "$SHARED/check-null-safety.sh" $FILES
bash "$SHARED/check-sql-injection.sh" $FILES
bash "$SHARED/check-forbidden-patterns.sh" $FILES
bash "$SHARED/check-logging.sh" $FILES
```

Record all script findings as "自动化检查结果".

## Phase 2: Spec Compliance Review (AI)

1. Determine applicable specs per file:
```bash
SHARED="$(dirname "${CLAUDE_SKILL_DIR}")/_shared/scripts"
bash "$SHARED/resolve-specs.sh" $FILES
```

2. Load each relevant spec from `../../specs/{spec-id}/spec.md`
3. For each file, check every MUST / MUST NOT item:
   - ✅ Compliant — evidence
   - ❌ Violation — location and what to fix

See [spec-loader-rules.md](../_shared/spec-loader-rules.md) for mapping details.

## Phase 3: Deep Review (AI — scripts cannot do this)

Focus on areas requiring judgment:

### Architecture
- Is logic placed in the correct layer? (Controller vs Service vs DAO)
- Is the responsibility single and clear?
- Does dependency direction follow: Controller → BizService → Service → DAO?

### Data Integrity
- Transactions cover multi-table writes?
- Concurrent safety (optimistic/pessimistic locking where needed)?
- Idempotency for retryable operations?

### Edge Cases
- Null/empty collection handling at every boundary
- Error paths: what happens when external calls fail?
- Data type overflow, precision loss

### Maintainability
- Method length and complexity reasonable?
- Naming reveals intent?
- Code duplication that should be extracted?

### Cross-File Consistency
- Interface contracts match between caller and callee
- DTO/VO field names consistent with DB columns
- Error codes/messages consistent

For detailed review dimensions, see [review-dimensions.md](references/review-dimensions.md) if it exists.

## Output

```markdown
## 代码审查报告

### 自动化检查结果
[Script output summary — paste tables from Phase 1]

### 规范合规检查
| File | Spec | Status | Details |
|------|------|--------|---------|

### 深度审查发现
| # | File:Line | 严重度 | 类别 | 问题描述 | 建议修改 |
|---|----------|--------|------|---------|---------|

### 总结
- 检查文件: X
- 发现问题: X (🔴 Critical: X, 🟡 Major: X, 🟢 Minor: X)
- 结论: [可以合入 / 建议修复后再合入 / 需要重新设计]
```

## Thinking Discipline

After each step, apply [thinking discipline](../_shared/thinking-discipline.md).
