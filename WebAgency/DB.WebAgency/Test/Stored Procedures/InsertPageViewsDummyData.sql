-- =============================================
-- Author:	Giuseppe Carnimeo
-- Create date: 20210115
-- Description:	This Stored procedure populates the PageView table with a specified number of dummy Data
--				This Procedure should be executed once every very often to try to replicate a real scenario
-- Parameters: @NumberOfDummyPageViews int default 9000 
-- =============================================
CREATE PROCEDURE [Test].[InsertPageViewsDummyData]
	@NumberOfDummyPageViews int = 9000 
AS
BEGIN
	SET NOCOUNT ON;

	
	INSERT INTO [dbo].[PageView]([UserID])
	SELECT TOP(@NumberOfDummyPageViews) [UserID]  
	FROM [dbo].[User]
	order by NEWID()
END