CREATE TABLE Employee (
    EmployeeID INT NOT NULL IDENTITY(1,1),
    PostID INT NOT NULL,
    FullName NVARCHAR(200) NOT NULL,
    BirthDate DATE NOT NULL,
    HireDate DATE NOT NULL,
    CloseDate DATE NULL DEFAULT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_Employee PRIMARY KEY (EmployeeID),
    CONSTRAINT FK_Employee_Post FOREIGN KEY (PostID)
        REFERENCES Post(PostID),
    CONSTRAINT CHK_Employee_BirthDate CHECK (BirthDate < HireDate),
    CONSTRAINT CHK_Employee_CloseDate CHECK (CloseDate IS NULL OR CloseDate >= HireDate),
    CONSTRAINT UQ_Employee_FullName_BirthDate_HireDate UNIQUE (FullName, BirthDate,HireDate)
);
