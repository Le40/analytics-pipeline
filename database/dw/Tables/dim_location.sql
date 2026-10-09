CREATE TABLE [dw].[dim_location] (
    [location_key]    INT            IDENTITY (1, 1) NOT NULL,
    [zip_code_prefix] CHAR(5)        NOT NULL,
    [city]            NVARCHAR (100) NOT NULL,
    [state]           CHAR (2)       NOT NULL,
    
    CONSTRAINT PK_dim_location
        PRIMARY KEY CLUSTERED (location_key),

    CONSTRAINT UQ_dim_location_zip_city_state
        UNIQUE NONCLUSTERED (zip_code_prefix, city, state),

    CONSTRAINT CK_location_zip
        CHECK (zip_code_prefix LIKE '[0-9][0-9][0-9][0-9][0-9]'),

    CONSTRAINT CK_location_city
        CHECK (LEN(TRIM(city)) > 0),

    CONSTRAINT CK_location_state
        CHECK (state LIKE '[A-Z][A-Z]')
);


GO

