CREATE TABLE [dw].[fact_order_item] (
    [order_id]                 VARCHAR (32)    NOT NULL,
    [order_item_id]            INT             NOT NULL,
    [product_key]              INT             NOT NULL,
    [seller_key]               INT             NOT NULL,
    [purchase_date_key]        INT             NOT NULL,
    [shipping_limit_timestamp] DATETIME2 (7)   NOT NULL,
    [price]                    DECIMAL (12, 2) NOT NULL,
    [freight_value]            DECIMAL (12, 2) NOT NULL,
    PRIMARY KEY CLUSTERED ([order_id] ASC, [order_item_id] ASC)
);


GO

