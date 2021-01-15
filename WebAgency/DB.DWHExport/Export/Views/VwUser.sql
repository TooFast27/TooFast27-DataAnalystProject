
CREATE VIEW [Export].[VwUser] AS

SELECT top(9324)
	[UserID],
	[Postcode]
FROM [$(WebAgency)].dbo.[User]