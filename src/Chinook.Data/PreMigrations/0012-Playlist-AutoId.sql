ALTER TABLE [dbo].[PlaylistTrack] DROP CONSTRAINT [FK_dbo.PlaylistTrack_dbo.Playlist_PlaylistId];
GO

BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Playlist] (
    [PlaylistId] INT            IDENTITY (1, 1) NOT NULL,
    [Name]       NVARCHAR (120) NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_dbo.Playlist] PRIMARY KEY CLUSTERED ([PlaylistId] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Playlist])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Playlist] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Playlist] ([PlaylistId], [Name])
        SELECT   [PlaylistId],
                 [Name]
        FROM     [dbo].[Playlist]
        ORDER BY [PlaylistId] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Playlist] OFF;
    END

DROP TABLE [dbo].[Playlist];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Playlist]', N'Playlist';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_dbo.Playlist]', N'PK_dbo.Playlist', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO

ALTER TABLE [dbo].[PlaylistTrack] WITH NOCHECK
    ADD CONSTRAINT [FK_dbo.PlaylistTrack_dbo.Playlist_PlaylistId] FOREIGN KEY ([PlaylistId]) REFERENCES [dbo].[Playlist] ([PlaylistId]);
GO

ALTER TABLE [dbo].[PlaylistTrack] WITH CHECK CHECK CONSTRAINT [FK_dbo.PlaylistTrack_dbo.Playlist_PlaylistId];
