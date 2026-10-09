IF OBJECT_ID('dw.dim_date','U') IS NULL
BEGIN
    CREATE TABLE dw.dim_date (
        date_key INT PRIMARY KEY,
        full_date DATE NOT NULL,
        year INT NOT NULL,
        quarter INT NOT NULL,
        month INT NOT NULL,
        month_name VARCHAR(10) NOT NULL,
        day INT NOT NULL,
        day_of_week INT NOT NULL,
        day_name VARCHAR(10) NOT NULL
    );
END;