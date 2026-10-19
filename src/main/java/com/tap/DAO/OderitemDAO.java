package com.tap.DAO;

import java.util.List;
import com.tap.model.Oderitem;

public interface OderitemDAO {

    void addOderitem(Oderitem orderitem);

    void updateOderitem(Oderitem orderitem);

    Oderitem getOderitem(int id);

    void deleteOderitem(int id);

    List<Oderitem> getAllOderitem();

    List<Oderitem> getOderitemsByOrderId(int orderId);
}