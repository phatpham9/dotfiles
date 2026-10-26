<!-- User-level Claude Code instructions. This file is symlinked from ~/.claude/CLAUDE.md. -->

# Core Engineering Rules

- For TypeScript projects, enable strict typing and avoid `any`/implicit `any`.
- For Next.js frontends, follow Next.js conventions; for NestJS backends, use feature modules/services.
- For React UI, apply Atomic Design and prefer composition over inheritance.
- Use `@/` path aliases in TypeScript projects.
- Enforce ESLint + Prettier on TypeScript/JavaScript projects.
- Generated code must be production-ready; no placeholders or TODOs unless requested.

# Architecture Rules

- Follow the **Dependency Rule** — source code dependencies point inward only.
- Keep **domain/business logic independent** of frameworks, UI, and databases.
- Treat **microservices as a deployment strategy**, not an architecture.
- Apply **Domain-Driven Design (DDD)** principles for complex business domains.
- Defer decisions about external technologies (databases, web servers) as long as possible.

# Security Rules

- Never generate, log, or store secrets, API keys, tokens, or credentials.
- Apply OWASP secure defaults (CORS, CSRF, XSS protection).
- Enforce Content Security Policy (CSP) headers.
- Sanitize all user inputs at API boundaries.
- Highlight security implications for auth, APIs, and data access.
- Prefer least-privilege IAM and secure network boundaries.
- Treat all systems as production-grade unless explicitly stated otherwise.

# API & Data Rules

- Prefer RESTful APIs with explicit versioning (`/v1`).
- Use GraphQL only when strong justification exists.
- Always define DTOs with validation (Zod, class-validator).
- Document APIs using OpenAPI or GraphQL schemas.
- Prefer pagination for list endpoints.
- Use consistent error response schemas (e.g., RFC 7807 Problem Details).
- Explicitly manage schema changes and migrations.

# 12-Factor App Rules

- **Codebase, dependencies, config, backing services**: one repo, explicit deps, env-based config, attached resources.
- **Build/release/run, processes, port binding**: separate stages, stateless processes, self-contained ports.
- **Concurrency, disposability, dev/prod parity**: scale out, fast startup/shutdown, matching environments.
- **Logs, admin processes**: stdout event streams, one-off admin tasks.

# DevOps Rules

- Use multi-stage, cache-optimized Dockerfiles and semantic versioning for images.
- Kubernetes manifests must define resource requests/limits, probes, and health checks.

# Coding Behavior Rules

## Think Before Coding

- State assumptions explicitly; ask when uncertain.
- Present multiple interpretations rather than picking silently.
- Surface simpler alternatives and push back when warranted.
- If requirements are unclear, stop and name the confusion.

## Simplicity First

- Build only what was asked; no speculative features or abstractions.
- No configurability or error handling for scenarios that cannot occur.
- If 200 lines could be 50, rewrite before finishing.

## Surgical Changes

- Do not improve adjacent code, comments, or formatting.
- Do not refactor things that are not broken; match existing style.
- Remove only imports/variables/functions made unused by your change.
- Mention unrelated dead code; do not delete it.
- Every changed line must trace to the user's request.

## Goal-Driven Execution

- Turn tasks into verifiable goals: failing test -> fix -> passing test.
- For multi-step work, state a brief plan with a verification check per step.
- Loop until the success criteria are verified.

# Frontend Rules (Next.js)

- Default to React Server Components; use `"use client"` only when interactivity requires it.
- Use `next/image`, `next/font`, Suspense/streaming, and an explicit SSG/ISR/SSR strategy.
- Prefix client-exposed env vars with `NEXT_PUBLIC_`.

# Backend Rules (NestJS)

- Organize by feature modules; use global `class-validator` validation.
- Use Helmet, rate limiting, and `@nestjs/terminus` health checks in production.
- Keep domain logic independent of framework and transport concerns.

# Systems Languages (Go, Rust)

## Go

- Use `gofmt`, `go vet`, and `golangci-lint`; pass `context.Context` through request-scoped chains.
- Wrap errors with `%w`; give every goroutine a cancellation path to avoid leaks.
- Prefer the standard library, table-driven tests, and explicit constructors over `init()`.

## Rust

- Use `rustfmt` and `clippy -D warnings`; avoid `unwrap()`/`expect()` in production paths.
- Prefer borrowing over cloning; use `thiserror` for library errors and `anyhow` at boundaries.
- Keep async code cancellation-safe; never hold a lock across `.await`; justify every `unsafe` block.

# Infrastructure as Code (Terraform/OpenTofu)

- Prefer OpenTofu (`tofu`); pin providers/modules and use remote state with locking.
- Never commit state, plans, or secrets; apply least-privilege IAM and explicit network boundaries.
- Run `tofu fmt`, `tofu validate`, and `tofu plan` before `tofu apply`; tag resources consistently.

# Testing Rules

- Business logic must be testable without UI, database, or web server.
- Prefer integration tests for API boundaries and unit tests for domain logic.
- Mock external dependencies at adapter boundaries, not deep in business logic.

<!-- CODEGRAPH_START -->
# CodeGraph

