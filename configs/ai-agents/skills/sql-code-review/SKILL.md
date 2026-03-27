---
name: sql-code-review
description: 'Universal SQL assistant covering comprehensive security, maintainability, code quality, and performance optimization across all SQL databases (MySQL, PostgreSQL, SQL Server, Oracle). Handles SQL injection prevention, access control, code standards, anti-pattern detection, query tuning, indexing strategies, execution plan analysis, pagination, batch operations, and performance monitoring.'
---

# SQL Code Review & Optimization

Perform a thorough SQL review of ${selection} (or entire project if no selection) covering security, performance, maintainability, and database best practices.

## 🔒 Security Analysis

### SQL Injection Prevention

```sql
-- ❌ CRITICAL: SQL Injection vulnerability
query = "SELECT * FROM users WHERE id = " + userInput;
query = f"DELETE FROM orders WHERE user_id = {user_id}";

-- ✅ SECURE: Parameterized queries
-- PostgreSQL/MySQL
PREPARE stmt FROM 'SELECT * FROM users WHERE id = ?';
EXECUTE stmt USING @user_id;

-- SQL Server
EXEC sp_executesql N'SELECT * FROM users WHERE id = @id', N'@id INT', @id = @user_id;
```

### Access Control & Permissions

- **Principle of Least Privilege**: Grant minimum required permissions
- **Role-Based Access**: Use database roles instead of direct user permissions
- **Schema Security**: Proper schema ownership and access controls
- **Function/Procedure Security**: Review DEFINER vs INVOKER rights

### Data Protection

- **Sensitive Data Exposure**: Avoid SELECT \* on tables with sensitive columns
- **Audit Logging**: Ensure sensitive operations are logged
- **Data Masking**: Use views or functions to mask sensitive data
- **Encryption**: Verify encrypted storage for sensitive data

## ⚡ Performance Optimization

### Query Performance Analysis

```sql
-- ❌ BAD: Inefficient query patterns
SELECT * FROM orders o
WHERE YEAR(o.created_at) = 2024
  AND o.customer_id IN (
      SELECT c.id FROM customers c WHERE c.status = 'active'
  );

-- ✅ GOOD: Optimized query
SELECT o.id, o.customer_id, o.total_amount, o.created_at
FROM orders o
INNER JOIN customers c ON o.customer_id = c.id
WHERE o.created_at >= '2024-01-01'
  AND o.created_at < '2025-01-01'
  AND c.status = 'active';

-- Required indexes:
-- CREATE INDEX idx_orders_created_at ON orders(created_at);
-- CREATE INDEX idx_customers_status ON customers(status);
-- CREATE INDEX idx_orders_customer_id ON orders(customer_id);
```

### Index Strategy

```sql
-- ❌ BAD: Poor indexing strategy
CREATE INDEX idx_user_data ON users(email, first_name, last_name, created_at);

-- ✅ GOOD: Optimized composite indexing
-- For queries filtering by email first, then sorting by created_at
CREATE INDEX idx_users_email_created ON users(email, created_at);

-- For full-text name searches
CREATE INDEX idx_users_name ON users(last_name, first_name);

-- For status queries with partial index
CREATE INDEX idx_users_status_created ON users(status, created_at)
WHERE status IS NOT NULL;

-- Covering index (SQL Server INCLUDE / other DBs: list all needed columns)
CREATE INDEX idx_orders_covering
ON orders(customer_id, created_at)
INCLUDE (total_amount, status);
```

### JOIN Optimization

```sql
-- ❌ BAD: Unnecessary LEFT JOINs with filtering after
SELECT o.*, c.name, p.product_name
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.id
LEFT JOIN order_items oi ON o.id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.id
WHERE o.created_at > '2024-01-01'
  AND c.status = 'active';

-- ✅ GOOD: Push filters into join conditions, use INNER where appropriate
SELECT o.id, o.total_amount, c.name, p.product_name
FROM orders o
INNER JOIN customers c ON o.customer_id = c.id AND c.status = 'active'
INNER JOIN order_items oi ON o.id = oi.order_id
INNER JOIN products p ON oi.product_id = p.id
WHERE o.created_at > '2024-01-01';
```

### Subquery Optimization

```sql
-- ❌ BAD: Correlated subquery (re-executes per row)
SELECT p.product_name, p.price
FROM products p
WHERE p.price > (
    SELECT AVG(price)
    FROM products p2
    WHERE p2.category_id = p.category_id
);

-- ✅ GOOD: Window function (single pass)
SELECT product_name, price
FROM (
    SELECT product_name, price,
           AVG(price) OVER (PARTITION BY category_id) as avg_category_price
    FROM products
) ranked
WHERE price > avg_category_price;
```

### Pagination Optimization

```sql
-- ❌ BAD: OFFSET-based pagination degrades at large offsets
SELECT * FROM products
ORDER BY created_at DESC
LIMIT 20 OFFSET 10000;

-- ✅ GOOD: Cursor-based pagination
SELECT * FROM products
WHERE created_at < '2024-06-15 10:30:00'
ORDER BY created_at DESC
LIMIT 20;

-- Or ID-based cursor
SELECT * FROM products
WHERE id > 1000
ORDER BY id
LIMIT 20;
```

