CREATE PROCEDURE LogAudit
    @EntityName NVARCHAR(100),
    @EntityID INT,
    @Action NVARCHAR(20),
    @Message NVARCHAR(1000)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO AuditLog (
        EntityName,
        EntityID,
        Action,
        Message,
        ChangedBy,
        HostName,
        AppName,
        ClientIP
    )
    VALUES (
        @EntityName,
        @EntityID,
        @Action,
        @Message,
        CONVERT(NVARCHAR(100), SYSTEM_USER),
        CONVERT(NVARCHAR(100), HOST_NAME()),
        CONVERT(NVARCHAR(100), APP_NAME()),
        CONVERT(NVARCHAR(50), CONNECTIONPROPERTY('client_net_address'))
    );
END;
