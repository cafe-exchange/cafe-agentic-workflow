---
name: security-audit
description: "Deep security review of the codebase or a change: authN/authZ, injection, validation, secrets, dependencies, configuration. Use for security-focused requests or sensitive changes."
argument-hint: "<scope>"
---

# security-audit

Shared contracts: `docs/agentic/contracts/output-formats.md`, `docs/agentic/contracts/approval-gates.md`. Java-stack rules (`docs/agentic/contracts/java-stack.md`) only where the technology is present. Input: $ARGUMENTS

## Purpose
Find evidenced vulnerabilities and misconfigurations.

## Activation conditions
Auth/input/crypto/config/dependency changes, or explicit security request.

## Required inputs
Scope (whole repo or paths).

## Execution workflow
1. Delegate to `security-reviewer` with scope; if the scope is large, split by package and run in parallel (read-only).
2. Inspect `pom.xml` dependencies and config files (`application*.yaml`) for risky settings; check `.gitignore` covers secrets.
3. Consolidate; verify Critical/High by reading code.
4. Dependency CVEs: cite advisory IDs only if known with confidence; otherwise list as **Not verified** and suggest `./mvnw org.owasp:dependency-check-maven:check` (needs network; ask first).

## Expected outputs
Security-scoped Code Review Report.

## Quality criteria
Each finding has a data-flow or config evidence trail; Confirmed vs Plausible kept separate; no secret values shown.

## Error handling
On any failed command, show the real error, do not retry blindly more than once, and report status as **Blocked** with what is missing.

## Safety constraints
Read-only; no network scans or exploit execution; never print secret values.
