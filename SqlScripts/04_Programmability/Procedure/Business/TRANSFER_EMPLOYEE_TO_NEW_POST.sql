CREATE PROCEDURE TransferEmployeeToNewPost
    @EmployeeID INT,
    @NewPostID INT,
    @TransferDate DATE
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
        SET AssignedTo = DATEADD(DAY, -1, @TransferDate)
        WHERE EmployeeID = @EmployeeID AND AssignedTo IS NULL;

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
