BEGIN TRANSACTION;

ALTER TABLE [dbo].[Album] DROP CONSTRAINT [FK_dbo.Album_dbo.Artist_ArtistId];
GO

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Artist] (
    [ArtistId] INT            IDENTITY (1, 1) NOT NULL,
    [Name]     NVARCHAR (120) NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_dbo.Artist] PRIMARY KEY CLUSTERED ([ArtistId] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Artist])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Artist] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Artist] ([ArtistId], [Name])
        SELECT   [ArtistId],
                 [Name]
        FROM     [dbo].[Artist]
        ORDER BY [ArtistId] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Artist] OFF;
    END

DROP TABLE [dbo].[Artist];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Artist]', N'Artist';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_dbo.Artist]', N'PK_dbo.Artist', N'OBJECT';

ALTER TABLE [dbo].[Album]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Album_dbo.Artist_ArtistId] FOREIGN KEY([ArtistId])
REFERENCES [dbo].[Artist] ([ArtistId])
GO

ALTER TABLE [dbo].[Album] CHECK CONSTRAINT [FK_dbo.Album_dbo.Artist_ArtistId]
GO

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

