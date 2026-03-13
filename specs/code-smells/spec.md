# 代码坏味道检测清单

> 源自 Martin Fowler《重构》第三章 + Clean Code + 实践总结
>
> 每种坏味道标注：检测方式（🤖 脚本 / 🧠 AI）、推荐重构手法

---

## 一、臃肿类（Bloaters）

### 1. 过长方法（Long Method）
- **信号**: 函数体 > 25 行
- **检测**: 🤖 `check-method-length.sh`
- **重构**: Extract Method — 按逻辑块拆分为多个小函数

### 2. 过大类（Large Class / God Class）
- **信号**: 类超过 300 行，或有 5+ 个不同职责
- **检测**: 🤖 `check-method-length.sh` (行数) + 🧠 (职责判断)
- **重构**: Extract Class — 将不同职责分离到独立类

### 3. 过长参数列表（Long Parameter List）
- **信号**: 函数参数 ≥ 3 个
- **检测**: 🧠
- **重构**: Introduce Parameter Object — 封装为参数对象

### 4. 基本类型偏执（Primitive Obsession）
- **信号**: 用字符串/整数表示领域概念（status=1/2/3, type="A"/"B"）
- **检测**: 🧠
- **重构**: Replace Type Code with Class / Enum

### 5. 数据泥团（Data Clumps）
- **信号**: 同一组参数在多处反复出现
- **检测**: 🧠
- **重构**: Introduce Parameter Object / Extract Class

---

## 二、滥用面向对象（OO Abusers）

### 6. Switch / If-Else 链（Switch Statements）
- **信号**: 基于类型码的 switch/if-else 在多处重复
- **检测**: 🧠
- **重构**: Replace Conditional with Polymorphism / Strategy Pattern

### 7. 被拒绝的遗赠（Refused Bequest）
- **信号**: 子类继承了父类但不使用/覆盖大部分功能
- **检测**: 🧠
- **重构**: Replace Inheritance with Delegation

### 8. 临时字段（Temporary Field）
- **信号**: 类的某些字段只在特定情况下有值
- **检测**: 🧠
- **重构**: Extract Class — 将临时字段及其相关方法移出

---

## 三、变更阻碍（Change Preventers）

### 9. 发散式变更（Divergent Change）
- **信号**: 一个类因为不同原因需要频繁修改
- **检测**: 🧠 (需分析 git log)
- **重构**: Extract Class — 按变更原因拆分

### 10. 散弹式修改（Shotgun Surgery）
- **信号**: 一个变更需要修改多个不相关的文件
- **检测**: 🧠 (需分析改动范围)
- **重构**: Move Method / Move Field — 将分散的逻辑集中

### 11. 平行继承（Parallel Inheritance Hierarchies）
- **信号**: 每次增加一个子类就需要在另一个层级也增加一个
- **检测**: 🧠
- **重构**: 合并层级或使用组合

---

## 四、非必要的（Dispensables）

### 12. 重复代码（Duplicated Code）
- **信号**: 相同/相似代码块出现在 2+ 处
- **检测**: 🧠
- **重构**: Extract Method → 提取共用方法
- **规则**: 相同模式重复 3 次以上 MUST 提取

### 13. 冗余注释（Comments as Deodorant）
- **信号**: 注释解释"显而易见的逻辑"，或用注释弥补命名不清
- **检测**: 🧠
- **重构**: Rename Variable/Method — 用自文档化的名称替代注释

### 14. 多余的类/方法（Lazy Class / Speculative Generality）
- **信号**: 类/方法只被调用一次，没有复用价值
- **检测**: 🧠
- **重构**: Inline Class / Inline Method

### 15. 死代码（Dead Code）
- **信号**: 永远不会执行的代码、从未调用的方法
- **检测**: 🧠 + IDE
- **重构**: 直接删除

---

## 五、耦合类（Couplers）

### 16. 特性依恋（Feature Envy）
- **信号**: 方法大量使用另一个类的数据，而很少使用自己类的
- **检测**: 🧠
- **重构**: Move Method — 将方法移到它最常使用的类中

### 17. 过度亲密（Inappropriate Intimacy）
- **信号**: 两个类互相访问对方的私有成员
- **检测**: 🧠
- **重构**: Move Method/Field, Extract Class, Hide Delegate

### 18. 消息链（Message Chains）
- **信号**: 连续调用 `a.getB().getC().getD()`
- **检测**: 🤖 `check-null-safety.sh` (链式调用)
- **重构**: Hide Delegate / Extract Method

### 19. 中间人（Middle Man）
- **信号**: 类的大部分方法只是委托给另一个类
- **检测**: 🧠
- **重构**: Remove Middle Man / Inline Method

---

## 六、其他坏味道

### 20. 魔法数字 / 硬编码（Magic Numbers）
- **信号**: 代码中出现裸数字或字符串常量
- **检测**: 🧠 + 🤖 `check-forbidden-patterns.sh`
- **重构**: Replace Magic Number with Named Constant / Enum

### 21. 防御性拷贝缺失
- **信号**: 可变对象通过 getter 暴露内部引用
- **检测**: 🧠
- **重构**: 返回不可变副本或使用不可变对象

### 22. 不一致的抽象层次
- **信号**: 同一函数中混合高层编排与低层实现
- **检测**: 🧠
- **重构**: Extract Method — 提取低层逻辑，保持同一抽象层次

---

## 快速检查清单（供 code-reviewer / commit-checker 使用）

| # | 坏味道 | 检测 | 严重度 |
|---|--------|------|--------|
| 1 | 方法 > 25 行 | 🤖 | 🟡 |
| 2 | 类 > 300 行 | 🤖 | 🟡 |
| 3 | 参数 ≥ 3 个 | 🧠 | 🟢 |
| 4 | 重复代码 ≥ 3 处 | 🧠 | 🔴 |
| 5 | 空 catch / 吞异常 | 🤖 | 🔴 |
| 6 | 循环中 DB 查询 | 🧠 | 🔴 |
| 7 | SQL 字符串拼接 | 🤖 | 🔴 |
| 8 | 链式调用 ≥ 3 层 | 🤖 | 🟡 |
| 9 | 魔法数字 | 🤖 | 🟡 |
| 10 | 散弹式修改 | 🧠 | 🟡 |
| 11 | 过程性日志 | 🧠 | 🟢 |
| 12 | 命名不清 | 🤖+🧠 | 🟡 |
