<!--
Handoff template. Copy the block below the line, fill every section, save via save-handoff.sh.
Keep all headings; write "N/A" when a section is genuinely empty. Delete these HTML comments.
Reference other artifacts by path/URL — do not paste plans, diffs, or logs wholesale.
Redact secrets (API keys, passwords, tokens, PII).
-->

---

# Handoff: <一句话说明这是什么任务>

> **接手第一步 / Start here:** <一条可直接执行的命令或动作，例如：先读本文件 → 运行 `pytest tests/` 看当前红灯 → 从「下一步」第 1 条继续>
> **状态 / Status:** 🟡 进行中（未完成）
> **交接时间 / Handed off:** <YYYY-MM-DD HH:MM>
> **上一位 agent 用的模型 / 会话:** <可选>

## 1. 目标 Objective
<我们最终要交付什么？一两句话，可验收的成品，而非过程。>

## 2. 背景与动机 Why
<为什么做这个、约束条件、用户的偏好/硬要求。链接需求文档而非复制。>

## 3. 当前进度 Status
**已完成 Done**
- [x] <…>

**进行中 In progress（当前卡在哪一步）**
- [ ] <…，具体到文件/函数/命令>

**未开始 Not started**
- [ ] <…>

## 4. 关键文件与位置 Key files
| 路径 file:line | 作用 / 现状 |
|---|---|
| `path/to/file.ext:42` | <改了什么 / 还要改什么> |

## 5. 运行环境 Environment
- 工作目录 / project root: `<path>`
- 构建 / 运行 / 测试命令:
  ```bash
  <build / run / test commands the next agent needs>
  ```
- 依赖 / 前置条件 / 需要的凭据（只写“需要什么”，不写凭据本身）: <…>

## 6. 关键决策与理由 Decisions (& why)
- **<决策>** — 因为 <理由>。（别轻易推翻，除非发现 <条件>）

## 7. 坑 / 死路 Gotchas & dead ends
- 试过 <方案X>，不行，因为 <原因>。别再走这条。
- 注意 <易错点 / 环境怪癖>。

## 8. 下一步 Next steps（有序、可执行）
1. <具体到“打开哪个文件、做什么改动、预期结果”>
2. <…>
3. <…>

## 9. 如何验证完成 Definition of done / verification
- <怎样算做完：测试通过？某命令输出？用户验收标准？>

## 10. 阻塞与待用户确认 Blockers / open questions
- ❓ <需要用户回答才能继续的问题>；未答之前用 <默认假设> 兜底。

## 11. 恢复记忆入口 Memory & references
- 建议调用的 skills / Suggested skills: <如 mem-search、learn-codebase、collab…>
- 记忆索引: `~/.claude/projects/-Users-iverson/memory/MEMORY.md` 中相关条目 <列名>
- 相关产物: <plan / PR / issue / ADR 路径或 URL>

---
<!-- 接手 agent：继续过程中请就地更新本文件（勾选完成项、追加新决策/坑），保持它始终是最新的"当前状态"。 -->
