DROP TABLE Checkout_Return CASCADE CONSTRAINTS;
DROP TABLE Book_Copies CASCADE CONSTRAINTS;
DROP TABLE Transactions CASCADE CONSTRAINTS;
DROP TABLE Standard_Patron CASCADE CONSTRAINTS;
DROP TABLE Premium_Patron CASCADE CONSTRAINTS;
DROP TABLE CellPhone_Number CASCADE CONSTRAINTS;
DROP TABLE Association CASCADE CONSTRAINTS;
DROP TABLE Publisher_Association CASCADE CONSTRAINTS;
DROP TABLE Books CASCADE CONSTRAINTS;
DROP TABLE Patrons CASCADE CONSTRAINTS;
DROP TABLE Authors CASCADE CONSTRAINTS;

CREATE TABLE Authors (
    Author_ID INT PRIMARY KEY,
    Full_Name VARCHAR(100) CHECK (LENGTH(Full_Name) > 0),
    Dob DATE
);

CREATE TABLE Publisher_Association (
    Author_ID INT,
    Publisher_Associations VARCHAR(100),
    PRIMARY KEY (Author_ID, Publisher_Associations),
    FOREIGN KEY (Author_ID) REFERENCES Authors(Author_ID) ON DELETE CASCADE
);

CREATE TABLE Books (
    ISBN INT PRIMARY KEY,
    Premium_Resources INT,
    Edition INT CHECK (Edition > 0),
    Title VARCHAR(100),
    Category VARCHAR(100),
    Price INT CHECK (Price > 0),
    Premium_Flag INT CHECK (Premium_Flag IN (0, 1))
);

CREATE TABLE Association (
    ISBN INT,
    Author_ID INT,
    PRIMARY KEY (ISBN, Author_ID),
    FOREIGN KEY (ISBN) REFERENCES Books(ISBN) ON DELETE CASCADE,
    FOREIGN KEY (Author_ID) REFERENCES Authors(Author_ID) ON DELETE CASCADE
);

CREATE TABLE Patrons (
    Patron_ID INT PRIMARY KEY,
    First_Name VARCHAR(100),
    Last_Name VARCHAR(100),
    Email_Address VARCHAR(100) CHECK (Email_Address LIKE '%@%.%'),
    City VARCHAR(100),
    State VARCHAR(100),
    Zip INT CHECK (Zip BETWEEN 10000 AND 99999)
);

CREATE TABLE Transactions (
    Transaction_ID INT PRIMARY KEY,
    ReturnDate DATE,
    CheckoutDate_Time TIMESTAMP,
    DueDate DATE,
    Patron_ID INT,
    FOREIGN KEY (Patron_ID) REFERENCES Patrons(Patron_ID) ON DELETE CASCADE
);

CREATE TABLE Book_Copies (
    ISBN INT,
    Copy_Num INT,
    Status INT CHECK (Status IN (0, 1)),
    PRIMARY KEY (ISBN, Copy_Num),
    FOREIGN KEY (ISBN) REFERENCES Books(ISBN) ON DELETE CASCADE
);

CREATE TABLE Checkout_Return (
    Transaction_ID INT,
    ISBN INT,
    Copy_Num INT,
    PRIMARY KEY (Transaction_ID, ISBN, Copy_Num),
    FOREIGN KEY (Transaction_ID) REFERENCES Transactions(Transaction_ID) ON DELETE CASCADE,
    FOREIGN KEY (ISBN, Copy_Num) REFERENCES Book_Copies(ISBN, Copy_Num) ON DELETE CASCADE
);

CREATE TABLE CellPhone_Number (
    Patron_ID INT,
    CellPhone_Number INT,
    PRIMARY KEY (Patron_ID, CellPhone_Number),
    FOREIGN KEY (Patron_ID) REFERENCES Patrons(Patron_ID) ON DELETE CASCADE
);

CREATE TABLE Standard_Patron (
    Patron_ID INT,
    Borrowed_Limit INT,
    PRIMARY KEY (Patron_ID),
    FOREIGN KEY (Patron_ID) REFERENCES Patrons(Patron_ID) ON DELETE CASCADE
);

