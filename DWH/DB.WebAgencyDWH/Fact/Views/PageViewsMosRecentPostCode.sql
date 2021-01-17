CREATE VIEW Fact.PageViewsMosRecentPostCode AS
SELECT 
	count(*) as NumberPageViews,
	LM.Postcode
FROM [Fact].[PageViews] AS PW
INNER JOIN [Dimension].[User] AS USR
	ON PW.UserSurrogateKey  = USR.UserSurrogateKey
INNER JOIN [Dimension].[LocationMini] AS LM
	on LM.LocationMiniSurrogateKey = USR.CurrentLocationMiniSurrogateKey
GROUP BY Postcode