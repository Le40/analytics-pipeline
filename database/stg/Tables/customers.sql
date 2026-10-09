CREATE TABLE [stg].[customers] (
    [customer_id]              VARCHAR (32)   NOT NULL,
    [customer_unique_id]       VARCHAR (32)   NOT NULL,
    [customer_zip_code_prefix] CHAR(5)        NOT NULL,
    [customer_city]            NVARCHAR (100) NOT NULL,
    [customer_state]           CHAR (2)       NOT NULL
);


GO

