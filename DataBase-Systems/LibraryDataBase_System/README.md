
## Overview

This project showcases the design and implementation of a complete relational database system for managing a library. Built from the ground up, the project covers conceptual modeling, schema mapping, and full SQL implementation with meaningful queries to handle real-world use cases.

The system handles books, patrons (standard and premium), book copies, authors, and transaction history. It features normalized schema design, relationship mapping, and query support for common library operations like overdue tracking, availability checks, and category-based analysis.

---

## 🧠 Part 1: Conceptual Design with EER Diagram

The foundation of this system is an Enhanced Entity-Relationship (EER) diagram that models:

- Entity and relationship sets
- Subclassing and generalization (e.g., `Patron → {Standard, Premium}`)
- Composite and multivalued attributes (e.g., name, address, phone numbers)
- Primary key constraints and cardinality rules

### 📌 Key Entities & Attributes

- **Books**
  - `ISBN` (PK), `Title`, `Edition`, `Category`, `Price`
  - Linked to one or more authors

- **BookCopies**
  - Composite key (`ISBN`, `Copy#`)
  - `Status`: Available, Checked Out, Damaged

- **Authors**
  - `AuthorID` (PK), `Name`, `DOB`, `Nationality`, `PublisherAssociations`

- **Patrons**
  - `PatronID` (PK), `FirstName`, `LastName`, `Email`, `Address`, `PhoneNumbers`
  - Subclasses: `StandardPatron`, `PremiumPatron`

- **Transactions**
  - `TransactionID` (PK), `CheckOutDate`, `DueDate`, `ReturnDate`, `OverdueStatus`
  - Linked to patrons and book copies

The EER diagram is used as a blueprint to ensure a normalized and well-structured database.

---

## 🧱 Part 2: Mapping to Relational Schema

The EER model is translated into a normalized set of relational tables. This includes defining:

- Table names and attribute types
- Primary and foreign key constraints
- Domain constraints using `CHECK`
- Support for multivalued attributes using junction tables

All tables reflect real-world data relationships and enforce referential integrity between books, authors, patrons, and transactions.

---

## 💻 Part 3: SQL Implementation and Functional Queries

The project implements the schema and populates it with representative sample data using Oracle SQL. Queries were written to demonstrate the functionality and usefulness of the system.

### ✅ Features Implemented

- Creation of all necessary tables using `CREATE TABLE`
- Proper constraint enforcement (`PRIMARY KEY`, `FOREIGN KEY`, `CHECK`)
- Sample data population with `INSERT INTO`
- Query execution and output captured with `SPOOL`

### 🔍 Required Queries

1. Retrieve ISBNs and copy numbers of all premium-only book copies.
2. Find standard patrons who live in Fairfax (`ZIP = 22030`).
3. Identify books that have **never** been checked out.
4. Get authors who’ve written both "Science Fiction" and "Graphic Novel" books.
5. Count how many copies are **available** per book.
6. List patrons who currently have **overdue** books.
7. Find books checked out **more than 5 times**.
8. Get IDs of premium patrons who borrowed **every premium-only book**.

---

## 📦 File Structure

```
LibraryDataBase_System/
├── eer_diagram.pdf # EER design diagram
├── relational_schema.pdf # Mapped relational schema
├── project1.sql # Full SQL implementation (create, insert, queries)
├── project1_output.txt # Output log from running queries
└── README.md # Project overview and documentation
```
## 🧭 How to Run in SQL*Plus

If you're using Oracle SQL*Plus or SQL Developer:

```sql
spool project1_output.txt
@project1.sql
spool off

💬 Author Notes
This project was developed as part of a database systems course to demonstrate a full-cycle implementation—from data modeling to querying. 
It emphasizes normalization, constraint enforcement, and functional query writing. 
The goal was to simulate a realistic library system that could be scaled further
or used as a backend for a full-stack application in future coursework or personal projects.

