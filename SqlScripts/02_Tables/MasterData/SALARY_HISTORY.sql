CREATE TABLE SalaryHistory (
    SalaryHistoryID INT NOT NULL IDENTITY(1,1),
    PostID INT NOT NULL,
    Salary INT NOT NULL,
    EffectiveFrom DATE NOT NULL,
    EffectiveTo DATE NULL,
    ChangedAt DATETIME NOT NULL DEFAULT GETDATE(),
    ChangedBy NVARCHAR(100) NULL,

    CONSTRAINT PK_SalaryHistory PRIMARY KEY (SalaryHistoryID),
    CONSTRAINT FK_SalaryHistory_Post FOREIGN KEY (PostID)
        REFERENCES Post(PostID),
    CONSTRAINT CHK_Salary_Positive CHECK (Salary > 0),
    CONSTRAINT CHK_Salary_Dates CHECK (EffectiveTo > EffectiveFrom),
    CONSTRAINT UQ_Post_Post_EffectiveFrom UNIQUE (PostID, EffectiveFrom)

);

CREATE NONCLUSTERED INDEX IX_SalaryHistory_Post_EffectiveFrom ON SalaryHistory(PostID, EffectiveFrom);