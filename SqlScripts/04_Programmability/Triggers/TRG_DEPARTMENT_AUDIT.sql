CREATE TRIGGER trg_Department_Audit
ON Department
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EntityName NVARCHAR(100) = 'Department';
    DECLARE @EntityID INT;
    DECLARE @Action NVARCHAR(20);
    DECLARE @Name NVARCHAR(100);
    DECLARE @Code NVARCHAR(20);
    DECLARE @CodeOld NVARCHAR(20);
    DECLARE @CodeNew NVARCHAR(20);
    DECLARE @msg NVARCHAR(1000);

    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT TOP 1
            @EntityID = DepartmentID,
            @Name = Name,
            @Code = Code,
            @Action = 'INSERT'
        FROM inserted;
    END

    ELSE IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        SELECT TOP 1
            @EntityID = DepartmentID,
            @Name = Name,
            @Code = Code,
            @Action = 'DELETE'
        FROM deleted;
    END

    ELSE IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT TOP 1
            @EntityID = i.DepartmentID,
            @Name = i.Name,
            @CodeOld = d.Code,
            @CodeNew = i.Code,
            @Action = 'UPDATE'
        FROM inserted i
        JOIN deleted d ON i.DepartmentID = d.DepartmentID;
    END

    IF @Action = 'INSERT'
        SET @msg = CONCAT(N'Добавлен департамент "', @Name, '" с кодом "', @Code, '"');
    ELSE IF @Action = 'DELETE'
        SET @msg = CONCAT(N'Удалён департамент "', @Name, '" с кодом "', @Code, '"');
    ELSE IF @Action = 'UPDATE'
        SET @msg = CONCAT(N'Обновлён департамент "', @Name,
                          '". Старый код: "', @CodeOld,
                          '", новый код: "', @CodeNew, '"');

    IF @Action IS NOT NULL
        EXEC LogAudit @EntityName, @EntityID, @Action, @msg;
END;