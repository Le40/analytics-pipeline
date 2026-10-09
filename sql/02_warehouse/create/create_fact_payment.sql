IF OBJECT_ID('dw.fact_payment', 'U') IS NULL
BEGIN 
    CREATE TABLE dw.fact_payment (
        order_id VARCHAR(32) NOT NULL,
        payment_sequential INT NOT NULL,

        --dim keys
        customer_key INT NOT NULL,
        purchase_date_key INT NOT NULL,

        payment_type VARCHAR(20) NOT NULL,
        installments INT NOT NULL,
        payment_value DECIMAL(12, 2) NOT NULL,

        PRIMARY KEY(order_id, payment_sequential)
    );
END;