---
name: commit-checker
description: >
  Quick pre-commit quality check on staged changes. Runs automated static
  checks (method length, naming, null safety, SQL injection, forbidden
  patterns, logging) and summarizes results. Use when user wants a quick
  check before committing. Triggers on "提交检查", "检查一下", "commit check",
  "快速检查". Lighter than full code review — focuses on common issues only.
  For deep architecture review, use code-reviewer instead.
argument-hint: "[optional: focus area like 'naming' or 'security']"
---

# Pre-Commit Quality Check

## Context (auto-injected)

### Staged Files
!`git diff --cached --name-only 2>/dev/null || echo "No staged files"`

### Change Stats
!`git diff --cached --stat 2>/dev/null || git diff --stat 2>/dev/null || echo "No changes"`

## Execution

Run all check scripts against staged files:

```bash
SHARED="$(dirname "${CLAUDE_SKILL_DIR}")/_shared/scripts"
FILES=$(git diff --cached --name-only 2>/dev/null || git diff --name-only)

if [ -z "$FILES" ]; then
  echo "No changed files to check."
  exit 0
fi

bash "$SHARED/check-method-length.sh" $FILES
echo "---"
bash "$SHARED/check-naming.sh" $FILES
echo "---"
bash "$SHARED/check-null-safety.sh" $FILES
echo "---"
bash "$SHARED/check-sql-injection.sh" $FILES
echo "---"
bash "$SHARED/check-forbidden-patterns.sh" $FILES
echo "---"
bash "$SHARED/check-logging.sh" $FILES
```

## Output

Summarize all script results as a single table:

```markdown
## 提交前检查报告

| # | 文件 | 检查项 | 状态 | 详情 |
|---|------|--------|------|------|

### 统计
- 🔴 Critical: X (必须修复)
- 🟡 Warning: X (建议修复)
- 🟢 Pass: X

### 结论
[可以提交 / 建议修复 X 个问题后再提交]
```
