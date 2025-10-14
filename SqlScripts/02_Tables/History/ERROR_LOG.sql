CREATE TABLE ErrorLog (
    ErrorID INT PRIMARY KEY IDENTITY(1,1),
    ProcedureName NVARCHAR(100),
    ErrorMessage NVARCHAR(MAX),
    ErrorNumber INT,
    ErrorSeverity INT,
    ErrorState INT,
    CreatedAt DATETIME DEFAULT GETDATE(),

    -- Системные поля
    HostName NVARCHAR(100),
    AppName NVARCHAR(100),
    ClientIP NVARCHAR(50),

    -- Привязка к пользователю
    EmployeeId  INT NOT NULL,
    FOREIGN KEY (EmployeeId ) REFERENCES Employee(EmployeeId )
);
