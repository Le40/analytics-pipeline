CREATE TABLE [dw].[fact_order] (
    [order_id]                     VARCHAR (32)  NOT NULL,
    [customer_key]                 INT           NOT NULL,
    [location_key]                 INT           NOT NULL,
    [purchase_date_key]            INT           NOT NULL,
    [delivery_date_key]            INT           NULL,
    [status]                       VARCHAR (20)  NOT NULL,
    [purchase_timestamp]           DATETIME2 (7) NOT NULL,
    [approved_timestamp]           DATETIME2 (7) NULL,
    [carrier_delivery_timestamp]   DATETIME2 (7) NULL,
    [customer_delivery_timestamp]  DATETIME2 (7) NULL,
    [estimated_delivery_timestamp] DATETIME2 (7) NOT NULL,
    PRIMARY KEY CLUSTERED ([order_id] ASC)
);


GO

