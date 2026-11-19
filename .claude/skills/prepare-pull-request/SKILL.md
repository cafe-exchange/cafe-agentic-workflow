---
name: prepare-pull-request
description: "Generate a pull request title and description from the actual changes and verification results. Use when work is ready for review. Does not commit or push."
argument-hint: "<optional slug>"
disable-model-invocation: true
---

# prepare-pull-request

Shared contracts: `docs/agentic/contracts/output-formats.md`, `docs/agentic/contracts/approval-gates.md`. Java-stack rules (`docs/agentic/contracts/java-stack.md`) only where the technology is present. Input: $ARGUMENTS

## Purpose
Give reviewers a truthful, complete PR description.

## Activation conditions
Work is implemented and verified; user asks for PR text.

## Required inputs
Change set (git diff or explicit file list), Final Report if one exists.

## Execution workflow
1. Collect changes: `git diff --stat` and `git log` if a repo; else list files changed this session.
2. Draft `docs/pr/<slug>.md`: Summary, Motivation, Changes, Testing (exact commands + results labelled Verified/Not verified), Risks, Rollout/rollback, Reviewer notes.
3. Cross-check testing claims against what was really run; remove any unverified claim or label it **Not verified**.
4. Present the text to the user. Opening the PR (`gh pr create`) is a **G3** external write — only on explicit request.

## Expected outputs
PR description Markdown file.

## Quality criteria
Every claim backed by evidence; breaking changes and migrations called out; concise.

## Error handling
On any failed command, show the real error, do not retry blindly more than once, and report status as **Blocked** with what is missing. If not a git repo, say so and provide the description only.

## Safety constraints
No commit, push, or PR creation without explicit instruction.
