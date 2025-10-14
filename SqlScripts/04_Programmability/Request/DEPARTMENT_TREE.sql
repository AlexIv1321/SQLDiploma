DECLARE @TargetDate DATE = '2025-09-30';

WITH DepartmentTree AS (
    SELECT DepartmentID, Name, ParentDepartmentID
    FROM Department
    WHERE ParentDepartmentID IS NULL -- корневые

    UNION ALL

    SELECT d.DepartmentID, d.Name, d.ParentDepartmentID
    FROM Department d
    JOIN DepartmentTree dt ON d.ParentDepartmentID = dt.DepartmentID
)

SELECT
    dt.DepartmentID,
    dt.Name AS DepartmentName,
    COUNT(DISTINCT eph.EmployeeID) AS EmployeeCount
FROM DepartmentTree dt
JOIN Post p ON p.DepartmentID = dt.DepartmentID
JOIN EmployeePostHist eph ON eph.PostID = p.PostID
WHERE
    @TargetDate BETWEEN eph.AssignedFrom AND ISNULL(eph.AssignedTo, '9999-12-31')
GROUP BY dt.DepartmentID, dt.Name
ORDER BY dt.Name;
