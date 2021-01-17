
CREATE VIEW [Export].[VwUser] AS

SELECT
	[UserID],
	[Postcode]
FROM [$(WebAgency)].dbo.[User]