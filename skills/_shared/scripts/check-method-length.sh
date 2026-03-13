#!/bin/bash
# check-method-length.sh - Check if methods exceed line limit
# Usage: bash check-method-length.sh <file1> [file2] ...
# Checks: Java methods > 25 lines, PHP functions > 25 lines

MAX_LINES=25
ISSUES=0
CHECKED=0

echo "## Method Length Check (max $MAX_LINES lines)"
echo "STATUS: CHECKING"
echo ""
echo "| File | Method | Lines | Severity |"
echo "|------|--------|-------|----------|"

for FILE in "$@"; do
    [ ! -f "$FILE" ] && continue
    CHECKED=$((CHECKED + 1))

    case "$FILE" in
        *.java)
            # Match Java method declarations, count lines to closing brace
            grep -n "^\s*\(public\|private\|protected\)\s.*(.*).*{" "$FILE" 2>/dev/null | while IFS=: read -r LINE_NUM REST; do
                METHOD_NAME=$(echo "$REST" | sed 's/.*\s\+\([a-zA-Z_][a-zA-Z0-9_]*\)\s*(.*/\1/')
                # Count lines from method start to next method or closing brace at same indent
                END=$(tail -n +"$LINE_NUM" "$FILE" | awk 'NR>1 && /^\s*(public|private|protected)\s/ {print NR; exit}')
                [ -z "$END" ] && END=$(wc -l < "$FILE")
                LENGTH=$((END - 1))
                if [ "$LENGTH" -gt "$MAX_LINES" ]; then
                    ISSUES=$((ISSUES + 1))
                    SEV="WARN"
                    [ "$LENGTH" -gt 50 ] && SEV="CRITICAL"
                    echo "| $FILE | $METHOD_NAME() | $LENGTH | $SEV |"
                fi
            done
            ;;
        *.php)
            grep -n "^\s*\(public\|private\|protected\|function\)\s.*(.*).*{" "$FILE" 2>/dev/null | while IFS=: read -r LINE_NUM REST; do
                METHOD_NAME=$(echo "$REST" | sed 's/.*function\s\+\([a-zA-Z_][a-zA-Z0-9_]*\)\s*(.*/\1/')
                END=$(tail -n +"$LINE_NUM" "$FILE" | awk 'NR>1 && /^\s*(public|private|protected|function)\s/ {print NR; exit}')
                [ -z "$END" ] && END=$(wc -l < "$FILE")
                LENGTH=$((END - 1))
                if [ "$LENGTH" -gt "$MAX_LINES" ]; then
                    ISSUES=$((ISSUES + 1))
                    SEV="WARN"
                    [ "$LENGTH" -gt 50 ] && SEV="CRITICAL"
                    echo "| $FILE | $METHOD_NAME() | $LENGTH | $SEV |"
                fi
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
echo "TOTAL: $CHECKED files checked, $ISSUES issues found"
