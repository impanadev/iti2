-- Create Database
CREATE DATABASE LibraryManagementSystem;
USE LibraryManagementSystem;

-- Authors Table
CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Biography TEXT
);

-- Genres Table
CREATE TABLE Genres (
    GenreID INT AUTO_INCREMENT PRIMARY KEY,
    GenreName VARCHAR(100) NOT NULL UNIQUE
);

-- Publishers Table
CREATE TABLE Publishers (
    PublisherID INT AUTO_INCREMENT PRIMARY KEY,
    PublisherName VARCHAR(200) NOT NULL,
    Address TEXT,
    Phone VARCHAR(20),
    Email VARCHAR(100) UNIQUE
);

-- Books Table
CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    AuthorID INT,
    GenreID INT,
    PublisherID INT,
    ISBN VARCHAR(20) NOT NULL UNIQUE,
    PublicationYear YEAR,
    Pages INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (GenreID) REFERENCES Genres(GenreID) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (PublisherID) REFERENCES Publishers(PublisherID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Members Table
CREATE TABLE Members (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    DOB DATE,
    Address TEXT,
    Phone VARCHAR(20),
    Email VARCHAR(100) UNIQUE,
    MembershipDate DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Loans Table
CREATE TABLE Loans (
    LoanID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT NOT NULL,
    MemberID INT NOT NULL,
    LoanDate DATE NOT NULL DEFAULT CURRENT_DATE,
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    FineAmount DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Staff Table
CREATE TABLE Staff (
    StaffID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Position VARCHAR(100),
    HireDate DATE NOT NULL DEFAULT CURRENT_DATE,
    Phone VARCHAR(20),
    Email VARCHAR(100) UNIQUE
);

-- Reservations Table
CREATE TABLE Reservations (
    ReservationID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT NOT NULL,
    MemberID INT NOT NULL,
    ReservationDate DATE NOT NULL DEFAULT CURRENT_DATE,
    ExpirationDate DATE NOT NULL,
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Fines Table
CREATE TABLE Fines (
    FineID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT NOT NULL,
    LoanID INT NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Suppliers Table
CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(200) NOT NULL,
    ContactPerson VARCHAR(100),
    Address TEXT,
    Phone VARCHAR(20),
    Email VARCHAR(100) UNIQUE
);

-- BookSupplies Table
CREATE TABLE BookSupplies (
    SupplyID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierID INT NOT NULL,
    BookID INT NOT NULL,
    SupplyDate DATE NOT NULL DEFAULT CURRENT_DATE,
    Quantity INT NOT NULL,
    Cost DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- LibraryBranches Table
CREATE TABLE LibraryBranches (
    BranchID INT AUTO_INCREMENT PRIMARY KEY,
    BranchName VARCHAR(200) NOT NULL,
    Location TEXT,
    Phone VARCHAR(20),
    ManagerID INT,
    FOREIGN KEY (ManagerID) REFERENCES Staff(StaffID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- BookCopies Table
CREATE TABLE BookCopies (
    CopyID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT NOT NULL,
    BranchID INT NOT NULL,
    Status ENUM('Available', 'Loaned', 'Reserved', 'Lost') NOT NULL DEFAULT 'Available',
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (BranchID) REFERENCES LibraryBranches(BranchID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Indexes
CREATE INDEX idx_books_title ON Books(Title);
CREATE INDEX idx_members_lastname ON Members(LastName);
CREATE INDEX idx_loans_duedate ON Loans(DueDate);
CREATE INDEX idx_books_isbn ON Books(ISBN);
CREATE INDEX idx_publishers_email ON Publishers(Email);
CREATE INDEX idx_staff_email ON Staff(Email);
CREATE INDEX idx_suppliers_email ON Suppliers(Email);

-- Constraints and Relationships
ALTER TABLE Books ADD CONSTRAINT fk_books_author FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID);
ALTER TABLE Books ADD CONSTRAINT fk_books_genre FOREIGN KEY (GenreID) REFERENCES Genres(GenreID);
ALTER TABLE Books ADD CONSTRAINT fk_books_publisher FOREIGN KEY (PublisherID) REFERENCES Publishers(PublisherID);

ALTER TABLE Loans ADD CONSTRAINT fk_loans_book FOREIGN KEY (BookID) REFERENCES Books(BookID);
ALTER TABLE Loans ADD CONSTRAINT fk_loans_member FOREIGN KEY (MemberID) REFERENCES Members(MemberID);

ALTER TABLE Reservations ADD CONSTRAINT fk_reservations_book FOREIGN KEY (BookID) REFERENCES Books(BookID);
ALTER TABLE Reservations ADD CONSTRAINT fk_reservations_member FOREIGN KEY (MemberID) REFERENCES Members(MemberID);

ALTER TABLE Fines ADD CONSTRAINT fk_fines_member FOREIGN KEY (MemberID) REFERENCES Members(MemberID);
ALTER TABLE Fines ADD CONSTRAINT fk_fines_loan FOREIGN KEY (LoanID) REFERENCES Loans(LoanID);

ALTER TABLE BookSupplies ADD CONSTRAINT fk_booksupplies_supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID);
ALTER TABLE BookSupplies ADD CONSTRAINT fk_booksupplies_book FOREIGN KEY (BookID) REFERENCES Books(BookID);

ALTER TABLE LibraryBranches ADD CONSTRAINT fk_librarybranches_manager FOREIGN KEY (ManagerID) REFERENCES Staff(StaffID);

ALTER TABLE BookCopies ADD CONSTRAINT fk_bookcopies_book FOREIGN KEY (BookID) REFERENCES Books(BookID);
ALTER TABLE BookCopies ADD CONSTRAINT fk_bookcopies_branch FOREIGN KEY (BranchID) REFERENCES LibraryBranches(BranchID);
