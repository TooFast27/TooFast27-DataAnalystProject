CREATE VIEW Fact.PageViewsOriginalLocation AS
SELECT 
	count(*) as NumberPageViews,
	LM.Postcode
FROM [Fact].[PageViews] AS PW
INNER JOIN [Dimension].[LocationMini] AS LM
	on LM.LocationMiniSurrogateKey = PW.LocationMiniSurrogateKey
GROUP BY Postcode