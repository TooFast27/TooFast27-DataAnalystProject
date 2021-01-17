CREATE TABLE [Dimension].[User] (
    [UserSurrogateKey]                INT      IDENTITY (1, 1) NOT NULL,
    [UserID]                          INT      NOT NULL,
    [CurrentLocationMiniSurrogateKey] INT      NOT NULL,
    [ExecutionLogID]                  INT      NOT NULL,
    [ExtractedDate]                   DATETIME DEFAULT (getdate()) NOT NULL,
    [UpdatedExecutionLogID]           INT      NULL,
    [UpdatedExtractedDate]            DATETIME NULL,
    PRIMARY KEY CLUSTERED ([UserSurrogateKey] ASC),
    FOREIGN KEY ([CurrentLocationMiniSurrogateKey]) REFERENCES [Dimension].[LocationMini] ([LocationMiniSurrogateKey])
);





