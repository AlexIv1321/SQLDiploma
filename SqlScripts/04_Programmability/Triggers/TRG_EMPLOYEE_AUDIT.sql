CREATE TRIGGER trg_Employee_Audit
ON Employee
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EntityName NVARCHAR(100) = 'Employee';
    DECLARE @EntityID INT;
    DECLARE @Action NVARCHAR(20);
    DECLARE @FullName NVARCHAR(100);
    DECLARE @HireDateOld NVARCHAR(20);
    DECLARE @HireDateNew NVARCHAR(20);
    DECLARE @msg NVARCHAR(1000);

    -- INSERT
    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT TOP 1
            @EntityID = EmployeeID,
            @FullName = FullName,
            @HireDateNew = CONVERT(NVARCHAR(20), HireDate, 120),
            @Action = 'INSERT'
        FROM inserted;
    END

    -- DELETE
    ELSE IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        SELECT TOP 1
            @EntityID = EmployeeID,
            @FullName = FullName,
            @HireDateOld = CONVERT(NVARCHAR(20), HireDate, 120),
            @Action = 'DELETE'
        FROM deleted;
    END

    -- UPDATE
    ELSE IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT TOP 1
            @EntityID = i.EmployeeID,
            @FullName = i.FullName,
            @HireDateOld = CONVERT(NVARCHAR(20), d.HireDate, 120),
            @HireDateNew = CONVERT(NVARCHAR(20), i.HireDate, 120),
            @Action = 'UPDATE'
        FROM inserted i
        JOIN deleted d ON i.EmployeeID = d.EmployeeID;
    END

    -- Формирование сообщения
    IF @Action = 'INSERT'
        SET @msg = CONCAT(N'Добавлен сотрудник "', @FullName, '" с датой найма ', @HireDateNew);
    ELSE IF @Action = 'DELETE'
        SET @msg = CONCAT(N'Удалён сотрудник "', @FullName, '" с датой найма ', @HireDateOld);
    ELSE IF @Action = 'UPDATE'
        SET @msg = CONCAT(N'Обновлён сотрудник "', @FullName,
                          '". Старая дата найма: ', @HireDateOld,
                          ', новая: ', @HireDateNew);

    -- Единый вызов логирования
    IF @Action IS NOT NULL
        EXEC LogAudit @EntityName, @EntityID, @Action, @msg;
END;
