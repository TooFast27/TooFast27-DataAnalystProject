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
		 ISNULL(CONVERT(VARCHAR(25), MAX([PageviewDatetime]) , 121),'1990-01-01 10:00:00.000') AS lastPageViewsDate
	FROM [WebAgencyDWH].[Fact].[PageViews]

END