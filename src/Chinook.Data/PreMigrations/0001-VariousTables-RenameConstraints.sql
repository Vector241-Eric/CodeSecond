/* Table: Artist */
exec sp_rename '[dbo].[Album].PK_Album', 'PK_dbo.Album'
exec sp_rename 'FK_AlbumArtistId', 'FK_dbo.Album_dbo.Artist_ArtistId'
exec sp_rename N'[dbo].[Album].IFK_AlbumArtistId', N'IX_ArtistId', N'INDEX'

