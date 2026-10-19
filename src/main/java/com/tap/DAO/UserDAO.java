package com.tap.DAO;

import java.util.List;

import com.tap.model.User;

public interface UserDAO {

    void addUser(User user);

    void updateUser(User user);

    User getUser(int id);

    void deleteUser(int id);

    List<User> getAllUser();

    User getUserByEmail(String email);
    
    boolean updatePassword(int id, String hashedPassword);
}