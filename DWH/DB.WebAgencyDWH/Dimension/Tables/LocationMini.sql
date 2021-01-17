CREATE TABLE [Dimension].[LocationMini] (
    [LocationMiniSurrogateKey] INT          IDENTITY (1, 1) NOT NULL,
    [Postcode]                 VARCHAR (10) NOT NULL,
    [ExecutionLogID]           INT          NOT NULL,
    [ExtractedDate]            DATETIME     DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([LocationMiniSurrogateKey] ASC)
);



