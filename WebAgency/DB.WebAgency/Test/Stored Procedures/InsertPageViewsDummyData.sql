-- =============================================
-- Author:	Giuseppe Carnimeo
-- Create date: 20210115
-- Description:	This Stored procedure populates the PageView table with a specified number of dummy Data
--				This Procedure should be executed once every very often to try to replicate a real scenario
-- Parameters: @NumberOfDummyPageViews int default 9000 
-- =============================================
CREATE PROCEDURE [Test].[InsertPageViewsDummyData]
	@NumberOfDummyPageViews int = 90000 
AS
BEGIN
	SET NOCOUNT ON;

	
	INSERT INTO [dbo].[PageView]([UserID], [Url])
	SELECT TOP(@NumberOfDummyPageViews) [UserID], CONCAT('http://www.example.com/', LEFT(NEWID(),5)) 
	FROM [dbo].[User]
	order by NEWID()
END