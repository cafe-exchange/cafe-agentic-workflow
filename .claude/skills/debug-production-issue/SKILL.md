---
name: debug-production-issue
description: "Workflow D. Investigate a production incident read-only: collect evidence, separate facts from hypotheses, propose mitigation, write RCA. Use for outages, error spikes, latency incidents."
argument-hint: "<incident description>"
disable-model-invocation: true
---

# debug-production-issue

Shared contracts: `docs/agentic/contracts/output-formats.md`, `docs/agentic/contracts/approval-gates.md`. Java-stack rules (`docs/agentic/contracts/java-stack.md`) only where the technology is present. Input: $ARGUMENTS

## Purpose
Find the cause from evidence without changing production.

## Activation conditions
User reports a production incident or asks to analyze logs/metrics/traces.

## Required inputs
Incident description, time window, and any logs/metrics provided or reachable via configured read-only MCP (Grafana, Datadog, Postgres replica).

## Execution workflow
1. Establish: symptom, start time, blast radius, recent changes.
2. Collect evidence only via read-only sources; list which sources are unavailable (**Blocked**) rather than guessing.
3. Correlate logs, metrics, traces; check DB and Kafka behavior (lag, rebalances, slow queries, pool exhaustion) when relevant.
4. Write the Facts table and a separate Hypotheses table with the evidence that would confirm/refute each.
5. Propose mitigation options (rollback, flag, scale) as *recommendations*; execution needs **gate G5** and is not done by this skill.
6. Produce the RCA (output-formats.md).

## Expected outputs
RCA report; mitigation proposals.

## Quality criteria
Facts and hypotheses never mixed; every fact cites its source; unknowns listed.

## Error handling
On any failed command, show the real error, do not retry blindly more than once, and report status as **Blocked** with what is missing.

## Safety constraints
STRICTLY READ-ONLY. Never execute production-changing actions, restarts, writes or deployments. Redact secrets and PII from outputs.
