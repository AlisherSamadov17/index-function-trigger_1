
-- 2-HOMEWORK
CREATE OR REPLACE FUNCTION total_price(p_order_id uuid)
RETURNS INTEGER AS $$
DECLARE
    total_price INTEGER;
BEGIN
    SELECT SUM(price) INTO total_price
    FROM order_products
    WHERE order_id = p_order_id;

    RETURN total_price;
END;
$$ LANGUAGE plpgsql;

SELECT total_price('');

-- 3-HOMEWORK
-- BEFORE
EXPLAIN SELECT *
FROM order_products
WHERE order_id = '3cb2b33a-c971-44f9-8a3f-32c339cdc4d1';
                             QUERY PLAN                              
---------------------------------------------------------------------
 Seq Scan on order_products  (cost=0.00..17.12 rows=3 width=114)
   Filter: (order_id = '3cb2b33a-c971-44f9-8a3f-32c339cdc4d1'::uuid)


-- AFTER
CREATE INDEX xon ON order_products(order_id);
EXPLAIN SELECT *
FROM order_products
WHERE order_id = '3cb2b33a-c971-44f9-8a3f-32c339cdc4d1';
                             QUERY PLAN                              
---------------------------------------------------------------------
 Seq Scan on order_products  (cost=0.00..1.06 rows=1 width=114)
   Filter: (order_id = '3cb2b33a-c971-44f9-8a3f-32c339cdc4d1'::uuid)
(2 rows)

-- 4-HOMEWORK
CREATE OR REPLACE FUNCTION total_avg(p_order_id uuid)
RETURNS INTEGER AS $$
DECLARE
    total_avg INTEGER;
BEGIN
    SELECT AVG(price) INTO total_avg
    FROM order_products
    WHERE order_id = p_order_id;

    RETURN total_avg;
END;
$$ LANGUAGE plpgsql;

SELECT total_avg('');

-- 5-HOMEWORK
CREATE INDEX testing_order_name ON order_products(order_id, name);
EXPLAIN ANALYZE
SELECT *
FROM order_products
WHERE order_id = '0f62e266-8a1c-464e-af53-fe1f73b4c278';
                                                QUERY PLAN                                                
----------------------------------------------------------------------------------------------------------
 Seq Scan on order_products  (cost=0.00..1.06 rows=1 width=114) (actual time=0.008..0.008 rows=1 loops=1)
   Filter: (order_id = '0f62e266-8a1c-464e-af53-fe1f73b4c278'::uuid)
   Rows Removed by Filter: 4
 Planning Time: 0.175 ms
 Execution Time: 0.021 ms
(5 rows)


EXPLAIN ANALYZE
SELECT *
FROM order_products
WHERE name = 'Nokia 60';
                                                QUERY PLAN                                                
----------------------------------------------------------------------------------------------------------
 Seq Scan on order_products  (cost=0.00..1.06 rows=1 width=114) (actual time=0.011..0.011 rows=0 loops=1)
   Filter: ((name)::text = 'Nokia 60'::text)
   Rows Removed by Filter: 5
 Planning Time: 0.118 ms
 Execution Time: 0.028 ms

-- 8-homework
CREATE UNIQUE INDEX unique_external_id ON orders(external_id);

