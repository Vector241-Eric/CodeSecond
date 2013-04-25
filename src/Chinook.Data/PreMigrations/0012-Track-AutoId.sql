ALTER TABLE [dbo].[PlaylistTrack] DROP CONSTRAINT [FK_dbo.PlaylistTrack_dbo.Track_TrackId];
GO

ALTER TABLE [dbo].[InvoiceLine] DROP CONSTRAINT [FK_dbo.InvoiceLine_dbo.Track_TrackId];
GO

BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Track] (
    [TrackId]      INT             IDENTITY (1, 1) NOT NULL,
    [Name]         NVARCHAR (200)  NOT NULL,
    [AlbumId]      INT             NULL,
    [MediaTypeId]  INT             NOT NULL,
    [GenreId]      INT             NULL,
    [Composer]     NVARCHAR (220)  NULL,
    [Milliseconds] INT             NOT NULL,
    [Bytes]        INT             NULL,
    [UnitPrice]    DECIMAL (18, 2) NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_dbo.Track] PRIMARY KEY CLUSTERED ([TrackId] ASC),
    CONSTRAINT [tmp_ms_xx_constraint_FK_dbo.Track_dbo.Album_AlbumId] FOREIGN KEY ([AlbumId]) REFERENCES [dbo].[Album] ([AlbumId]),
    CONSTRAINT [tmp_ms_xx_constraint_FK_dbo.Track_dbo.Genre_GenreId] FOREIGN KEY ([GenreId]) REFERENCES [dbo].[Genre] ([GenreId]),
    CONSTRAINT [tmp_ms_xx_constraint_FK_dbo.Track_dbo.MediaType_MediaTypeId] FOREIGN KEY ([MediaTypeId]) REFERENCES [dbo].[MediaType] ([MediaTypeId])

);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Track])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Track] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Track] ([TrackId], [Name], [AlbumId], [MediaTypeId], [GenreId], [Composer], [Milliseconds], [Bytes], [UnitPrice])
        SELECT   [TrackId],
                 [Name],
                 [AlbumId],
                 [MediaTypeId],
                 [GenreId],
                 [Composer],
                 [Milliseconds],
                 [Bytes],
                 [UnitPrice]
        FROM     [dbo].[Track]
        ORDER BY [TrackId] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Track] OFF;
    END

DROP TABLE [dbo].[Track];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Track]', N'Track';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_dbo.Track]', N'PK_dbo.Track', N'OBJECT';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_FK_dbo.Track_dbo.Album_AlbumId]', N'FK_dbo.Track_dbo.Album_AlbumId', N'OBJECT';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_FK_dbo.Track_dbo.Genre_GenreId]', N'FK_dbo.Track_dbo.Genre_GenreId', N'OBJECT';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_FK_dbo.Track_dbo.MediaType_MediaTypeId]', N'FK_dbo.Track_dbo.MediaType_MediaTypeId', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO

CREATE NONCLUSTERED INDEX [IX_AlbumId] ON [dbo].[Track]([AlbumId] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_GenreId] ON [dbo].[Track]([GenreId] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_MediaTypeId] ON [dbo].[Track]([MediaTypeId] ASC);
GO

ALTER TABLE [dbo].[PlaylistTrack] WITH NOCHECK
    ADD CONSTRAINT [FK_dbo.PlaylistTrack_dbo.Track_TrackId] FOREIGN KEY ([TrackId]) REFERENCES [dbo].[Track] ([TrackId]);
GO

ALTER TABLE [dbo].[InvoiceLine] WITH NOCHECK
    ADD CONSTRAINT [FK_dbo.InvoiceLine_dbo.Track_TrackId] FOREIGN KEY ([TrackId]) REFERENCES [dbo].[Track] ([TrackId]);
GO

ALTER TABLE [dbo].[PlaylistTrack] WITH CHECK CHECK CONSTRAINT [FK_dbo.PlaylistTrack_dbo.Track_TrackId];

ALTER TABLE [dbo].[InvoiceLine] WITH CHECK CHECK CONSTRAINT [FK_dbo.InvoiceLine_dbo.Track_TrackId];
