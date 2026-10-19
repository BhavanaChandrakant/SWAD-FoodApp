package com.tap.DAO;

import java.util.List;

import com.tap.model.Restaurant;



public interface RestaurantDAO {
	void addRestaurant(Restaurant restaurant);
	void updateRestaurant(Restaurant restaurant);
	Restaurant getRestaurant(int id);
	void deleteRestaurant(int id);
	List<Restaurant>getAllRestaurant();
}
