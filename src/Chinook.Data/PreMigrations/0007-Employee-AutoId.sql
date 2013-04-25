ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [FK_dbo.Customer_dbo.Employee_SupportRepId];
GO

BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Employee] (
    [EmployeeId] INT           IDENTITY (1, 1) NOT NULL,
    [LastName]   NVARCHAR (20) NOT NULL,
    [FirstName]  NVARCHAR (20) NOT NULL,
    [Title]      NVARCHAR (30) NULL,
    [ReportsTo]  INT           NULL,
    [BirthDate]  DATETIME      NULL,
    [HireDate]   DATETIME      NULL,
    [Address]    NVARCHAR (70) NULL,
    [City]       NVARCHAR (40) NULL,
    [State]      NVARCHAR (40) NULL,
    [Country]    NVARCHAR (40) NULL,
    [PostalCode] NVARCHAR (10) NULL,
    [Phone]      NVARCHAR (24) NULL,
    [Fax]        NVARCHAR (24) NULL,
    [Email]      NVARCHAR (60) NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_dbo.Employee] PRIMARY KEY CLUSTERED ([EmployeeId] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Employee])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Employee] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Employee] ([EmployeeId], [LastName], [FirstName], [Title], [ReportsTo], [BirthDate], [HireDate], [Address], [City], [State], [Country], [PostalCode], [Phone], [Fax], [Email])
        SELECT   [EmployeeId],
                 [LastName],
                 [FirstName],
                 [Title],
                 [ReportsTo],
                 [BirthDate],
                 [HireDate],
                 [Address],
                 [City],
                 [State],
                 [Country],
                 [PostalCode],
                 [Phone],
                 [Fax],
                 [Email]
        FROM     [dbo].[Employee]
        ORDER BY [EmployeeId] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Employee] OFF;
    END

DROP TABLE [dbo].[Employee];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Employee]', N'Employee';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_dbo.Employee]', N'PK_dbo.Employee', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO

CREATE NONCLUSTERED INDEX [IX_ReportsTo] ON [dbo].[Employee]([ReportsTo] ASC);
GO

ALTER TABLE [dbo].[Customer] WITH NOCHECK
    ADD CONSTRAINT [FK_dbo.Customer_dbo.Employee_SupportRepId] FOREIGN KEY ([SupportRepId]) REFERENCES [dbo].[Employee] ([EmployeeId]);
GO

ALTER TABLE [dbo].[Employee] WITH NOCHECK
    ADD CONSTRAINT [FK_dbo.Employee_dbo.Employee_ReportsTo] FOREIGN KEY ([ReportsTo]) REFERENCES [dbo].[Employee] ([EmployeeId]);
GO

ALTER TABLE [dbo].[Employee] WITH CHECK CHECK CONSTRAINT [FK_dbo.Employee_dbo.Employee_ReportsTo];
GO