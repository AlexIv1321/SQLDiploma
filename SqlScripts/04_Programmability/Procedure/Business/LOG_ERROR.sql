CREATE PROCEDURE LogError
    @ProcedureName NVARCHAR(100),
    @EmployeeID INT
AS
BEGIN
    INSERT INTO ErrorLog (
        ProcedureName,
        ErrorMessage,
        ErrorNumber,
        ErrorSeverity,
        ErrorState,
        HostName,
        AppName,
        ClientIP,
        EmployeeID
    )
    VALUES (
        @ProcedureName,
        CONVERT(NVARCHAR(MAX), ERROR_MESSAGE()),
        CONVERT(INT, ERROR_NUMBER()),
        CONVERT(INT, ERROR_SEVERITY()),
        CONVERT(INT, ERROR_STATE()),
        CONVERT(NVARCHAR(100), HOST_NAME()),
        CONVERT(NVARCHAR(100), APP_NAME()),
        CONVERT(NVARCHAR(50), CONNECTIONPROPERTY('client_net_address')),
        @EmployeeID
    );
END
