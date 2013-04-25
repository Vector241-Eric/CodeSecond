ALTER TABLE [dbo].[Invoice] DROP CONSTRAINT [FK_dbo.Invoice_dbo.Customer_CustomerId];
GO

BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Customer] (
    [CustomerId]   INT           IDENTITY (1, 1) NOT NULL,
    [FirstName]    NVARCHAR (40) NOT NULL,
    [LastName]     NVARCHAR (20) NOT NULL,
    [Company]      NVARCHAR (80) NULL,
    [Address]      NVARCHAR (70) NULL,
    [City]         NVARCHAR (40) NULL,
    [State]        NVARCHAR (40) NULL,
    [Country]      NVARCHAR (40) NULL,
    [PostalCode]   NVARCHAR (10) NULL,
    [Phone]        NVARCHAR (24) NULL,
    [Fax]          NVARCHAR (24) NULL,
    [Email]        NVARCHAR (60) NOT NULL,
    [SupportRepId] INT           NULL,
    CONSTRAINT [tmp_ms_xx_constraint_FK_dbo.Customer_dbo.Employee_SupportRepId] FOREIGN KEY ([SupportRepId]) REFERENCES [dbo].[Employee] ([EmployeeId]),
    CONSTRAINT [tmp_ms_xx_constraint_PK_dbo.Customer] PRIMARY KEY CLUSTERED ([CustomerId] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Customer])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Customer] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Customer] ([CustomerId], [FirstName], [LastName], [Company], [Address], [City], [State], [Country], [PostalCode], [Phone], [Fax], [Email], [SupportRepId])
        SELECT   [CustomerId],
                 [FirstName],
                 [LastName],
                 [Company],
                 [Address],
                 [City],
                 [State],
                 [Country],
                 [PostalCode],
                 [Phone],
                 [Fax],
                 [Email],
                 [SupportRepId]
        FROM     [dbo].[Customer]
        ORDER BY [CustomerId] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Customer] OFF;
    END

DROP TABLE [dbo].[Customer];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Customer]', N'Customer';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_dbo.Customer]', N'PK_dbo.Customer', N'OBJECT';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_FK_dbo.Customer_dbo.Employee_SupportRepId]', N'FK_dbo.Customer_dbo.Employee_SupportRepId', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO

CREATE NONCLUSTERED INDEX [IX_SupportRepId] ON [dbo].[Customer]([SupportRepId] ASC);
GO

ALTER TABLE [dbo].[Invoice] WITH NOCHECK
    ADD CONSTRAINT [FK_dbo.Invoice_dbo.Customer_CustomerId] FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId]);
GO
ALTER TABLE [dbo].[Invoice] WITH CHECK CHECK CONSTRAINT [FK_dbo.Invoice_dbo.Customer_CustomerId];
