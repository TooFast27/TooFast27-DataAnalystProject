CREATE TABLE [dbo].[PageView] (
    [PageViewID]       INT           IDENTITY (1, 1) NOT NULL,
    [UserID]           INT           NOT NULL,
    [PageviewDatetime] DATETIME      DEFAULT (getdate()) NULL,
    [Url]              VARCHAR (500) NOT NULL,
    CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED ([PageViewID] ASC)
);