CREATE TABLE Premium_Patron (
    Patron_ID INT,
    PRIMARY KEY (Patron_ID),
    FOREIGN KEY (Patron_ID) REFERENCES Patrons(Patron_ID) ON DELETE CASCADE
);


-- Insert Authors
INSERT INTO Authors (Author_ID, Full_Name, Dob) 
VALUES (1, 'Mark Twain', TO_DATE('1835-11-30', 'YYYY-MM-DD'));

INSERT INTO Authors (Author_ID, Full_Name, Dob) 
VALUES (2, 'J.K. Rowling', TO_DATE('1965-07-31', 'YYYY-MM-DD'));

INSERT INTO Authors (Author_ID, Full_Name, Dob) 
VALUES (3, 'George Orwell', TO_DATE('1903-06-25', 'YYYY-MM-DD'));

-- Insert Books (Make sure at least one Premium book is never checked out)
INSERT INTO Books (ISBN, Premium_Resources, Edition, Title, Category, Price, Premium_Flag) 
VALUES (1001, 2, 1, 'Advanced Databases', 'Science Fiction', 45, 1);

INSERT INTO Books (ISBN, Premium_Resources, Edition, Title, Category, Price, Premium_Flag) 
VALUES (1002, 1, 2, 'Graphic Novel 101', 'Graphic Novel', 30, 1);

INSERT INTO Books (ISBN, Premium_Resources, Edition, Title, Category, Price, Premium_Flag) 
VALUES (1003, 0, 3, 'Intro to SQL', 'Educational', 25, 0);

INSERT INTO Books (ISBN, Premium_Resources, Edition, Title, Category, Price, Premium_Flag) 
VALUES (1004, 3, 1, 'The Adventures of Tom Sawyer', 'Science Fiction', 10, 0);

INSERT INTO Books (ISBN, Premium_Resources, Edition, Title, Category, Price, Premium_Flag) 
VALUES (1005, 1, 1, 'Harry Potter and the Sorcerer Stone', 'Science Fiction', 20, 1);

INSERT INTO Books (ISBN, Premium_Resources, Edition, Title, Category, Price, Premium_Flag) 
VALUES (1006, 0, 2, 'SQL for Beginners', 'Educational', 30, 0);

INSERT INTO Books (ISBN, Premium_Resources, Edition, Title, Category, Price, Premium_Flag) 
VALUES (1007, 2, 1, 'Big Data Analytics', 'Graphic Novel', 50, 1);

INSERT INTO Book_Copies (ISBN, Copy_Num, Status) VALUES (1001, 1, 1);
INSERT INTO Book_Copies (ISBN, Copy_Num, Status) VALUES (1001, 2, 0);
INSERT INTO Book_Copies (ISBN, Copy_Num, Status) VALUES (1002, 1, 1);
INSERT INTO Book_Copies (ISBN, Copy_Num, Status) VALUES (1003, 1, 0);
INSERT INTO Book_Copies (ISBN, Copy_Num, Status) VALUES (1004, 1, 1);
INSERT INTO Book_Copies (ISBN, Copy_Num, Status) VALUES (1005, 1, 1);
INSERT INTO Book_Copies (ISBN, Copy_Num, Status) VALUES (1006, 1, 0);
INSERT INTO Book_Copies (ISBN, Copy_Num, Status) VALUES (1007, 1, 1);
INSERT INTO Book_Copies (ISBN, Copy_Num, Status) VALUES (1001, 3, 1); 

INSERT INTO Association (ISBN, Author_ID) VALUES (1001, 1);
INSERT INTO Association (ISBN, Author_ID) VALUES (1002, 2);
INSERT INTO Association (ISBN, Author_ID) VALUES (1003, 3);
INSERT INTO Association (ISBN, Author_ID) VALUES (1004, 1);
INSERT INTO Association (ISBN, Author_ID) VALUES (1005, 2);
INSERT INTO Association (ISBN, Author_ID) VALUES (1006, 3);
INSERT INTO Association (ISBN, Author_ID) VALUES (1007, 1);
INSERT INTO Association (ISBN, Author_ID) VALUES (1002, 1); 

INSERT INTO Patrons (Patron_ID, First_Name, Last_Name, Email_Address, City, State, Zip) 
VALUES (1, 'John', 'Doe', 'john.doe@example.com', 'Fairfax', 'VA', 22030);

