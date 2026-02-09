---
name: senior-code-review
description: 'Senior engineer code review for PRs, diffs, and code snippets focusing on security vulnerabilities, OWASP compliance, performance bottlenecks, maintainability, error handling, and architectural patterns'
---

# Purpose

Perform thorough code reviews with a senior engineer mindset, identifying issues across security, performance, maintainability, and correctness dimensions.

## When to Use

Use this skill when the task involves:

- Reviewing pull requests or merge requests
- Analyzing code snippets for issues
- Auditing code for security vulnerabilities
- Identifying performance bottlenecks
- Evaluating architectural decisions

## Constraints

- **Never approve without reviewing** — Always provide substantive feedback
- Prioritize issues by **severity** (critical → high → medium → low)
- Cite **specific lines** when pointing out issues
- Suggest **concrete fixes**, not just problem descriptions
- Flag **security issues** with OWASP references where applicable
- Consider **backward compatibility** for public APIs

## Review Checklist

### Security

- [ ] Input validation and sanitization
- [ ] SQL/NoSQL injection prevention
- [ ] XSS prevention (output encoding)
- [ ] CSRF protection
- [ ] Authentication/authorization checks
- [ ] Secrets not hardcoded
- [ ] Dependency vulnerabilities

### Performance

- [ ] N+1 query patterns
- [ ] Unnecessary re-renders (React)
- [ ] Memory leaks (event listeners, subscriptions)
- [ ] Appropriate caching
- [ ] Database index usage

### Maintainability

- [ ] Single Responsibility Principle
- [ ] Clear naming conventions
- [ ] Adequate error handling
- [ ] Proper logging
- [ ] Test coverage

### Correctness

- [ ] Edge case handling
- [ ] Race condition prevention
- [ ] Type safety
- [ ] Business logic accuracy

## Examples

### Input

> Review this endpoint for issues:

```typescript
app.post('/users', (req, res) => {
  const query = `SELECT * FROM users WHERE email = '${req.body.email}'`;
  db.query(query).then((user) => res.json(user));
});
```

### Output

**🔴 CRITICAL: SQL Injection Vulnerability**

- **Line 2**: Direct string interpolation in SQL query allows injection attacks
- **OWASP Reference**: A03:2021-Injection
- **Fix**: Use parameterized queries

```typescript
app.post('/users', async (req, res) => {
  try {
    const user = await db.query('SELECT * FROM users WHERE email = $1', [
      req.body.email,
    ]);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});
```

**🟡 MEDIUM: Missing Input Validation**

- No validation on `req.body.email` format
- **Fix**: Add email format validation before query

**🟡 MEDIUM: Missing Error Handling**

- Unhandled promise rejection could crash server
- **Fix**: Wrap in try/catch with proper error response

## Related Skills

- `jest-testing-generator` — Suggest missing test cases
- `nest-backend-service-builder` — Recommend architectural improvements
