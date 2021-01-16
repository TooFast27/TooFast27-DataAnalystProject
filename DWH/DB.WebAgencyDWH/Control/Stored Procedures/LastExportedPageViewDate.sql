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
		MAX([PageviewDatetime]) AS lastPageViewsDate
	FROM [WebAgencyDWH].[Fact].[pageviews_extract]

END