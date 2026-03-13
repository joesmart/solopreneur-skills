#!/bin/bash
# 校验所有 Skill 格式（扁平结构：skills/<name>/SKILL.md）
# 检查项：SKILL.md 存在性、YAML frontmatter 格式、名称和描述字段

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"
ERRORS=0
WARNINGS=0
CHECKED=0

echo "## Skill 格式校验"
echo ""

for skill_dir in "$SKILLS_DIR"/*/; do
    [[ ! -d "$skill_dir" ]] && continue
    skill=$(basename "$skill_dir")
    [[ "$skill" == "_shared" ]] && continue
    [[ "$skill" == ".DS_Store" ]] && continue

    skill_file="$skill_dir/SKILL.md"

    # 跳过没有 SKILL.md 的子目录（如 steps/、references/ 不在此层级）
    [[ ! -f "$skill_file" ]] && continue

    CHECKED=$((CHECKED + 1))

    # 检查 YAML frontmatter
    if ! head -1 "$skill_file" | grep -q '^---$'; then
        echo "❌ [$skill] SKILL.md 缺少 YAML frontmatter"
        ERRORS=$((ERRORS + 1))
        continue
    fi

    # 检查 name 字段
    if ! grep -q '^name:' "$skill_file"; then
        echo "❌ [$skill] SKILL.md 缺少 name 字段"
        ERRORS=$((ERRORS + 1))
    fi

    # 检查 description 字段
    if ! grep -q '^description:' "$skill_file"; then
        echo "❌ [$skill] SKILL.md 缺少 description 字段"
        ERRORS=$((ERRORS + 1))
    fi

    # 检查行数
    lines=$(wc -l < "$skill_file" | tr -d ' ')
    if [[ $lines -gt 500 ]]; then
        echo "⚠️  [$skill] SKILL.md 超过 500 行 (${lines} 行)"
        WARNINGS=$((WARNINGS + 1))
    fi

    echo "✅ [$skill] OK (${lines} 行)"
done

echo ""
echo "---"
echo "检查完成：$CHECKED 个 Skills，$ERRORS 个错误，$WARNINGS 个警告"

if [[ $ERRORS -gt 0 ]]; then
    echo "STATUS: FAIL"
    exit 1
else
    echo "STATUS: PASS"
fi
