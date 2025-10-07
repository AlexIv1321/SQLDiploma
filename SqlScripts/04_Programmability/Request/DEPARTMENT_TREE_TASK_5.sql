DECLARE @TargetDate DATE = '2025-09-30';

WITH DepartmentTree AS (
    SELECT DepartmentID, Name, ParentDepartmentID
    FROM Department
    WHERE ParentDepartmentID IS NULL

    UNION ALL

    SELECT d.DepartmentID, d.Name, d.ParentDepartmentID
    FROM Department d
    JOIN DepartmentTree dt ON d.ParentDepartmentID = dt.DepartmentID
)

SELECT
    dt.DepartmentID,
    dt.Name AS DepartmentName,
    MIN(sh.Salary) AS MinSalary,
    MAX(sh.Salary) AS MaxSalary
FROM DepartmentTree dt
JOIN Post p ON p.DepartmentID = dt.DepartmentID
JOIN SalaryHistory sh ON sh.PostID = p.PostID
WHERE
    @TargetDate BETWEEN sh.EffectiveFrom AND ISNULL(sh.EffectiveTo, '9999-12-31')
GROUP BY dt.DepartmentID, dt.Name
ORDER BY dt.Name;
