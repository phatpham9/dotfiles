---
name: telemetry-opentelemetry-integrator
description: 'Instrument applications with OpenTelemetry for distributed tracing, metrics, and logs; configure exporters for SigNoz, Jaeger, Prometheus, Grafana, and cloud observability platforms'
---

# Purpose

Add comprehensive observability to applications using OpenTelemetry standards for vendor-neutral instrumentation of traces, metrics, and logs.

## When to Use

Use this skill when the task involves:

- Adding distributed tracing to services
- Collecting custom metrics or business KPIs
- Setting up structured logging with correlation IDs
- Configuring exporters (SigNoz, Jaeger, Prometheus, Datadog)
- Creating dashboards or alerting rules
- Debugging performance issues across services

## Constraints

- Use **OpenTelemetry SDK** for vendor-neutral instrumentation
- Include **trace context propagation** for distributed systems
- Add **service.name, service.version** resource attributes
- Use **semantic conventions** for span and metric names
- Export **logs** as event streams to stdout in structured format
- Sample appropriately — **100% for errors, tail sampling for success**

## Execution Steps

1. **Install dependencies** — Add OpenTelemetry SDK and auto-instrumentation packages
2. **Configure tracer** — Set up tracer provider with resource attributes
3. **Add instrumentation** — Auto-instrument HTTP, database, and messaging clients
4. **Create custom spans** — Add spans for critical business operations
5. **Define metrics** — Create counters, histograms for KPIs
6. **Configure exporters** — Set up OTLP exporter to observability backend
7. **Add dashboards** — Create Grafana/SigNoz dashboards for SLIs

## Examples

### Input

> Instrument a NestJS application with OpenTelemetry for SigNoz

### Output

```typescript
// src/telemetry/tracing.ts
import { NodeSDK } from '@opentelemetry/sdk-node';
import { getNodeAutoInstrumentations } from '@opentelemetry/auto-instrumentations-node';
import { OTLPTraceExporter } from '@opentelemetry/exporter-trace-otlp-http';
import { OTLPMetricExporter } from '@opentelemetry/exporter-metrics-otlp-http';
import { Resource } from '@opentelemetry/resources';
import { SemanticResourceAttributes } from '@opentelemetry/semantic-conventions';
import { PeriodicExportingMetricReader } from '@opentelemetry/sdk-metrics';

const resource = new Resource({
  [SemanticResourceAttributes.SERVICE_NAME]:
    process.env.SERVICE_NAME || 'my-nestjs-app',
  [SemanticResourceAttributes.SERVICE_VERSION]:
    process.env.npm_package_version || '1.0.0',
  [SemanticResourceAttributes.DEPLOYMENT_ENVIRONMENT]:
    process.env.NODE_ENV || 'development',
});

const traceExporter = new OTLPTraceExporter({
  url:
    process.env.OTEL_EXPORTER_OTLP_ENDPOINT ||
    'http://localhost:4318/v1/traces',
});

const metricExporter = new OTLPMetricExporter({
  url:
    process.env.OTEL_EXPORTER_OTLP_ENDPOINT ||
    'http://localhost:4318/v1/metrics',
});

export const otelSDK = new NodeSDK({
  resource,
  traceExporter,
  metricReader: new PeriodicExportingMetricReader({
    exporter: metricExporter,
    exportIntervalMillis: 30000,
  }),
  instrumentations: [
    getNodeAutoInstrumentations({
      '@opentelemetry/instrumentation-fs': { enabled: false },
    }),
  ],
});

// Start before app bootstrap
otelSDK.start();

process.on('SIGTERM', () => {
  otelSDK.shutdown().finally(() => process.exit(0));
});
```

```typescript
// src/main.ts
import './telemetry/tracing'; // Must be first import
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(3000);
}
bootstrap();
```

## Related Skills

- `nest-backend-service-builder` — Service implementation
- `docker-k8s-optimizer` — Container observability configuration
