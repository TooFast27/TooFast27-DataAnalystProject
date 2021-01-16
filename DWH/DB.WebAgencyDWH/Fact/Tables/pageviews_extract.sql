CREATE TABLE [Fact].[pageviews_extract] (
    [pageviews_extract_key] INT           IDENTITY (1, 1) NOT NULL,
    [users_extract_key]     INT           NOT NULL,
    [PageViewID]            INT           NOT NULL,
    [PageviewDatetime]      DATETIME      NOT NULL,
    [url]                   VARCHAR (500) NULL,
    [ExecutionLogID]        INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([pageviews_extract_key] ASC),
    FOREIGN KEY ([users_extract_key]) REFERENCES [Dimension].[users_extract] ([users_extract_key])
);

