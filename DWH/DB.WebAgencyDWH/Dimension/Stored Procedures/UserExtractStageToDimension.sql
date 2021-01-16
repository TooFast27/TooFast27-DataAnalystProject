-- =============================================
-- Author:	Giuseppe Carnimeo
-- Create date: 20210116
-- Description: This procedure Load the data from the staging table to the Dimension table
-- Parameters: @ExecutionLogID given from the ssis process
-- =============================================
CREATE PROCEDURE [Dimension].[UserExtractStageToDimension]
@ExecutionLogID	INT = -1
AS
BEGIN
	SET NOCOUNT ON;
    SET XACT_ABORT ON; --We specity SET XACT_ABORT ON because we want a rollback every time the transactions fails to ensure consistency of the data 

	BEGIN TRAN;

		--the idea here is to close all the rows that exist in staging to be able to load them again with the new values, this is needed because the UserExtract dimension is an SCD Type 2 and we want to keep the history of the old records

		WITH RowsToClose
		AS(
			SELECT 
				[UserID],
				[Postcode]
			FROM [Stage].[users_extract]
		)
		UPDATE DimUs
			SET 
				DimUs.[EndDate] = GETDATE(),
				IsActive = 0,
				ExecutionLogID = @ExecutionLogID  
		FROM [Dimension].[users_extract] AS DimUs
		INNER JOIN RowsToClose AS ExistingRows
		ON DimUs.[UserID] = ExistingRows.[UserID]
		WHERE IsActive = 1;

		--after we closed the existing users we can preform the full load 
		INSERT [Dimension].[users_extract]
        (
			[UserID], 
			[Postcode],
			[ExecutionLogID],
			[StartDate],
			[IsActive]
		)
		SELECT 
				[UserID],
				[Postcode],
				@ExecutionLogID,
				GETDATE(),
				1
		FROM [Stage].[users_extract];

		--eventually we return the number of the inserted rows by the last statement
		SELECT @@ROWCOUNT As InsertedRows 

	COMMIT TRAN

		

END