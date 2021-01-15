-- =============================================
-- Author:	Giuseppe Carnimeo
-- Create date: 20210115
-- Description:	This procedure is used to end a log with a defined status thac can be Failes or success
-- Parameters: @ExecutionLogID fiven from the ssis process
-- =============================================
CREATE PROCEDURE [Control].[EndLog]
	@Status int,
	@ExecutionLogID VARCHAR(200),
	@RowsInserted int = 0
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [Control].[ExecutionLog] 
	SET 
		EndDate = GETDATE(),
		StatusID = @Status,
		RowsInserted = @RowsInserted
	WHERE ExecutionLogID = @ExecutionLogID


END