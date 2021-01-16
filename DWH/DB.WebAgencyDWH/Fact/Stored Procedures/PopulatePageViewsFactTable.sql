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
		CREATE TABLE #CountAction(
			[Action] VARCHAR(10)
		) 

		INSERT INTO #CountAction (
			[Action]
		)
		SELECT [Action]
		FROM(
			--The goal is to update or insert records based on the business key so out target table is the fact table
			MERGE [Fact].[pageviews_extract] AS [Target]
			--our source table is coumputed joining the record from the stage table and trying to take the user key to get the value of the location
			USING (
				SELECT 
						ISNULL(UsExt.[users_extract_key],-1) AS user_extract_key, --our dummy record has -1 this should never happen
						PageExt.[UserID],
						PageExt.[PageViewID],
						PageExt.[PageviewDatetime],
						PageExt.[url],
						@ExecutionLogID as [ExecutionLogID],
						GETDATE() as [DateTime]
				FROM [Stage].[pageviews_extract] as PageExt
				LEFT JOIN [Dimension].[users_extract] as UsExt 
					ON PageExt.UserID = UsExt.UserID 
					AND UsExt.IsActive =1
			) AS [Source]
			--if the record match for the busines key then we just update the values if there is any difference
			ON (
				[Target].[PageViewID] = [Source].[PageViewID]
			) 
			WHEN MATCHED AND 
				(
					[Target].[UserID] <> [Source].[UserID] OR 
					[Target].[PageviewDatetime] <> [Source].[PageviewDatetime] OR 
					[Target].[url] <> [Source].[url]  
				)
			THEN UPDATE SET 
				[Target].[UserID] = [Source].[UserID], 
				[Target].[PageviewDatetime] = [Source].[PageviewDatetime], 
				[Target].[url] = [Source].[url]
			--If there is no record with the same business key we need to insert it
			WHEN NOT MATCHED BY TARGET 
			THEN INSERT 
			(
				[users_extract_key], 
				[UserID],
				[PageViewID],
				[PageviewDatetime],
				[url],
				[ExecutionLogID],
				[InsertedDateTime]
			)
			VALUES (
				[Source].user_extract_key,
				[Source].[UserID],
				[Source].[PageViewID],
				[Source].[PageviewDatetime],
				[Source].[url],
				[Source].[ExecutionLogID],
				[Source].[DateTime]
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