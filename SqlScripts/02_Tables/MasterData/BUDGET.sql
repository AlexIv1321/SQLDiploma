CREATE TABLE Budget (
    BudgetID INT NOT NULL IDENTITY(1,1),
    FiscalYear INT NOT NULL,
    DepartmentCode NVARCHAR(10) NULL,
    Amount DECIMAL(18,2) NOT NULL,
    Currency NVARCHAR(10) NOT NULL DEFAULT 'USD',
    ApprovedBy NVARCHAR(100) NULL,
    ApprovedAt DATE NULL,
    CreatedAt DATE NOT NULL DEFAULT GETDATE(),
    IsActive BIT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Budget PRIMARY KEY (BudgetID),
    CONSTRAINT CHK_Budget_Amount CHECK (Amount >= 0)
);

