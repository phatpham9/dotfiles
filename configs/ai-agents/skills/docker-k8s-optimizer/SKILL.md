---
name: docker-k8s-optimizer
description: 'Optimize Dockerfiles with multi-stage builds, layer caching, and security hardening; create Kubernetes manifests with resource limits, probes, HPA, PDB, network policies, and Helm charts'
---

# Purpose

Build production-grade container images and Kubernetes configurations optimized for security, performance, and reliability.

## When to Use

Use this skill when the task involves:

- Writing or optimizing Dockerfiles
- Creating Kubernetes Deployments, Services, or ConfigMaps
- Setting up health checks, resource limits, or autoscaling
- Configuring Ingress with Istio, Emissary, or nginx
- Building Helm charts for deployable applications
- Troubleshooting container or pod issues

## Constraints

- Dockerfiles must use **multi-stage builds** to minimize image size
- Always run as **non-root user** in production images
- Pin image versions with **SHA digests** for reproducibility
- Kubernetes manifests must define **resource requests AND limits**
- Include **liveness, readiness, and startup probes**
- Use **semantic versioning** for container image tags
- Apply **Pod Disruption Budgets** for high-availability workloads

## Execution Steps

1. **Analyze application** — Identify runtime requirements, dependencies, ports
2. **Design Dockerfile** — Multi-stage build with optimized layer ordering
3. **Add security hardening** — Non-root user, minimal base image, no secrets in image
4. **Create K8s manifests** — Deployment, Service, ConfigMap, Secrets references
5. **Configure reliability** — Probes, resource limits, PDBs, HPA
6. **Set up networking** — Ingress, network policies, service mesh integration
7. **Verify locally** — Test with docker build and kubectl dry-run

## Examples

### Input

> Create an optimized Dockerfile for a Next.js application

### Output

```dockerfile
# Stage 1: Dependencies
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN corepack enable pnpm && pnpm install --frozen-lockfile

# Stage 2: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
ENV NEXT_TELEMETRY_DISABLED=1
RUN corepack enable pnpm && pnpm build

# Stage 3: Production
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Security: non-root user
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs
EXPOSE 3000
ENV PORT=3000
CMD ["node", "server.js"]
```

### Kubernetes Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nextjs-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nextjs-app
  template:
    spec:
      containers:
        - name: app
          image: myregistry/nextjs-app:v1.0.0@sha256:abc123...
          ports:
            - containerPort: 3000
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 500m
              memory: 512Mi
          livenessProbe:
            httpGet:
              path: /api/health
              port: 3000
            initialDelaySeconds: 10
          readinessProbe:
            httpGet:
              path: /api/health
              port: 3000
            initialDelaySeconds: 5
```

## Related Skills

- `terraform-aws-builder` — Provision EKS clusters
- `telemetry-opentelemetry-integrator` — Add observability to containers
