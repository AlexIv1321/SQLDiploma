CREATE PROCEDURE TransferEmployeeToNewPost
    @EmployeeID INT,
    @NewPostID INT,
    @TransferDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        -- 1. Проверка сотрудника
        IF @EmployeeID IS NULL OR NOT EXISTS (
            SELECT 1 FROM Employee WHERE EmployeeID = @EmployeeID
        )
            THROW 90001, N'Працівник не знайдений.', 1;

        -- 2. Проверка новой должности
        IF @NewPostID IS NULL OR NOT EXISTS (
            SELECT 1 FROM Post WHERE PostID = @NewPostID
        )
            THROW 90002, N'Нова посада не знайдена.', 1;

        -- 3. Проверка: должность не закрыта
        IF EXISTS (
            SELECT 1 FROM Post
            WHERE PostID = @NewPostID
              AND CloseDate IS NOT NULL
              AND CloseDate <= @TransferDate
        )
            THROW 90003, N'Неможливо перевести на посаду, яка вже закрита.', 1;

        -- 4. Проверка: уволен ли сотрудник
        IF EXISTS (
            SELECT 1 FROM Employee
            WHERE EmployeeID = @EmployeeID
                AND CloseDate IS NOT NULL
                AND CloseDate <= @TransferDate
        )
            THROW 90004, N'Неможливо перевести працівника, який вже звільнений.', 1;


        -- 5. Закрытие текущего назначения
        UPDATE EmployeePostHist
        SET AssignedTo = DATEADD(DAY, -1, @TransferDate)
        WHERE EmployeeID = @EmployeeID AND AssignedTo IS NULL;

        -- 6. Вставка нового назначения
        INSERT INTO EmployeePostHist (
            EmployeeID,
            PostID,
            AssignedFrom,
            AssignedTo,
            ChangedAt,
            ChangedBy
        )
        VALUES (
            @EmployeeID,
            @NewPostID,
            @TransferDate,
            NULL,
            GETDATE(),
            USER_NAME()
        );

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        EXEC LogError 'TransferEmployeeToNewPost', @EmployeeID;
        THROW;
    END CATCH
END;
