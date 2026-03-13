# Design Document Output Template

**CRITICAL**: This template is MANDATORY. The final design document MUST strictly follow this format.

---

## Document Structure

The design document must contain these sections in this exact order. No sections may be omitted, reordered, or added.

```markdown
# Design: [功能名称]

## 需求

**用户需求**：[一句话概括]

**范围**：
- 做什么: [核心功能]
- 不做什么: [明确排除的事项]

**参考模块**：[最相似的现有模块名称及路径]

---

## Database Design

### Table: [table_name]

**用途**：[一句话描述]

**Schema**：

（完整 CREATE TABLE DDL，遵循 database-design spec）

**设计说明**：
- 表命名规则
- 字段命名规则
- 索引设计理由

---

## End-to-End Flow

（使用标准化节点协议的 ASCII 流程图，标注服务边界和通信方式）

**Visual Indicators for Changes**:
- ✨ New: Completely new components/services
- 🔧 Extend: Modifications to existing components
- 📝 Modify: Changes to existing logic
- Mark new/modified steps with [新增] or [修改] tags

---

## Implementation Tasks

（按功能模块分组，每个任务包含完整的实现细节）

---

## 待确认

[如有开放问题列出，否则写 "N/A"]
```

---

## Implementation Tasks Format

**MANDATORY**: Every Implementation Tasks section MUST follow this exact format.

### Template Structure

```markdown
## Implementation Tasks

### [功能模块名称]

#### [子任务编号] [具体任务描述]

**Status**: 🔲 TODO / 🔄 IN PROGRESS / ✅ DONE

**Related Specs**: [相关规范列表，用逗号分隔]

**Done When**:
- [ ] [验收标准1 - 具体可验证的条件]
- [ ] [验收标准2 - 包含具体的代码位置或指标]
- [ ] [验收标准3 - 引用相关规范]

**Implementation Details**:
- **File**: `完整文件路径`
- **Class**: `ClassName`
- **Method**: `methodName(paramTypes) → returnType`
- **Responsibility**: 一句话描述该方法的职责
- **Steps**:
  1. 具体操作步骤1
  2. 具体操作步骤2
  3. 具体操作步骤3

---
```

### Complete Example

```markdown
## Implementation Tasks

### 1. 列表展示支持负数品类ID

#### 1.1 新增 formatCategoryName 私有方法

**Status**: 🔲 TODO

**Related Specs**: code-quality-php, project-structure

**Done When**:
- [ ] 方法能正确格式化负数 cat_id 为"XXX - 全部二级品类"
- [ ] 方法能正确格式化正数 cat_id 为品类名称
- [ ] 方法行数 ≤ 25 行 (code-quality-php)
- [ ] 使用卫语句减少嵌套 (code-quality-php)
- [ ] 复用 CategoryMatcherService::getFirstLevelCategoryName() (project-structure)

**Implementation Details**:
- **File**: `wdcl-inquiry-service/app/Controller/DirectSetting.php`
- **Class**: `DirectSetting`
- **Method**: `formatCategoryName(int $catId) → string`
- **Responsibility**: 格式化品类ID为可读的品类名称，支持负数ID表示全部二级品类
- **Steps**:
  1. 检查 cat_id 是否为负数（卫语句）
  2. 如果为负数，调用 CategoryMatcherService::getFirstLevelCategoryName(abs($catId)) 获取一级品类名
  3. 返回格式化字符串："{一级品类名} - 全部二级品类"
  4. 如果为正数，直接返回品类名称

---

#### 1.2 修改 formatDirectListData 方法

**Status**: 🔲 TODO

**Related Specs**: code-quality-php

**Done When**:
- [ ] 列表展示正确显示"XXX - 全部二级品类"
- [ ] 调用 formatCategoryName() 处理品类名称
- [ ] 使用 PHP 8.0+ 特性（类型转换） (code-quality-php)

**Implementation Details**:
- **File**: `wdcl-inquiry-service/app/Controller/DirectSetting.php`
- **Class**: `DirectSetting`
- **Method**: `formatDirectListData(array $data) → array`
- **Responsibility**: 格式化直销配置列表数据，包括品类名称展示
- **Steps**:
  1. 遍历 $data 数组
  2. 对每条记录的 cat_id 调用 $this->formatCategoryName()
  3. 将格式化后的品类名称赋值给 category_name 字段
  4. 返回格式化后的数组

---

### 2. 直销分配支持负数品类ID匹配

#### 2.1 修改 InquiryService::getOperateUid 方法

**Status**: 🔲 TODO

**Related Specs**: code-quality-php, project-structure

**Done When**:
- [ ] 直销分配能正确匹配负数 cat_id 配置
- [ ] 精确匹配优先，负数匹配兜底
- [ ] 复用 CategoryMatcherService::buildQueryIds() (project-structure)
- [ ] 复用 CategoryMatcherService::matchConfigs() (project-structure)
- [ ] 方法行数 ≤ 25 行 (code-quality-php)
- [ ] 日志极度克制，只记录关键节点 (code-quality-php)

**Implementation Details**:
- **File**: `wdcl-inquiry-service/app/Logic/InquiryService.php`
- **Class**: `InquiryService`
- **Method**: `getOperateUid(int $catId) → int`
- **Responsibility**: 根据品类ID获取直销运营人员UID，支持负数品类ID的模糊匹配
- **Steps**:
  1. 调用 CategoryMatcherService::buildQueryIds($catId) 构建查询ID列表（包含精确ID和负数ID）
  2. 查询直销配置表，WHERE cat_id IN (查询ID列表)
  3. 调用 CategoryMatcherService::matchConfigs($configs, $catId) 进行优先级匹配
  4. 返回匹配到的运营人员UID，未匹配则返回默认值

---
```

