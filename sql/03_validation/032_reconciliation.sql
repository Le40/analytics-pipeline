-- Orders missing from DWH
SELECT order_id
FROM stg.orders

EXCEPT

SELECT order_id
FROM dw.fact_order;

-- Unexpected orders in DWH
SELECT order_id
FROM dw.fact_order

EXCEPT

SELECT order_id
FROM stg.orders;