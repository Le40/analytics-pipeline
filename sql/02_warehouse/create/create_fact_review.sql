IF OBJECT_ID('dw.fact_review', 'U') IS NULL
BEGIN
    CREATE TABLE dw.fact_review (
        review_id VARCHAR(32) PRIMARY KEY,
        order_id VARCHAR(32) NOT NULL,

        --dim keys
        customer_key INT NOT NULL,
        send_date_key INT NOT NULL,
        answer_date_key INT NOT NULL,

        score INT NOT NULL,
        comment_title NVARCHAR(500) NULL,
        comment_message NVARCHAR(MAX) NULL,
        creation_date DATETIME2 NOT NULL,
        answer_timestamp DATETIME2 NOT NULL
    );
END;