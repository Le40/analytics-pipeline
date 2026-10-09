IF OBJECT_ID('dw.dim_location', 'U') IS NULL
BEGIN
    CREATE TABLE dw.dim_location (
        location_key INT IDENTITY(1,1) PRIMARY KEY,
        zip_code_prefix INT NOT NULL,
        city NVARCHAR(100) NOT NULL,
        state CHAR(2) NOT NULL,

        UNIQUE (zip_code_prefix, city, state)
    );
END;