---

## Key Requirements

### 1. Status Icons
Use emoji for visual clarity:
- 🔲 TODO
- 🔄 IN PROGRESS
- ✅ DONE

### 2. Related Specs
Always reference applicable specs from the project's spec documents.

### 3. Done When Criteria
Must be specific, measurable, and verifiable:
- Include concrete metrics (e.g., "≤ 25 行")
- Reference specific code locations when possible
- Link to spec requirements with (spec-name) notation

### 4. Implementation Details
Must include ALL of:
- **File**: Complete file path
- **Class**: Class name
- **Method**: Full method signature with parameter types and return type
- **Responsibility**: One-sentence description of what the method does
- **Steps**: Numbered list of implementation steps

### 5. Grouping
Group related tasks under functional modules using hierarchical numbering (1.1, 1.2, 2.1, etc.)

### 6. Separation
Use `---` to clearly separate individual tasks for better readability.

---

## End-to-End Flow Visual Indicators

When creating E2E flow diagrams, use these visual indicators to highlight changes:

### Status Indicators
```
[Status: ✨ New]      - Completely new component/service
[Status: 🔧 Extend]   - Extending existing component with new functionality
[Status: 📝 Modify]   - Modifying existing logic
```

### Step-Level Indicators
Mark individual steps within a node:
```
├── Step 1: 查询Lead和AgentSession
├── Step 2: 构建追问消息 [🆕 新增逻辑]
├── Step 3: 通过IM渠道发送追问消息 [🆕 新增逻辑]
└── Step 4: 记录追问状态 [🆕 新增逻辑]
```

### Example Node with Visual Indicators

```
┌──────────────────────────────────────────────────────────────────┐
│ [h-moss]: ContactFollowUpBizService [Status: ✨ New]             │
├──────────────────────────────────────────────────────────────────┤
│  [G1] ContactFollowUpBizServiceImpl                               │
│      File: h-moss/.../lead/biz/impl/ContactFollowUpBizServiceImpl.java [新增] │
│      Method: triggerFollowUp(Long leadId, String contactInfo, String reason) → void │
│      Responsibility: 触发联系方式追问                              │
│      Input: leadId(线索ID), contactInfo(联系方式), reason(无效原因) │
│      Output: void                                                │
│      │                                                           │
│      ├── Step 1: 查询Lead和AgentSession [🆕 新增逻辑]             │
│      ├── Step 2: 构建追问消息 [🆕 新增逻辑]                        │
│      ├── Step 3: 通过IM渠道发送追问消息 [🆕 新增逻辑]              │
│      └── Step 4: 记录追问状态到LeadElement [🆕 新增逻辑]          │
└──────────────────────────────────────────────────────────────────┘
```

For modified nodes:
```
┌──────────────────────────────────────────────────────────────────┐
│ [h-moss]: LeadCheckScoreBizService [Status: 🔧 Extend]           │
├──────────────────────────────────────────────────────────────────┤
│  [D1] LeadCheckScoreBizServiceImpl                                │
│      File: h-moss/.../lead/biz/impl/LeadCheckScoreBizServiceImpl.java │
│      Method: checkAndScore(LeadSaveOrUpdateDTO, Lead) → void     │
│      Responsibility: 执行联系方式检测并评分                        │
│      │                                                           │
│      ├── Step 1: initLeadElement(dto, lead) - 初始化线索要素      │
│      ├── Step 2: checkPhoneNumber(dto, leadElement) - 提交手机号检测 │
│      ├── Step 3: checkEmail(dto, leadElement) - 提交邮箱检测     │
│      └── Step 4: 检查联系方式是否全部无效 [🆕 新增逻辑]            │
└──────────────────────────────────────────────────────────────────┘
```
