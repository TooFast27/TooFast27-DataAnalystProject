CREATE TABLE [Control].[ExecutionLogStatus] (
    [StatusID]    INT          IDENTITY (1, 1) NOT NULL,
    [Description] VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_ExecutionLogStatus] PRIMARY KEY CLUSTERED ([StatusID] ASC)
);

