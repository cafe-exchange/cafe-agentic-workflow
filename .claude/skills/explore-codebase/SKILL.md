---
name: explore-codebase
description: "Map the relevant parts of the codebase for a task: entry points, impacted components, conventions, tests. Use before design or when locating where behavior lives."
argument-hint: "<topic or symptom>"
---

# explore-codebase

Shared contracts: `docs/agentic/contracts/output-formats.md`, `docs/agentic/contracts/approval-gates.md`. Java-stack rules (`docs/agentic/contracts/java-stack.md`) only where the technology is present. Input: $ARGUMENTS

## Purpose
Give the orchestrator verified knowledge of the existing implementation.

## Activation conditions
Any task touching existing code; first step of fix-bug and design-architecture.

## Required inputs
A topic, feature or symptom to locate.

## Execution workflow
1. Check `pom.xml` for actual dependencies and Java/Spring versions.
2. Use Grep/Glob to find entry points (`@RestController`, `@KafkaListener`, `@Scheduled`, `main`), then follow call paths.
3. For broad sweeps spawn the built-in `Explore` agent; for narrow ones search directly.
4. Identify conventions (naming, layering, error handling) and the existing tests covering the area.
5. Summarize impacted components with `path:line` evidence.

## Expected outputs
The Existing implementation + Impacted components sections of an Analysis Report.

## Quality criteria
Every claim cites `path:line`; states what was NOT found; no assumptions about absent technology.

## Error handling
On any failed command, show the real error, do not retry blindly more than once, and report status as **Blocked** with what is missing. If nothing relevant exists, say so (greenfield) rather than guessing.

## Safety constraints
Read-only.
