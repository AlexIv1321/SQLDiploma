DECLARE @CalcMonth DATE = '2025-09-01';

SELECT 
    d.Name AS [Назва підрозділу],
    SUM(sc.GrossSalary) AS [Сума нарахованої заробітної плати],

    -- Податки як окремі стовпчики
    SUM(CASE WHEN tc.TaxID = 1 THEN tc.TaxValue ELSE 0 END) AS [ПДФО],
    SUM(CASE WHEN tc.TaxID = 2 THEN tc.TaxValue ELSE 0 END) AS [Військовий збір],
    SUM(CASE WHEN tc.TaxID = 3 THEN tc.TaxValue ELSE 0 END) AS [ЄСВ]

FROM SalaryCalc sc
JOIN Employee e ON sc.EmployeeID = e.EmployeeID
JOIN EmployeePostHist eph ON e.EmployeeID = eph.EmployeeID
JOIN Post p ON eph.PostID = p.PostID
JOIN Department d ON p.DepartmentID = d.DepartmentID
LEFT JOIN TaxCalc tc ON sc.SalaryCalcID = tc.SalaryCalcID AND sc.CalcDate = tc.CalcDate

WHERE sc.CalcDate = @CalcMonth
  AND eph.AssignedFrom <= EOMONTH(@CalcMonth)
  AND (eph.AssignedTo IS NULL OR eph.AssignedTo >= @CalcMonth)

GROUP BY d.Name
ORDER BY d.Name;
