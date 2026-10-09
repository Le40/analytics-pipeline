CREATE TABLE [dw].[dim_customer] (
    [customer_key]       INT          IDENTITY (1, 1) NOT NULL,
    [customer_unique_id] VARCHAR (32) NOT NULL,

    CONSTRAINT PK_dim_customer
        PRIMARY KEY CLUSTERED (customer_key),

    CONSTRAINT UQ_dim_customer_unique_id
        UNIQUE NONCLUSTERED (customer_unique_id)
);


GO

