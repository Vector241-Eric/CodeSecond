ALTER TABLE [dbo].[Track] DROP CONSTRAINT [FK_dbo.Track_dbo.Genre_GenreId];
GO

BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Genre] (
    [GenreId] INT            IDENTITY (1, 1) NOT NULL,
    [Name]    NVARCHAR (120) NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_dbo.Genre] PRIMARY KEY CLUSTERED ([GenreId] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Genre])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Genre] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Genre] ([GenreId], [Name])
        SELECT   [GenreId],
                 [Name]
        FROM     [dbo].[Genre]
        ORDER BY [GenreId] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Genre] OFF;
    END

DROP TABLE [dbo].[Genre];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Genre]', N'Genre';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_dbo.Genre]', N'PK_dbo.Genre', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO

ALTER TABLE [dbo].[Track] WITH NOCHECK
    ADD CONSTRAINT [FK_dbo.Track_dbo.Genre_GenreId] FOREIGN KEY ([GenreId]) REFERENCES [dbo].[Genre] ([GenreId]);
GO

ALTER TABLE [dbo].[Track] WITH CHECK CHECK CONSTRAINT [FK_dbo.Track_dbo.Genre_GenreId];
