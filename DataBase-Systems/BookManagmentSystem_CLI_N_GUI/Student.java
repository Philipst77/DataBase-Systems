package src;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class Student {
    static Connection con;
    static Statement stmt;
    static Scanner scanner = new Scanner(System.in); 

    public static void main(String[] argv) {
        connectToDatabase();

        System.out.print("Enter path to BookCopies.sql: ");
        String filepath = scanner.nextLine();
        executeSQLScript(filepath);

        while (true) {
            System.out.println("\n==== Main Menu ====");
            System.out.println("1. Search Books");
            System.out.println("2. Show the Number of Available Copies");
            System.out.println("3. Find and Replace Damaged Copies");
            System.out.println("4. Update Book Copy Status (if valid)");
            System.out.println("5. Exit");
            System.out.print("Enter your choice (1–5): ");

            String choice = scanner.nextLine().trim();

            switch (choice) {
                case "1":
                    searchBooks();
                    break;
                case "2":
                    showAvailableCopies();
                    break;
                case "3":
                    replaceDamagedCopies();
                    break;
                case "4":
                    updateBookCopyStatus();
                    break;
                case "5":
                    System.out.println("Exiting program.");
                    closeConnection();
                    scanner.close();
                    return;
                default:
                    System.out.println("Invalid option. Please enter a number from 1 to 5.");
            }
        }
    }

    public static void connectToDatabase() {
        String driverPrefixURL = "jdbc:oracle:thin:@";
        String jdbc_url = "artemis.vsnet.gmu.edu:1521/vse18c.vsnet.gmu.edu";

        System.out.print("Enter Oracle username: ");
        String username = scanner.nextLine();
        System.out.print("Enter Oracle password: ");
        String password = scanner.nextLine();

        try {
            con = DriverManager.getConnection(driverPrefixURL + jdbc_url, username, password);
            stmt = con.createStatement();
            DatabaseMetaData dbmd = con.getMetaData();

            System.out.println("Connected.");

            if (dbmd == null) {
                System.out.println("No database meta data");
            } else {
                System.out.println("Database Product Name: " + dbmd.getDatabaseProductName());
                System.out.println("Database Product Version: " + dbmd.getDatabaseProductVersion());
                System.out.println("Database Driver Name: " + dbmd.getDriverName());
                System.out.println("Database Driver Version: " + dbmd.getDriverVersion());
            }
        } catch (Exception e) {
            System.out.println("Connection failed:");
            e.printStackTrace();
        }
    }

    public static void executeSQLScript(String filepath) {
        try {
            BufferedReader reader = new BufferedReader(new FileReader(filepath));
            StringBuilder sqlBuilder = new StringBuilder();
            String line;

            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("--")) {
                    continue;
                }

                sqlBuilder.append(line).append(" ");

                if (line.endsWith(";")) {
                    String sql = sqlBuilder.toString().replace(";", "").trim();

                    try {
                        stmt.executeUpdate(sql);
                        System.out.println("Executed: " + sql);
                    } catch (SQLException e) {
                        System.out.println("Skipped statement due to error: " + e.getMessage());
                    }

                    sqlBuilder.setLength(0);
                }
            }

            reader.close();
            System.out.println("SQL script executed (with warnings if any).");

        } catch (IOException e) {
            System.out.println("Error reading SQL file: " + e.getMessage());
        }
    }

    public static void searchBooks() {
        try {
            System.out.print("Search by (isbn/title/category): ");
            String field = scanner.nextLine().trim().toLowerCase();
    
            if (!field.equals("isbn") && !field.equals("title") && !field.equals("category")) {
                System.out.println("Invalid search field. Please enter 'isbn', 'title', or 'category'.");
                return;
            }
    
            System.out.print("Enter search keyword: ");
            String keyword = scanner.nextLine().trim();
    
            String query;
            if (field.equals("isbn")) {
                query = "SELECT * FROM Books WHERE ISBN = ?";
            } else {
                query = "SELECT * FROM Books WHERE " + field + " LIKE ?";
            }
    
            PreparedStatement pstmt = con.prepareStatement(query);
            if (field.equals("isbn")) {
                pstmt.setString(1, keyword);
            } else {
                pstmt.setString(1, "%" + keyword + "%");
            }
    
            ResultSet rs = pstmt.executeQuery();
    
            boolean hasResults = false;
            while (rs.next()) {
                hasResults = true;
                String isbn = rs.getString("ISBN");
                String title = rs.getString("Title");
                String edition = rs.getString("Edition");
                String category = rs.getString("Category");
                double price = rs.getDouble("Price");
    
                System.out.printf("ISBN: %s, Title: %s, Edition: %s, Category: %s, Price: %.2f%n",
                        isbn, title, edition, category, price);
            }
    
            if (!hasResults) {
                System.out.println("No matching books found.");
            }
    
            rs.close();
            pstmt.close();
        } catch (SQLException e) {
            System.out.println("Error searching books: " + e.getMessage());
        }
    }
    

    public static void showAvailableCopies() {
        try {
            System.out.print("Search by (isbn/title): ");
            String field = scanner.nextLine().trim().toLowerCase();
    
            if (!field.equals("isbn") && !field.equals("title")) {
                System.out.println("Invalid field. Use 'isbn' or 'title'.");
                return;
            }
    
            System.out.print("Enter search keyword: ");
            String keyword = scanner.nextLine().trim();
    
            String query;
            PreparedStatement pstmt;
    
            if (field.equals("isbn")) {
                query = "SELECT COUNT(*) FROM Book_Copies WHERE ISBN = ? AND Status = 'Available'";
                pstmt = con.prepareStatement(query);
                pstmt.setString(1, keyword);
            } else {
                // Join to match Title using LIKE
                query = "SELECT COUNT(*) FROM Book_Copies bc JOIN Books b ON bc.ISBN = b.ISBN " +
                        "WHERE b.Title LIKE ? AND bc.Status = 'Available'";
                pstmt = con.prepareStatement(query);
                pstmt.setString(1, "%" + keyword + "%");
            }
    
            ResultSet rs = pstmt.executeQuery();
    
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("Available copies: " + count);
            } else {
                System.out.println("No matching books found.");
            }
    
            rs.close();
            pstmt.close();
    
        } catch (SQLException e) {
            System.out.println("Error fetching available copies: " + e.getMessage());
        }
    }
    

    public static void replaceDamagedCopies() {
        try {
            System.out.print("Search by (isbn/title): ");
            String field = scanner.nextLine().trim().toLowerCase();
    
            if (!field.equals("isbn") && !field.equals("title")) {
                System.out.println("Invalid field. Use 'isbn' or 'title'.");
                return;
            }
    
            System.out.print("Enter search keyword: ");
            String keyword = scanner.nextLine().trim();
    
            String query;
            PreparedStatement pstmt;
    
            if (field.equals("isbn")) {
                query = "SELECT ISBN, Copy# FROM Book_Copies WHERE ISBN = ? AND Status = 'Damaged'";
                pstmt = con.prepareStatement(query);
                pstmt.setString(1, keyword);
            } else {
                query = "SELECT bc.ISBN, bc.Copy# FROM Book_Copies bc JOIN Books b ON bc.ISBN = b.ISBN " +
                        "WHERE b.Title LIKE ? AND bc.Status = 'Damaged'";
                pstmt = con.prepareStatement(query);
                pstmt.setString(1, "%" + keyword + "%");
            }
    
            ResultSet rs = pstmt.executeQuery();
            boolean found = false;
    
            while (rs.next()) {
                found = true;
                String isbn = rs.getString("ISBN");
                int oldCopy = rs.getInt("Copy#");
    
                System.out.println("Damaged copy found: ISBN " + isbn + ", Copy# " + oldCopy);
                System.out.print("Enter new copy number to replace it: ");
                int newCopy = Integer.parseInt(scanner.nextLine().trim());
    
                String insertSQL = "INSERT INTO Book_Copies (ISBN, Copy#, Status) VALUES (?, ?, 'Available')";
                PreparedStatement insertStmt = con.prepareStatement(insertSQL);
                insertStmt.setString(1, isbn);
                insertStmt.setInt(2, newCopy);
                insertStmt.executeUpdate();
                insertStmt.close();
    
                System.out.println("New available copy added for ISBN " + isbn + ", Copy# " + newCopy);
            }
    
            if (!found) {
                System.out.println("No damaged copies found.");
            }
    
            rs.close();
            pstmt.close();
    
        } catch (SQLException e) {
            System.out.println("Error replacing damaged copies: " + e.getMessage());
        } catch (NumberFormatException e) {
            System.out.println("Invalid number entered.");
        }
    }
    

    public static void updateBookCopyStatus() {
        try {
            System.out.print("Enter ISBN: ");
            String isbn = scanner.nextLine().trim();
    
            System.out.print("Enter Copy#: ");
            int copyNum = Integer.parseInt(scanner.nextLine().trim());
    
            System.out.print("Enter new status (Available / Checked out / Damaged): ");
            String newStatus = scanner.nextLine().trim();
    
            // Check current status
            String checkQuery = "SELECT Status FROM Book_Copies WHERE ISBN = ? AND Copy# = ?";
            PreparedStatement checkStmt = con.prepareStatement(checkQuery);
            checkStmt.setString(1, isbn);
            checkStmt.setInt(2, copyNum);
            ResultSet rs = checkStmt.executeQuery();
    
            if (rs.next()) {
                String currentStatus = rs.getString("Status");
                if (currentStatus.equalsIgnoreCase("Damaged")) {
                    System.out.println("Cannot update a damaged copy.");
                } else {
                    String updateSQL = "UPDATE Book_Copies SET Status = ? WHERE ISBN = ? AND Copy# = ?";
                    PreparedStatement updateStmt = con.prepareStatement(updateSQL);
                    updateStmt.setString(1, newStatus);
                    updateStmt.setString(2, isbn);
                    updateStmt.setInt(3, copyNum);
                    int rows = updateStmt.executeUpdate();
    
                    if (rows > 0) {
                        System.out.println("Book copy status updated successfully.");
                    } else {
                        System.out.println("No matching book copy found.");
                    }
    
                    updateStmt.close();
                }
            } else {
                System.out.println("Book copy not found.");
            }
    
            rs.close();
            checkStmt.close();
    
        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
        } catch (NumberFormatException e) {
            System.out.println("Invalid number format.");
        }
    }
    

    public static void closeConnection() {
        try {
            if (stmt != null) stmt.close();
            if (con != null) con.close();
            System.out.println("Database connection closed.");
        } catch (SQLException e) {
            System.out.println("Error closing connection: " + e.getMessage());
        }
    }
}
