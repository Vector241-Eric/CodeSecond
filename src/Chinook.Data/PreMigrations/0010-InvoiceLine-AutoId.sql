BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_InvoiceLine] (
    [InvoiceLineId] INT             IDENTITY (1, 1) NOT NULL,
    [InvoiceId]     INT             NOT NULL,
    [TrackId]       INT             NOT NULL,
    [UnitPrice]     DECIMAL (18, 2) NOT NULL,
    [Quantity]      INT             NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_dbo.InvoiceLine] PRIMARY KEY CLUSTERED ([InvoiceLineId] ASC),
    CONSTRAINT [tmp_ms_xx_constraint_FK_dbo.InvoiceLine_dbo.Track_TrackId] FOREIGN KEY ([TrackId]) REFERENCES [dbo].[Track] ([TrackId]),
    CONSTRAINT [tmp_ms_xx_constraint_FK_dbo.InvoiceLine_dbo.Invoice_InvoiceId] FOREIGN KEY ([InvoiceId]) REFERENCES [dbo].[Invoice] ([InvoiceId])
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[InvoiceLine])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_InvoiceLine] ON;
        INSERT INTO [dbo].[tmp_ms_xx_InvoiceLine] ([InvoiceLineId], [InvoiceId], [TrackId], [UnitPrice], [Quantity])
        SELECT   [InvoiceLineId],
                 [InvoiceId],
                 [TrackId],
                 [UnitPrice],
                 [Quantity]
        FROM     [dbo].[InvoiceLine]
        ORDER BY [InvoiceLineId] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_InvoiceLine] OFF;
    END

DROP TABLE [dbo].[InvoiceLine];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_InvoiceLine]', N'InvoiceLine';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_dbo.InvoiceLine]', N'PK_dbo.InvoiceLine', N'OBJECT';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_FK_dbo.InvoiceLine_dbo.Track_TrackId]', N'FK_dbo.InvoiceLine_dbo.Track_TrackId', N'OBJECT';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_FK_dbo.InvoiceLine_dbo.Invoice_InvoiceId]', N'FK_dbo.InvoiceLine_dbo.Invoice_InvoiceId', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO

CREATE NONCLUSTERED INDEX [IX_InvoiceId] ON [dbo].[InvoiceLine]([InvoiceId] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_TrackId] ON [dbo].[InvoiceLine]([TrackId] ASC);
GO

