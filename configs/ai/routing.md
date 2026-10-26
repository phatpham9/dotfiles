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
