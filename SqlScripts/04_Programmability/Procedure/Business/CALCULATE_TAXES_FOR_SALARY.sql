CREATE PROCEDURE CalculateTaxesForSalary
    @SalaryCalcID INT,
    @CalcDate DATE,
    @GrossSalary DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TaxID INT, @Rate DECIMAL(5,4);

    DECLARE TaxCursor CURSOR FOR
    SELECT TaxID, Rate
    FROM Tax
    WHERE @CalcDate BETWEEN EffectiveFrom AND ISNULL(EffectiveTo, '9999-12-31');

    OPEN TaxCursor;
    FETCH NEXT FROM TaxCursor INTO @TaxID, @Rate;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO TaxCalc (SalaryCalcID, CalcDate, TaxID, AppliedRate, TaxValue)
        VALUES (
            @SalaryCalcID,
            @CalcDate,
            @TaxID,
            @Rate,
            ROUND(@GrossSalary * @Rate / 100.0, 2)
        );

        FETCH NEXT FROM TaxCursor INTO @TaxID, @Rate;
    END

    CLOSE TaxCursor;
    DEALLOCATE TaxCursor;

    -- Обновляем сумму налогов
    UPDATE SalaryCalc
    SET TaxAmount = (
        SELECT SUM(TaxValue)
        FROM TaxCalc
        WHERE SalaryCalcID = @SalaryCalcID
    )
    WHERE SalaryCalcID = @SalaryCalcID;
END;
