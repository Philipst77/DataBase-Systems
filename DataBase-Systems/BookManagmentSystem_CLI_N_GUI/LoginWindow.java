package gui;

import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import src.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class LoginWindow extends Application {
    private static Connection con;

    @Override
    public void start(Stage primaryStage) {
        Label title = new Label("Login to Oracle Database");
        TextField usernameField = new TextField();
        usernameField.setPromptText("Username");

        PasswordField passwordField = new PasswordField();
        passwordField.setPromptText("Password");

        Label feedback = new Label();

        Button connectBtn = new Button("Connect");
        connectBtn.setOnAction(e -> {
            String username = usernameField.getText();
            String password = passwordField.getText();

            con = DatabaseUtil.connect(username, password);
            if (con != null) {
                feedback.setText("Connected!");
                showMainMenu(primaryStage);
            } else {
                feedback.setText("Connection failed. Try again.");
            }
        });

        VBox loginBox = new VBox(10, title, usernameField, passwordField, connectBtn, feedback);
        loginBox.setStyle("-fx-padding: 20;");
        Scene scene = new Scene(loginBox, 300, 200);
        primaryStage.setScene(scene);
        primaryStage.setTitle("Library Login");
        primaryStage.show();
    }

  public void showMainMenu(Stage primaryStage) {
    Label label = new Label("Library Database System");

    Button searchBtn = new Button("Search Books");
    Button availableBtn = new Button("Show Available Copies");
    Button replaceBtn = new Button("Replace Damaged Copies");
    replaceBtn.setOnAction(e -> showReplaceDamagedCopiesWindow());
    Button updateBtn = new Button("Update Book Copy Status");
    updateBtn.setOnAction(e -> showUpdateStatusWindow());

    searchBtn.setOnAction(e -> showSearchBooksWindow());
    availableBtn.setOnAction(e -> showAvailableCopiesWindow());

    Button exitBtn = new Button("Exit");
    exitBtn.setOnAction(e -> {
        if (con != null) {
            try {
                con.close();
            } catch (Exception ex) {
                System.out.println("Error closing DB connection: " + ex.getMessage());
            }
        }
        primaryStage.close();
    });

    VBox root = new VBox(10);
    root.setStyle("-fx-padding: 20;");
    root.getChildren().addAll(label, searchBtn, availableBtn, replaceBtn, updateBtn, exitBtn);

    Scene scene = new Scene(root, 400, 250);
    primaryStage.setScene(scene);
    primaryStage.setTitle("Library GUI");
    primaryStage.show();
}


    private void showSearchBooksWindow() {
        Stage stage = new Stage();
        VBox layout = new VBox(10);
        layout.setStyle("-fx-padding: 20;");

        Label prompt = new Label("Search by Title or Category:");
        TextField input = new TextField();
        Button search = new Button("Search");
        TextArea results = new TextArea();
        results.setEditable(false);

        search.setOnAction(ev -> {
            String keyword = input.getText().trim();
            if (keyword.isEmpty()) {
                results.setText("Please enter a keyword.");
                return;
            }

            try {
                String query = "SELECT * FROM Books WHERE Title LIKE ? OR Category LIKE ?";
                PreparedStatement pstmt = con.prepareStatement(query);
                pstmt.setString(1, "%" + keyword + "%");
                pstmt.setString(2, "%" + keyword + "%");

                ResultSet rs = pstmt.executeQuery();
                StringBuilder output = new StringBuilder();

                boolean found = false;
                while (rs.next()) {
                    found = true;
                    output.append("ISBN: ").append(rs.getString("ISBN")).append("\n");
                    output.append("Title: ").append(rs.getString("Title")).append("\n");
                    output.append("Edition: ").append(rs.getString("Edition")).append("\n");
                    output.append("Category: ").append(rs.getString("Category")).append("\n");
                    output.append("Price: $").append(rs.getDouble("Price")).append("\n\n");
                }

                if (!found) {
                    output.append("No books found.");
                }

                results.setText(output.toString());

                rs.close();
                pstmt.close();
            } catch (Exception ex) {
                results.setText("Error: " + ex.getMessage());
            }
        });

        layout.getChildren().addAll(prompt, input, search, results);
        stage.setScene(new Scene(layout, 500, 400));
        stage.setTitle("Search Books");
        stage.show();
    }

    private void showAvailableCopiesWindow() {
        Stage stage = new Stage();
        VBox layout = new VBox(10);
        layout.setStyle("-fx-padding: 20;");

        Label prompt = new Label("Enter ISBN or part of a Title:");
        TextField input = new TextField();
        Button checkBtn = new Button("Check Availability");
        Label result = new Label();

        checkBtn.setOnAction(ev -> {
            String keyword = input.getText().trim();
            if (keyword.isEmpty()) {
                result.setText("Please enter a value.");
                return;
            }
        
            try {
                String query = "SELECT COUNT(*) FROM Book_Copies WHERE REPLACE(ISBN, '-', '') = ? AND Status = 'Available'";
                PreparedStatement pstmt = con.prepareStatement(query);
                pstmt.setString(1, keyword.replaceAll("-", ""));
        
                ResultSet rs = pstmt.executeQuery();
                int count = 0;
                if (rs.next()) {
                    count = rs.getInt(1);
                }
                rs.close();
                pstmt.close();
        
                if (count == 0) {
                    query = "SELECT COUNT(*) FROM Book_Copies bc JOIN Books b ON bc.ISBN = b.ISBN " +
                            "WHERE b.Title LIKE ? AND bc.Status = 'Available'";
                    pstmt = con.prepareStatement(query);
                    pstmt.setString(1, "%" + keyword + "%");
        
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        count = rs.getInt(1);
                    }
                    rs.close();
                    pstmt.close();
                }
        
                result.setText("Available copies: " + count);
            } catch (Exception ex) {
                result.setText("Error: " + ex.getMessage());
            }
        });
        

        layout.getChildren().addAll(prompt, input, checkBtn, result);
        stage.setScene(new Scene(layout, 400, 200));
        stage.setTitle("Available Copies");
        stage.show();
    }

    private void showReplaceDamagedCopiesWindow() {
        Stage stage = new Stage();
        VBox layout = new VBox(10);
        layout.setStyle("-fx-padding: 20;");
    
        Label prompt = new Label("Enter ISBN or part of a Title:");
        TextField input = new TextField();
        Button findBtn = new Button("Find Damaged Copies");
        TextArea results = new TextArea();
        results.setEditable(false);
    
        findBtn.setOnAction(ev -> {
            String keyword = input.getText().trim();
            if (keyword.isEmpty()) {
                results.setText("Please enter a value.");
                return;
            }
    
            try {
                String query;
                PreparedStatement pstmt;
    
                if (keyword.replaceAll("-", "").matches("\\d+")) {
                    query = "SELECT ISBN, Copy# FROM Book_Copies WHERE REPLACE(ISBN, '-', '') = ? AND Status = 'Damaged'";
                    pstmt = con.prepareStatement(query);
                    pstmt.setString(1, keyword.replaceAll("-", ""));
                }
                 else {
                    query = "SELECT bc.ISBN, bc.Copy# FROM Book_Copies bc JOIN Books b ON bc.ISBN = b.ISBN " +
                            "WHERE b.Title LIKE ? AND bc.Status = 'Damaged'";
                    pstmt = con.prepareStatement(query);
                    pstmt.setString(1, "%" + keyword + "%");
                }
    
                ResultSet rs = pstmt.executeQuery();
                StringBuilder sb = new StringBuilder();
                boolean found = false;
    
                while (rs.next()) {
                    found = true;
                    String isbn = rs.getString("ISBN");
                    int oldCopy = rs.getInt("Copy#");
    
                    sb.append("Damaged Copy Found - ISBN: ").append(isbn).append(", Copy#: ").append(oldCopy).append("\n");
    
                    TextInputDialog dialog = new TextInputDialog();
                    dialog.setTitle("Replace Copy");
                    dialog.setHeaderText("Damaged Copy: ISBN " + isbn + ", Copy# " + oldCopy);
                    dialog.setContentText("Enter new copy number:");
    
                    dialog.showAndWait().ifPresent(newCopyStr -> {
                        try {
                            int newCopy = Integer.parseInt(newCopyStr);
                            String insertSQL = "INSERT INTO Book_Copies (ISBN, Copy#, Status) VALUES (?, ?, 'Available')";
                            PreparedStatement insertStmt = con.prepareStatement(insertSQL);
                            insertStmt.setString(1, isbn);
                            insertStmt.setInt(2, newCopy);
                            insertStmt.executeUpdate();
                            insertStmt.close();
    
                            sb.append("→ Added replacement: Copy# ").append(newCopy).append(" (Available)\n\n");
                        } catch (Exception ex) {
                            sb.append("→ Failed to add replacement: ").append(ex.getMessage()).append("\n\n");
                        }
                    });
                }
    
                if (!found) {
                    sb.append("No damaged copies found.");
                }
    
                results.setText(sb.toString());
                rs.close();
                pstmt.close();
            } catch (Exception ex) {
                results.setText("Error: " + ex.getMessage());
            }
        });
    
        layout.getChildren().addAll(prompt, input, findBtn, results);
        stage.setScene(new Scene(layout, 500, 400));
        stage.setTitle("Replace Damaged Copies");
        stage.show();
    }
    private void showUpdateStatusWindow() {
        Stage stage = new Stage();
        VBox layout = new VBox(10);
        layout.setStyle("-fx-padding: 20;");
    
        TextField isbnField = new TextField();
        isbnField.setPromptText("ISBN");
    
        TextField copyField = new TextField();
        copyField.setPromptText("Copy Number");
    
        ComboBox<String> statusBox = new ComboBox<>();
        statusBox.getItems().addAll("Available", "Checked out", "Damaged");
        statusBox.setPromptText("Select New Status");
    
        Button updateBtn = new Button("Update Status");
        Label result = new Label();
    
        updateBtn.setOnAction(ev -> {
            String isbn = isbnField.getText().trim();
            String copyStr = copyField.getText().trim();
            String newStatus = statusBox.getValue();
    
            if (isbn.isEmpty() || copyStr.isEmpty() || newStatus == null) {
                result.setText("Please complete all fields.");
                return;
            }
    
            try {
                int copyNum = Integer.parseInt(copyStr);
    
                String checkSQL = "SELECT Status FROM Book_Copies WHERE ISBN = ? AND Copy# = ?";
                PreparedStatement checkStmt = con.prepareStatement(checkSQL);
                checkStmt.setString(1, isbn);
                checkStmt.setInt(2, copyNum);
                ResultSet rs = checkStmt.executeQuery();
    
                if (rs.next()) {
                    String currentStatus = rs.getString("Status");
                    if (currentStatus.equalsIgnoreCase("Damaged")) {
                        result.setText("Cannot update a damaged copy.");
                    } else {
                        String updateSQL = "UPDATE Book_Copies SET Status = ? WHERE ISBN = ? AND Copy# = ?";
                        PreparedStatement updateStmt = con.prepareStatement(updateSQL);
                        updateStmt.setString(1, newStatus);
                        updateStmt.setString(2, isbn);
                        updateStmt.setInt(3, copyNum);
                        int updated = updateStmt.executeUpdate();
                        updateStmt.close();
    
                        if (updated > 0) {
                            result.setText("Status updated successfully.");
                        } else {
                            result.setText("No matching book copy found.");
                        }
                    }
                } else {
                    result.setText("Book copy not found.");
                }
    
                rs.close();
                checkStmt.close();
            } catch (NumberFormatException ex) {
                result.setText("Copy# must be a number.");
            } catch (Exception ex) {
                result.setText("Error: " + ex.getMessage());
            }
        });
    
        layout.getChildren().addAll(isbnField, copyField, statusBox, updateBtn, result);
        stage.setScene(new Scene(layout, 400, 250));
        stage.setTitle("Update Book Copy Status");
        stage.show();
    }
    
}
