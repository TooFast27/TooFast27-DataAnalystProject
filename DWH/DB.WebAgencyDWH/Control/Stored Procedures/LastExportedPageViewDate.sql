-- =============================================
-- Author:	Giuseppe Carnimeo
-- Create date: 20210115
-- Description: This procedure is used to get the last date time we have for the pageViews
-- Parameters: @ExecutionLogID fiven from the ssis process
-- =============================================
CREATE PROCEDURE [Control].[LastExportedPageViewDate]
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		 CONVERT(VARCHAR(25), MAX([PageviewDatetime]) , 121) AS lastPageViewsDate
	FROM [WebAgencyDWH].[Fact].[PageViews]

END