Q aparent low retention of clients
1. how is customer satisfaction? 4.08
2. what is the spread 75% good, only 15% not

Select score, count(*)*100.0 / (select count(*) from dw.fact_review)
from dw.fact_review
group by score
order by score

3. how relevant are review data:
select COUNT(DISTINCT r.order_id) * 100.0
    / COUNT(DISTINCT o.order_id) AS review_coverage_pct
from dw.fact_order o
LEFT JOIN stg.reviews r 
	ON r.order_id = o.order_id

Covergae over 99%.
Review coverage is approximately 99%. This unusually high coverage should not automatically be interpreted as the real-world customer survey response rate.

4. is it caused by delivery time? avg 12.56 days, estimated is 23.77 days.
select 
	sum(CASE WHEN 
		CAST(customer_delivery_timestamp AS DATE) 
			> CAST(estimated_delivery_timestamp AS DATE) 
		THEN 1 ELSE 0 END) * 100.0
	/ count(*) as late_delivery_pct
from dw.fact_order
where status = 'delivered'

Late delivery only 6.7%

WITH delivery_time AS (
    SELECT
        DATEDIFF(DAY, purchase_timestamp, customer_delivery_timestamp) AS delivery_days
    FROM dw.fact_order
    WHERE status = 'delivered'
      AND customer_delivery_timestamp IS NOT NULL
),
delivery_buckets AS (
    SELECT
        delivery_days,
        CASE
            WHEN delivery_days < 0 THEN 'Invalid'
            WHEN delivery_days <= 3 THEN '0-3 days'
            WHEN delivery_days <= 7 THEN '4-7 days'
            WHEN delivery_days <= 14 THEN '8-14 days'
            WHEN delivery_days <= 30 THEN '15-30 days'
            ELSE 'Over 30 days'
        END AS bucket
    FROM delivery_time
)

SELECT
    bucket,
    round(COUNT(*) * 100.0 / (select count(*) from delivery_buckets),2) AS deliveries_pct
FROM delivery_buckets
GROUP BY bucket
ORDER BY MIN(delivery_days);

70% is over week

4a How much time goods spend pre transit and in transit:
select
	ROUND(AVG(datediff(HOUR, approved_timestamp, carrier_delivery_timestamp) / 24.0 ),2) AS time_to_carrier,
	ROUND(AVG(datediff(HOUR, carrier_delivery_timestamp, customer_delivery_timestamp) / 24.0 ),2) AS shipping_time
from dw.fact_order
Where status = 'delivered'

2.8 days pre, and 9.33 in transit.

5. How many customers return?
WITH purchase_occurences As(Select 
	customer_key,
	count(distinct(purchase_date_key)) as purchases_count
from dw.fact_order
group by customer_key)

select
purchases_count,
round(count(*) *100.0 / (select count(*) from purchase_occurences),2) as number_of_puchases_pct
from purchase_occurences
group by purchases_count
order by purchases_count

only 2.25 % return