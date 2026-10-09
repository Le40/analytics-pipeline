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

    CONSTRAINT PK_fact_order
        PRIMARY KEY CLUSTERED (order_id),

    CONSTRAINT FK_order_customer    
        FOREIGN KEY (customer_key)
        REFERENCES dw.dim_customer(customer_key),

    CONSTRAINT FK_order_location
        FOREIGN KEY (location_key)
        REFERENCES dw.dim_location(location_key),

    CONSTRAINT FK_order_purchase_date
        FOREIGN KEY (purchase_date_key)
        REFERENCES dw.dim_date(date_key),

    CONSTRAINT FK_order_delivery_date
        FOREIGN KEY (delivery_date_key)
        REFERENCES dw.dim_date(date_key)
);


GO

