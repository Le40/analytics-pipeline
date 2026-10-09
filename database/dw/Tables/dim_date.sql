CREATE TABLE [dw].[dim_date] (
    [date_key]    INT          NOT NULL,
    [full_date]   DATE         NOT NULL,
    [year]        INT          NOT NULL,
    [quarter]     INT          NOT NULL,
    [month]       INT          NOT NULL,
    [month_name]  VARCHAR (10) NOT NULL,
    [day]         INT          NOT NULL,
    [day_of_week] INT          NOT NULL,
    [day_name]    VARCHAR (10) NOT NULL,

    CONSTRAINT PK_dim_date
        PRIMARY KEY CLUSTERED (date_key)
);


GO

