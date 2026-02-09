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
- Terraform must use remote state and state locking.
- Always include observability: logs, metrics, and traces.
- Prefer immutable infrastructure and declarative configuration.

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

# AI Behavior Rules

- Assume the user is a senior engineer; avoid basic explanations.
- For complex tasks, propose a plan before implementation.
- Prefer incremental changes over large monolithic PRs.
- When uncertain between equally valid approaches, state trade-offs and ask for preference.
- Ask clarifying questions only when ambiguity blocks correctness.
- Be concise, precise, and actionable.