INSERT INTO Patrons (Patron_ID, First_Name, Last_Name, Email_Address, City, State, Zip) 
VALUES (2, 'Alice', 'Smith', 'alice.smith@example.com', 'Arlington', 'VA', 22201);

INSERT INTO Patrons (Patron_ID, First_Name, Last_Name, Email_Address, City, State, Zip) 
VALUES (3, 'Michael', 'Johnson', 'michael.johnson@example.com', 'Washington', 'DC', 20001);

INSERT INTO Patrons (Patron_ID, First_Name, Last_Name, Email_Address, City, State, Zip) 
VALUES (4, 'Emily', 'Davis', 'emily.davis@example.com', 'Bethesda', 'MD', 20814);

INSERT INTO Patrons (Patron_ID, First_Name, Last_Name, Email_Address, City, State, Zip) 
VALUES (5, 'David', 'Williams', 'david.williams@example.com', 'Alexandria', 'VA', 22301);

INSERT INTO Standard_Patron (Patron_ID, Borrowed_Limit) VALUES (5, 5);


INSERT INTO Standard_Patron (Patron_ID, Borrowed_Limit) VALUES (1, 5);
INSERT INTO Standard_Patron (Patron_ID, Borrowed_Limit) VALUES (2, 5);

INSERT INTO Premium_Patron (Patron_ID) VALUES (3);
INSERT INTO Premium_Patron (Patron_ID) VALUES (4);

INSERT INTO Transactions (Transaction_ID, ReturnDate, CheckoutDate_Time, DueDate, Patron_ID)
VALUES (5001, NULL, TO_TIMESTAMP('2025-02-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-02-15', 'YYYY-MM-DD'), 1);

INSERT INTO Transactions (Transaction_ID, ReturnDate, CheckoutDate_Time, DueDate, Patron_ID)
VALUES (5002, NULL, TO_TIMESTAMP('2025-03-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-03-15', 'YYYY-MM-DD'), 1);
INSERT INTO Transactions (Transaction_ID, ReturnDate, CheckoutDate_Time, DueDate, Patron_ID)
VALUES (5003, NULL, TO_TIMESTAMP('2025-03-02 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-03-16', 'YYYY-MM-DD'), 2);
INSERT INTO Transactions (Transaction_ID, ReturnDate, CheckoutDate_Time, DueDate, Patron_ID)
VALUES (5004, NULL, TO_TIMESTAMP('2025-03-03 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-03-17', 'YYYY-MM-DD'), 3);
INSERT INTO Transactions (Transaction_ID, ReturnDate, CheckoutDate_Time, DueDate, Patron_ID)
VALUES (5005, NULL, TO_TIMESTAMP('2025-03-04 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-03-18', 'YYYY-MM-DD'), 4);


INSERT INTO Transactions (Transaction_ID, ReturnDate, CheckoutDate_Time, DueDate, Patron_ID)
VALUES (6001, NULL, TO_TIMESTAMP('2025-03-05 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-03-19', 'YYYY-MM-DD'), 1);

INSERT INTO Transactions (Transaction_ID, ReturnDate, CheckoutDate_Time, DueDate, Patron_ID)
VALUES (6002, NULL, TO_TIMESTAMP('2025-03-06 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-03-20', 'YYYY-MM-DD'), 2);

INSERT INTO Transactions (Transaction_ID, ReturnDate, CheckoutDate_Time, DueDate, Patron_ID)
VALUES (6003, NULL, TO_TIMESTAMP('2025-03-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-03-21', 'YYYY-MM-DD'), 3);

INSERT INTO Transactions (Transaction_ID, ReturnDate, CheckoutDate_Time, DueDate, Patron_ID)
VALUES (6004, NULL, TO_TIMESTAMP('2025-03-08 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-03-22', 'YYYY-MM-DD'), 4);

INSERT INTO Transactions (Transaction_ID, ReturnDate, CheckoutDate_Time, DueDate, Patron_ID)
VALUES (6005, NULL, TO_TIMESTAMP('2025-03-09 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-03-23', 'YYYY-MM-DD'), 5);

