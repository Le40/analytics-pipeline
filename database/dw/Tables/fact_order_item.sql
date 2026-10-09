CREATE TABLE [dw].[fact_order_item] (
    [order_id]                 VARCHAR (32)    NOT NULL,
    [order_item_id]            INT             NOT NULL,
    [product_key]              INT             NOT NULL,
    [seller_key]               INT             NOT NULL,
    [purchase_date_key]        INT             NOT NULL,
    [shipping_limit_timestamp] DATETIME2 (7)   NOT NULL,
    [price]                    DECIMAL (12, 2) NOT NULL,
    [freight_value]            DECIMAL (12, 2) NOT NULL,
    
    CONSTRAINT PK_fact_order_item
        PRIMARY KEY CLUSTERED (order_id, order_item_id),

    CONSTRAINT FK_order_item_order
        FOREIGN KEY (order_id)
        REFERENCES dw.fact_order(order_id),

    CONSTRAINT FK_order_item_product    
        FOREIGN KEY (product_key)
        REFERENCES dw.dim_product(product_key),

     CONSTRAINT FK_order_item_seller    
        FOREIGN KEY (seller_key)
        REFERENCES dw.dim_seller(seller_key),

    CONSTRAINT FK_order_item_purchase_date
        FOREIGN KEY (purchase_date_key)
        REFERENCES dw.dim_date(date_key),

    CONSTRAINT CK_oitem_id
        CHECK (order_item_id >= 1),

    CONSTRAINT CK_oitem_freight_value
        CHECK (freight_value >= 0),

    CONSTRAINT CK_oitem_price
        CHECK (price >= 0)

);


GO

