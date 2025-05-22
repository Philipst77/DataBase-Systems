# 📘 Book Management System – CLI & GUI Java Application

## Overview

This project is a dual-interface Java application (Command-Line Interface and GUI) designed to manage books and book copies in a relational Oracle database. The system leverages **JDBC** to connect, initialize, and interact with the database using SQL, offering both console-based and graphical user interactions.

It automates common library operations such as searching for books, tracking available copies, replacing damaged ones, and updating the status of specific book copies.
The GUI version extends these features into a user-friendly interface for better usability and accessibility.

---

## 🛠 Features

### ✅ Core Functionalities

1. **🔍 Search Books**
   - Search by ISBN, Title, or Category
   - Supports partial (substring) matches for Title and Category
   - Displays all book attributes

2. **📚 Show Number of Available Copies**
   - Input: ISBN or partial Title
   - Output: Number of copies marked as "Available"

3. **🔄 Replace Damaged Copies**
   - Finds damaged copies based on ISBN or Title
   - Allows replacement with new "Available" copies
   - Input validation for new entries included

4. **📝 Update Book Copy Status**
   - Updates `Status` of a book copy using ISBN + Copy#
   - Prevents invalid status transitions (e.g., "Damaged" ➝ "Available")

5. **🚪 Exit Option**
   - Gracefully terminates the session
   - Closes all database resources upon shutdown

---

## 🖥️ Interfaces

### 🔧 Command-Line Interface (CLI)
- Prompts for Oracle DB credentials at runtime (no hardcoding)
- Asks for path to SQL script (BookCopies.sql)
- Interactive menu with error checking and input validation
- Loops until the user selects **Exit**

### 🖼️ Graphical User Interface (GUI)
- Built using Java Swing
- Replicates all CLI functionalities with a clean, button-driven interface
- Validates inputs with error dialogs
- Displays results in readable text areas and pop-ups
- Includes dropdowns, dynamic fields, and intuitive layouts

---

## 📂 File Structure
```
BookManagementSystem/
├── src/
│ ├── MainCLI.java # CLI application
│ ├── MainGUI.java # GUI entry point
│ ├── BookManager.java # Core logic (search, update, etc.)
│ ├── DBConnector.java # JDBC connection and script executor
│ ├── GUIComponents.java # Custom GUI components
│ ├── BookCopies.sql # SQL schema and insert statements
└── README.md
```
---

## 🚀 How to Run

### 🧑‍💻 CLI Mode
javac MainCLI.java
java MainCLI

Enter your Oracle DB username and password

Enter the path to BookCopies.sql

Use the numbered menu to interact with the system


🖱️ GUI Mode
javac MainGUI.java
java MainGUI

Login screen will prompt for DB credentials

File chooser to select the SQL script

GUI will launch with buttons and input fields

💾 Technologies Used
Java 21

JDBC (Oracle Thin Driver)

SQL (DDL + DML)

Java Swing (GUI)

Oracle Database 18c

🏁 Final Notes
This project demonstrates hands-on experience in:

Database connectivity and SQL execution via JDBC

Input validation and error handling

Object-oriented design separating logic, I/O, and UI

Dual-interface design patterns (CLI and GUI)

Relational data manipulation using SQL constraints and joins

