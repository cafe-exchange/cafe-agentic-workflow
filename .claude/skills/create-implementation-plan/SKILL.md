---
name: create-implementation-plan
description: "Break an approved design into small ordered tasks with dependencies, files, acceptance criteria and test strategy, then request human approval (gate G1). Use before any implementation."
argument-hint: "<feature>"
---

# create-implementation-plan

Shared contracts: `docs/agentic/contracts/output-formats.md`, `docs/agentic/contracts/approval-gates.md`. Java-stack rules (`docs/agentic/contracts/java-stack.md`) only where the technology is present. Input: $ARGUMENTS

## Purpose
Produce a plan a developer agent can execute task by task.

## Activation conditions
After design-architecture; mandatory before implement-feature writes code.

## Required inputs
Analysis Report + design.

## Execution workflow
1. Delegate to `planner`.
2. Check each task has: files, depends-on, acceptance criteria, verification command.
3. Mark parallel-safe (disjoint files) vs sequential tasks.
4. Present the plan and **stop at gate G1** (`docs/agentic/contracts/approval-gates.md`). Record approval or requested changes.

## Expected outputs
Implementation Plan per output-formats.md + recorded G1 outcome.

## Quality criteria
Tasks small and independently verifiable; no task without acceptance criteria; risks and rollback listed.

## Error handling
On any failed command, show the real error, do not retry blindly more than once, and report status as **Blocked** with what is missing. If plan is rejected, revise and re-gate; never proceed on partial approval.

## Safety constraints
Read-only. Never begin implementation before G1 approval.