### Aggregation Optimization

```sql
-- ❌ BAD: Multiple separate aggregation queries
SELECT COUNT(*) FROM orders WHERE status = 'pending';
SELECT COUNT(*) FROM orders WHERE status = 'shipped';
SELECT COUNT(*) FROM orders WHERE status = 'delivered';

-- ✅ GOOD: Single conditional aggregation
SELECT
    COUNT(CASE WHEN status = 'pending'   THEN 1 END) as pending_count,
    COUNT(CASE WHEN status = 'shipped'   THEN 1 END) as shipped_count,
    COUNT(CASE WHEN status = 'delivered' THEN 1 END) as delivered_count
FROM orders;
```

### Batch Operations

```sql
-- ❌ BAD: Row-by-row inserts
INSERT INTO products (name, price) VALUES ('Product 1', 10.00);
INSERT INTO products (name, price) VALUES ('Product 2', 15.00);

-- ✅ GOOD: Batch insert
INSERT INTO products (name, price) VALUES
('Product 1', 10.00),
('Product 2', 15.00),
('Product 3', 20.00);
```

### Temporary Tables for Complex Operations

```sql
-- ✅ GOOD: Materialize intermediate results to avoid repeated scanning
CREATE TEMPORARY TABLE temp_calculations AS
SELECT customer_id,
       SUM(total_amount) as total_spent,
       COUNT(*)          as order_count
FROM orders
WHERE created_at >= '2024-01-01'
GROUP BY customer_id;

SELECT c.name, tc.total_spent, tc.order_count
FROM temp_calculations tc
JOIN customers c ON tc.customer_id = c.id
WHERE tc.total_spent > 1000;
```

## 📊 Performance Monitoring Queries

```sql
-- MySQL: slow query log
SELECT query_time, lock_time, rows_sent, rows_examined, sql_text
FROM mysql.slow_log
ORDER BY query_time DESC;

-- PostgreSQL: pg_stat_statements
SELECT query, calls, total_time, mean_time
FROM pg_stat_statements
ORDER BY total_time DESC;

-- SQL Server: dm_exec_query_stats
SELECT
    qs.total_elapsed_time / qs.execution_count AS avg_elapsed_time,
    qs.execution_count,
    SUBSTRING(qt.text,
        (qs.statement_start_offset / 2) + 1,
        ((CASE qs.statement_end_offset
            WHEN -1 THEN DATALENGTH(qt.text)
            ELSE qs.statement_end_offset END
          - qs.statement_start_offset) / 2) + 1) AS query_text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER BY avg_elapsed_time DESC;
```

## 🛠️ Code Quality & Maintainability

### SQL Style & Formatting

```sql
-- ❌ BAD: Poor formatting and style
select u.id,u.name,o.total from users u left join orders o on u.id=o.user_id where u.status='active' and o.order_date>='2024-01-01';

-- ✅ GOOD: Clean, readable formatting
SELECT u.id,
       u.name,
       o.total
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.status = 'active'
  AND o.order_date >= '2024-01-01';
```

### Naming Conventions

- **Consistent Naming**: Tables, columns, constraints follow consistent patterns
- **Descriptive Names**: Clear, meaningful names for database objects
- **Reserved Words**: Avoid using database reserved words as identifiers
- **Case Sensitivity**: Consistent case usage across schema

### Schema Design Review

- **Normalization**: Appropriate normalization level (3NF for OLTP, denormalized for OLAP)
- **Data Types**: Optimal data type choices for storage and performance
- **Constraints**: Proper use of PRIMARY KEY, FOREIGN KEY, CHECK, NOT NULL
- **Default Values**: Appropriate default values for columns

## 🗄️ Database-Specific Best Practices

### PostgreSQL

```sql
-- Use JSONB for JSON data
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    data JSONB NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- GIN index for JSONB queries
CREATE INDEX idx_events_data ON events USING gin(data);

-- Array types for multi-value columns
CREATE TABLE tags (
    post_id INT,
    tag_names TEXT[]
);
```

### MySQL

```sql
-- Use appropriate storage engines
CREATE TABLE sessions (
    id VARCHAR(128) PRIMARY KEY,
    data TEXT,
    expires TIMESTAMP
) ENGINE=InnoDB;

-- Optimize for InnoDB
ALTER TABLE large_table
ADD INDEX idx_covering (status, created_at, id);
```

### SQL Server

```sql
-- Use appropriate data types
CREATE TABLE products (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    created_at DATETIME2 DEFAULT GETUTCDATE()
);

-- Columnstore indexes for analytics
CREATE COLUMNSTORE INDEX idx_sales_cs ON sales;
```

### Oracle

```sql
-- Use sequences for auto-increment
CREATE SEQUENCE user_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE users (
    id NUMBER DEFAULT user_id_seq.NEXTVAL PRIMARY KEY,
    name VARCHAR2(255) NOT NULL
);
```

## 🧪 Testing & Validation

### Data Integrity Checks

