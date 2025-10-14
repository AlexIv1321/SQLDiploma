CREATE NONCLUSTERED INDEX IX_Tax_TaxName ON Tax(TaxName);
CREATE NONCLUSTERED INDEX IX_Tax_Effectivety ON Tax(EffectiveFrom, EffectiveTo);