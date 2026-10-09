DECLARE @min_date DATE;
DECLARE @max_date DATE;

SELECT
    @min_date = MIN(date_value),
    @max_date = MAX(date_value)
FROM (
    SELECT CAST(order_purchase_timestamp AS DATE) AS date_value
    FROM stg.orders

    UNION ALL

    SELECT CAST(order_approved_at AS DATE)
    FROM stg.orders

    UNION ALL

    SELECT CAST(order_delivered_carrier_date AS DATE)
    FROM stg.orders

    UNION ALL

    SELECT CAST(order_delivered_customer_date AS DATE)
    FROM stg.orders

    UNION ALL

    SELECT CAST(order_estimated_delivery_date AS DATE)
    FROM stg.orders

    UNION ALL

    SELECT CAST(shipping_limit_date AS DATE)
    FROM stg.order_items

    UNION ALL

    SELECT CAST(review_creation_date AS DATE)
    FROM stg.reviews

    UNION ALL

    SELECT CAST(review_answer_timestamp AS DATE)
    FROM stg.reviews
) AS all_dates;


WITH date_series AS (
    SELECT @min_date AS full_date

    UNION ALL

    SELECT DATEADD(DAY, 1, full_date)
    FROM date_series
    WHERE full_date < @max_date
)

INSERT INTO dw.dim_date (
    date_key,
    full_date,
    year,
    quarter,
    month,
    month_name,
    day,
    day_of_week,
    day_name
)
SELECT
    YEAR(full_date) * 10000
        + MONTH(full_date) * 100
        + DAY(full_date) AS date_key,

    full_date,

    YEAR(full_date) AS [year],

    DATEPART(QUARTER, full_date) AS [quarter],

    MONTH(full_date) AS [month],

    DATENAME(MONTH, full_date) AS month_name,

    DAY(full_date) AS [day],

    ((DATEDIFF(DAY, '19000101', full_date) % 7 + 7) % 7) + 1 AS day_of_week,

    DATENAME(WEEKDAY, full_date) AS day_name

FROM date_series
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.dim_date AS d
    WHERE d.full_date = date_series.full_date
)
OPTION (MAXRECURSION 0);