```sql
-- Verify referential integrity
SELECT o.user_id
FROM orders o
LEFT JOIN users u ON o.user_id = u.id
WHERE u.id IS NULL;

-- Check for data consistency
SELECT COUNT(*) as inconsistent_records
FROM products
WHERE price < 0 OR stock_quantity < 0;
```

### Performance Testing

- **Execution Plans**: Review query execution plans before and after changes
- **Load Testing**: Test queries with realistic data volumes
- **Stress Testing**: Verify performance under concurrent load
- **Regression Testing**: Ensure optimizations don't break functionality

## 📋 Common Anti-Patterns

### N+1 Query Problem

```sql
-- ❌ BAD: N+1 queries in application code
for user in users:
    orders = query("SELECT * FROM orders WHERE user_id = ?", user.id)

-- ✅ GOOD: Single optimized query
SELECT u.*, o.*
FROM users u
LEFT JOIN orders o ON u.id = o.user_id;
```

### Overuse of DISTINCT

```sql
-- ❌ BAD: DISTINCT masking a missing join condition
SELECT DISTINCT u.name
FROM users u, orders o
WHERE u.id = o.user_id;

-- ✅ GOOD: Proper join
SELECT u.name
FROM users u
INNER JOIN orders o ON u.id = o.user_id
GROUP BY u.name;
```

### Function Misuse in WHERE Clauses

```sql
-- ❌ BAD: Functions prevent index usage
SELECT * FROM orders WHERE UPPER(customer_email) = 'JOHN@EXAMPLE.COM';
SELECT * FROM orders WHERE YEAR(order_date) = 2024;

-- ✅ GOOD: Index-friendly predicates
SELECT * FROM orders WHERE customer_email = 'john@example.com';
-- Consider: CREATE INDEX idx_orders_email ON orders(LOWER(customer_email));

SELECT * FROM orders
WHERE order_date >= '2024-01-01'
  AND order_date <  '2025-01-01';
```

### OR vs UNION

```sql
-- ❌ BAD: Complex OR conditions (may skip indexes)
SELECT * FROM products
WHERE (category = 'electronics' AND price < 1000)
   OR (category = 'books' AND price < 50);

-- ✅ GOOD: UNION ALL for independent index scans
SELECT * FROM products WHERE category = 'electronics' AND price < 1000
UNION ALL
SELECT * FROM products WHERE category = 'books'        AND price < 50;
```

## ✅ Comprehensive Checklist

### Security

- [ ] All user inputs are parameterized
- [ ] No dynamic SQL construction with string concatenation
- [ ] Appropriate access controls and permissions
- [ ] Sensitive data is properly protected
- [ ] SQL injection attack vectors are eliminated

### Performance

- [ ] Avoiding SELECT \* in production queries
- [ ] Indexes exist for frequently queried columns
- [ ] Composite indexes ordered by selectivity and query pattern
- [ ] No functions in WHERE clauses that prevent index usage
- [ ] JOINs use appropriate types (INNER vs LEFT vs EXISTS)
- [ ] Subqueries replaced with JOINs or window functions where beneficial
- [ ] Efficient pagination strategy (cursor-based vs OFFSET)
- [ ] Batch operations used for bulk data changes
- [ ] N+1 query patterns eliminated
- [ ] Prepared statements used for repeated queries

### Code Quality

- [ ] Consistent naming conventions throughout
- [ ] Proper formatting and indentation
- [ ] Meaningful comments for complex logic
- [ ] Appropriate data types used
- [ ] Error handling implemented

### Schema Design

- [ ] Tables properly normalized
- [ ] Constraints enforce data integrity
- [ ] Indexes support query patterns
- [ ] Foreign key relationships defined
- [ ] Default values appropriate

## 🎯 Review Output Format

### Issue Template

````
## [PRIORITY] [CATEGORY]: [Brief Description]

**Location**: [Table/View/Procedure name and line number if applicable]
**Issue**: [Detailed explanation of the problem]
**Security Risk**: [If applicable — injection risk, data exposure, etc.]
**Performance Impact**: [Query cost, execution time impact]
**Recommendation**: [Specific fix with code example]

**Before**:
```sql
-- Problematic SQL
````

**After**:

```sql
-- Improved SQL
```

**Expected Improvement**: [Performance gain, security benefit]

```

### Summary Assessment
- **Security Score**: [1-10] — SQL injection protection, access controls
- **Performance Score**: [1-10] — Query efficiency, index usage
- **Maintainability Score**: [1-10] — Code quality, documentation
- **Schema Quality Score**: [1-10] — Design patterns, normalization

### Top 3 Priority Actions
1. **[Critical Security Fix]**: Address SQL injection vulnerabilities
2. **[Performance Optimization]**: Add missing indexes or optimize queries
3. **[Code Quality]**: Improve naming conventions and documentation

## 📝 Optimization Methodology

1. **Identify**: Use database-specific tools to find slow queries
2. **Analyze**: Examine execution plans and identify bottlenecks
3. **Optimize**: Apply appropriate optimization techniques
4. **Test**: Verify performance improvements with realistic data volumes
5. **Monitor**: Continuously track performance metrics
6. **Iterate**: Regular performance review and optimization cycles

```
