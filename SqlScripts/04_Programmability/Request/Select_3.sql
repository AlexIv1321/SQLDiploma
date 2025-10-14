DECLARE @StartDate DATE = '2025-07-01';
DECLARE @EndDate DATE = '2025-09-30';

SELECT 
    e.FullName AS [Найменування працівника],
    p.Title AS [Посада],
    d.Name AS [Департамент],
    sc.CalcDate AS [Дата розрахунку],
    sc.BaseSalary AS [Оклад],
    sc.GrossSalary AS [Нарахована сума],
    sc.TaxAmount AS [Сума податків],
    ROUND(sc.GrossSalary - sc.TaxAmount, 2) AS [Сума після утримання]

FROM SalaryCalc sc
JOIN Employee e ON sc.EmployeeID = e.EmployeeID
JOIN EmployeePostHist eph ON e.EmployeeID = eph.EmployeeID
JOIN Post p ON eph.PostID = p.PostID
JOIN Department d ON p.DepartmentID = d.DepartmentID

WHERE sc.CalcDate BETWEEN @StartDate AND @EndDate
  AND eph.AssignedFrom <= sc.CalcDate
  AND (eph.AssignedTo IS NULL OR eph.AssignedTo >= sc.CalcDate)

ORDER BY e.FullName, sc.CalcDate;

