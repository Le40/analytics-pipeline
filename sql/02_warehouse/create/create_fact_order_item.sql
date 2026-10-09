IF OBJECT_ID('dw.fact_order_item', 'U') IS NULL
BEGIN 
    CREATE TABLE dw.fact_order_item (
        order_id VARCHAR(32) NOT NULL,
        order_item_id INT NOT NULL,

        --dim keys
        product_key INT NOT NULL,
        seller_key INT NOT NULL,
        purchase_date_key INT NOT NULL,

        shipping_limit_timestamp DATETIME2 NOT NULL,
        price DECIMAL(12, 2) NOT NULL,
        freight_value DECIMAL(12, 2) NOT NULL,

        PRIMARY KEY(order_id, order_item_id)
    );
END;