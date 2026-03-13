---
name: refactorer
description: >
  Safely refactor code while preserving external behavior. Identifies code
  smells, designs incremental refactoring steps, and verifies behavioral
  equivalence after each step. Use when user wants to refactor, clean up
  code, reduce technical debt, or improve code structure. Triggers on
  "重构", "优化代码结构", "清理技术债", "refactor". Does NOT add new features
  or fix bugs — restructures existing code only.
argument-hint: "<file or module to refactor>"
---

# Safe Code Refactoring

**Principle**: Change structure, preserve behavior. Every step must be verifiable.

## Step 1: Analyze Current Code

Read the target code. Identify code smells:

| Smell | Check |
|-------|-------|
| Long method | > 25 lines |
| God class | > 300 lines or > 5 responsibilities |
| Feature envy | Method uses another class's data more than its own |
| Duplicate code | Similar blocks in 2+ places |
| Shotgun surgery | One change requires editing many files |
| Data clumps | Same group of parameters passed together |
| Inappropriate intimacy | Class accesses another's internals |

Run automated detection:
```bash
SHARED="$(dirname "${CLAUDE_SKILL_DIR}")/_shared/scripts"
bash "$SHARED/check-method-length.sh" $ARGUMENTS
bash "$SHARED/check-naming.sh" $ARGUMENTS
bash "$SHARED/check-forbidden-patterns.sh" $ARGUMENTS
```

Produce a smell inventory:
```
| # | Location | Smell | Severity | Refactoring |
|---|----------|-------|----------|-------------|
```

## Step 2: Design Refactoring Plan

### 2.1 Identify callers (blast radius)
```bash
SHARED="$(dirname "${CLAUDE_SKILL_DIR}")/_shared/scripts"
bash "$SHARED/trace-callers.sh" <class_or_method_name>
```

### 2.2 Choose refactoring techniques
For each smell, select a safe technique:
- Extract Method, Extract Class, Move Method
- Rename, Inline Temp, Replace Temp with Query
- Introduce Parameter Object, Replace Conditional with Polymorphism

### 2.3 Order steps
Each step must:
- Be independently verifiable (behavior doesn't change)
- Be small enough to easily review
- State: what changes, what stays the same, how to verify

### 2.4 Validate against quality gates
Check refactoring plan against [quality-gates.md](../_shared/quality-gates.md).

## Step 3: Execute Refactoring (Step by Step)

For each step in the plan:

1. **State intent**: "I will [technique] to fix [smell] in [location]"
2. **Execute**: Make the code change
3. **Verify equivalence**:
   - All public method signatures unchanged (or callers updated)
   - All return values identical for same inputs
   - No side effects added or removed
   - Run automated checks:
   ```bash
   SHARED="$(dirname "${CLAUDE_SKILL_DIR}")/_shared/scripts"
   bash "$SHARED/check-method-length.sh" <changed_files>
   bash "$SHARED/check-naming.sh" <changed_files>
   ```
4. **If verification fails** → revert this step and reconsider

## Output

```markdown
## 重构报告

### 重构前
- 代码坏味道: X 处
- 最长方法: X 行
- 圈复杂度最高: X

### 重构内容
| # | 技术 | 位置 | 改动 | 验证 |
|---|------|------|------|------|

### 重构后
- 代码坏味道: X 处 (减少 X)
- 最长方法: X 行
- 影响范围: X 个调用者

### 变更清单
- [file]: [summary]
```

## Thinking Discipline

After each step, apply [thinking discipline](../_shared/thinking-discipline.md).
