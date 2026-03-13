#!/bin/bash
# check-forbidden-patterns.sh - Scan for forbidden code patterns
# Usage: bash check-forbidden-patterns.sh <file1> [file2] ...

ISSUES=0
CHECKED=0

echo "## Forbidden Pattern Check"
echo "STATUS: CHECKING"
echo ""
echo "| File | Line | Pattern | Severity |"
echo "|------|------|---------|----------|"

for FILE in "$@"; do
    [ ! -f "$FILE" ] && continue
    CHECKED=$((CHECKED + 1))

    case "$FILE" in
        *.java)
            # System.out.println
            grep -n 'System\.out\.print' "$FILE" 2>/dev/null | while IFS=: read -r LINE REST; do
                echo "| $FILE | $LINE | System.out.println (use logger) | CRITICAL |"
                ISSUES=$((ISSUES + 1))
            done
            # e.printStackTrace()
            grep -n 'printStackTrace()' "$FILE" 2>/dev/null | while IFS=: read -r LINE REST; do
                echo "| $FILE | $LINE | printStackTrace() (use logger) | CRITICAL |"
                ISSUES=$((ISSUES + 1))
            done
            # Bare catch(Exception)
            grep -n 'catch\s*(Exception\s' "$FILE" 2>/dev/null | while IFS=: read -r LINE REST; do
                echo "| $FILE | $LINE | Bare catch(Exception) — too broad | WARN |"
                ISSUES=$((ISSUES + 1))
            done
            # Magic numbers (excluding 0, 1, -1)
            grep -n 'return\s\+[2-9][0-9]*\b' "$FILE" 2>/dev/null | while IFS=: read -r LINE REST; do
                echo "| $FILE | $LINE | Magic number in return | WARN |"
                ISSUES=$((ISSUES + 1))
            done
            ;;
        *.php)
            # var_dump / print_r / dd
            grep -n '\bvar_dump\b\|print_r\b\|\bdd(' "$FILE" 2>/dev/null | while IFS=: read -r LINE REST; do
                echo "| $FILE | $LINE | Debug output (var_dump/print_r/dd) | CRITICAL |"
                ISSUES=$((ISSUES + 1))
            done
            # die / exit
            grep -n '\bdie\b\|\bexit\b' "$FILE" 2>/dev/null | grep -v '^\s*//' | while IFS=: read -r LINE REST; do
                echo "| $FILE | $LINE | die/exit (use proper error handling) | WARN |"
                ISSUES=$((ISSUES + 1))
            done
            ;;
    esac
done

echo ""
if [ "$ISSUES" -gt 0 ]; then
    echo "STATUS: FAIL"
else
    echo "STATUS: PASS"
fi
echo "TOTAL: $CHECKED files checked"
