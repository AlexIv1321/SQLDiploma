CREATE PROCEDURE CalculateEmployeeSalary
    @CalcMonth DATE,           -- например: '2025-09-01'
    @EmployeeID INT            -- конкретный сотрудник
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartDate DATE = DATEFROMPARTS(YEAR(@CalcMonth), MONTH(@CalcMonth), 1);
    DECLARE @EndDate DATE = EOMONTH(@StartDate);

    DECLARE @CloseDate DATE;
    DECLARE @ActiveDays INT;
    DECLARE @PostID INT;
    DECLARE @Salary DECIMAL(10,2);
    DECLARE @GrossSalary DECIMAL(10,2);
    DECLARE @SalaryCalcID INT;
    DECLARE @InsertedSalaryCalc TABLE (SalaryCalcID INT);

    -- 1. Назначения сотрудника в период
    SELECT @CloseDate = CloseDate FROM Employee WHERE EmployeeID = @EmployeeID;

    SET @ActiveDays = CASE
        WHEN @CloseDate IS NOT NULL AND @CloseDate < @EndDate THEN DATEDIFF(DAY, @StartDate, @CloseDate) + 1
        ELSE DATEDIFF(DAY, @StartDate, @EndDate) + 1
    END;

    -- 2. Получаем актуальное назначение
    SELECT TOP 1 @PostID = PostID
    FROM EmployeePostHist
    WHERE EmployeeID = @EmployeeID
      AND AssignedFrom <= @EndDate
      AND (AssignedTo IS NULL OR AssignedTo >= @StartDate)
    ORDER BY AssignedFrom DESC;

    -- 3. Получаем актуальную зарплату
    SELECT TOP 1 @Salary = Salary
    FROM SalaryHistory
    WHERE PostID = @PostID
      AND @StartDate BETWEEN EffectiveFrom AND ISNULL(EffectiveTo, '9999-12-31')
    ORDER BY EffectiveFrom DESC;

    SET @GrossSalary = ROUND(@Salary * @ActiveDays / DATEDIFF(DAY, @StartDate, @EndDate) + 1, 2);

    -- 4. Вставляем в SalaryCalc
    INSERT INTO SalaryCalc (EmployeeID, CalcDate, BaseSalary, GrossSalary, TaxAmount)
    OUTPUT INSERTED.SalaryCalcID INTO @InsertedSalaryCalc
    VALUES (@EmployeeID, @StartDate, @Salary, @GrossSalary, 0);

    SELECT @SalaryCalcID = SalaryCalcID FROM @InsertedSalaryCalc;

    -- 5-6. Расчёт налогов
    EXEC CalculateTaxesForSalary @SalaryCalcID, @StartDate, @GrossSalary;
END;
