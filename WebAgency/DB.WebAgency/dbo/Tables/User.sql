CREATE TABLE [dbo].[User] (
    [UserID]   INT          IDENTITY (1, 1) NOT NULL,
    [Postcode] VARCHAR (10) NOT NULL,
    CONSTRAINT [PK_User_Id] PRIMARY KEY CLUSTERED ([UserID] ASC)
);

