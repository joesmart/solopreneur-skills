#!/bin/bash
# check-sql-injection.sh - Scan for SQL injection risks
# Usage: bash check-sql-injection.sh <file1> [file2] ...

ISSUES=0
CHECKED=0

echo "## SQL Injection Risk Check"
echo "STATUS: CHECKING"
echo ""
echo "| File | Line | Risk | Severity |"
echo "|------|------|------|----------|"

for FILE in "$@"; do
    [ ! -f "$FILE" ] && continue
    CHECKED=$((CHECKED + 1))

    case "$FILE" in
        *.java)
            # String concatenation in SQL
            grep -n '".*SELECT\|".*INSERT\|".*UPDATE\|".*DELETE' "$FILE" 2>/dev/null | \
                grep '+\s*[a-zA-Z]' | grep -v '^\s*//' | \
                head -10 | while IFS=: read -r LINE REST; do
                echo "| $FILE | $LINE | SQL string concatenation — injection risk | CRITICAL |"
            done

            # ${} in MyBatis XML (should use #{})
            # This check is for .xml files
            ;;
        *.xml)
            # ${} in MyBatis mapper (should use #{})
            grep -n '\${' "$FILE" 2>/dev/null | \
                grep -v '^\s*<!--' | head -10 | while IFS=: read -r LINE REST; do
                echo "| $FILE | $LINE | \${} in MyBatis (should use #{}) | CRITICAL |"
            done
            ;;
        *.php)
            # Direct variable in SQL query
            grep -n 'query\|execute\|raw\|whereRaw\|selectRaw' "$FILE" 2>/dev/null | \
                grep '\$' | grep -v '^\s*//' | grep -v '?' | \
                head -10 | while IFS=: read -r LINE REST; do
                echo "| $FILE | $LINE | Variable in raw SQL — injection risk | CRITICAL |"
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
