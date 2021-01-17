-- =============================================
-- Author:	Giuseppe Carnimeo
-- Create date: 20210116
-- Description: This procedure Loads all the possible Postcode we could have into its Dimension table 
-- Parameters: @ExecutionLogID given from the ssis process
-- =============================================
CREATE PROCEDURE [Dimension].[LocationMiniToDimension]
@ExecutionLogID	INT = -1
AS
BEGIN
	SET NOCOUNT ON;
    SET XACT_ABORT ON; --We specity SET XACT_ABORT ON because we want a rollback every time the transactions fails to ensure consistency of the data 

	BEGIN TRAN;

		--the idea here is to close all the rows that exist in staging to be able to load them again with the new values, this is needed because the UserExtract dimension is an SCD Type 2 and we want to keep the history of the old records

		INSERT INTO [Dimension].[LocationMini]
		(
				[Postcode],
				[ExecutionLogID]
		)
		SELECT 
			DISTINCT 
			[Postcode],
			@ExecutionLogID
		FROM 
			[Stage].[users_extract] AS ue
		WHERE
		   NOT EXISTS 
		   (
			SELECT * 
			FROM 
				[Dimension].[LocationMini] AS lm
					  WHERE lm.[Postcode] = ue.[Postcode]
		    )

		--eventually we return the number of the inserted rows by the last statement
		SELECT @@ROWCOUNT As InsertedRows 

	COMMIT TRAN

		

END