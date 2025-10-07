CREATE TABLE Department (
    DepartmentID INT NOT NULL,

    Name NVARCHAR(100) NOT NULL,
    Code NVARCHAR(10) NOT NULL,

    ManagerID INT NULL,
    ParentDepartmentID INT NULL,
    OfficeID INT NULL,
    BudgetID INT NULL,

    CreatedAt DATE NOT NULL DEFAULT GETDATE(),
    IsActive BIT NOT NULL DEFAULT 1,

    CONSTRAINT PK_Department PRIMARY KEY (DepartmentID),

    CONSTRAINT UQ_Department_Code UNIQUE (Code),
    CONSTRAINT UQ_Department_Name UNIQUE (Name),

    CONSTRAINT FK_Department_Manager FOREIGN KEY (ManagerID)
        REFERENCES Employee(EmployeeID),
    CONSTRAINT FK_Department_Parent FOREIGN KEY (ParentDepartmentID)
        REFERENCES Department(DepartmentID),
    CONSTRAINT FK_Department_Office FOREIGN KEY (OfficeID)
        REFERENCES Office(OfficeID),
    CONSTRAINT FK_Department_Budget FOREIGN KEY (BudgetID)
        REFERENCES Budget(BudgetID)
);