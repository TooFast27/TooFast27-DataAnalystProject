CREATE TABLE [Control].[ExecutionLog] (
    [ExecutionLogID] INT           IDENTITY (1, 1) NOT NULL,
    [PackageName]    VARCHAR (200) NOT NULL,
    [StartDate]      DATETIME      NOT NULL,
    [EndDate]        DATETIME      NULL,
    [StatusID]       INT           NOT NULL,
    [RowsInserted]   INT           NULL,
    [RowsUpdated]    INT           NULL,
    CONSTRAINT [PK_ExecutionLog] PRIMARY KEY CLUSTERED ([ExecutionLogID] ASC),
    CONSTRAINT [FK_ExecutionLog_ExecutionLogStatusID] FOREIGN KEY ([StatusID]) REFERENCES [Control].[ExecutionLogStatus] ([StatusID])
);



