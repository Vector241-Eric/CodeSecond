/* Table: Artist */
exec sp_rename '[dbo].[Album].PK_Album', 'PK_dbo.Album'
exec sp_rename 'FK_AlbumArtistId', 'FK_dbo.Album_dbo.Artist_ArtistId'
exec sp_rename N'[dbo].[Album].[IFK_AlbumArtistId]', N'IX_ArtistId', N'INDEX'

exec sp_rename '[dbo].[Customer].[PK_Customer]', 'PK_dbo.Customer'
exec sp_rename '[FK_CustomerSupportRepId]', 'FK_dbo.Customer_dbo.Employee_SupportRepId'
exec sp_rename N'[dbo].[Customer].[IFK_CustomerSupportRepId]', N'IX_SupportRepId', N'INDEX'

exec sp_rename '[dbo].[Employee].[PK_Employee]', 'PK_dbo.Employee'
exec sp_rename '[FK_EmployeeReportsTo]', 'FK_dbo.Employee_dbo.Employee_ReportsTo'
exec sp_rename N'[dbo].[Employee].[IFK_EmployeeReportsTo]', N'IX_ReportsTo', N'INDEX'

exec sp_rename '[dbo].[Genre].[PK_Genre]', 'PK_dbo.Genre'

exec sp_rename '[dbo].[Invoice].[PK_Invoice]', 'PK_dbo.Invoice'
exec sp_rename '[FK_InvoiceCustomerId]', 'FK_dbo.Invoice_dbo.Customer_CustomerId'
exec sp_rename N'[dbo].[Invoice].[IFK_InvoiceCustomerId]', N'IX_CustomerId', N'INDEX'

exec sp_rename '[dbo].[InvoiceLine].[PK_InvoiceLine]', 'PK_dbo.InvoiceLine'
exec sp_rename '[FK_InvoiceLineInvoiceId]', 'FK_dbo.InvoiceLine_dbo.Invoice_InvoiceId'
exec sp_rename '[FK_InvoiceLineTrackId]', 'FK_dbo.InvoiceLine_dbo.Track_TrackId'
exec sp_rename N'[dbo].[InvoiceLine].[IFK_InvoiceLineInvoiceId]', N'IX_InvoiceId', N'INDEX'
exec sp_rename N'[dbo].[InvoiceLine].[IFK_InvoiceLineTrackId]', N'IX_TrackId', N'INDEX'

exec sp_rename '[dbo].[MediaType].[PK_MediaType]', 'PK_dbo.MediaType'

exec sp_rename '[dbo].[Playlist].[PK_Playlist]', 'PK_dbo.Playlist'

exec sp_rename '[FK_PlaylistTrackPlaylistId]', 'FK_dbo.PlaylistTrack_dbo.Playlist_PlaylistId'
exec sp_rename '[FK_PlaylistTrackTrackId]', 'FK_dbo.PlaylistTrack_dbo.Track_TrackId'

exec sp_rename '[dbo].[Track].[PK_Track]', 'PK_dbo.Track'
exec sp_rename '[FK_TrackGenreId]', 'FK_dbo.Track_dbo.Genre_GenreId'
exec sp_rename '[FK_TrackMediaTypeId]', 'FK_dbo.Track_dbo.MediaType_MediaTypeId'
exec sp_rename N'[dbo].[Track].[IFK_TrackAlbumId]', N'IX_AlbumId', N'INDEX'
exec sp_rename N'[dbo].[Track].[IFK_TrackGenreId]', N'IX_GenreId', N'INDEX'
exec sp_rename N'[dbo].[Track].[IFK_TrackMediaTypeId]', N'IX_MediaTypeId', N'INDEX'

