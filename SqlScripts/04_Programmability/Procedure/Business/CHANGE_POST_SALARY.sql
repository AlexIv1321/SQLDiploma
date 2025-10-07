CREATE PROCEDURE ChangePostSalary
    @PostID INT,
    @NewSalary DECIMAL(18,2),
    @EffectiveFrom DATE,
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (
            SELECT 1 FROM Post WHERE PostID = @PostID AND IsActive = 1
        )
            THROW 80001, N'Должность не найдена или неактивна.', 1;

        UPDATE SalaryHistory
        SET EffectiveTo = DATEADD(DAY, -1, @EffectiveFrom)
        WHERE PostID = @PostID AND EffectiveTo IS NULL;

        INSERT INTO SalaryHistory (
            PostID,
            Salary,
            EffectiveFrom,
            EffectiveTo,
            ChangedAt,
            ChangedBy
        )
        VALUES (
            @PostID,
            @NewSalary,
            @EffectiveFrom,
            NULL,
            GETDATE(),
            USER_NAME()
        );

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
         EXEC LogError 'ChangePostSalary', @EmployeeID;
        THROW;
    END CATCH
END;