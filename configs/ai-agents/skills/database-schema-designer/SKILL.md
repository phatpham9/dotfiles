---
name: database-schema-designer
description: 'Design PostgreSQL, MongoDB, or Redis schemas with entities, relationships, indexes, constraints, migrations, query optimization, and backward-compatible schema evolution'
---

# Purpose

Design efficient, scalable database schemas optimized for application access patterns with proper indexing and migration strategies.

## When to Use

Use this skill when the task involves:

- Designing new database tables, collections, or key structures
- Creating or modifying indexes for query performance
- Writing database migrations (Prisma, TypeORM, Drizzle, raw SQL)
- Optimizing slow queries or analyzing execution plans
- Planning schema changes with backward compatibility

## Constraints

- Always consider **query patterns first** before designing schema
- Include **migration rollback scripts** for every schema change
- Apply **least-privilege** for database roles and permissions
- Use **explicit constraints** (NOT NULL, UNIQUE, CHECK) at database level
- Prefer **UUID or ULID** over auto-increment for distributed systems
- Document **breaking changes** and data migration requirements

## Execution Steps

1. **Identify entities** — List domain entities and their attributes
2. **Map relationships** — Define 1:1, 1:N, M:N relationships with cardinality
3. **Design schema** — Create tables/collections with appropriate types
4. **Add indexes** — Create indexes based on WHERE, JOIN, and ORDER BY patterns
5. **Write migrations** — Generate up/down migration scripts
6. **Validate performance** — Check EXPLAIN plans for critical queries
7. **Document changes** — Note breaking changes and required data backfills

## Examples

### Input

> Design a schema for a blog with posts, authors, and tags (many-to-many)

### Output

```sql
-- PostgreSQL schema
CREATE TABLE authors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id UUID NOT NULL REFERENCES authors(id) ON DELETE CASCADE,
  title VARCHAR(500) NOT NULL,
  slug VARCHAR(500) NOT NULL UNIQUE,
  content TEXT,
  published_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE tags (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE post_tags (
  post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
  tag_id UUID REFERENCES tags(id) ON DELETE CASCADE,
  PRIMARY KEY (post_id, tag_id)
);

-- Indexes for common queries
CREATE INDEX idx_posts_author ON posts(author_id);
CREATE INDEX idx_posts_published ON posts(published_at) WHERE published_at IS NOT NULL;
CREATE INDEX idx_posts_slug ON posts(slug);
```

## Related Skills

- `nest-backend-service-builder` — Implement repository layer
- `system-planning-assistant` — High-level data architecture decisions
