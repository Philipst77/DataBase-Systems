package gui;

import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

public class Main extends Application {

    @Override
    public void start(Stage primaryStage) {
        Label label = new Label("Library Database System");

        Button searchBtn = new Button("Search Books");
        Button availableBtn = new Button("Show Available Copies");
        Button replaceBtn = new Button("Replace Damaged Copies");
        Button updateBtn = new Button("Update Book Copy Status");

        VBox root = new VBox(10);
        root.setStyle("-fx-padding: 20;");
        root.getChildren().addAll(label, searchBtn, availableBtn, replaceBtn, updateBtn);

        Scene scene = new Scene(root, 400, 250);
        primaryStage.setScene(scene);
        primaryStage.setTitle("Library GUI");
        primaryStage.show();
    }

    public static void main(String[] args) {
        launch(args);
    }
}
