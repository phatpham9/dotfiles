---
applyTo: '**'
---

<!-- This file is symlinked to ~/.copilot/instructions/copilot-instructions.instructions.md -->
<!-- It applies globally to all GitHub Copilot interactions across all workspaces. -->
<!-- Source of truth: dotfiles/configs/ai-agents/copilot-instructions.md -->

# Core Engineering Rules

- Always prefer **TypeScript** with strict typing enabled.
- Avoid `any`, implicit `any`, and weak typing.
- Follow **Next.js conventions** for frontend and **NestJS module/service patterns** for backend.
- Apply **Atomic Design** principles for UI components.
- Prefer composition over inheritance; favor pure functions where possible.
- Use path aliases (`@/`) for imports.
- Enforce ESLint + Prettier formatting consistency.
- Generated code must be production-ready; avoid placeholders or TODOs unless explicitly requested.

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

- **Codebase**: One codebase per app, tracked in version control, many deploys.
- **Dependencies**: Explicitly declare and isolate dependencies — no implicit system-wide packages.
- **Config**: Store config in environment variables, never in code.
- **Backing Services**: Treat databases, caches, and queues as attached resources.
- **Build/Release/Run**: Strictly separate build, release, and run stages.
- **Processes**: Execute the app as stateless processes — no sticky sessions.
- **Port Binding**: Export services via port binding — be self-contained.
- **Concurrency**: Scale out via the process model (horizontal scaling).
- **Disposability**: Design for fast startup and graceful shutdown.
- **Dev/Prod Parity**: Keep dev, staging, and production as similar as possible.
- **Logs**: Treat logs as event streams — write to stdout, let platform aggregate.
- **Admin Processes**: Run admin/management tasks as one-off processes.

# DevOps Rules

- Dockerfiles must be multi-stage and cache-optimized.
- Kubernetes manifests must define resource requests/limits and probes.
- Prefer health checks alongside readiness probes.
- Use semantic versioning for container images.

# Coding Behavior Rules

## Think Before Coding

Don't assume. Don't hide confusion. Surface tradeoffs.

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## Simplicity First

Minimum code that solves the problem. Nothing speculative.

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## Surgical Changes

Touch only what you must. Clean up only your own mess.

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: every changed line should trace directly to the user's request.

## Goal-Driven Execution

Define success criteria. Loop until verified.

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

# Next.js Rules

- Default to **React Server Components (RSC)**; use `"use client"` only when interactivity is required.
- Use `next/image` and `next/font` for automatic optimization.
- Choose the right data fetching strategy (SSG, ISR, SSR) based on content dynamism.
- Use Suspense and streaming for progressive UI rendering.
- Prefix client-exposed env vars with `NEXT_PUBLIC_`.

# NestJS Rules

- Organize by **feature modules**, not file type (controllers/, services/).
- Use global validation pipes with `class-validator`.
- Implement health check endpoints (`@nestjs/terminus`).
- Use Helmet for secure HTTP headers in production.
- Apply rate limiting/throttling on API endpoints.

# Testing Rules

- Business logic must be testable without UI, database, or web server.
- Prefer integration tests for API boundaries, unit tests for domain logic.
- Mock external dependencies at adapter boundaries, not deep in business logic.

# CodeGraph MCP Usage

- When `codegraph_*` tools are available, prefer CodeGraph for structural code questions: symbol definitions, signatures, callers, callees, dependency impact, related context, and indexed file structure.
- Use `codegraph_context` first for broad feature or task exploration, then narrow with `codegraph_search`, `codegraph_node`, `codegraph_callers`, `codegraph_callees`, or `codegraph_impact`.
- Use native file search/read tools for literal text, comments, logs, config keys, or when CodeGraph is unavailable or the project has no `.codegraph/` index.
- If CodeGraph is configured but the index is missing, tell the user to run `codegraph init -i` from the project root.

# AI Behavior Rules

- Assume the user is a senior engineer; avoid basic explanations.
- For complex tasks, propose a plan before implementation.
- Prefer incremental changes over large monolithic PRs.
- When uncertain between equally valid approaches, state trade-offs and ask for preference.
- Ask clarifying questions only when ambiguity blocks correctness.
- Be concise, precise, and actionable.
