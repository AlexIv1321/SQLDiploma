CREATE TABLE AuditLog (
    AuditLogID INT NOT NULL IDENTITY(1,1),
    EntityName NVARCHAR(100) NOT NULL,      
    EntityID INT NULL,                      
    Action NVARCHAR(20) NOT NULL,           
    Message NVARCHAR(1000) NOT NULL,       
    ChangedBy NVARCHAR(100) NULL,           
    ChangedAt DATETIME NOT NULL DEFAULT GETDATE(), 
    HostName NVARCHAR(100) NULL,            
    AppName NVARCHAR(100) NULL,             
    ClientIP NVARCHAR(50) NULL              
    
    CONSTRAINT PK_AuditLog PRIMARY KEY (AuditLogID)
);
