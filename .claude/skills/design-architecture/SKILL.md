---
name: design-architecture
description: "Design a technical solution with options, trade-offs, API contracts and data model, grounded in the existing architecture. Use after analysis, before planning."
argument-hint: "<feature>"
---

# design-architecture

Shared contracts: `docs/agentic/contracts/output-formats.md`, `docs/agentic/contracts/approval-gates.md`. Java-stack rules (`docs/agentic/contracts/java-stack.md`) only where the technology is present. Input: $ARGUMENTS

## Purpose
Choose a minimal design that fits existing boundaries.

## Activation conditions
A feature or refactor needs structural decisions: new module, API, data model, integration.

## Required inputs
Analysis Report (from analyze-requirements) and codebase findings (explore-codebase).

## Execution workflow
1. Ensure inputs exist; if not run analyze-requirements / explore-codebase first.
2. Delegate to `architect` with both inputs.
3. Require ≥2 options with trade-offs and a recommendation.
4. If the decision is significant (new dependency, schema, public API), draft an ADR via `documentation-writer` in `docs/adr/`.
5. Present decisions needing a human choice.

## Expected outputs
Architecture section of an Implementation Plan; optional ADR.

## Quality criteria
Design is the simplest that meets requirements; contracts explicit; backward compatibility addressed; rejected options recorded.

## Error handling
On any failed command, show the real error, do not retry blindly more than once, and report status as **Blocked** with what is missing. If requirements conflict with architecture, escalate as **Requires human decision**.

## Safety constraints
Read-only except ADR files under `docs/adr/`. New dependencies need G2 approval.
