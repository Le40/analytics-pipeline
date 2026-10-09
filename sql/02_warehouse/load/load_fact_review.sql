WITH unique_reviews AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY review_id
            ORDER BY review_answer_timestamp DESC
        ) AS rn
    FROM stg.reviews
)

INSERT INTO dw.fact_review (
    review_id,
    order_id,
    customer_key,
    send_date_key,
    answer_date_key,
    score,
    comment_title,
    comment_message,
    creation_date,
    answer_timestamp
)
    SELECT
        r.review_id,
        r.order_id,
        dc.customer_key,
        send_date.date_key AS send_date_key,
        answer_date.date_key AS answer_date_key,
        r.review_score,
        r.review_comment_title,
        r.review_comment_message,
        r.review_creation_date,
        r.review_answer_timestamp

    FROM unique_reviews AS r

    JOIN stg.orders AS o
        ON o.order_id = r.order_id

    JOIN stg.customers AS c
        ON c.customer_id = o.customer_id

    JOIN dw.dim_customer AS dc
        ON dc.customer_unique_id = c.customer_unique_id

    JOIN dw.dim_date AS send_date
        ON CAST(r.review_creation_date AS DATE) = send_date.full_date

    JOIN dw.dim_date AS answer_date
        ON CAST(r.review_answer_timestamp AS DATE) = answer_date.full_date

    WHERE r.rn = 1
        AND NOT EXISTS (
            SELECT 1
            FROM dw.fact_review AS fr
            WHERE fr.review_id = r.review_id
        );


