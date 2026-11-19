---
name: performance-audit
description: "Analyze complexity, allocations, queries, pools and concurrency for performance risks with proposed measurements. Use for slow paths or performance-sensitive changes."
argument-hint: "<scope>"
---

# performance-audit

Shared contracts: `docs/agentic/contracts/output-formats.md`, `docs/agentic/contracts/approval-gates.md`. Java-stack rules (`docs/agentic/contracts/java-stack.md`) only where the technology is present. Input: $ARGUMENTS

## Purpose
Identify real bottlenecks and the measurement that would confirm them.

## Activation conditions
Latency/throughput/memory concerns, hot-path changes, query changes.

## Required inputs
Scope plus any metrics or profiles the user can supply.

## Execution workflow
1. Delegate to `performance-engineer` with scope and any measurements.
2. Separate Confirmed (evident from code, e.g., N+1, O(n²) on unbounded input) from Plausible (needs measurement).
3. For each Plausible item, name the measurement (JFR, `EXPLAIN ANALYZE`, JMH, load test).
4. Run measurements only if the human approves (they can be expensive).

## Expected outputs
Performance-scoped Code Review Report with measurement plan.

## Quality criteria
No performance numbers unless measured; recommendations ranked by expected impact vs cost.

## Error handling
On any failed command, show the real error, do not retry blindly more than once, and report status as **Blocked** with what is missing.

## Safety constraints
Read-only; no load tests against shared/production systems.
