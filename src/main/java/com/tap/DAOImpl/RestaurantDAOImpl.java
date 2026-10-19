package com.tap.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.RestaurantDAO;
import com.tap.model.Menu;
import com.tap.model.Restaurant;
import com.tap.util.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {
	private static final String insert_Query="insert into restaurant(Name,CuisineType,DeliveryTime,Address,Rating,IsActive) values(?,?,?,?,?,?)";
	private static final String update_Query="update restaurant set Name=?,CuisineType=?,DeliveryTime=?,Address=?,AdimUserID=?,Rating=?,IsActive=? where RestaurantID=?";
	private static final String select_Query="select * from restaurant  where RestaurantID=?";
	private static final String delete_Query="delete from restaurant where RestaurantID=?";
	private static final String select_All_Query="select * from restaurant";
	 
	
	 
	@Override
	public void addRestaurant(Restaurant rest) {
		Connection connection=DBConnection.getConnection();
		try {
			PreparedStatement pstmt=connection.prepareStatement(insert_Query);
			pstmt.setString(1, rest.getName());
			pstmt.setString(2, rest.getCuisineType());
			pstmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
			pstmt.setString(4, rest.getAddress());
			pstmt.setDouble(5,rest.getRating());
			pstmt.setInt(6, rest.getIsActive());
			
			int i=pstmt.executeUpdate();
			System.out.print(i);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	@Override
	public void updateRestaurant(Restaurant rest) {
		Connection connection=DBConnection.getConnection();
		try {
			PreparedStatement pstmt=connection.prepareStatement(update_Query);
			pstmt.setString(1, rest.getName());
			pstmt.setString(2, rest.getCuisineType());
			pstmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
			pstmt.setString(4, rest.getAddress());
			pstmt.setInt(5, rest.getAdimUserId());
			pstmt.setDouble(6,rest.getRating());
			pstmt.setInt(7, rest.getIsActive());
			pstmt.setInt(8, rest.getRestaurantId());
			int i=pstmt.executeUpdate();
			System.out.print(i+"affected");
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	@Override
	public Restaurant getRestaurant(int id) {
		Connection connection=DBConnection.getConnection();
		Restaurant  rest=null;
		try {
			PreparedStatement pstmt=connection.prepareStatement(select_Query);
			pstmt.setInt(1, id);
			ResultSet res =pstmt.executeQuery();
			 if (res.next()) {
		            rest = extractRestaurantFromResultSet(res);
		        }
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return rest;
	}
	private Restaurant extractRestaurantFromResultSet(ResultSet rs)
	        throws SQLException {

	    Restaurant restaurant = new Restaurant();

	    restaurant.setRestaurantId(
	            rs.getInt("RestaurantID"));

	    restaurant.setName(
	            rs.getString("Name"));

	    restaurant.setCuisineType(
	            rs.getString("CuisineType"));

	    restaurant.setDeleiveryTime(
	            rs.getTimestamp("DeliveryTime"));

	    restaurant.setAddress(
	            rs.getString("Address"));

	    restaurant.setAdminUserId(
	            rs.getInt("AdimUserID"));

	    restaurant.setRating(
	            rs.getDouble("Rating"));

	    restaurant.setIsActive(
	            rs.getInt("IsActive"));

	    restaurant.setImagePath(
	            rs.getString("ImagePath"));

	    return restaurant;
	}

	@Override
	public void deleteRestaurant(int id) {
		Connection connection=DBConnection.getConnection();
		try {
			PreparedStatement pstmt=connection.prepareStatement(delete_Query);
			pstmt.setInt(1, id);
			pstmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	@Override
	public List<Restaurant> getAllRestaurant() {

	    List<Restaurant> restaurants = new ArrayList<>();

	    try (Connection connection = DBConnection.getConnection()) {

	        // Check whether the connection was created successfully
	        if (connection == null) {
	            throw new SQLException(
	                "Database connection is null. Check DBConnection.java."
	            );
	        }

	        try (Statement stmt = connection.createStatement();
	             ResultSet res = stmt.executeQuery(select_All_Query)) {

	            while (res.next()) {

	                Restaurant rest = extractRestaurantFromResultSet(res);

	                restaurants.add(rest);
	            }
	        }

	    } catch (SQLException e) {

	        e.printStackTrace();

	        throw new RuntimeException(
	            "Failed to retrieve restaurants from the database.", e
	        );
	    }

	    return restaurants;
	}
	

}
