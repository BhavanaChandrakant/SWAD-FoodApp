package com.tap.DAO;

import java.util.List;

import com.tap.model.Menu;

public interface MenuDAO {

    void addMenu(Menu menu);

    void updateMenu(Menu menu);

    Menu getMenu(int id);

    void deleteMenu(int id);

    List<Menu> getAllMenu();

    List<Menu> getAllMenuItemsByRestaurantId(int restaurantId);
}