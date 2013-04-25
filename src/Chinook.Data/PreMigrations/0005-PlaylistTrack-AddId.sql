ALTER TABLE [dbo].[PlaylistTrack] DROP CONSTRAINT [PK_PlaylistTrack];
GO

BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_PlaylistTrack] (
    [Id]         INT IDENTITY (1, 1) NOT NULL,
    [PlaylistId] INT NOT NULL,
    [TrackId]    INT NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_dbo.PlaylistTrack] PRIMARY KEY CLUSTERED ([Id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[PlaylistTrack])
    BEGIN
        
        INSERT INTO [dbo].[tmp_ms_xx_PlaylistTrack] ([PlaylistId], [TrackId])
        SELECT [PlaylistId],
               [TrackId]
        FROM   [dbo].[PlaylistTrack];
        
    END

DROP TABLE [dbo].[PlaylistTrack];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_PlaylistTrack]', N'PlaylistTrack';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_dbo.PlaylistTrack]', N'PK_dbo.PlaylistTrack', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

CREATE NONCLUSTERED INDEX [IX_PlaylistId] ON [dbo].[PlaylistTrack]([PlaylistId] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_TrackId] ON [dbo].[PlaylistTrack]([TrackId] ASC);
GO

ALTER TABLE [dbo].[PlaylistTrack] WITH NOCHECK
    ADD CONSTRAINT [FK_dbo.PlaylistTrack_dbo.Playlist_PlaylistId] FOREIGN KEY ([PlaylistId]) REFERENCES [dbo].[Playlist] ([PlaylistId]);
GO

ALTER TABLE [dbo].[PlaylistTrack] WITH NOCHECK
    ADD CONSTRAINT [FK_dbo.PlaylistTrack_dbo.Track_TrackId] FOREIGN KEY ([TrackId]) REFERENCES [dbo].[Track] ([TrackId]);
GO

ALTER TABLE [dbo].[PlaylistTrack] WITH CHECK CHECK CONSTRAINT [FK_dbo.PlaylistTrack_dbo.Playlist_PlaylistId];
ALTER TABLE [dbo].[PlaylistTrack] WITH CHECK CHECK CONSTRAINT [FK_dbo.PlaylistTrack_dbo.Track_TrackId];
