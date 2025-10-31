Index performance review
=========================

When using the commands `EXPLAIN` and `ANALYZE` there was a difference in the planning and execution time of the queries. This is an example analysis of the queries.


This was without the indexes a total execution time of ~3.3 ms

```bash
EXPLAIN ANALYZE WITH more_than_3 AS (
    SELECT user_id, COUNT(*) AS booking_count
    FROM bookings
    GROUP BY user_id
    HAVING COUNT(*) >= 3
)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    m.booking_count
FROM users AS u
JOIN more_than_3 AS m ON u.user_id = m.user_id;
                                                           QUERY PLAN                                                           
--------------------------------------------------------------------------------------------------------------------------------
 Hash Join  (cost=22.11..56.76 rows=86 width=61) (actual time=1.580..2.230 rows=93 loops=1)
   Hash Cond: (u.user_id = m.user_id)
   ->  Seq Scan on users u  (cost=0.00..32.01 rows=1001 width=53) (actual time=0.024..0.302 rows=1001 loops=1)
   ->  Hash  (cost=21.04..21.04 rows=86 width=24) (actual time=1.522..1.525 rows=93 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 14kB
         ->  Subquery Scan on m  (cost=16.94..21.04 rows=86 width=24) (actual time=1.283..1.412 rows=93 loops=1)
               ->  HashAggregate  (cost=16.94..20.18 rows=86 width=24) (actual time=1.280..1.382 rows=93 loops=1)
                     Group Key: bookings.user_id
                     Filter: (count(*) >= 3)
                     Batches: 1  Memory Usage: 61kB
                     Rows Removed by Filter: 166
                     ->  Seq Scan on bookings  (cost=0.00..13.96 rows=596 width=16) (actual time=0.016..0.308 rows=596 loops=1)
 Planning Time: 1.008 ms
 Execution Time: 2.394 ms
```


This were the results with the indexes with an execution time of ~2.6 ms 

```bash
EXPLAIN ANALYZE WITH more_than_3 AS (
    SELECT user_id, COUNT(*) AS booking_count
    FROM bookings
    GROUP BY user_id
    HAVING COUNT(*) >= 3
)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    m.booking_count
FROM users AS u
JOIN more_than_3 AS m ON u.user_id = m.user_id;
                                                           QUERY PLAN                                                           
--------------------------------------------------------------------------------------------------------------------------------
 Hash Join  (cost=22.11..56.76 rows=86 width=61) (actual time=0.873..1.509 rows=93 loops=1)
   Hash Cond: (u.user_id = m.user_id)
   ->  Seq Scan on users u  (cost=0.00..32.01 rows=1001 width=53) (actual time=0.017..0.288 rows=1001 loops=1)
   ->  Hash  (cost=21.04..21.04 rows=86 width=24) (actual time=0.829..0.832 rows=93 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 14kB
         ->  Subquery Scan on m  (cost=16.94..21.04 rows=86 width=24) (actual time=0.652..0.778 rows=93 loops=1)
               ->  HashAggregate  (cost=16.94..20.18 rows=86 width=24) (actual time=0.650..0.748 rows=93 loops=1)
                     Group Key: bookings.user_id
                     Filter: (count(*) >= 3)
                     Batches: 1  Memory Usage: 61kB
                     Rows Removed by Filter: 166
                     ->  Seq Scan on bookings  (cost=0.00..13.96 rows=596 width=16) (actual time=0.009..0.170 rows=596 loops=1)
 Planning Time: 0.979 ms
 Execution Time: 1.614 ms
(14 rows)
```