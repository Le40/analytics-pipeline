DECLARE @min_date DATE;
DECLARE @max_date DATE;

SELECT
    @min_date = MIN(full_date),
    @max_date = MAX(full_date)
FROM stg.v_source_dates;


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