-- =============================================
-- Author:	Giuseppe Carnimeo
-- Create date: 20210115
-- Description:	This procedure is used to start to log the execution of a package and return the last inserted ID
-- Parameters: @@PackageName given from SSIS
-- =============================================
CREATE PROCEDURE [Control].[StartLog]
	@PackageName VARCHAR(200) 
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [Control].[ExecutionLog]([PackageName],[StartDate],[StatusID])
	VALUES(@PackageName,GETDATE(),2)

	--we need to retrive the last inserted ID
	Select scope_identity();

END