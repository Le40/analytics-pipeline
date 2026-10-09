CREATE TABLE [stg].[order_items] (
    [order_id]            VARCHAR (32)    NOT NULL,
    [order_item_id]       INT             NOT NULL,
    [product_id]          VARCHAR (32)    NOT NULL,
    [seller_id]           VARCHAR (32)    NOT NULL,
    [shipping_limit_date] DATETIME2 (7)   NOT NULL,
    [price]               DECIMAL (12, 2) NOT NULL,
    [freight_value]       DECIMAL (12, 2) NOT NULL
);


GO

