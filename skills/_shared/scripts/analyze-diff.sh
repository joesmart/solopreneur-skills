#!/bin/bash
# analyze-diff.sh - Analyze git diff and summarize changes
# Usage: bash analyze-diff.sh [--cached]

CACHED_FLAG=""
[ "$1" = "--cached" ] && CACHED_FLAG="--cached"

echo "## Git Diff Analysis"
echo ""

# Changed files with stats
echo "### Changed Files"
echo "| File | Added | Removed | Status |"
echo "|------|-------|---------|--------|"
git diff $CACHED_FLAG --numstat 2>/dev/null | while read -r ADDED REMOVED FILE; do
    STATUS="modified"
    [ "$ADDED" = "0" ] && [ "$REMOVED" != "0" ] && STATUS="deleted lines"
    [ "$REMOVED" = "0" ] && [ "$ADDED" != "0" ] && STATUS="added lines"
    echo "| $FILE | +$ADDED | -$REMOVED | $STATUS |"
done

echo ""
echo "### Summary"
FILES=$(git diff $CACHED_FLAG --name-only 2>/dev/null | wc -l | tr -d ' ')
INSERTIONS=$(git diff $CACHED_FLAG --shortstat 2>/dev/null | grep -o '[0-9]* insertion' | grep -o '[0-9]*')
DELETIONS=$(git diff $CACHED_FLAG --shortstat 2>/dev/null | grep -o '[0-9]* deletion' | grep -o '[0-9]*')
echo "- Files changed: $FILES"
echo "- Insertions: +${INSERTIONS:-0}"
echo "- Deletions: -${DELETIONS:-0}"

echo ""
echo "### File Types"
git diff $CACHED_FLAG --name-only 2>/dev/null | sed 's/.*\.//' | sort | uniq -c | sort -rn | while read -r COUNT EXT; do
    echo "- .$EXT: $COUNT files"
done
