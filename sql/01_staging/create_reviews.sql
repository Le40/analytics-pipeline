IF OBJECT_ID('stg.reviews', 'U') IS NULL
BEGIN
    CREATE TABLE stg.reviews (
        review_id VARCHAR(32) NOT NULL,
        order_id VARCHAR(32) NOT NULL,
        review_score INT NOT NULL,
        review_comment_title NVARCHAR(500) NULL,
        review_comment_message NVARCHAR(MAX) NULL,
        review_creation_date DATETIME2 NOT NULL,
        review_answer_timestamp DATETIME2 NOT NULL
    );
END;