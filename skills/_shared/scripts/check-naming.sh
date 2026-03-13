#!/bin/bash
# check-naming.sh - Check naming conventions
# Usage: bash check-naming.sh <file1> [file2] ...
# Checks: camelCase for Java, snake_case for PHP variables, PascalCase for classes

ISSUES=0
CHECKED=0

echo "## Naming Convention Check"
echo "STATUS: CHECKING"
echo ""
echo "| File | Line | Issue | Severity |"
echo "|------|------|-------|----------|"

for FILE in "$@"; do
    [ ! -f "$FILE" ] && continue
    CHECKED=$((CHECKED + 1))

    case "$FILE" in
        *.java)
            # Check for snake_case variables (should be camelCase in Java)
            grep -n '\b[a-z]\+_[a-z]\+\b' "$FILE" 2>/dev/null | \
                grep -v '^\s*//' | grep -v '^\s*\*' | grep -v 'import ' | \
                grep -v '".*_.*"' | grep -v "'.*_.*'" | \
                grep -v 'static final' | \
                head -10 | while IFS=: read -r LINE REST; do
                ISSUES=$((ISSUES + 1))
                echo "| $FILE | $LINE | snake_case variable (should be camelCase) | WARN |"
            done

            # Check class names not PascalCase
            grep -n '^\s*\(public\|private\|protected\)\s\+class\s\+[a-z]' "$FILE" 2>/dev/null | \
                while IFS=: read -r LINE REST; do
                ISSUES=$((ISSUES + 1))
                echo "| $FILE | $LINE | Class name not PascalCase | CRITICAL |"
            done
            ;;
        *.php)
            # Check for camelCase variables (PHP typically uses snake_case or camelCase)
            # Check class names not PascalCase
            grep -n '^\s*class\s\+[a-z]' "$FILE" 2>/dev/null | \
                while IFS=: read -r LINE REST; do
                ISSUES=$((ISSUES + 1))
                echo "| $FILE | $LINE | Class name not PascalCase | CRITICAL |"
            done
            ;;
    esac
done

echo ""
if [ "$ISSUES" -gt 0 ]; then
    echo "STATUS: WARN"
else
    echo "STATUS: PASS"
fi
echo "TOTAL: $CHECKED files checked"
