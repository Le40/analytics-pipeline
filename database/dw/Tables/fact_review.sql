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
    PRIMARY KEY CLUSTERED ([review_id] ASC)
);


GO

