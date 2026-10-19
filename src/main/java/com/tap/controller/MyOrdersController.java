package com.tap.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tap.DAOImpl.MenuDAOImpl;
import com.tap.DAOImpl.OderitemDAOImpl;
import com.tap.DAOImpl.OrderTableDAOImpl;
import com.tap.DAOImpl.RestaurantDAOImpl;

import com.tap.model.Menu;
import com.tap.model.Oderitem;
import com.tap.model.Ordertable;
import com.tap.model.Restaurant;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orders")
public class MyOrdersController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
                         throws ServletException, IOException {

        HttpSession session = req.getSession();

        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // -----------------------------------
        // 1. Get user's orders
        // -----------------------------------

        OrderTableDAOImpl orderDAO =
                new OrderTableDAOImpl();

        List<Ordertable> orders =
                orderDAO.getOrdersByUserId(user.getId());


        // -----------------------------------
        // 2. Restaurant names/details
        // -----------------------------------

        RestaurantDAOImpl restaurantDAO =
                new RestaurantDAOImpl();

        Map<Integer, Restaurant> restaurants =
                new HashMap<>();


        // -----------------------------------
        // 3. Order items
        // -----------------------------------

        OderitemDAOImpl orderItemDAO =
                new OderitemDAOImpl();

        Map<Integer, List<Oderitem>> orderItems =
                new HashMap<>();


        // -----------------------------------
        // 4. Menu details
        // -----------------------------------

        MenuDAOImpl menuDAO =
                new MenuDAOImpl();

        Map<Integer, Menu> menuDetails =
                new HashMap<>();


        // -----------------------------------
        // Process every order
        // -----------------------------------

        for (Ordertable order : orders) {

            // Get restaurant
            Restaurant restaurant =
                    restaurantDAO.getRestaurant(
                            order.getRestaurantId()
                    );

            if (restaurant != null) {

                restaurants.put(
                        order.getRestaurantId(),
                        restaurant
                );
            }


            // Get items belonging to this order
            List<Oderitem> items =
                    orderItemDAO.getOderitemsByOrderId(
                            order.getOrderId()
                    );

            orderItems.put(
                    order.getOrderId(),
                    items
            );


            // Get menu information for every item
            for (Oderitem item : items) {

                Menu menu =
                        menuDAO.getMenu(
                                item.getMenuId()
                        );

                if (menu != null) {

                    menuDetails.put(
                            item.getMenuId(),
                            menu
                    );
                }
            }
        }


        // -----------------------------------
        // Send data to JSP
        // -----------------------------------

        req.setAttribute("orders", orders);

        req.setAttribute(
                "restaurants",
                restaurants
        );

        req.setAttribute(
                "orderItems",
                orderItems
        );

        req.setAttribute(
                "menuDetails",
                menuDetails
        );


        req.getRequestDispatcher(
                "MyOrders.jsp"
        ).forward(req, resp);
    }
}