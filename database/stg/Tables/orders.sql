CREATE TABLE [stg].[orders] (
    [order_id]                      VARCHAR (32)  NOT NULL,
    [customer_id]                   VARCHAR (32)  NOT NULL,
    [order_status]                  VARCHAR (20)  NOT NULL,
    [order_purchase_timestamp]      DATETIME2 (7) NOT NULL,
    [order_approved_at]             DATETIME2 (7) NULL,
    [order_delivered_carrier_date]  DATETIME2 (7) NULL,
    [order_delivered_customer_date] DATETIME2 (7) NULL,
    [order_estimated_delivery_date] DATETIME2 (7) NOT NULL
);


GO

