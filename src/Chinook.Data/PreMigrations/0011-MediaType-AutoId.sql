ALTER TABLE [dbo].[Track] DROP CONSTRAINT [FK_dbo.Track_dbo.MediaType_MediaTypeId];
GO

BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_MediaType] (
    [MediaTypeId] INT            IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (120) NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_dbo.MediaType] PRIMARY KEY CLUSTERED ([MediaTypeId] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[MediaType])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_MediaType] ON;
        INSERT INTO [dbo].[tmp_ms_xx_MediaType] ([MediaTypeId], [Name])
        SELECT   [MediaTypeId],
                 [Name]
        FROM     [dbo].[MediaType]
        ORDER BY [MediaTypeId] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_MediaType] OFF;
    END

DROP TABLE [dbo].[MediaType];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_MediaType]', N'MediaType';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_dbo.MediaType]', N'PK_dbo.MediaType', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO

ALTER TABLE [dbo].[Track] WITH NOCHECK
    ADD CONSTRAINT [FK_dbo.Track_dbo.MediaType_MediaTypeId] FOREIGN KEY ([MediaTypeId]) REFERENCES [dbo].[MediaType] ([MediaTypeId]);
GO

ALTER TABLE [dbo].[Track] WITH CHECK CHECK CONSTRAINT [FK_dbo.Track_dbo.MediaType_MediaTypeId];
