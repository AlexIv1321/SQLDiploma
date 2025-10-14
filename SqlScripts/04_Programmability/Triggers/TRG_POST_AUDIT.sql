CREATE TRIGGER trg_Post_Audit
ON Post
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EntityName NVARCHAR(100) = 'Post';
    DECLARE @EntityID INT;
    DECLARE @Action NVARCHAR(20);
    DECLARE @Title NVARCHAR(100);
    DECLARE @DeptIDOld NVARCHAR(10);
    DECLARE @DeptIDNew NVARCHAR(10);
    DECLARE @msg NVARCHAR(1000);

    -- INSERT
    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT TOP 1
            @EntityID = PostID,
            @Title = title,
            @DeptIDNew = CONVERT(NVARCHAR(10), DepartmentID),
            @Action = 'INSERT'
        FROM inserted;
    END

    -- DELETE
    ELSE IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        SELECT TOP 1
            @EntityID = PostID,
            @Title = title,
            @DeptIDOld = CONVERT(NVARCHAR(10), DepartmentID),
            @Action = 'DELETE'
        FROM deleted;
    END

    -- UPDATE
    ELSE IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT TOP 1
            @EntityID = i.PostID,
            @Title = i.title,
            @DeptIDOld = CONVERT(NVARCHAR(10), d.DepartmentID),
            @DeptIDNew = CONVERT(NVARCHAR(10), i.DepartmentID),
            @Action = 'UPDATE'
        FROM inserted i
        JOIN deleted d ON i.PostID = d.PostID;
    END

    -- Формирование сообщения
    IF @Action = 'INSERT'
        SET @msg = CONCAT(N'Добавлена должность "', @Title, '" в департаменте ', @DeptIDNew);
    ELSE IF @Action = 'DELETE'
        SET @msg = CONCAT(N'Удалена должность "', @Title, '" из департамента ', @DeptIDOld);
    ELSE IF @Action = 'UPDATE'
        SET @msg = CONCAT(N'Обновлена должность "', @Title,
                          '". Старый департамент: ', @DeptIDOld,
                          ', новый департамент: ', @DeptIDNew);

    -- Единый вызов логирования
    IF @Action IS NOT NULL
        EXEC LogAudit @EntityName, @EntityID, @Action, @msg;
END;
