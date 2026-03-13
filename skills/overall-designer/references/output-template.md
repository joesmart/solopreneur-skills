# Overall Design Output Template

The final design document MUST strictly contain the following sections in this exact order. No sections may be omitted, reordered, or added.

```markdown
# [功能名称] - 初步设计方案

## 一、背景与问题

[描述业务背景、核心矛盾、要解决的问题]

## 二、总体方案

### 2.1 方案总览

[用 ASCII 图展示整体架构，标注新增/变更部分]

### 2.2 核心设计原则

[列出核心设计原则，每条说明理由]

## 三、数据库模型概要

[每个表：表名 + 用途 + 核心字段 + 表间关系图]
[标注新建/修改]

## 四、核心流程链路

[按关键路径分别绘制 ASCII 流程图，使用链路节点协议]
[标注系统间通信方式和数据流向]
[标注新增/变更部分]

## 五、迭代实施计划

[按 Phase 拆分，每个 Phase 包含目标、交付物、Step 列表]
[Phase 间依赖关系图]
[关键里程碑]

## 六、关键设计决策

| # | 决策 | 理由 |
|---|------|------|

## 七、待确认事项

[列出所有待确认的问题，如果没有写 "N/A"]
```
