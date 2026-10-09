CREATE TABLE [stg].[payments] (
    [order_id]             VARCHAR (32)    NOT NULL,
    [payment_sequential]   INT             NOT NULL,
    [payment_type]         VARCHAR (20)    NOT NULL,
    [payment_installments] INT             NOT NULL,
    [payment_value]        DECIMAL (12, 2) NOT NULL
);


GO

