IF OBJECT_ID('dw.fact_order', 'U') IS NULL
BEGIN 
    CREATE TABLE dw.fact_order (
        order_id VARCHAR(32) PRIMARY KEY,

        --dim keys
        customer_key INT NOT NULL,
        location_key INT NOT NULL,

        purchase_date_key INT NOT NULL,
        delivery_date_key INT NULL,

        status VARCHAR(20) NOT NULL,

        purchase_timestamp DATETIME2 NOT NULL,
        approved_timestamp DATETIME2 NULL,
        carrier_delivery_timestamp DATETIME2 NULL,
        customer_delivery_timestamp DATETIME2 NULL,
        estimated_delivery_timestamp DATETIME2 NOT NULL,

        -- Foreign keys
        CONSTRAINT FK_order_customer FOREIGN KEY (customer_key)
            REFERENCES dw.dim_customer(customer_key),

        CONSTRAINT FK_order_location FOREIGN KEY (location_key)
            REFERENCES dw.dim_location(location_key),

        CONSTRAINT FK_order_purchase_date FOREIGN KEY (purchase_date_key)
            REFERENCES dw.dim_date(date_key),

        CONSTRAINT FK_order_delivery_date FOREIGN KEY (delivery_date_key)
            REFERENCES dw.dim_date(date_key)
    );
END;