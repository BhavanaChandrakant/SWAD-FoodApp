
package com.tap.controller;

import java.io.IOException;

import com.tap.DAOImpl.UserDAOImpl;
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

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();

        // Do not create a new session just to check authentication.
        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(contextPath + "/login");
            return;
        }

        String email = (String) session.getAttribute("userEmail");

        if (email == null || email.trim().isEmpty()) {
            session.setAttribute("afterLogin", "checkout");
            response.sendRedirect(contextPath + "/login");
            return;
        }

        try {
            UserDAOImpl userDAO = new UserDAOImpl();
            User user = userDAO.getUserByEmail(email.trim());

            if (user == null) {
                session.removeAttribute("userEmail");
                session.setAttribute("afterLogin", "checkout");

                response.sendRedirect(contextPath + "/login");
                return;
            }

            Cart cart = (Cart) session.getAttribute("cart");

            if (cart == null || cart.getTotalItems() <= 0) {
                response.sendRedirect(contextPath + "/cart");
                return;
            }

            // Request attributes are available to Checkout.jsp only.
            // The User object is not stored in the session.
            request.setAttribute("user", user);
            request.setAttribute("cart", cart);

            request.getRequestDispatcher("/Checkout.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            getServletContext().log(
                "Unable to load checkout.", e
            );

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load checkout. Please check the server console."
            );
        }
    }
}
