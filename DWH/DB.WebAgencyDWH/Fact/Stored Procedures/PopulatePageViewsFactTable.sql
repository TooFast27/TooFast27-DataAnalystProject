-- =============================================
-- Author:	Giuseppe Carnimeo
-- Create date: 20210116
-- Description: This procedure Loads the data from the staging table to the Fact PageViews
-- Parameters: @ExecutionLogID given from the ssis process
-- =============================================
CREATE PROCEDURE [Fact].[PopulatePageViewsFactTable]  
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

	
		SELECT 
				ISNULL(Us.[UserSurrogateKey],-1) AS UserSurrogateKey, --our dummy record has -1 this should never happen
				ISNULL(Us.[CurrentLocationMiniSurrogateKey],-1) AS CurrentLocationMiniSurrogateKey,
				PageExt.[PageViewID],
				PageExt.[PageviewDatetime],
				PageExt.[url]
		INTO #UserSourceForMerge
		FROM [Stage].[pageviews_extract] as PageExt
		LEFT JOIN [Dimension].[User] as Us 
			ON Us.UserID = PageExt.UserID
		LEFT JOIN [Dimension].[LocationMini] AS CusLoc
			on CusLoc.LocationMiniSurrogateKey = Us.CurrentLocationMiniSurrogateKey




		INSERT INTO #CountAction (
			[Action]
		)
		SELECT [Action]
		FROM(
			--The goal is to update or insert records based on the business key so out target table is the fact table
			MERGE [Fact].[PageViews] AS [Target]
			--our source table is coumputed joining the record from the stage table and trying to take the user key to get the value of the location at the time of the visit so iven if the user will change the location we will still have the original key and it wont be affected
			USING #UserSourceForMerge AS [Source]
			--if the record match for the busines key then we just update the values if there is any difference
			ON (
				[Target].[PageViewID] = [Source].[PageViewID]
			) 
			WHEN MATCHED AND 
				(
					[Target].[PageviewDatetime] <> [Source].[PageviewDatetime] OR 
					[Target].[url] <> [Source].[url]  
				)
			THEN UPDATE SET 
				[Target].[PageviewDatetime] = [Source].[PageviewDatetime], 
				[Target].[url] = [Source].[url]
			--If there is no record with the same business key we need to insert it
			WHEN NOT MATCHED BY TARGET 
			THEN INSERT 
			(
				[UserSurrogateKey], 
				[LocationMiniSurrogateKey],
				[PageViewID],
				[PageviewDatetime],
				[url],
				[ExecutionLogID],
				[InsertedDateTime]
			)
			VALUES (
				[Source].[UserSurrogateKey],
				[Source].[CurrentLocationMiniSurrogateKey],
				[Source].[PageViewID],
				[Source].[PageviewDatetime],
				[Source].[url],
				@ExecutionLogID,
				GETDATE()
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