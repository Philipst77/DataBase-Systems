package src;

import java.sql.*;
import java.util.Scanner;

public class DatabaseUtil {
    private static Connection con;

    public static Connection connect(String username, String password) {
        String driverPrefixURL = "jdbc:oracle:thin:@";
        String jdbc_url = "artemis.vsnet.gmu.edu:1521/vse18c.vsnet.gmu.edu";
    
        try {
            System.out.println("Attempting connection for user: " + username);
            Connection con = DriverManager.getConnection(driverPrefixURL + jdbc_url, username, password);
            System.out.println("Connected to Oracle.");
            return con;
        } catch (SQLException e) {
            System.out.println("Connection failed: " + e.getMessage());
            e.printStackTrace(); 
            return null;
        }
    }
}