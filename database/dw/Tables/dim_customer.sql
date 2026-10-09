CREATE TABLE [dw].[dim_customer] (
    [customer_key]       INT          IDENTITY (1, 1) NOT NULL,
    [customer_unique_id] VARCHAR (32) NOT NULL,
    PRIMARY KEY CLUSTERED ([customer_key] ASC),
    UNIQUE NONCLUSTERED ([customer_unique_id] ASC)
);


GO

