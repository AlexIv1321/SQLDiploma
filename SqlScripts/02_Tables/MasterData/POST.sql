CREATE TABLE Post (
    PostID INT NOT NULL IDENTITY(1,1),
    DepartmentId INT NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    ClouseDate DATETIME NOT NULL,

    CONSTRAINT PK_Post PRIMARY KEY (PostID),
    CONSTRAINT UQ_Post_Department_Title_Active UNIQUE (DepartmentId, Title, IsActive)

);