package com.tap.model;

import java.sql.Timestamp;

public class Restaurant {

    private int restaurantId;
    private String name;
    private String cuisineType;
    private Timestamp deleiveryTime;
    private String address;
    private int adimUserId;
    private double rating;
    private int isActive;
    private String imagePath;


    // Default constructor
    public Restaurant() {

    }


    // Constructor
    public Restaurant(String name, String cuisineType, String address,
            double rating, int isActive) {

        super();

        this.name = name;
        this.cuisineType = cuisineType;
        this.address = address;
        this.rating = rating;
        this.isActive = isActive;
    }


    // Parameterized constructor
    public Restaurant(int restaurantId, String name, String cuisineType,
            Timestamp deleiveryTime, String address,
            int adminUserId, double rating, int isActive) {

        super();

        this.restaurantId = restaurantId;
        this.name = name;
        this.cuisineType = cuisineType;
        this.deleiveryTime = deleiveryTime;
        this.address = address;
        this.adimUserId = adminUserId;
        this.rating = rating;
        this.isActive = isActive;
    }


    // Restaurant ID
    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }


    // Name
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }


    // Cuisine Type
    public String getCuisineType() {
        return cuisineType;
    }

    public void setCuisineType(String cuisineType) {
        this.cuisineType = cuisineType;
    }


    // Delivery Time
    public Timestamp getDeleiveryTime() {
        return deleiveryTime;
    }

    public void setDeleiveryTime(Timestamp deleiveryTime) {
        this.deleiveryTime = deleiveryTime;
    }


    // Address
    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }


    // Admin User ID
    public int getAdimUserId() {
        return adimUserId;
    }

    public void setAdminUserId(int adminUserId) {
        this.adimUserId = adminUserId;
    }


    // Rating
    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }


    // Active Status
    public int getIsActive() {
        return isActive;
    }

    public void setIsActive(int isActive) {
        this.isActive = isActive;
    }


    // Image Path
    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }


    // toString
    @Override
    public String toString() {

        return "Restaurant [restaurantId=" + restaurantId
                + ", name=" + name
                + ", cuisineType=" + cuisineType
                + ", deleiveryTime=" + deleiveryTime
                + ", address=" + address
                + ", adminUserId=" + adimUserId
                + ", rating=" + rating
                + ", isActive=" + isActive
                + ", imagePath=" + imagePath + "]";
    }
}