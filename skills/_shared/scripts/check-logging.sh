#!/bin/bash
# check-logging.sh - Check logging best practices
# Usage: bash check-logging.sh <file1> [file2] ...

ISSUES=0
CHECKED=0

echo "## Logging Check"
echo "STATUS: CHECKING"
echo ""
echo "| File | Line | Issue | Severity |"
echo "|------|------|-------|----------|"

for FILE in "$@"; do
    [ ! -f "$FILE" ] && continue
    CHECKED=$((CHECKED + 1))

    case "$FILE" in
        *.java)
            # log.debug in production code with string concatenation
            grep -n 'log\.\(debug\|info\|warn\|error\).*+\s*' "$FILE" 2>/dev/null | \
                grep -v '^\s*//' | head -10 | while IFS=: read -r LINE REST; do
                echo "| $FILE | $LINE | Log with string concat (use parameterized: log.info(\"msg {}\", var)) | WARN |"
            done

            # Excessive logging in loops
            # (heuristic: log statement inside for/while block)
            awk '/for\s*\(|while\s*\(/{loop=1} loop && /log\.(debug|info|warn|error)/{print FILENAME":"NR": Log inside loop"; loop=0}' "$FILE" 2>/dev/null | \
                while IFS=: read -r F LINE REST; do
                echo "| $FILE | $LINE | Logging inside loop — performance risk | WARN |"
            done
            ;;
        *.php)
            # Using echo/print for logging instead of Log facade
            grep -n '^\s*echo\s\|^\s*print\s' "$FILE" 2>/dev/null | \
                grep -v '^\s*//' | head -5 | while IFS=: read -r LINE REST; do
                echo "| $FILE | $LINE | echo/print instead of Log facade | WARN |"
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
