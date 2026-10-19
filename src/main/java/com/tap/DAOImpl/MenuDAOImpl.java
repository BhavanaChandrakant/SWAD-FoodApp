package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.MenuDAO;
import com.tap.model.Menu;
import com.tap.util.DBConnection;

public class MenuDAOImpl implements MenuDAO {

    private static final String insert_Query =
            "INSERT INTO Menu(RestaurantID, ItemName, Description, Price, IsAvailable, Category, CreatedAt, UpdatedAt, DeletedAt, ImagePath) "
            + "VALUES(?,?,?,?,?,?,?,?,?,?)";

    private static final String update_Query =
            "UPDATE Menu SET RestaurantID=?, ItemName=?, Description=?, Price=?, IsAvailable=?, Category=?, ImagePath=? "
            + "WHERE MenuID=?";

    private static final String select_Query =
            "SELECT * FROM Menu WHERE MenuID=?";

    private static final String delete_Query =
            "DELETE FROM Menu WHERE MenuID=?";

    private static final String select_All_Query =
            "SELECT * FROM Menu";

    private static final String select_All_By_Restaurant_Query =
            "SELECT * FROM Menu WHERE RestaurantID=?";


    @Override
    public void addMenu(Menu menu) {

        Connection connection = DBConnection.getConnection();

        try {

            PreparedStatement pstmt =
                    connection.prepareStatement(insert_Query);

            pstmt.setInt(1, menu.getRestaurantID());
            pstmt.setString(2, menu.getItemName());
            pstmt.setString(3, menu.getDescription());
            pstmt.setFloat(4, menu.getPrice());
            pstmt.setInt(5, menu.getIsAvailable());
            pstmt.setString(6, menu.getCategory());

            pstmt.setTimestamp(7,
                    new Timestamp(System.currentTimeMillis()));

            pstmt.setTimestamp(8,
                    new Timestamp(System.currentTimeMillis()));

            // Item is not deleted when it is created
            pstmt.setTimestamp(9, null);

            pstmt.setString(10, menu.getImagePath());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public void updateMenu(Menu menu) {

        Connection connection = DBConnection.getConnection();

        try {

            PreparedStatement pstmt =
                    connection.prepareStatement(update_Query);

            pstmt.setInt(1, menu.getRestaurantID());
            pstmt.setString(2, menu.getItemName());
            pstmt.setString(3, menu.getDescription());
            pstmt.setFloat(4, menu.getPrice());
            pstmt.setInt(5, menu.getIsAvailable());
            pstmt.setString(6, menu.getCategory());
            pstmt.setString(7, menu.getImagePath());
            pstmt.setInt(8, menu.getMenuID());

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public Menu getMenu(int id) {

        Connection connection = DBConnection.getConnection();

        Menu menu = null;

        try {

            PreparedStatement pstmt =
                    connection.prepareStatement(select_Query);

            pstmt.setInt(1, id);

            ResultSet res = pstmt.executeQuery();

            if (res.next()) {
                menu = extractMenuFromResultSet(res);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menu;
    }


    private Menu extractMenuFromResultSet(ResultSet res)
            throws SQLException {

        int menuId = res.getInt(1);
        int restaurantId = res.getInt(2);
        String itemName = res.getString(3);
        String description = res.getString(4);
        float price = res.getFloat(5);
        int isAvailable = res.getInt(6);
        String category = res.getString(7);

        Timestamp createdDate = res.getTimestamp(8);
        Timestamp updatedAt = res.getTimestamp(9);
        Timestamp deletedAt = res.getTimestamp(10);

        // ImagePath is the 11th column
        String imagePath = res.getString(11);

        Menu menu = new Menu(
                menuId,
                restaurantId,
                itemName,
                description,
                price,
                isAvailable,
                category,
                createdDate,
                updatedAt,
                deletedAt,
                imagePath
        );

        return menu;
    }


    @Override
    public void deleteMenu(int id) {

        Connection connection = DBConnection.getConnection();

        try {

            PreparedStatement pstmt =
                    connection.prepareStatement(delete_Query);

            pstmt.setInt(1, id);

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public List<Menu> getAllMenu() {

        List<Menu> menuList = new ArrayList<>();

        Connection connection = DBConnection.getConnection();

        try {

            Statement stmt = connection.createStatement();

            ResultSet res =
                    stmt.executeQuery(select_All_Query);

            while (res.next()) {

                Menu menu = extractMenuFromResultSet(res);

                menuList.add(menu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menuList;
    }


    // Get all menu items belonging to one restaurant
    @Override
    public List<Menu> getAllMenuItemsByRestaurantId(int restaurantId) {

        List<Menu> menuList = new ArrayList<>();

        Connection connection = DBConnection.getConnection();

        try {

            PreparedStatement pstmt =
                    connection.prepareStatement(
                            select_All_By_Restaurant_Query);

            pstmt.setInt(1, restaurantId);

            ResultSet res = pstmt.executeQuery();

            while (res.next()) {

                Menu menu = extractMenuFromResultSet(res);

                menuList.add(menu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menuList;
    }
}