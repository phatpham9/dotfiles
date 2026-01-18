---
name: kafka-stream-designer
description: 'Design Kafka topics, partitions, consumer groups, producers with idempotency, retry strategies, dead letter queues, exactly-once semantics, and schema registry integration'
---

# Purpose

Design reliable, scalable Kafka-based event streaming architectures with proper partitioning, ordering, and error handling strategies.

## When to Use

Use this skill when the task involves:

- Designing Kafka topics and partition strategies
- Implementing producers or consumers
- Setting up consumer groups for scaling
- Handling failures with retries and DLQs
- Configuring exactly-once or at-least-once semantics
- Integrating with Schema Registry (Avro, Protobuf)

## Constraints

- Enable **idempotent producer** (`enable.idempotence=true`) by default
- Use **Schema Registry** for message contracts in production
- Design **partition keys** based on ordering requirements
- Implement **dead letter queues** for poison messages
- Set appropriate **retention** based on replay needs
- Use **transactional producers** for exactly-once across topics
- Monitor **consumer lag** as a key health metric

## Execution Steps

1. **Identify events** — List domain events with their schemas
2. **Design topics** — Name conventions, partition count, replication factor
3. **Define partition keys** — Choose keys that ensure ordering where needed
4. **Implement producers** — Idempotent with proper serializers
5. **Build consumers** — Consumer groups, offset management, error handling
6. **Add DLQ** — Configure dead letter topic for failed messages
7. **Set up monitoring** — Consumer lag alerts, throughput dashboards

## Examples

### Input

> Design a Kafka topic for order events that maintains per-customer ordering

### Output

```typescript
// Topic Configuration
const topicConfig = {
  topic: 'orders.events.v1',
  partitions: 12, // Scale based on throughput needs
  replicationFactor: 3,
  config: {
    'retention.ms': 7 * 24 * 60 * 60 * 1000, // 7 days
    'cleanup.policy': 'delete',
    'min.insync.replicas': 2,
  },
};

// Producer with idempotency
import { Kafka, Partitioners } from 'kafkajs';

const kafka = new Kafka({
  clientId: 'order-service',
  brokers: ['kafka:9092'],
});

const producer = kafka.producer({
  idempotent: true,
  maxInFlightRequests: 5,
  createPartitioner: Partitioners.DefaultPartitioner,
});

interface OrderEvent {
  orderId: string;
  customerId: string;
  type: 'CREATED' | 'UPDATED' | 'CANCELLED';
  payload: Record<string, unknown>;
  timestamp: string;
}

async function publishOrderEvent(event: OrderEvent): Promise<void> {
  await producer.send({
    topic: 'orders.events.v1',
    messages: [
      {
        key: event.customerId, // Partition by customerId for ordering
        value: JSON.stringify(event),
        headers: {
          'event-type': event.type,
          'correlation-id': event.orderId,
        },
      },
    ],
  });
}

// Consumer with error handling
const consumer = kafka.consumer({
  groupId: 'order-processor',
  maxWaitTimeInMs: 100,
  retry: { retries: 3 },
});

await consumer.subscribe({ topic: 'orders.events.v1', fromBeginning: false });

await consumer.run({
  eachMessage: async ({ topic, partition, message }) => {
    try {
      const event = JSON.parse(message.value?.toString() || '{}');
      await processOrderEvent(event);
    } catch (error) {
      // Send to DLQ after retries exhausted
      await sendToDLQ('orders.events.v1.dlq', message, error);
    }
  },
});
```

## Related Skills

- `nest-backend-service-builder` — Integrate Kafka with NestJS
- `database-schema-designer` — Outbox pattern for reliability
