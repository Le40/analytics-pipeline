CREATE TABLE [dw].[dim_product] (
    [product_key]           INT             IDENTITY (1, 1) NOT NULL,
    [product_id]            VARCHAR (32)    NOT NULL,
    [category_name]         NVARCHAR (100)  NULL,
    [category_name_english] NVARCHAR (100)  NULL,
    [weight_g]              DECIMAL (10, 2) NULL,
    [length_cm]             DECIMAL (10, 2) NULL,
    [height_cm]             DECIMAL (10, 2) NULL,
    [width_cm]              DECIMAL (10, 2) NULL,
    
    PRIMARY KEY CLUSTERED ([product_key] ASC),
    UNIQUE NONCLUSTERED ([product_id] ASC)
);


GO

