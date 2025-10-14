CREATE PROCEDURE CloseDepartment
    @DepartmentID INT,
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (
            SELECT 1 FROM Department WHERE DepartmentID = @DepartmentID
        )
        BEGIN
            THROW 60001, N'Департамент не найден.', 1;
        END

        IF EXISTS (
            SELECT 1 FROM Department WHERE DepartmentID = @DepartmentID AND IsActive = 0
        )
        BEGIN
            THROW 60002, N'Департамент уже закрыт.', 1;
        END

        IF EXISTS (
            SELECT 1 FROM Department WHERE ParentDepartmentID = @DepartmentID AND IsActive = 1
        )
        BEGIN
            THROW 60003, N'Нельзя закрыть департамент: есть активные дочерние отделы.', 1;
        END

        IF EXISTS (
            SELECT 1
            FROM Employee e
            JOIN Post p ON e.PostID = p.PostID
            WHERE p.DepartmentID = @DepartmentID AND e.CloseDate IS NULL
        )
        BEGIN
            THROW 60004, N'Нельзя закрыть департамент: есть активные сотрудники.', 1;
        END

        UPDATE Department
        SET IsActive = 0
        WHERE DepartmentID = @DepartmentID;

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
         EXEC LogError 'CloseDepartment', @EmployeeID;
        THROW;
    END CATCH
END;