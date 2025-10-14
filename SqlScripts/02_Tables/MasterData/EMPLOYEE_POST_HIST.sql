CREATE TABLE EmployeePostHist (
    EmployeePostHistID INT NOT NULL IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    AssignedFrom DATE NOT NULL,
    AssignedTo DATE NULL,
    ChangedAt DATETIME NOT NULL DEFAULT GETDATE(),
    ChangedBy NVARCHAR(100) NULL,

    CONSTRAINT PK_EmployeePostHist PRIMARY KEY (EmployeePostHistID),
    CONSTRAINT FK_EPH_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID),
    
    CONSTRAINT CHK_EPH_Dates CHECK (
        AssignedTo IS NULL OR AssignedTo > AssignedFrom
    ),
    CONSTRAINT UQ_EPH_Employee_AssignedFrom UNIQUE (EmployeeID, AssignedFrom)
);

ALTER TABLE EmployeePostHist ADD PostID INT NOT NULL;

ALTER TABLE EmployeePostHist ADD CONSTRAINT FK_EPH_Post FOREIGN KEY (PostID)
    REFERENCES Post(PostID);