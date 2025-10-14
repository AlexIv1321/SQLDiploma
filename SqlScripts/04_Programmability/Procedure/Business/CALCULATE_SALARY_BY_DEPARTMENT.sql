CREATE PROCEDURE CalculateSalaryByDepartment
    @CalcMonth DATE,
    @DepartmentID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Собираем всех сотрудников из иерархии департаментов
    WITH DepartmentTree AS (
        SELECT DepartmentID FROM Department WHERE DepartmentID = @DepartmentID
        UNION ALL
        SELECT d.DepartmentID
        FROM Department d
        JOIN DepartmentTree dt ON d.ParentDepartmentID = dt.DepartmentID
    )
    SELECT DISTINCT eph.EmployeeID
    INTO #EmployeesToCalculate
    FROM EmployeePostHist eph
    JOIN Post p ON eph.PostID = p.PostID
    JOIN DepartmentTree dt ON p.DepartmentID = dt.DepartmentID
    WHERE eph.AssignedFrom <= EOMONTH(@CalcMonth)
      AND (eph.AssignedTo IS NULL OR eph.AssignedTo >= @CalcMonth);

    DECLARE @EmpID INT;
    DECLARE EmpCursor CURSOR FOR SELECT EmployeeID FROM #EmployeesToCalculate;

    OPEN EmpCursor;
    FETCH NEXT FROM EmpCursor INTO @EmpID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC CalculateEmployeeSalary @CalcMonth, @EmpID;
        FETCH NEXT FROM EmpCursor INTO @EmpID;
    END

    CLOSE EmpCursor;
    DEALLOCATE EmpCursor;
    DROP TABLE #EmployeesToCalculate;
END;