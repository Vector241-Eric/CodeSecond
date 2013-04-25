ALTER TABLE [dbo].[InvoiceLine] DROP CONSTRAINT [FK_dbo.InvoiceLine_dbo.Invoice_InvoiceId];
GO

BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Invoice] (
    [InvoiceId]         INT             IDENTITY (1, 1) NOT NULL,
    [CustomerId]        INT             NOT NULL,
    [InvoiceDate]       DATETIME        NOT NULL,
    [BillingAddress]    NVARCHAR (70)   NULL,
    [BillingCity]       NVARCHAR (40)   NULL,
    [BillingState]      NVARCHAR (40)   NULL,
    [BillingCountry]    NVARCHAR (40)   NULL,
    [BillingPostalCode] NVARCHAR (10)   NULL,
    [Total]             DECIMAL (18, 2) NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_dbo.Invoice] PRIMARY KEY CLUSTERED ([InvoiceId] ASC),
    CONSTRAINT [tmp_ms_xx_constraint_FK_dbo.Invoice_dbo.Customer_CustomerId] FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId])
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Invoice])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Invoice] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Invoice] ([InvoiceId], [CustomerId], [InvoiceDate], [BillingAddress], [BillingCity], [BillingState], [BillingCountry], [BillingPostalCode], [Total])
        SELECT   [InvoiceId],
                 [CustomerId],
                 [InvoiceDate],
                 [BillingAddress],
                 [BillingCity],
                 [BillingState],
                 [BillingCountry],
                 [BillingPostalCode],
                 [Total]
        FROM     [dbo].[Invoice]
        ORDER BY [InvoiceId] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Invoice] OFF;
    END

DROP TABLE [dbo].[Invoice];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Invoice]', N'Invoice';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_dbo.Invoice]', N'PK_dbo.Invoice', N'OBJECT';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_FK_dbo.Invoice_dbo.Customer_CustomerId]', N'FK_dbo.Invoice_dbo.Customer_CustomerId', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO

CREATE NONCLUSTERED INDEX [IX_CustomerId] ON [dbo].[Invoice]([CustomerId] ASC);
GO

ALTER TABLE [dbo].[InvoiceLine] WITH NOCHECK
    ADD CONSTRAINT [FK_dbo.InvoiceLine_dbo.Invoice_InvoiceId] FOREIGN KEY ([InvoiceId]) REFERENCES [dbo].[Invoice] ([InvoiceId]);
GO

ALTER TABLE [dbo].[InvoiceLine] WITH CHECK CHECK CONSTRAINT [FK_dbo.InvoiceLine_dbo.Invoice_InvoiceId];
