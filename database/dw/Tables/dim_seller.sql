CREATE TABLE [dw].[dim_seller] (
    [seller_key]      INT            IDENTITY (1, 1) NOT NULL,
    [seller_id]       VARCHAR (32)   NOT NULL,
    [zip_code_prefix] CHAR(5)        NOT NULL,
    [city]            NVARCHAR (100) NOT NULL,
    [state]           CHAR (2)       NOT NULL,
    
    CONSTRAINT PK_dim_seller
        PRIMARY KEY CLUSTERED (seller_key),

    UNIQUE NONCLUSTERED (seller_id),

    CONSTRAINT CK_seller_zip
        CHECK (zip_code_prefix LIKE '[0-9][0-9][0-9][0-9][0-9]'),

    CONSTRAINT CK_seller_city
        CHECK (LEN(TRIM(city)) > 0),

    CONSTRAINT CK_seller_state
        CHECK (state LIKE '[A-Z][A-Z]')
);


GO

