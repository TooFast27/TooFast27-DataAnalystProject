CREATE TABLE [Dimension].[users_extract] (
    [users_extract_key] INT          IDENTITY (1, 1) NOT NULL,
    [UserID]            INT          NOT NULL,
    [Postcode]          VARCHAR (10) NOT NULL,
    [ExecutionLogID]    INT          NOT NULL,
    [StartDate]         DATETIME     DEFAULT (getdate()) NOT NULL,
    [EndDate]           DATETIME     NULL,
    [IsActive]          BIT          NOT NULL,
    PRIMARY KEY CLUSTERED ([users_extract_key] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX__users_extract.uniqueId]
    ON [Dimension].[users_extract]([UserID] ASC) WHERE ([IsActive]=(1));

