WITH
orders_with_one_seller AS (
    SELECT
        order_id,
        MIN(seller_key) AS seller_key,
        MIN(shipping_limit_timestamp) AS shipping_limit_timestamp
    FROM dw.fact_order_item
    GROUP BY order_id
    HAVING COUNT(DISTINCT seller_key) = 1
       AND COUNT(DISTINCT shipping_limit_timestamp) = 1
),
seller_orders AS (
    SELECT
        s.order_id,
        s.seller_key,
        o.status,
        CASE
            WHEN CAST(o.customer_delivery_timestamp AS DATE) >
                 CAST(o.estimated_delivery_timestamp AS DATE)
            THEN 1
            ELSE 0
        END AS late_delivery,
        CASE
            WHEN CAST(o.carrier_delivery_timestamp AS DATE) >
                 CAST(s.shipping_limit_timestamp AS DATE)
            THEN 1
            ELSE 0
        END AS late_handover
    FROM dw.fact_order AS o
    INNER JOIN orders_with_one_seller AS s
        ON o.order_id = s.order_id
    WHERE o.status = 'delivered'
      AND o.customer_delivery_timestamp IS NOT NULL
      AND o.estimated_delivery_timestamp IS NOT NULL
      AND o.carrier_delivery_timestamp IS NOT NULL
      AND o.purchase_timestamp >= '20170101'
      AND o.purchase_timestamp < '20180901'
)

SELECT
    late_handover,
    COUNT(*) AS total_orders,
    SUM(late_delivery) AS late_orders,
    ROUND(
        100.0 * SUM(late_delivery) / COUNT(*),
        2
    ) AS late_delivery_rate_pct
FROM sellers_orders
GROUP BY late_handover
ORDER BY late_handover;