INSERT INTO Checkout_Return (Transaction_ID, ISBN, Copy_Num) VALUES (6001, 1001, 1);
INSERT INTO Checkout_Return (Transaction_ID, ISBN, Copy_Num) VALUES (6002, 1001, 1);
INSERT INTO Checkout_Return (Transaction_ID, ISBN, Copy_Num) VALUES (6003, 1001, 1);
INSERT INTO Checkout_Return (Transaction_ID, ISBN, Copy_Num) VALUES (6004, 1001, 1);
INSERT INTO Checkout_Return (Transaction_ID, ISBN, Copy_Num) VALUES (6005, 1001, 1);


INSERT INTO Transactions (Transaction_ID, ReturnDate, CheckoutDate_Time, DueDate, Patron_ID)
VALUES (7001, NULL, TO_TIMESTAMP('2025-03-10 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-03-24', 'YYYY-MM-DD'), 3);

INSERT INTO Checkout_Return (Transaction_ID, ISBN, Copy_Num) VALUES (7001, 1001, 1);
INSERT INTO Checkout_Return (Transaction_ID, ISBN, Copy_Num) VALUES (7001, 1002, 1);
INSERT INTO Checkout_Return (Transaction_ID, ISBN, Copy_Num) VALUES (7001, 1005, 1);
INSERT INTO Checkout_Return (Transaction_ID, ISBN, Copy_Num) VALUES (7001, 1007, 1);

INSERT INTO Checkout_Return (Transaction_ID, ISBN, Copy_Num) VALUES (5002, 1001, 1);
INSERT INTO Checkout_Return (Transaction_ID, ISBN, Copy_Num) VALUES (5003, 1005, 1);
INSERT INTO Checkout_Return (Transaction_ID, ISBN, Copy_Num) VALUES (5004, 1007, 1);





--Queries

--Query 1 
SELECT b.ISBN , bc.Copy_Num
FROM Books b , Book_Copies bc
WHERE b.ISBN = bc.ISBN AND b.Premium_Flag = 1;


--Query 2

SELECT p.First_Name
FROM Standard_Patron sp, Patrons p
WHERE sp.Patron_ID = p.Patron_ID AND p.Zip = 22030;

--Query 3

SELECT b.ISBN, b.Title
FROM Books b
WHERE NOT EXISTS (
    SELECT 1 FROM Checkout_Return cr WHERE cr.ISBN = b.ISBN
);


--Query 4

SELECT A.Author_ID
FROM Authors A, Association assoc, Books b
WHERE b.Category = 'Science Fiction'
AND A.Author_ID = assoc.Author_ID
AND assoc.ISBN = b.ISBN
INTERSECT
SELECT A.Author_ID
FROM Authors A , Association assoc, Books b
WHERE b.Category = 'Graphic Novel'
AND A.Author_ID = assoc.Author_ID
AND assoc.ISBN = b.ISBN;


--Query 5   
SELECT COUNT(bc.Copy_Num)
FROM Book_Copies bc, Books b
WHERE b.ISBN = bc.ISBN
AND (bc.ISBN, bc.Copy_Num) NOT IN (
    SELECT ck.ISBN, ck.Copy_Num
    FROM Checkout_Return ck, Transactions T
    WHERE ck.Transaction_Id = T.Transaction_ID AND  T.ReturnDate IS NULL
);

-- Query 6
SELECT p.Patron_ID
FROM Patrons p, Transactions t
WHERE t.Patron_ID = p.Patron_ID
AND t.DueDate < CURRENT_DATE
AND t.ReturnDate IS NULL;

--Query 7

SELECT b.ISBN, b.title
FROM Books b
WHERE ISBN IN (
    SELECT cr.ISBN
    FROM Checkout_Return cr
    GROUP BY ISBN
    HAVING COUNT(*) > 5
);

--Query 8


SELECT p.Patron_ID
FROM Patrons p
WHERE NOT EXISTS (
    SELECT b.ISBN
    FROM Books b
    WHERE b.Premium_Flag = 1 
    AND NOT EXISTS (
        SELECT ck.Transaction_ID
        FROM Checkout_Return ck , Transactions T
        WHERE ck.Transaction_ID = T.Transaction_ID
        AND ck.ISBN = b.ISBN AND T.Patron_ID = p.Patron_ID
    )
);




