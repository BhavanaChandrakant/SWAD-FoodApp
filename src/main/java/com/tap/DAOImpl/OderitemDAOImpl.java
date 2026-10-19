package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.OderitemDAO;
import com.tap.model.Oderitem;
import com.tap.util.DBConnection;

public class OderitemDAOImpl implements OderitemDAO {

    private static final String insert_Query =
            "INSERT INTO orderitem(OrderID, MenuID, Quantity, ItemTotal) VALUES(?,?,?,?)";

    private static final String update_Query =
            "UPDATE orderitem SET Quantity=?, ItemTotal=? WHERE OrderItemID=?";

    private static final String select_Query =
            "select * from orderitem where OrderItemID=?";

    private static final String delete_Query =
            "delete from orderitem where OrderItemID=?";

    private static final String select_All_Query =
            "select * from orderitem";

    private static final String select_By_Order_Query =
            "select * from orderitem where OrderID=?";


    @Override
    public void addOderitem(Oderitem orderitem) {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement pstmt = connection.prepareStatement(insert_Query)
        ) {

            pstmt.setInt(1, orderitem.getOrderId());
            pstmt.setInt(2, orderitem.getMenuId());
            pstmt.setInt(3, orderitem.getQuantity());
            pstmt.setDouble(4, orderitem.getItemTotal());

            int i = pstmt.executeUpdate();

            System.out.println(i + " affected");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public void updateOderitem(Oderitem orderitem) {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement pstmt = connection.prepareStatement(update_Query)
        ) {

            pstmt.setInt(1, orderitem.getQuantity());
            pstmt.setDouble(2, orderitem.getItemTotal());
            pstmt.setInt(3, orderitem.getOrderItemID());

            int i = pstmt.executeUpdate();

            System.out.println(i + " affected");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public Oderitem getOderitem(int id) {

        Oderitem orderItem = null;

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement pstmt = connection.prepareStatement(select_Query)
        ) {

            pstmt.setInt(1, id);

            try (ResultSet res = pstmt.executeQuery()) {

                if (res.next()) {
                    orderItem = extractOderitemFromResultSet(res);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItem;
    }


    @Override
    public List<Oderitem> getOderitemsByOrderId(int orderId) {

        List<Oderitem> list = new ArrayList<>();

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement pstmt =
                    connection.prepareStatement(select_By_Order_Query)
        ) {

            pstmt.setInt(1, orderId);

            try (ResultSet res = pstmt.executeQuery()) {

                while (res.next()) {

                    Oderitem orderItem =
                            extractOderitemFromResultSet(res);

                    list.add(orderItem);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }


    private Oderitem extractOderitemFromResultSet(ResultSet res)
            throws SQLException {

        int orderitemId = res.getInt(1);
        int oderId = res.getInt(2);
        int menuId = res.getInt(3);
        int quantity = res.getInt(4);
        double itemTotal = res.getDouble(5);

        Oderitem orderItem =
                new Oderitem(
                        orderitemId,
                        oderId,
                        menuId,
                        quantity,
                        itemTotal
                );

        return orderItem;
    }


    @Override
    public void deleteOderitem(int id) {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement pstmt = connection.prepareStatement(delete_Query)
        ) {

            pstmt.setInt(1, id);

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public List<Oderitem> getAllOderitem() {

        List<Oderitem> al = new ArrayList<>();

        try (
            Connection connection = DBConnection.getConnection();
            Statement stmt = connection.createStatement();
            ResultSet res = stmt.executeQuery(select_All_Query)
        ) {

            while (res.next()) {

                Oderitem orderItem =
                        extractOderitemFromResultSet(res);

                al.add(orderItem);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return al;
    }
}