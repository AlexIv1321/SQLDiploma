CREATE TABLE SalaryCalc (
    ID INT IDENTITY(1,1),               
    SalaryCalcID INT NOT NULL UNIQUE,               
    EmployeeID INT NOT NULL,                        
    CalcDate DATE NOT NULL,                         
    BaseSalary DECIMAL(10,2) NOT NULL,              
    GrossSalary DECIMAL(10,2) NOT NULL,             
    TaxAmount DECIMAL(10,2) NOT NULL,               
    NetSalary AS (GrossSalary - TaxAmount) PERSISTED, 
    CONSTRAINT PK_ID PRIMARY KEY (ID),
    CONSTRAINT FK_SalaryCalc_Employee FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);