# Optimization Report: Booking and Payment Query Performance

## 1. Overview

Two SQL queries were tested to retrieve booking, property, user, and payment information. Both queries join the same set of tables (`bookings`, `properties`, `users`, `payments`) but differ in structure:

1. **Query A (CTE-based)** – Uses a *Common Table Expression (CTE)* `matching_payments` to pre-join `bookings` and `payments` before joining with `properties` and `users`.  
2. **Query B (Direct Join)** – Performs all joins in a single query without using a CTE.

This report compares their **execution plans**, **performance metrics**, and recommends optimizations.

---

## 2. Query Summaries

### Query A – CTE-based Join

```sql
WITH matching_payments AS (
  SELECT 
    b.booking_id, b.user_id, b.property_id,
    b.start_date, b.end_date,
    d.payment_id, d.amount, d.payment_date, d.payment_method
  FROM bookings b
  LEFT JOIN payments d 
    ON b.booking_id = d.booking_id
)
SELECT 
  b.booking_id, b.start_date, b.end_date,
  b.payment_id, b.amount, b.payment_date, b.payment_method,
  p.property_id, p.name, p.location, p.pricepernight, p.host_id,
  u.user_id, u.first_name, u.last_name, u.email
FROM matching_payments b
JOIN properties p ON b.property_id = p.property_id
JOIN users u ON b.user_id = u.user_id;
```

**Execution Time:** `3.591 ms`  
**Planning Time:** `1.062 ms`

---

### Query B – Direct Join

```sql
SELECT                     
  b.booking_id, b.start_date, b.end_date, b.total_price,
  p.property_id, p.name, p.location, p.pricepernight, p.host_id,
  u.user_id, u.first_name, u.last_name, u.email,
  d.payment_id, d.amount, d.payment_date, d.payment_method
FROM bookings b
JOIN properties p  ON b.property_id = p.property_id
JOIN users u        ON b.user_id = u.user_id
LEFT JOIN payments d ON b.booking_id = d.booking_id;
```

**Execution Time:** `8.391 ms`  
**Planning Time:** `1.703 ms`

---

## 3. Performance Comparison

| Metric | Query A (CTE) | Query B (Direct Join) | Difference |
|--------|----------------|------------------------|-------------|
| **Planning Time** | 1.062 ms | 1.703 ms | CTE ~37% faster |
| **Execution Time** | 3.591 ms | 8.391 ms | CTE ~58% faster |
| **Total Time** | 4.653 ms | 10.094 ms | ~54% improvement |
| **Rows Returned** | 596 | 596 | Identical output |

**CTE version performs approximately twice as fast overall.**

---

## 4. Execution Plan Analysis

### Query A (CTE)
- The **CTE precomputes** the `bookings` ↔ `payments` join efficiently using a `Hash Left Join`.
- Subsequent joins with `properties` and `users` leverage **in-memory hash joins**, minimizing recomputation.
- **Sequential scans** occur on all tables (`bookings`, `payments`, `properties`, `users`) — acceptable for small datasets.
- **Low hash memory usage** (<100kB per table) indicates efficient hash table sizing.

### Query B (Direct Join)
- Performs multiple **nested hash joins** within a single query plan.
- The `LEFT JOIN` to `payments` happens **after** all inner joins are resolved, increasing temporary hash table buildup and probe costs.
- The **join order** forces the planner to compute the full intermediate join result of `bookings`, `properties`, and `users` before joining with `payments`.
- This leads to higher total execution time and memory churn, even though total rows remain the same.

---

## 5. Root Cause of Performance Difference

| Cause | Explanation |
|-------|--------------|
| **Join order** | The CTE groups related data early (bookings + payments), reducing intermediate join complexity. |
| **Planner optimization scope** | CTE acts as a logical barrier that allows PostgreSQL to optimize smaller subqueries independently. |
| **Reduced hash recomputation** | Pre-hashing in the CTE minimizes repeated hash table building across joins. |
| **I/O efficiency** | Smaller intermediate data sets are scanned fewer times in Query A. |

---
