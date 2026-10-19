package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.OrdertableDAO;
import com.tap.model.Ordertable;
import com.tap.util.DBConnection;

public class OrderTableDAOImpl implements OrdertableDAO {

    private static final String insert_Query =
            "INSERT INTO ordertable(UserId, RestaurantID, OrderDate, TotalAmount, Status, PaymentMethod) "
            + "VALUES(?,?,?,?,?,?)";

    private static final String update_Query =
            "UPDATE ordertable SET TotalAmount=?, Status=?, PaymentMethod=? WHERE OrderId=?";

    private static final String select_Query =
            "SELECT * FROM ordertable WHERE OrderID=?";

    private static final String delete_Query =
            "DELETE FROM ordertable WHERE OrderID=?";

    private static final String select_All_Query =
            "SELECT * FROM ordertable";
    
    private static final String select_By_User_Query =
            "SELECT * FROM ordertable WHERE UserId=?";


    // ADD ORDER
    @Override
    public int addOrdertable(Ordertable ordertable) {

        int orderId = 0;

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(
                    insert_Query,
                    Statement.RETURN_GENERATED_KEYS
            )
        ) {

            pstmt.setInt(1, ordertable.getUserId());
            pstmt.setInt(2, ordertable.getRestaurantId());
            pstmt.setTimestamp(3, ordertable.getOrderDate());
            pstmt.setDouble(4, ordertable.getTotalAmount());
            pstmt.setString(5, ordertable.getStatus());
            pstmt.setString(6, ordertable.getPaymentMethod());

            pstmt.executeUpdate();

            // Get automatically generated OrderID
            try (ResultSet res = pstmt.getGeneratedKeys()) {

                if (res.next()) {
                    orderId = res.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return orderId;
    }


    // UPDATE ORDER
    @Override
    public void updateOrdertable(Ordertable ordertable) {

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(update_Query)
        ) {

            pstmt.setDouble(1, ordertable.getTotalAmount());
            pstmt.setString(2, ordertable.getStatus());
            pstmt.setString(3, ordertable.getPaymentMethod());
            pstmt.setInt(4, ordertable.getOrderId());

            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    // GET ORDER BY ID
    @Override
    public Ordertable getOrdertable(int id) {

        Ordertable ordertable = null;

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(select_Query)
        ) {

            pstmt.setInt(1, id);

            try (ResultSet res = pstmt.executeQuery()) {

                if (res.next()) {
                    ordertable = extractOrdertableFromResultSet(res);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ordertable;
    }


    // DELETE ORDER
    @Override
    public void deleteOrdertable(int id) {

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(delete_Query)
        ) {

            pstmt.setInt(1, id);

            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    // GET ALL ORDERS
    @Override
    public List<Ordertable> getAllOrdertable() {

        List<Ordertable> list = new ArrayList<>();

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement(select_All_Query);
            ResultSet res = pstmt.executeQuery()
        ) {

            while (res.next()) {

                list.add(extractOrdertableFromResultSet(res));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    @Override
    public List<Ordertable> getOrdersByUserId(int userId) {

        List<Ordertable> list = new ArrayList<>();

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pstmt =
                    con.prepareStatement(select_By_User_Query)
        ) {

            pstmt.setInt(1, userId);

            try (ResultSet res = pstmt.executeQuery()) {

                while (res.next()) {

                    Ordertable ordertable =
                            extractOrdertableFromResultSet(res);

                    list.add(ordertable);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    // EXTRACT ORDER FROM RESULTSET
    private Ordertable extractOrdertableFromResultSet(ResultSet res)
            throws Exception {

        Ordertable ordertable = new Ordertable();

        ordertable.setOrderId(res.getInt("OrderID"));
        ordertable.setUserId(res.getInt("UserId"));
        ordertable.setRestaurantId(res.getInt("RestaurantID"));
        ordertable.setOrderDate(res.getTimestamp("OrderDate"));
        ordertable.setTotalAmount(res.getDouble("TotalAmount"));
        ordertable.setStatus(res.getString("Status"));
        ordertable.setPaymentMethod(res.getString("PaymentMethod"));

        return ordertable;
    }
}