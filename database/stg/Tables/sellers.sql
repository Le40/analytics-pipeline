CREATE TABLE [stg].[sellers] (
    [seller_id]              VARCHAR (32)   NOT NULL,
    [seller_zip_code_prefix] CHAR(5)        NOT NULL,
    [seller_city]            NVARCHAR (100) NOT NULL,
    [seller_state]           CHAR (2)       NOT NULL
);


GO

