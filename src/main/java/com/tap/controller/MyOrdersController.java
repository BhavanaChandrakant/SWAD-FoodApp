
package com.tap.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tap.DAOImpl.MenuDAOImpl;
import com.tap.DAOImpl.OderitemDAOImpl;
import com.tap.DAOImpl.OrderTableDAOImpl;
import com.tap.DAOImpl.RestaurantDAOImpl;
import com.tap.DAOImpl.UserDAOImpl;

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

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Get the existing session.
        HttpSession session = req.getSession(false);

        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 2. Read the logged-in user's email.
        String userEmail = (String) session.getAttribute("userEmail");

        if (userEmail == null || userEmail.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            // 3. Retrieve the user from the database.
            UserDAOImpl userDAO = new UserDAOImpl();

            User user = userDAO.getUserByEmail(userEmail.trim());

            if (user == null) {
                session.removeAttribute("userEmail");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            // 4. Get this user's orders.
            OrderTableDAOImpl orderDAO = new OrderTableDAOImpl();

            List<Ordertable> orders =
                    orderDAO.getOrdersByUserId(user.getId());

            // 5. Prepare restaurant details.
            RestaurantDAOImpl restaurantDAO =
                    new RestaurantDAOImpl();

            Map<Integer, Restaurant> restaurants =
                    new HashMap<>();

            // 6. Prepare order-item details.
            OderitemDAOImpl orderItemDAO =
                    new OderitemDAOImpl();

            Map<Integer, List<Oderitem>> orderItems =
                    new HashMap<>();

            // 7. Prepare menu details.
            MenuDAOImpl menuDAO = new MenuDAOImpl();

            Map<Integer, Menu> menuDetails =
                    new HashMap<>();

            // 8. Process every order.
            if (orders != null) {
                for (Ordertable order : orders) {

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

                    List<Oderitem> items =
                            orderItemDAO.getOderitemsByOrderId(
                                    order.getOrderId()
                            );

                    orderItems.put(
                            order.getOrderId(),
                            items
                    );

                    if (items != null) {
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
                }
            }

            // 9. Send the data to MyOrders.jsp.
            req.setAttribute("orders", orders);
            req.setAttribute("restaurants", restaurants);
            req.setAttribute("orderItems", orderItems);
            req.setAttribute("menuDetails", menuDetails);

            req.getRequestDispatcher("/MyOrders.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            getServletContext().log(
                    "Unable to load the user's orders.",
                    e
            );

            resp.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load your orders. Please try again."
            );
        }
    }
}
