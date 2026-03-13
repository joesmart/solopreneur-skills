#!/bin/bash
# check-null-safety.sh - Check for potential null pointer risks
# Usage: bash check-null-safety.sh <file1> [file2] ...

ISSUES=0
CHECKED=0

echo "## Null Safety Check"
echo "STATUS: CHECKING"
echo ""
echo "| File | Line | Risk | Severity |"
echo "|------|------|------|----------|"

for FILE in "$@"; do
    [ ! -f "$FILE" ] && continue
    CHECKED=$((CHECKED + 1))

    case "$FILE" in
        *.java)
            # Chained method calls without null check (a.getB().getC())
            grep -n '\.[a-zA-Z]*()\..*()' "$FILE" 2>/dev/null | \
                grep -v '^\s*//' | grep -v '^\s*\*' | grep -v 'import ' | \
                grep -v '".*"' | grep -v 'builder\.' | grep -v 'stream()' | grep -v 'toString()' | \
                head -15 | while IFS=: read -r LINE REST; do
                echo "| $FILE | $LINE | Chained calls — NPE risk if intermediate null | WARN |"
            done

            # .get() without isPresent() on Optional
            grep -n '\.get()' "$FILE" 2>/dev/null | grep -v 'isPresent\|ifPresent\|orElse' | \
                grep -v '^\s*//' | head -10 | while IFS=: read -r LINE REST; do
                echo "| $FILE | $LINE | Optional.get() without isPresent check | WARN |"
            done

            # toString() called directly (NPE if null)
            grep -n '[a-zA-Z]\.toString()' "$FILE" 2>/dev/null | \
                grep -v '^\s*//' | grep -v 'String\.valueOf' | \
                head -10 | while IFS=: read -r LINE REST; do
                echo "| $FILE | $LINE | .toString() — NPE if object is null | WARN |"
            done
            ;;
        *.php)
            # Accessing property/method on potentially null result
            grep -n '\->.*\->.*\->' "$FILE" 2>/dev/null | \
                grep -v '^\s*//' | head -10 | while IFS=: read -r LINE REST; do
                echo "| $FILE | $LINE | Deep chained access — null risk | WARN |"
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
