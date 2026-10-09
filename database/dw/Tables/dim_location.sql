CREATE TABLE [dw].[dim_location] (
    [location_key]    INT            IDENTITY (1, 1) NOT NULL,
    [zip_code_prefix] INT            NOT NULL,
    [city]            NVARCHAR (100) NOT NULL,
    [state]           CHAR (2)       NOT NULL,
    
    PRIMARY KEY CLUSTERED ([location_key] ASC),
    UNIQUE NONCLUSTERED ([zip_code_prefix] ASC, [city] ASC, [state] ASC)
);


GO

