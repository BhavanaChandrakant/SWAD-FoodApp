package com.tap.model;

import java.util.HashMap;
import java.util.Map;

public class Cart {

    private Map<Integer, CartItem> items;

    private int restaurantId;

    public Cart() {

        items = new HashMap<>();

        restaurantId = 0;
    }

    public Map<Integer, CartItem> getItems() {

        return items;
    }

    public int getRestaurantId() {

        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {

        this.restaurantId = restaurantId;
    }

    public boolean addItem(CartItem newItem) {

        int newRestaurantId = newItem.getRestaurantId();

        // Cart already contains items from another restaurant
        if (!items.isEmpty() &&
            restaurantId != newRestaurantId) {

            return false;
        }

        // First item being added
        if (items.isEmpty()) {

            restaurantId = newRestaurantId;
        }

        int menuId = newItem.getMenuId();

        // Item already exists
        if (items.containsKey(menuId)) {

            CartItem existingItem = items.get(menuId);

            existingItem.setQuantity(
                existingItem.getQuantity()
                + newItem.getQuantity()
            );

        } else {

            items.put(menuId, newItem);
        }

        return true;
    }

    public void updateItem(int menuId, int quantity) {

        if (items.containsKey(menuId)) {

            CartItem item = items.get(menuId);

            item.setQuantity(quantity);
        }
    }

    public void removeItem(int menuId) {

        items.remove(menuId);

        // If cart becomes empty,
        // remove the restaurant association too
        if (items.isEmpty()) {

            restaurantId = 0;
        }
    }

    public void clearCart() {

        items.clear();

        restaurantId = 0;
    }

    public float getTotal() {

        float total = 0;

        for (CartItem item : items.values()) {

            total = total + item.getItemTotal();
        }

        return total;
    }

    public boolean isEmpty() {

        return items.isEmpty();
    }

    public int getTotalItems() {

        int count = 0;

        for (CartItem item : items.values()) {

            count = count + item.getQuantity();
        }

        return count;
    }
}