---
name: analyze-requirements
description: "Turn a business requirement or ticket into a structured Analysis Report with acceptance criteria, edge cases and open questions. Use when a request is vague, new, or before designing anything."
argument-hint: "<requirement or ticket>"
---

# analyze-requirements

Shared contracts: `docs/agentic/contracts/output-formats.md`, `docs/agentic/contracts/approval-gates.md`. Java-stack rules (`docs/agentic/contracts/java-stack.md`) only where the technology is present. Input: $ARGUMENTS

## Purpose
Produce an unambiguous, testable requirement set.

## Activation conditions
A new feature/ticket arrives, or requirements are unclear. Called first by implement-feature.

## Required inputs
Requirement text or ticket key/URL (read via Jira MCP only if configured and read-only).

## Execution workflow
1. Delegate to `product-analyst` with the requirement and any known context.
2. If a ticket key is given and a Jira MCP is available, fetch it read-only; otherwise ask the user to paste it.
3. Review the report: every open question must be classified blocking / non-blocking.
4. Ask the human to resolve blocking questions (AskUserQuestion). Update the report with answers.

## Expected outputs
Analysis Report per `docs/agentic/contracts/output-formats.md`.

## Quality criteria
Each requirement testable; acceptance criteria in Given/When/Then; no invented requirements; blocking questions resolved or explicitly deferred.

## Error handling
On any failed command, show the real error, do not retry blindly more than once, and report status as **Blocked** with what is missing. If the requirement is too vague to analyze, return questions only.

## Safety constraints
Read-only. No code changes.
