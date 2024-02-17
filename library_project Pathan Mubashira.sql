create database Library;

use library;

CREATE TABLE Publisher (
    Publisher_PublisherName VARCHAR (255) PRIMARY KEY,
    Publisher_PublisherAddress VARCHAR(255) NOT NULL,
    Publisher_publisherPhone VARCHAR(255)
);

CREATE TABLE Borrower (
    Borrower_CardNo INT AUTO_INCREMENT PRIMARY KEY,
    Borrower_BorrowerName VARCHAR(255) NOT NULL,
	Borrower_BorrowerAddress VARCHAR(255) NOT NULL,
    Borrower_BorrowerPhone  VARCHAR(255)
);

CREATE TABLE Book (
    Book_BookID INT AUTO_INCREMENT PRIMARY KEY,
    Book_Title VARCHAR(255) NOT NULL,
    Book_PublisherName VARCHAR(255),
    FOREIGN KEY (Book_PublisherName) REFERENCES Publisher(Publisher_PublisherName) ON DELETE CASCADE
);

CREATE TABLE Book_Authors (
    Book_authors_BookID INT AUTO_INCREMENT PRIMARY KEY,
    Book_author_AuthorName VARCHAR(255) NOT NULL,
    FOREIGN KEY ( Book_authors_BookID) REFERENCES Book(Book_BookID ) ON DELETE CASCADE
);

CREATE TABLE Library_Branch (
     Library_Branch_BranchID INT AUTO_INCREMENT PRIMARY KEY,
     Library_Branch_BranchName VARCHAR(255) NOT NULL,
     Library_Branch_BranchAddress VARCHAR(255)
);

CREATE TABLE Book_Copies (
	 Book_Copies_BookID INT AUTO_INCREMENT PRIMARY KEY,
	 Book_Copies_BranchID INT,
     Book_Copies_Num_Of_Copies INT NOT NULL,
    FOREIGN KEY ( Book_Copies_BookID) REFERENCES Book(Book_BookID) ON DELETE CASCADE,
    FOREIGN KEY (Book_Copies_BranchID) REFERENCES Library_Branch(Library_Branch_BranchID) ON DELETE CASCADE
);

CREATE TABLE Book_Loans (
    Book_Loans_BookID INT AUTO_INCREMENT PRIMARY KEY,
    Book_Loans_BranchID INT,
    Book_Loans_CardNo INT , 
	Book_Loans_DateOut DATE NOT NULL,
    Book_Loans_DueDate DATE NOT NULL,
    FOREIGN KEY (Book_Loans_BookID) REFERENCES Book_Copies(Book_Copies_BookID) ON DELETE CASCADE,
    FOREIGN KEY (Book_Loans_BranchID) REFERENCES Library_Branch(Library_Branch_BranchID) ON DELETE CASCADE,
    FOREIGN KEY (Book_Loans_CardNo) REFERENCES Borrower(Borrower_CardNo) ON DELETE CASCADE
);

select * from book_loans;
select * from book_copies;
select * from book_authors;
select * from book;
select * from borrower;
select * from library_branch;
select * from publisher;




-- 1. How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

SELECT COUNT(*) AS NumberOfCopies
FROM Book_Copies bc
INNER JOIN book b ON bc.Book_Copies_BookID = b.book_BookID
INNER JOIN Library_Branch lb ON bc.Book_Copies_BranchID = lb.Library_Branch_BranchID
WHERE b.book_Title = 'The Lost Tribe' AND lb.Library_Branch_BranchName = 'Sharpstown';
-- 2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?

SELECT Library_Branch_BranchName, COUNT(*) AS NumberOfCopies
FROM Book_Copies bc
INNER JOIN book b ON bc.Book_Copies_BookID = b.book_BookID
INNER JOIN Library_Branch lb ON bc.Book_Copies_BranchID = lb.Library_Branch_BranchID
WHERE b.book_Title = 'The Lost Tribe'
GROUP BY Library_Branch_BranchName;


-- 3. Retrieve the names of all borrowers who do not have any books checked out.

SELECT borrower_BorrowerName
FROM borrower
LEFT JOIN Book_Loans ON borrower.borrower_CardNo = Book_Loans.Book_Loans_CardNo
WHERE Book_Loans.Book_Loans_CardNo IS NULL;


-- 4. For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 

select * from book; 

SELECT b.book_Title, bo.borrower_BorrowerName, bo.borrower_BorrowerAddress 
FROM BOOK b
INNER JOIN BOOK_LOANS bl ON b.book_BookID = bl.Book_Loans_BookID
INNER JOIN LIBRARY_BRANCH lb ON bl.Book_Loans_BranchID = lb.Library_Branch_BranchID
INNER JOIN BORROWER bo ON  bl.Book_Loans_CardNo = bo.borrower_CardNo
WHERE lb.Library_Branch_BranchName = 'Sharpstown' AND bl.Book_Loans_DueDate = '2/3/18';




-- 5 .For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

SELECT Library_Branch_BranchName, COUNT(*) AS 'Books On Loan' FROM library_branch lb
INNER JOIN BOOK_LOANS bl on lb.Library_Branch_BranchID = bl.Book_Loans_BranchID
GROUP BY Library_Branch_BranchName HAVING COUNT(*) >= 0 ;


 -- 6 .Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.

SELECT borrower_BorrowerName, borrower_BorrowerAddress, COUNT(*) AS 'Books On Loan' FROM BORROWER b
INNER JOIN BOOK_LOANS bl ON b.borrower_CardNo = bl.Book_Loans_CardNo
GROUP BY borrower_BorrowerName, borrower_BorrowerAddress HAVING COUNT(*) > 5 ; 


-- 7.For each book authored (or co-authored) by "Stephen King", retrieve the title and the 
--   number of copies owned by the library branch whose name is "Central". 

SELECT book.book_Title, COUNT(book_copies.Book_Copies_BookID) AS num_copies
FROM book
JOIN book_copies ON book.book_BookID = book_copies.Book_Copies_BookID
JOIN book_authors ON book.book_BookID = book_authors.book_authors_BookID
JOIN library_branch ON book_copies.Book_Copies_BookID = library_branch.Library_Branch_BranchID
WHERE book_authors.book_author_AuthorName = 'Stephen King' AND library_branch.Library_Branch_BranchName = 'Central'
GROUP BY book.book_Title; 

-- Error Code: 1054. Unknown column 'book_authors.book_authors_AuthorName' in 'where clause'

