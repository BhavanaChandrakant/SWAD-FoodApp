package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.UserDAO;
import com.tap.model.User;
import com.tap.util.DBConnection;

public class UserDAOImpl implements UserDAO {

    private static final String insert_Query =
            "insert into user(name,email,passward,phone,address,role,created_date,login_Date) "
            + "values(?,?,?,?,?,?,?,?)";

    private static final String select_Query =
            "select * from user where id=?";

    private static final String select_By_Email_Query =
            "select * from user where email=?";

    private static final String update_Query =
            "update user set name=?,email=?,passward=?,phone=?,address=?,role=?,login_Date=? "
            + "where id=?";

    private static final String delete_Query =
            "delete from user where id=?";

    private static final String select_All_Query =
            "select * from user";


    // ADD USER
    @Override
    public void addUser(User user) {

        Connection connection = DBConnection.getConnection();
        PreparedStatement pstmt = null;

        try {

            pstmt = connection.prepareStatement(insert_Query);

            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPassward());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getAddress());
            pstmt.setString(6, user.getRole());

            pstmt.setTimestamp(
                    7,
                    new Timestamp(System.currentTimeMillis())
            );

            pstmt.setTimestamp(
                    8,
                    new Timestamp(System.currentTimeMillis())
            );

            int i = pstmt.executeUpdate();

            System.out.println(i);

        } catch (SQLException e) {

            e.printStackTrace();

        } finally {

            try {

                if (pstmt != null) {
                    pstmt.close();
                }

                if (connection != null) {
                    connection.close();
                }

            } catch (SQLException e) {

                e.printStackTrace();
            }
        }
    }


    // UPDATE USER
    @Override
    public void updateUser(User user) {

        Connection connection = DBConnection.getConnection();
        PreparedStatement pstmt = null;

        try {

            pstmt = connection.prepareStatement(update_Query);

            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPassward());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getAddress());
            pstmt.setString(6, user.getRole());
            pstmt.setTimestamp(7, user.getLastLogin_date());
            pstmt.setInt(8, user.getId());

            pstmt.executeUpdate();

        } catch (SQLException e) {

            e.printStackTrace();

        } finally {

            try {

                if (pstmt != null) {
                    pstmt.close();
                }

                if (connection != null) {
                    connection.close();
                }

            } catch (SQLException e) {

                e.printStackTrace();
            }
        }
    }


    // GET USER BY ID
    @Override
    public User getUser(int id) {

        Connection connection = DBConnection.getConnection();
        PreparedStatement pstmt = null;
        ResultSet res = null;

        User user = null;

        try {

            pstmt = connection.prepareStatement(select_Query);

            pstmt.setInt(1, id);

            res = pstmt.executeQuery();

            if (res.next()) {

                user = extractUserFromResultSet(res);
            }

        } catch (SQLException e) {

            e.printStackTrace();

        } finally {

            try {

                if (res != null) {
                    res.close();
                }

                if (pstmt != null) {
                    pstmt.close();
                }

                if (connection != null) {
                    connection.close();
                }

            } catch (SQLException e) {

                e.printStackTrace();
            }
        }

        return user;
    }


    // GET USER BY EMAIL
    @Override
    public User getUserByEmail(String email) {

        Connection connection = DBConnection.getConnection();
        PreparedStatement pstmt = null;
        ResultSet res = null;

        User user = null;

        try {

            pstmt = connection.prepareStatement(select_By_Email_Query);

            pstmt.setString(1, email);

            res = pstmt.executeQuery();

            if (res.next()) {

                user = extractUserFromResultSet(res);
            }

        } catch (SQLException e) {

            e.printStackTrace();

        } finally {

            try {

                if (res != null) {
                    res.close();
                }

                if (pstmt != null) {
                    pstmt.close();
                }

                if (connection != null) {
                    connection.close();
                }

            } catch (SQLException e) {

                e.printStackTrace();
            }
        }

        return user;
    }


    // EXTRACT USER FROM RESULTSET
    private User extractUserFromResultSet(ResultSet res)
            throws SQLException {

        int id = res.getInt(1);
        String name = res.getString(2);
        String email = res.getString(3);
        String passward = res.getString(4);
        String phone = res.getString(5);
        String address = res.getString(6);
        String role = res.getString(7);

        Timestamp created_date =
                res.getTimestamp(8);

        Timestamp lastLogin_date =
                res.getTimestamp(9);

        User user = new User(
                id,
                name,
                email,
                passward,
                phone,
                address,
                role,
                created_date,
                lastLogin_date
        );

        return user;
    }


    // DELETE USER
    @Override
    public void deleteUser(int id) {

        Connection connection = DBConnection.getConnection();
        PreparedStatement pstmt = null;

        try {

            pstmt = connection.prepareStatement(delete_Query);

            pstmt.setInt(1, id);

            pstmt.executeUpdate();

        } catch (SQLException e) {

            e.printStackTrace();

        } finally {

            try {

                if (pstmt != null) {
                    pstmt.close();
                }

                if (connection != null) {
                    connection.close();
                }

            } catch (SQLException e) {

                e.printStackTrace();
            }
        }
    }
     
    
    
 // UPDATE PASSWORD ONLY
    @Override
    public boolean updatePassword(int id, String hashedPassword) {

        String query = "UPDATE user SET passward = ? WHERE id = ?";

        try (Connection connection = DBConnection.getConnection()) {

            if (connection == null) {
                return false;
            }

            try (PreparedStatement pstmt =
                         connection.prepareStatement(query)) {

                pstmt.setString(1, hashedPassword);
                pstmt.setInt(2, id);

                return pstmt.executeUpdate() == 1;
            }

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }
    

    // GET ALL USERS
    @Override
    public List<User> getAllUser() {

        List<User> allUser = new ArrayList<>();

        Connection connection = DBConnection.getConnection();
        Statement stmt = null;
        ResultSet res = null;

        try {

            stmt = connection.createStatement();

            res = stmt.executeQuery(select_All_Query);

            while (res.next()) {

                User user =
                        extractUserFromResultSet(res);

                allUser.add(user);
            }

        } catch (SQLException e) {

            e.printStackTrace();

        } finally {

            try {

                if (res != null) {
                    res.close();
                }

                if (stmt != null) {
                    stmt.close();
                }

                if (connection != null) {
                    connection.close();
                }

            } catch (SQLException e) {

                e.printStackTrace();
            }
        }

        return allUser;
    }
}