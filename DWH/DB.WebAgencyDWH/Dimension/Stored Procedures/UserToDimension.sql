-- =============================================
-- Author:	Giuseppe Carnimeo
-- Create date: 20210116
-- Description: This procedure Loads the data the User Staging table to the User dimension
-- Parameters: @ExecutionLogID given from the ssis process
-- =============================================
CREATE PROCEDURE [Dimension].[UserToDimension]  
@ExecutionLogID	INT = -1
AS
BEGIN
	SET NOCOUNT ON;
    SET XACT_ABORT ON; --We specity SET XACT_ABORT ON because we want a rollback every time the transactions fails to ensure consistency of the data 

	BEGIN TRAN;
		--We create a temporal table to get all the informations for the logs
		IF OBJECT_ID('tempdb..#CountAction') IS NOT NULL 
		BEGIN
			DROP TABLE #CountAction
		END

		CREATE TABLE #CountAction(
			[Action] VARCHAR(10)
		) 

		IF OBJECT_ID('tempdb..#UserSourceForMerge') IS NOT NULL 
		BEGIN
			DROP TABLE #UserSourceForMerge
		END

		CREATE TABLE #UserSourceForMerge(
			[UserID] int primary Key,
			CurrentLocationMiniSurrogateKey int
		)

		INSERT INTO #UserSourceForMerge(
			UserID,
			CurrentLocationMiniSurrogateKey
		)
		Select 
			UsExt.[UserID],
			ISNULL(CUsLoc.LocationMiniSurrogateKey,-1) AS CurrentLocationMiniSurrogateKey --our dummy record has -1 this should never happen,
		FROM [Stage].[users_extract] as UsExt
			LEFT JOIN [Dimension].[LocationMini] as CUsLoc
				ON CUsLoc.[Postcode] = UsExt.[Postcode] 

		
		INSERT INTO #CountAction (
			[Action]
		)
		SELECT [Action]
		FROM(
			--the target table where we perform the insert
			MERGE [Dimension].[User] AS [Target]
			--The source table, the CurrentLocationMiniSurrogateKey rapresent the most recent position we have for certain user!
			USING #UserSourceForMerge AS [Source]
			--if we have the same user ID we need to update his position.
			ON (
				[Target].[UserID] = [Source].[UserID]
			) 
			WHEN MATCHED AND 
				(
					[Target].[CurrentLocationMiniSurrogateKey] <> [Source].[CurrentLocationMiniSurrogateKey] 
				)
			THEN UPDATE SET 
				[Target].[CurrentLocationMiniSurrogateKey] = [Source].[CurrentLocationMiniSurrogateKey],
				[UpdatedExecutionLogID] = 1,
				[UpdatedExtractedDate] = GETDATE()
			--If we do not have any record it means that this user is a new one therefore we insert it
			WHEN NOT MATCHED BY TARGET 
			THEN INSERT 
			(
				[UserID],
				[CurrentLocationMiniSurrogateKey],
				[ExecutionLogID]
			)
			VALUES (
				[Source].[UserID],
				[Source].[CurrentLocationMiniSurrogateKey],
				0
			)
			OUTPUT $action AS [Action]
		) MergeOutput;	 
		SELECT
			ISNULL(
				SUM(
					CASE WHEN 
						[Action]='INSERT' 
						THEN 1 
						ELSE 0 
					END
				),
				0
			)AS InsertedRows,
			ISNULL(
				SUM(
					CASE WHEN
						[Action]='UPDATE' 
						THEN 1 
						ELSE 0 
					END
				),
				0
			)AS UpdatedRows
		FROM #CountAction

		DROP TABLE #CountAction 
	COMMIT TRAN

		

END