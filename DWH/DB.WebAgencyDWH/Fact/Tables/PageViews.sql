CREATE TABLE [Fact].[PageViews] (
    [PageViewsSurrogateSurrogateKey] INT           IDENTITY (1, 1) NOT NULL,
    [UserSurrogateKey]               INT           NOT NULL,
    [LocationMiniSurrogateKey]       INT           NOT NULL,
    [PageViewID]                     INT           NOT NULL,
    [PageviewDatetime]               DATETIME      NOT NULL,
    [url]                            VARCHAR (500) NULL,
    [ExecutionLogID]                 INT           NOT NULL,
    [InsertedDateTime]               DATETIME      NOT NULL,
    PRIMARY KEY CLUSTERED ([PageViewsSurrogateSurrogateKey] ASC),
    FOREIGN KEY ([LocationMiniSurrogateKey]) REFERENCES [Dimension].[LocationMini] ([LocationMiniSurrogateKey]),
    FOREIGN KEY ([UserSurrogateKey]) REFERENCES [Dimension].[User] ([UserSurrogateKey])
);

