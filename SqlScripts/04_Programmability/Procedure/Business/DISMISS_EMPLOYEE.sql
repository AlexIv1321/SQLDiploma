CREATE PROCEDURE DismissEmployee
    @EmployeeID INT,
    @DismissalDate DATE,
    @NewPostID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        IF @EmployeeID IS NULL OR NOT EXISTS (
            SELECT 1 FROM Employee WHERE EmployeeID = @EmployeeID
        )
            THROW 90001, N'Працівник не знайдений.', 1;

        IF @NewPostID IS NULL OR NOT EXISTS (
            SELECT 1 FROM Post WHERE PostID = @NewPostID
        )
            THROW 90002, N'Нова посада не знайдена або неактивна.', 1;

        UPDATE EmployeePostHist
        SET AssignedTo = DATEADD(DAY, -1, @DismissalDate)
        WHERE EmployeeID = @EmployeeID AND AssignedTo IS NULL;

        UPDATE Employee
        SET CloseDate = @DismissalDate
        WHERE EmployeeID = @EmployeeID;

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
            @DismissalDate,
            @DismissalDate,
            GETDATE(),
            USER_NAME()
        );

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        EXEC LogError 'DismissEmployee', @EmployeeID;
        THROW;
    END CATCH
END;
