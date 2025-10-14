DECLARE @StartDate DATE = '2025-01-01';
DECLARE @EndDate DATE = '2025-09-30';

WITH DepartmentTree AS (
    SELECT DepartmentID, Name, ParentDepartmentID, CreatedAt, 0 AS Level
    FROM Department
    WHERE ParentDepartmentID IS NULL

    UNION ALL

    SELECT d.DepartmentID, d.Name, d.ParentDepartmentID, d.CreatedAt, dt.Level + 1
    FROM Department d
    JOIN DepartmentTree dt ON d.ParentDepartmentID = dt.DepartmentID
)
SELECT
    Level,
    COUNT(*) AS CreatedCount
FROM DepartmentTree
WHERE CreatedAt BETWEEN @StartDate AND @EndDate
GROUP BY Level
ORDER BY Level;

