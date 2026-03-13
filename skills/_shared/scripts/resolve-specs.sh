#!/bin/bash
# resolve-specs.sh - Resolve applicable specs by task type
# Usage: bash resolve-specs.sh <task_type>
# Task types: implement, review, design, refactor, bugfix, commit-check

TASK_TYPE="${1:-review}"

echo "## Spec Resolution for: $TASK_TYPE"
echo ""

case "$TASK_TYPE" in
    implement|code|write)
        echo "Required specs:"
        echo "  - clean-function/spec.md (函数整洁)"
        echo "  - clean-naming/spec.md (命名整洁)"
        echo "  - error-handling/spec.md (错误处理)"
        ;;
    review|audit)
        echo "Required specs (全部):"
        echo "  - code-smells/spec.md (先读：快速扫描清单)"
        echo "  - clean-function/spec.md"
        echo "  - clean-naming/spec.md"
        echo "  - clean-structure/spec.md"
        echo "  - error-handling/spec.md"
        echo "  - data-integrity/spec.md"
        echo "  - security/spec.md"
        echo "  - logging/spec.md"
        ;;
    design)
        echo "Required specs:"
        echo "  - clean-structure/spec.md (结构整洁)"
        echo "  - data-integrity/spec.md (数据完整性)"
        ;;
    refactor)
        echo "Required specs:"
        echo "  - code-smells/spec.md (坏味道检测)"
        echo "  - clean-function/spec.md (函数整洁)"
        echo "  - clean-structure/spec.md (结构整洁)"
        ;;
    bugfix|debug)
        echo "Required specs:"
        echo "  - error-handling/spec.md (错误处理)"
        echo "  - data-integrity/spec.md (数据完整性)"
        ;;
    commit-check|check)
        echo "Required specs:"
        echo "  - code-smells/spec.md (仅快速检查清单表格)"
        ;;
    *)
        echo "Unknown task type: $TASK_TYPE"
        echo "Available: implement, review, design, refactor, bugfix, commit-check"
        exit 1
        ;;
esac
