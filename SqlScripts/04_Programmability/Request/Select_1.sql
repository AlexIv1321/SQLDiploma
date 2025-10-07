DECLARE @CalcMonth DATE = '2025-09-01';

SELECT 
    e.FullName AS [Найменування працівника],
    p.Title AS [Посада],
    d.Name AS [Департамент],
    sc.BaseSalary AS [Оклад],
    
    -- Податки як окремі стовпчики
    SUM(CASE WHEN tc.TaxID = 1 THEN tc.TaxValue ELSE 0 END) AS [ПДФО],
    SUM(CASE WHEN tc.TaxID = 2 THEN tc.TaxValue ELSE 0 END) AS [Військовий збір],
    SUM(CASE WHEN tc.TaxID = 3 THEN tc.TaxValue ELSE 0 END) AS [ЄСВ],
    
    -- Сума після утримання
    ROUND(sc.GrossSalary - SUM(tc.TaxValue), 2) AS [Сума після утримання]
    
FROM SalaryCalc sc
JOIN Employee e ON sc.EmployeeID = e.EmployeeID
JOIN EmployeePostHist eph ON e.EmployeeID = eph.EmployeeID
JOIN Post p ON eph.PostID = p.PostID
JOIN Department d ON p.DepartmentID = d.DepartmentID
LEFT JOIN TaxCalc tc ON sc.SalaryCalcID = tc.SalaryCalcID AND sc.CalcDate = tc.CalcDate

WHERE sc.CalcDate = @CalcMonth
  AND eph.AssignedFrom <= EOMONTH(@CalcMonth)
  AND (eph.AssignedTo IS NULL OR eph.AssignedTo >= @CalcMonth)

GROUP BY 
    e.FullName, p.Title, d.Name, sc.BaseSalary, sc.GrossSalary
ORDER BY 
    d.Name, p.Title, e.FullName;

