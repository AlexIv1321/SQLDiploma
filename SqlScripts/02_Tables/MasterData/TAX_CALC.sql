CREATE TABLE TaxCalc (
    TaxCalcID INT NOT NULL,
    SalaryCalcID INT NOT NULL,
    CalcDate DATE NOT NULL,
    TaxID INT NOT NULL,
    AppliedRate INT NOT NULL,
    TaxValue INT NOT NULL,
    CONSTRAINT PK_TaxCalc PRIMARY KEY (TaxCalcID),
    CONSTRAINT FK_TaxCalc_Salary FOREIGN KEY (SalaryCalcID) REFERENCES SalaryCalc(SalaryCalcID),
    CONSTRAINT FK_TaxCalc_Tax FOREIGN KEY (TaxID) REFERENCES Tax(TaxID)
);

CREATE NONCLUSTERED INDEX IX_TaxCalc_SalaryCalcID_CalcDate ON TaxCalc (SalaryCalcID, CalcDate);

