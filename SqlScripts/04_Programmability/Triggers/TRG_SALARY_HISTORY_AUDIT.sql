CREATE TRIGGER trg_SalaryHistory_Audit
ON SalaryHistory
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EntityName NVARCHAR(100) = 'SalaryHistory';
    DECLARE @EntityID INT;
    DECLARE @Action NVARCHAR(20);
    DECLARE @PostID NVARCHAR(10);
    DECLARE @SalaryOld NVARCHAR(20);
    DECLARE @SalaryNew NVARCHAR(20);
    DECLARE @EffectiveFrom NVARCHAR(20);
    DECLARE @msg NVARCHAR(1000);

    -- INSERT
    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT TOP 1
            @EntityID = SalaryHistoryID,
            @PostID = CONVERT(NVARCHAR(10), PostID),
            @SalaryNew = CONVERT(NVARCHAR(20), Salary),
            @EffectiveFrom = CONVERT(NVARCHAR(20), EffectiveFrom, 120),
            @Action = 'INSERT'
        FROM inserted;
    END

    -- DELETE
    ELSE IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        SELECT TOP 1
            @EntityID = SalaryHistoryID,
            @PostID = CONVERT(NVARCHAR(10), PostID),
            @SalaryOld = CONVERT(NVARCHAR(20), Salary),
            @EffectiveFrom = CONVERT(NVARCHAR(20), EffectiveFrom, 120),
            @Action = 'DELETE'
        FROM deleted;
    END

    -- UPDATE
    ELSE IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT TOP 1
            @EntityID = i.SalaryHistoryID,
            @PostID = CONVERT(NVARCHAR(10), i.PostID),
            @SalaryOld = CONVERT(NVARCHAR(20), d.Salary),
            @SalaryNew = CONVERT(NVARCHAR(20), i.Salary),
            @EffectiveFrom = CONVERT(NVARCHAR(20), i.EffectiveFrom, 120),
            @Action = 'UPDATE'
        FROM inserted i
        JOIN deleted d ON i.SalaryHistoryID = d.SalaryHistoryID;
    END

    -- Формирование сообщения
    IF @Action = 'INSERT'
        SET @msg = CONCAT(N'Добавлена зарплата ', @SalaryNew,
                          ' для должности ', @PostID,
                          ' с ', @EffectiveFrom);
    ELSE IF @Action = 'DELETE'
        SET @msg = CONCAT(N'Удалена зарплата ', @SalaryOld,
                          ' для должности ', @PostID,
                          ' с ', @EffectiveFrom);
    ELSE IF @Action = 'UPDATE'
        SET @msg = CONCAT(N'Обновлена зарплата для должности ', @PostID,
                          '. Старая: ', @SalaryOld,
                          ', новая: ', @SalaryNew,
                          '. С ', @EffectiveFrom);

    -- Единый вызов логирования
    IF @Action IS NOT NULL
        EXEC LogAudit @EntityName, @EntityID, @Action, @msg;
END;
