---
name: review-code
description: "Workflow C. Independent multi-perspective review (architecture, correctness, security, performance, maintainability, tests) of a diff or file set. Use before merge or on request."
argument-hint: "<diff, PR or files>"
---

# review-code

Shared contracts: `docs/agentic/contracts/output-formats.md`, `docs/agentic/contracts/approval-gates.md`. Java-stack rules (`docs/agentic/contracts/java-stack.md`) only where the technology is present. Input: $ARGUMENTS

## Purpose
Surface real, evidenced defects with severity.

## Activation conditions
User asks for a review; automatic phase in implement-feature/fix-bug.

## Required inputs
A diff, PR, or list of files. If not a git repo, use the explicit file list.

## Execution workflow
1. Determine scope: `git diff` if available, else the files given/changed in this session.
2. In ONE message spawn in parallel: `code-reviewer` (always), `security-reviewer` (if input/auth/config/deps touched), `performance-engineer` (if queries/hot paths/concurrency/I-O touched). Add a test-coverage check via `test-engineer` in read-only analysis mode only if coverage is unclear.
3. Consolidate: dedupe findings, sort by severity, keep Confirmed vs Plausible distinct.
4. Spot-check every Critical/High finding by reading the cited lines yourself; downgrade or drop any you cannot confirm.

## Expected outputs
Code Review Report (consolidated) with verdict.

## Quality criteria
Every finding has severity, `path:line`, evidence, impact, fix; no speculative item presented as confirmed.

## Error handling
On any failed command, show the real error, do not retry blindly more than once, and report status as **Blocked** with what is missing. If a reviewer returns without evidence, discard those findings.

## Safety constraints
Reviewers are read-only; this skill makes no edits. Fixes happen in a separate step.
