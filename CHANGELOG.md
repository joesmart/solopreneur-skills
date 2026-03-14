# Changelog

本文件记录所有重要变更。格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)。

## [2.0.0] - 2026-03-13

### Changed
- 仓库定位从"AI 研发助手技能包"升级为"一人软件公司全链路 AI 技能仓库"
- 现有 9 个研发类 Skills 迁移至 `skills/dev/` 子目录
- 所有 Skills 内部路径引用更新适配新目录结构

### Added
- `CLAUDE.md` 项目指令文件
- `.claude-plugin/plugin.json` Plugin 配置
- `docs/creating-skills.md` Skill 编写指南
- `scripts/validate-skills.sh` 格式校验脚本
- 六大分类子目录骨架：`product/`、`content/`、`visual/`、`util/`、`ops/`

## [1.0.0] - 初始版本

### Added
- 9 个软件研发 Skills（设计/编码/审查）
- 8 个通用编码规范（Clean Code 体系）
- 14 个自动化检查脚本
- 共享模块（思维纪律、质量门、规范加载）
