package com.tap.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import com.mysql.jdbc.Driver;

public class DBConnection {
	
	private static final String URL = "jdbc:mysql://localhost:3306/foodapp";
	private static final String USERNAME =
	        System.getenv("FOODAPP_DB_USERNAME");

	private static final String PASSWORD =
	        System.getenv("FOODAPP_DB_PASSWORD");
	private static Connection connection =null;

	
		public static Connection getConnection()
		{
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				connection =DriverManager.getConnection(URL,USERNAME,PASSWORD);
			} 
			catch (ClassNotFoundException e) {
				
				e.printStackTrace();
			} 
			catch (SQLException e) {
				
				e.printStackTrace();
			}
			return connection;
			
		}
	
	

}