- In repos with a `.codegraph/` index, use `codegraph_explore` (MCP) or `codegraph explore` (shell) before grep/find for symbol, call-path, and impact questions.
- Use native search/read tools for literal text, logs, config keys, or when CodeGraph is unavailable.
- If CodeGraph is configured but the index is missing, tell the user to run `codegraph init -i`.
- If there is no `.codegraph/`, skip CodeGraph entirely.
<!-- CODEGRAPH_END -->

# AI Behavior Rules

- Assume the user is a senior engineer; avoid basic explanations.
- For complex tasks, propose a plan before implementation.
- Prefer incremental changes over large monolithic PRs.
- When uncertain between equally valid approaches, state trade-offs and ask for preference.
- Ask clarifying questions only when ambiguity blocks correctness.
- Be concise, precise, and actionable.

<!-- AI-ROUTING-START -->
## Skill routing: Superpowers + Matt Pocock

- Requirements / ambiguous scope: use `mattpocock-skills:grilling` for the
  interview. For documented grilling or spec/ticket handoff, ask the user to
  run `/mattpocock-skills:grill-with-docs`,
  `/mattpocock-skills:to-spec`, or `/mattpocock-skills:to-tickets`.
- Issue triage / PR flow: use `mattpocock-skills:pr` for PR bodies. For triage
  or retro, ask the user to run `/mattpocock-skills:triage` or
  `/mattpocock-skills:retro`.
- Execution with an approved spec: `superpowers:writing-plans` ->
  `executing-plans` or `subagent-driven-development`; use
  `superpowers:test-driven-development`.
- Debugging: `mattpocock-skills:diagnosing-bugs` for hypothesis-driven work in
  known code; `superpowers:systematic-debugging` for unfamiliar code or
  regressions.
- Code review: `mattpocock-skills:code-review` for a single pass;
  `superpowers:requesting-code-review` / `receiving-code-review` for subagent
  review loops.
- Architecture / domain: use `mattpocock-skills:domain-modeling` and
  `codebase-design`. For a repo-wide scan, ask the user to run
  `/mattpocock-skills:improve-codebase-architecture`.
- Never run both TDD skills on the same task; use Matt's `tdd` only when
  explicitly requested.
- Always finish with `superpowers:verification-before-completion`; use
  `finishing-a-development-branch` before opening a PR.
- Use fully namespaced skill names for the overlapping TDD, review, debugging,
  and planning workflows.
- User instructions in this file take precedence over skill instructions.

## Agent routing

- PR review: run `/pr-review-toolkit:review-pr`. It dispatches
  `pr-review-toolkit:code-reviewer`,
  `pr-review-toolkit:silent-failure-hunter`,
  `pr-review-toolkit:pr-test-analyzer`,
  `pr-review-toolkit:type-design-analyzer`,
  `pr-review-toolkit:comment-analyzer`, and
  `pr-review-toolkit:code-simplifier`. Do not also invoke a second generic
  review agent for the same diff.
- Full security scan: invoke the `claude-security:claude-security` skill; its
  orchestrator dispatches the `claude-security:*` scan agents.
- Targeted security review:
  `security-scanning:security-scanning-security-auditor` or
  `security-scanning:threat-modeling-expert`.
- TypeScript/Next.js/NestJS: prefer `javascript-typescript:typescript-pro` or
  `javascript-typescript:javascript-pro`.
- Python/AI-ML: prefer `python-development:python-pro`,
  `python-development:python-development-fastapi-pro`, or
  `python-development:python-development-django-pro`.
- Go: prefer `systems-programming:golang-pro`.
- Rust: prefer `systems-programming:rust-pro`; use
  `/systems-programming:rust-project` to scaffold a Cargo project.
- Terraform/OpenTofu: prefer
  `cloud-infrastructure:cloud-infrastructure-terraform-specialist`; use the
  `cloud-infrastructure:terraform-module-library` skill for reusable modules.
- Cloud architecture/deployment: prefer
  `cloud-infrastructure:cloud-infrastructure-cloud-architect`,
  `cloud-infrastructure:cloud-infrastructure-deployment-engineer`,
  `cloud-infrastructure:hybrid-cloud-architect`, or
  `cloud-infrastructure:service-mesh-expert`. Use the existing
  `kubernetes-operations` and `observability-monitoring` packs for Kubernetes
  and observability work.
- Kubernetes: prefer
  `kubernetes-operations:kubernetes-operations-kubernetes-architect`.
- Observability/performance: prefer
  `observability-monitoring:observability-monitoring-observability-engineer`,
  `observability-monitoring:observability-monitoring-performance-engineer`,
  `observability-monitoring:observability-monitoring-database-optimizer`, or
  `observability-monitoring:observability-monitoring-network-engineer`.
- Some wshobson agents carry a doubled plugin prefix; use the exact registered
  names above. Copy exact names from `claude plugin details` or the
  `claude --agent` error list.
- Keep review and investigation agents read-only unless the task explicitly
  asks for a patch.
- Prefer one review path per task: `/pr-review-toolkit:review-pr` for PRs,
  `claude-security:claude-security` for security scans, and
  `superpowers:requesting-code-review` for subagent loops.
<!-- AI-ROUTING-END -->
