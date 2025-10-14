CREATE TABLE Tax (
    TaxID INT NOT NULL,
    TaxName NVARCHAR(100) NOT NULL,
    Rate INT NOT NULL DEFAULT 1,
    EffectiveFrom DATE NOT NULL,
    EffectiveTo DATE NULL,
    IsMandatory BIT NOT NULL DEFAULT 1,
    CONSTRAINT CHK_Tax_CloseDate CHECK (EffectiveTo IS NULL OR EffectiveFrom <= EffectiveTo),
    CONSTRAINT PK_Tax PRIMARY KEY (TaxID)
);

CREATE NONCLUSTERED INDEX IX_Tax_TaxName ON Tax(TaxName);
CREATE NONCLUSTERED INDEX IX_Tax_Effectivety ON Tax(EffectiveFrom, EffectiveTo);