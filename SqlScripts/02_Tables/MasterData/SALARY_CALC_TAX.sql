CREATE TABLE SalaryCalcTax (
    SalaryCalcID INT NOT NULL,
    CalcDate DATE NOT NULL,
    TaxID INT NOT NULL,
    AppliedRate INT NOT NULL,
    TaxValue INT NOT NULL,
    CONSTRAINT PK_SalaryCalcTax PRIMARY KEY (SalaryCalcID, CalcDate),
    CONSTRAINT FK_SCT_Calc FOREIGN KEY (SalaryCalcID) REFERENCES SalaryCalc(SalaryCalcID) ON DELETE CASCADE,
    CONSTRAINT FK_SCT_Tax FOREIGN KEY (TaxID) REFERENCES Tax(TaxID)
);

CREATE NONCLUSTERED INDEX IX_SalaryCalcTax_Salary_Tax ON SalaryCalcTax(SalaryCalcID, TaxID);
