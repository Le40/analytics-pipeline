CREATE TABLE [dw].[fact_payment] (
    [order_id]           VARCHAR (32)    NOT NULL,
    [payment_sequential] INT             NOT NULL,
    [customer_key]       INT             NOT NULL,
    [purchase_date_key]  INT             NOT NULL,
    [payment_type]       VARCHAR (20)    NOT NULL,
    [installments]       INT             NOT NULL,
    [payment_value]      DECIMAL (12, 2) NOT NULL,
    
    CONSTRAINT PK_fact_payment
        PRIMARY KEY CLUSTERED (order_id, payment_sequential),

    CONSTRAINT FK_payment_order
        FOREIGN KEY (order_id)
        REFERENCES dw.fact_order(order_id),

    CONSTRAINT FK_payment_customer    
        FOREIGN KEY (customer_key)
        REFERENCES dw.dim_customer(customer_key),

    CONSTRAINT FK_payment_purchase_date
        FOREIGN KEY (purchase_date_key)
        REFERENCES dw.dim_date(date_key),

    CONSTRAINT CK_payment_value
        CHECK (payment_value >= 0),

    CONSTRAINT CK_payment_installments
        CHECK (installments >= 0),

    CONSTRAINT CK_payment_sequential
        CHECK (payment_sequential >= 1)

);


GO

