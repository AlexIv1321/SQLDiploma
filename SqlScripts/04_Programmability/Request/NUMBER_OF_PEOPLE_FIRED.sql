DECLARE @TargetDate DATE = '2025-09-30';

SELECT COUNT(*) AS DismissedCount
FROM Employee
WHERE CloseDate IS NOT NULL AND CloseDate <= @TargetDate;


DECLARE @StartDate DATE = '2025-01-01';
DECLARE @EndDate DATE = '2025-09-30';

SELECT COUNT(*) AS DismissedCount
FROM Employee
WHERE CloseDate BETWEEN @StartDate AND @EndDate;
