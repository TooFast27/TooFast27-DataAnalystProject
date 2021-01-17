-- =============================================
-- Author:	Giuseppe Carnimeo
-- Create date: 20210115
-- Description: This procedures select the incremental records from the PageViewTable into the OLTP db
-- Parameters: @StartTime
-- =============================================
CREATE PROCEDURE [Export].[GetPageView]
	@StartTime datetime = '19900101'
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		[PageViewID],
		[UserID],
		[PageviewDatetime],
		[Url]
	FROM [$(WebAgency)].[dbo].[PageView]
	WHERE [PageviewDatetime]> @StartTime


END