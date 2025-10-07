CREATE PROCEDURE InsertDepartment
    @Name NVARCHAR(100),
    @Code NVARCHAR(10),
    @ManagerID INT = NULL,
    @ParentDepartmentID INT = NULL,
    @OfficeID INT = NULL,
    @BudgetID INT = NULL,
    @IsActive BIT = 1,
    @EmployeeID INT 
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NewDepartmentID INT;

    BEGIN TRY
        BEGIN TRAN;

        IF EXISTS (SELECT 1 FROM Department WHERE Code = @Code)
            THROW 50001, N'Департамент с таким кодом уже существует.', 1;

        IF EXISTS (SELECT 1 FROM Department WHERE Name = @Name)
            THROW 50002, N'Департамент с таким именем уже существует.', 1;

        IF @ManagerID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Employee WHERE EmployeeID = @ManagerID)
            THROW 50003, N'Менеджер не найден.', 1;

        IF @ParentDepartmentID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Department WHERE DepartmentID = @ParentDepartmentID)
            THROW 50004, N'Родительский департамент не найден.', 1;

        IF @OfficeID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Office WHERE OfficeID = @OfficeID)
            THROW 50005, N'Офис не найден.', 1;

        IF @BudgetID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Budget WHERE BudgetID = @BudgetID)
            THROW 50006, N'Бюджет не найден.', 1;

        INSERT INTO Department (
            Name, Code, ManagerID, ParentDepartmentID,
            OfficeID, BudgetID, CreatedAt, IsActive
        )
        VALUES (
            @Name, @Code, @ManagerID, @ParentDepartmentID,
            @OfficeID, @BudgetID, GETDATE(), @IsActive
        );

        SET @NewDepartmentID = SCOPE_IDENTITY();

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
     EXEC LogError 'InsertDepartment', @EmployeeID;
        THROW;
    END CATCH
END;