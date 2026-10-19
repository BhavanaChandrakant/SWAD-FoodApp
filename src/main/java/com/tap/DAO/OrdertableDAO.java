package com.tap.DAO;

import java.util.List;

import com.tap.model.Ordertable;

public interface OrdertableDAO {

    int addOrdertable(Ordertable ordertable);

    void updateOrdertable(Ordertable ordertable);

    Ordertable getOrdertable(int id);

    void deleteOrdertable(int id);

    List<Ordertable> getAllOrdertable();
    
    List<Ordertable> getOrdersByUserId(int userId);
}