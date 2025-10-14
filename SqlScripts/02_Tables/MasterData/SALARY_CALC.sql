CREATE TABLE SalaryCalc (           
    SalaryCalcID INT NOT NULL IDENTITY(1,1),               
    EmployeeID INT NOT NULL,                        
    CalcDate DATE NOT NULL,                         
    BaseSalary INT NOT NULL,              
    GrossSalary INT NOT NULL,             
    TaxAmount INT NOT NULL,               
    NetSalary AS (GrossSalary - TaxAmount) PERSISTED, 
    CONSTRAINT PK_ID PRIMARY KEY (SalaryCalcID),
    CONSTRAINT FK_SalaryCalc_Employee FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
