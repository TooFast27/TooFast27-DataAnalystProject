/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/


--InsertDummy Records
IF NOT EXISTS (SELECT 1 FROM [Dimension].[LocationMini] WHERE [LocationMiniSurrogateKey] = -1)
	BEGIN
	SET IDENTITY_INSERT [Dimension].[LocationMini] ON; 
		INSERT INTO [Dimension].[LocationMini]
				   ([LocationMiniSurrogateKey]
				   ,[Postcode]
				   ,[ExecutionLogID]
				   ,[ExtractedDate])
			 VALUES
				   (-1
				   ,'<N/A>'
				   ,-1
				   ,'20210101')
		SET IDENTITY_INSERT [Dimension].[LocationMini] OFF; 
	END
IF NOT EXISTS (SELECT 1 FROM [Dimension].[User] WHERE [UserSurrogateKey] = -1)
	BEGIN
	SET IDENTITY_INSERT [Dimension].[User] ON; 
		INSERT INTO [Dimension].[User]
			   ([UserSurrogateKey]
			   ,[UserID]
			   ,[CurrentLocationMiniSurrogateKey]
			   ,[ExecutionLogID]
			   ,[ExtractedDate]
			   ,[UpdatedExecutionLogID]
			   ,[UpdatedExtractedDate])
		 VALUES
			   (-1
			   ,-1
			   ,-1
			   ,-1
			   ,'20210101'
			   ,-1
			   ,null)
		SET IDENTITY_INSERT [Dimension].[User] OFF; 
	END
GO


--insert status for logs
IF NOT EXISTS (SELECT 1 FROM [Control].[ExecutionLogStatus])
	BEGIN
		SET IDENTITY_INSERT [Control].[ExecutionLogStatus] ON; 
		INSERT INTO [Control].[ExecutionLogStatus]
			   ([StatusID]
			   ,[Description])
		 VALUES
			   (1,'Success'),
			   (2,'In Progress'),
			   (3,'Failed')

		SET IDENTITY_INSERT [Control].[ExecutionLogStatus] OFF; 
	END