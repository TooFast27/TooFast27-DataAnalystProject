-- =============================================
-- Author:	Giuseppe Carnimeo
-- Create date: 20210114
-- Description:	This Stored procedure populates the user table with a specified number of dummy Data
-- Parameters: @NumberOfDummyUsers int default 0
-- =============================================
CREATE PROCEDURE [Test].[InsertUserDummyData]
	@NumberOfDummyUsers int = 900000 
AS
BEGIN
	SET NOCOUNT ON;

	TRUNCATE TABLE [dbo].[User];
	--We use the CTE to create the random postcodes with the recursion
	WITH cteRandomPostCode(i, PostCode) AS
	(
		SELECT 1 as i , LEFT( NEWID(), 5 ) as PostCode
		UNION ALL
		
		SELECT i + 1 as i, LEFT( NEWID(), 5 ) as PostCode
		FROM cteRandomPostCode 
		WHERE i < @NumberOfDummyUsers -- how many times to iterate
	)
	INSERT INTO [dbo].[User]([Postcode])
	SELECT PostCode 
	FROM cteRandomPostCode
	option (MAXRECURSION 0)--(MAXRECURSION 0) is needed because we want to ovverride the MaxRecursionValue set by microsot to an indefinite value

END