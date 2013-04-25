ALTER TABLE [dbo].[Track] DROP CONSTRAINT [FK_TrackAlbumId];
GO

BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Album] (
    [AlbumId]  INT            IDENTITY (1, 1) NOT NULL,
    [Title]    NVARCHAR (160) NOT NULL,
    [ArtistId] INT            NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_dbo.Album] PRIMARY KEY CLUSTERED ([AlbumId] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Album])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Album] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Album] ([AlbumId], [Title], [ArtistId])
        SELECT   [AlbumId],
                 [Title],
                 [ArtistId]
        FROM     [dbo].[Album]
        ORDER BY [AlbumId] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Album] OFF;
    END

DROP TABLE [dbo].[Album];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Album]', N'Album';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_dbo.Album]', N'PK_dbo.Album', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

ALTER TABLE [dbo].[Track] WITH NOCHECK
    ADD CONSTRAINT [FK_dbo.Track_dbo.Album_AlbumId] FOREIGN KEY ([AlbumId]) REFERENCES [dbo].[Album] ([AlbumId]);

ALTER TABLE [dbo].[Track] WITH CHECK CHECK CONSTRAINT [FK_dbo.Track_dbo.Album_AlbumId];

ALTER TABLE [dbo].[Album]  WITH CHECK ADD CONSTRAINT [FK_dbo.Album_dbo.Artist_ArtistId] FOREIGN KEY([ArtistId]) REFERENCES [dbo].[Artist] ([ArtistId])
GO

ALTER TABLE [dbo].[Album] CHECK CONSTRAINT [FK_dbo.Album_dbo.Artist_ArtistId]
GO

