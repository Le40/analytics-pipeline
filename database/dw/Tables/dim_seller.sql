CREATE TABLE [dw].[dim_seller] (
    [seller_key]      INT            IDENTITY (1, 1) NOT NULL,
    [seller_id]       VARCHAR (32)   NOT NULL,
    [zip_code_prefix] INT            NOT NULL,
    [city]            NVARCHAR (100) NOT NULL,
    [state]           CHAR (2)       NOT NULL,
    PRIMARY KEY CLUSTERED ([seller_key] ASC),
    UNIQUE NONCLUSTERED ([seller_id] ASC)
);


GO

