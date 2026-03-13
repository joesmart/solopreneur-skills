# Microservices Project Template

Generated `PROJECT_MAP.md` MUST strictly contain the following sections in this exact order. No sections may be omitted, reordered, or added.

```markdown
# 项目架构地图

> 本文档描述微服务架构中各服务的调用关系，帮助快速定位代码位置和理解服务协作方式。

## 服务清单

<!-- 格式: **服务名** - 职责描述 - 技术栈 - 代码路径 -->

- **service-a** - [职责描述] - [语言/框架] - `[代码路径]`
- **service-b** - [职责描述] - [语言/框架] - `[代码路径]`
- **service-c** - [职责描述] - [语言/框架] - `[代码路径]`

## 服务调用关系图

<!-- 
使用ASCII字符绘制服务调用关系图
建议使用的字符: ┌ ┐ └ ┘ ├ ┤ ┬ ┴ ┼ │ ─ → ← ↑ ↓ ▶ ◀ ▲ ▼
-->

​```
[在这里绘制实际的服务调用关系图]

符号说明：
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  →  HTTP 同步调用
  ⇢  消息队列异步通知
  ─  数据库连接
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
​```

**调用关系说明**:

- service-a → service-b: [调用目的]
- service-b → service-c: [调用目的]
- service-a ⇢ service-d: [消息队列通知内容]

## 服务目录结构

<!-- 列出各服务的目录结构，帮助快速定位代码 -->

### service-a
​```
service-a/
├─ controller/    # [说明]
├─ service/       # [说明]
├─ dao/           # [说明]
└─ model/         # [说明]
​```

### service-b
​```
service-b/
├─ [目录1]/       # [说明]
├─ [目录2]/       # [说明]
└─ [目录3]/       # [说明]
​```

---

## 维护说明

**更新时机**:
- 新增服务时
- 修改服务间调用关系时
- 变更通信方式时（HTTP→MQ或反之）

**不需要更新**:
- 业务功能变更
- 代码重构（不改变服务边界）
- Bug修复
```
