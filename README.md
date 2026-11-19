# Cafe Agentic Workflow

An **agentic workflow** kit for [Claude Code](https://claude.com/claude-code), built for **Java/Spring (Maven)** backend projects. It bundles role-specific *agents*, reusable *skills* (ready-made workflows) and safety *hooks*, so Claude works through a disciplined process: analyze → design → plan → **human approval** → code → test → review → PR.

## Structure

```
.claude/
├── settings.json      # permissions (allow/ask/deny) + hook registration
├── agents/            # 9 role-specific subagents
├── skills/            # 15 skills (slash commands)
├── hooks/             # scripts that block/warn on risky actions
└── validate.sh        # integrity check for the framework
```

## Installation

1. Copy the `.claude/` directory into the **root** of your Java/Spring project (next to `pom.xml` and `mvnw`).
2. Install requirements: `jq`, `python3` + `PyYAML` (for validation), and the Maven wrapper `./mvnw`.
3. Make scripts executable: `chmod +x .claude/hooks/*.sh .claude/validate.sh`
4. Open Claude Code at the project root. Skills, agents and hooks load automatically.
5. Verify: `.claude/validate.sh` (exit 0 = all checks passed).

## Usage

Type a slash command in Claude Code. There are two kinds of skills.

### End-to-end workflows (manual invocation only)

| Command | Purpose |
|---|---|
| `/implement-feature <requirement/ticket>` | **Workflow A** – deliver a feature from requirement to PR description |
| `/fix-bug <bug description>` | **Workflow B** – reproduce, root-cause, fix, add a regression test, write an RCA |
| `/refactor-code <target and goal>` | Restructure code without changing behavior, protected by tests |
| `/debug-production-issue <incident>` | **Workflow D** – read-only production investigation, mitigation options, RCA |
| `/prepare-pull-request [slug]` | Generate PR title and description from the actual changes (does not commit/push) |
| `/verify-release <range>` | **Workflow E** – release readiness check with a go/no-go report |

### Building-block skills (Claude may invoke automatically; you can call them directly too)

| Command | Purpose |
|---|---|
| `/analyze-requirements` | Turn a vague requirement into an Analysis Report (acceptance criteria, edge cases, open questions) |
| `/explore-codebase` | Map relevant code: entry points, impacted components, conventions, tests |
| `/design-architecture` | Design a solution: options, trade-offs, API contracts, data model |
| `/create-implementation-plan` | Break a design into small ordered tasks, then request approval (G1) |
| `/generate-tests` | Design and write unit/integration tests, find coverage gaps |
| `/review-code` | **Workflow C** – independent multi-perspective review before merge |
| `/security-audit` | Review authN/authZ, injection, secrets, dependencies, configuration |
| `/performance-audit` | Analyze complexity, queries, pools, concurrency; propose measurements |
| `/update-documentation` | Update README/API docs/ADRs to match the code |

### Examples

```text
/implement-feature Add a table-booking API for the cafe, max 4 people per table
/fix-bug GET /orders returns 500 when the item list is empty
/review-code git diff main...HEAD
/verify-release v1.2.0..HEAD
```

## The `/implement-feature` flow

```
analyze-requirements → explore-codebase → design-architecture → create-implementation-plan
                                                                         │
                                                              ⛔ G1: human approves the plan
                                                                         ▼
        per task:  backend-developer → test-engineer  (compile/test after each step)
                                                                         ▼
                        review-code → fix confirmed Critical/High findings
                                                                         ▼
                                 ./mvnw -q verify → Final Report → prepare-pull-request
```

Claude **never commits, pushes or deploys on its own**; the final step is yours.

## Agents

| Agent | Role | Write access |
|---|---|---|
| `product-analyst` | Requirements analysis, acceptance criteria | Read-only |
| `architect` | Technical design, module boundaries | Read-only |
| `planner` | Task breakdown, dependencies, risks | Read-only |
| `backend-developer` | Implements one approved task at a time | `src/main` |
| `test-engineer` | Writes and runs tests | `src/test` |
| `code-reviewer` | Correctness, maintainability, SOLID | Read-only |
| `security-reviewer` | Security review | Read-only |
| `performance-engineer` | Performance review | Read-only |
| `documentation-writer` | Docs, ADRs, PR descriptions | `docs/` and Markdown files |

`validate.sh` checks that read-only agents have no Edit/Write tools.

## Human approval gates

| Gate | When |
|---|---|
| **G1** | Approve the implementation plan before any code is written |
| **G2** | Significant changes: public API, schema, security, >3 modules, new dependencies |
| **G3** | External writes: opening a PR (`gh pr create`) |
| **G4** | Release |
| **G5** | Production actions (rollback, scaling, etc.) |

## Safety hooks

| Hook | Runs | Effect |
|---|---|---|
| `guard-bash.sh` | Before Bash | **Blocks**: `rm -rf` on root/home, `git reset --hard`, `git clean -f`, force push, `DROP/TRUNCATE`, `curl \| sh`. **Asks**: `git commit/push/tag/merge/rebase` |
| `protect-files.sh` | Before Edit/Write | **Blocks** edits to `.env`, `*.pem`, `*.key`, `.git/`, etc. **Asks** for `pom.xml`, `application*.yml/properties`, `settings.json`, hook scripts |
| `check-edit.sh` | After Edit/Write | Quick syntax sanity check (JSON, YAML, XML, brace balance and tabs in Java) |
| `stop-check.sh` | When Claude stops | Non-blocking reminder if Java sources are newer than the last compile |

Debug hooks with `CLAUDE_HOOK_DEBUG=1` (logs to `.claude/hooks/hook.log`). Self-test: `.claude/hooks/test-hooks.sh`.

## Permissions in `settings.json`

- **Allowed**: `./mvnw test|compile|verify|dependency:tree`, `git status|diff|log|show`.
- **Ask first**: `git commit`, `git push`, `gh pr create`.
- **Denied**: reading `.env*`, `*.pem`, `*.key`, `credentials*`; `git push --force`, `git reset --hard`, `rm -rf /*`.

## Customizing

- **Add an agent**: create `.claude/agents/<name>.md` with frontmatter `name`, `description`, `tools`, `model`, and the sections `## Responsibilities`, `## Execution rules`, `## Expected output`, `## Constraints`.
- **Add a skill**: create `.claude/skills/<name>/SKILL.md` with frontmatter `name`, `description`, `argument-hint`; add `disable-model-invocation: true` for manual-only skills.
- For non-Maven/Java projects, adjust `permissions`, the hooks (`stop-check.sh`, `check-edit.sh`) and the `backend-developer`/`test-engineer` agents.
- After changes, re-run `.claude/validate.sh`. If you add agents or skills, update `REQ_AGENTS`/`REQ_SKILLS` in that script.

## Notes

Skills reference `CLAUDE.md` and `docs/agentic/contracts/` (`output-formats.md`, `approval-gates.md`, `java-stack.md`) in the target project, and `validate.sh` checks these paths. This repo doesn't contain those files yet, so create them when adopting the kit, otherwise `validate.sh` will report broken references.
