CREATE TABLE [dw].[fact_review] (
    [review_id]        VARCHAR (32)   NOT NULL,
    [order_id]         VARCHAR (32)   NOT NULL,
    [customer_key]     INT            NOT NULL,
    [send_date_key]    INT            NOT NULL,
    [answer_date_key]  INT            NOT NULL,
    [score]            INT            NOT NULL,
    [comment_title]    NVARCHAR (500) NULL,
    [comment_message]  NVARCHAR (MAX) NULL,
    [creation_date]    DATETIME2 (7)  NOT NULL,
    [answer_timestamp] DATETIME2 (7)  NOT NULL,
    
    CONSTRAINT PK_fact_review
        PRIMARY KEY CLUSTERED (review_id),

    CONSTRAINT FK_review_order
        FOREIGN KEY (order_id)
        REFERENCES dw.fact_order(order_id),

    CONSTRAINT FK_review_customer    
        FOREIGN KEY (customer_key)
        REFERENCES dw.dim_customer(customer_key),

    CONSTRAINT FK_review_send_date
        FOREIGN KEY (send_date_key)
        REFERENCES dw.dim_date(date_key),

    CONSTRAINT FK_review_answer_date
        FOREIGN KEY (answer_date_key)
        REFERENCES dw.dim_date(date_key),

    CONSTRAINT CK_review_score
        CHECK (score BETWEEN 1 AND 5)

);


GO

