package com.tap.controller;

import java.io.IOException;

import com.tap.model.Cart;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
                         throws ServletException, IOException {

        HttpSession session = req.getSession();

        // Get logged-in user
        User user = (User) session.getAttribute("user");

        if (user == null) {

            // Remember that user should go to Cart after login
            session.setAttribute("afterLogin", "cart");

            resp.sendRedirect(req.getContextPath() + "/login");

            return;
        }

        // Get cart
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {

            resp.sendRedirect(req.getContextPath() + "/cart");

            return;
        }

        req.setAttribute("cart", cart);

        req.getRequestDispatcher("Checkout.jsp")
           .forward(req, resp);
    }
}