SELECT
    order_id,
    COUNT(*) AS occurrences
FROM dw.fact_order
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS missing_orders
FROM stg.orders AS s
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.fact_order AS f
    WHERE f.order_id = s.order_id
);

SELECT COUNT(*) AS orphan_customers
FROM dw.fact_order AS f
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.dim_customer AS c
    WHERE c.customer_key = f.customer_key
);