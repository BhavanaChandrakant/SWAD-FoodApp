package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.DAOImpl.MenuDAOImpl;
import com.tap.model.Menu;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menu")
public class MenuController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Get restaurant ID from URL
        int restaurantId = Integer.parseInt(
                req.getParameter("restaurantId")
        );

        // Create DAO object
        MenuDAOImpl menuDao = new MenuDAOImpl();

        // Get menu items for that restaurant
        List<Menu> menuList =
                menuDao.getAllMenuItemsByRestaurantId(restaurantId);

        // Send menu list to JSP
        req.setAttribute("menuList", menuList);

        // Forward to menu.jsp
        RequestDispatcher rd =
                req.getRequestDispatcher("Menu.jsp");

        rd.forward(req, resp);
    }
}