
package com.tap.controller;

import java.io.IOException;
import java.sql.Timestamp;

import com.tap.DAOImpl.OderitemDAOImpl;
import com.tap.DAOImpl.OrderTableDAOImpl;
import com.tap.DAOImpl.UserDAOImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Oderitem;
import com.tap.model.Ordertable;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/placeOrder")
public class PlaceOrderController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // 1. Get the existing session without creating a new one.
        HttpSession session = req.getSession(false);

        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 2. Get the logged-in user's email from the session.
        String userEmail = (String) session.getAttribute("userEmail");

        if (userEmail == null || userEmail.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 3. Retrieve the user from the database.
        User user;

        try {
            UserDAOImpl userDAO = new UserDAOImpl();
            user = userDAO.getUserByEmail(userEmail.trim());
        } catch (Exception e) {
            getServletContext().log("Error retrieving user for order.", e);
            resp.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to retrieve user details."
            );
            return;
        }

        if (user == null) {
            session.removeAttribute("userEmail");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 4. Get the cart from the same session.
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // 5. Validate the payment method.
        String paymentMethod = req.getParameter("paymentMethod");

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/checkout");
            return;
        }

        paymentMethod = paymentMethod.trim();

        if (!paymentMethod.equals("UPI")
                && !paymentMethod.equals("Card")
                && !paymentMethod.equals("Cash")) {
            resp.sendRedirect(req.getContextPath() + "/checkout");
            return;
        }

        try {
            // 6. Get the restaurant ID from the first cart item.
            CartItem firstItem = cart.getItems().values().iterator().next();
            int restaurantId = firstItem.getRestaurantId();

            // 7. Create the order.
            Ordertable order = new Ordertable(
                user.getId(),
                restaurantId,
                new Timestamp(System.currentTimeMillis()),
                cart.getTotal(),
                "Pending",
                paymentMethod
            );

            // 8. Save the order.
            OrderTableDAOImpl orderDAO = new OrderTableDAOImpl();
            int orderId = orderDAO.addOrdertable(order);

            if (orderId <= 0) {
                req.setAttribute(
                    "error",
                    "Unable to place order. Please try again."
                );
                req.setAttribute("cart", cart);
                req.setAttribute("user", user);

                req.getRequestDispatcher("/Checkout.jsp")
                   .forward(req, resp);
                return;
            }

            // 9. Save each order item.
            OderitemDAOImpl orderItemDAO = new OderitemDAOImpl();

            for (CartItem item : cart.getItems().values()) {
                Oderitem orderItem = new Oderitem(
                    orderId,
                    item.getMenuId(),
                    item.getQuantity(),
                    item.getItemTotal()
                );

                orderItemDAO.addOderitem(orderItem);
            }

            // 10. Clear the cart after placing the order.
            cart.clearCart();
            session.setAttribute("cart", cart);

            // 11. Forward order details to the confirmation page.
            req.setAttribute("orderId", orderId);
            req.setAttribute("totalAmount", order.getTotalAmount());
            req.setAttribute("paymentMethod", paymentMethod);

            req.getRequestDispatcher("/OrderConfirmation.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            getServletContext().log("Error placing order.", e);

            resp.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "An error occurred while placing your order."
            );
        }
    }
}
