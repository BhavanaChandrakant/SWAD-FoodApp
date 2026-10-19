package com.tap.controller;

import java.io.IOException;
import java.sql.Timestamp;

import com.tap.DAOImpl.OderitemDAOImpl;
import com.tap.DAOImpl.OrderTableDAOImpl;
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

    @Override
    protected void doPost(HttpServletRequest req,
                           HttpServletResponse resp)
                           throws ServletException, IOException {

        // 1. Get session
        HttpSession session = req.getSession();

        // 2. Get logged-in user
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 3. Get cart
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // 4. Get payment method
        String paymentMethod = req.getParameter("paymentMethod");

        if (paymentMethod == null || paymentMethod.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/checkout");
            return;
        }

        // 5. Get restaurant ID from cart
        CartItem firstItem = cart.getItems().values().iterator().next();

        int restaurantId = firstItem.getRestaurantId();

        // 6. Create Ordertable object
        Ordertable order = new Ordertable(
                user.getId(),
                restaurantId,
                new Timestamp(System.currentTimeMillis()),
                cart.getTotal(),
                "Pending",
                paymentMethod
        );

        // 7. Insert order into OrderTable
        OrderTableDAOImpl orderDAO = new OrderTableDAOImpl();

        int orderId = orderDAO.addOrdertable(order);

        // 8. Check whether order was inserted
        if (orderId == 0) {

            req.setAttribute("error",
                    "Unable to place order. Please try again.");

            req.setAttribute("cart", cart);

            req.getRequestDispatcher("Checkout.jsp")
               .forward(req, resp);

            return;
        }

        // 9. Insert every cart item into OrderItem
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

        // 10. Clear cart after successful order
        cart.clearCart();

        // 11. Send details to confirmation page
        req.setAttribute("orderId", orderId);
        req.setAttribute("totalAmount", order.getTotalAmount());
        req.setAttribute("paymentMethod", paymentMethod);

        // 12. Forward to confirmation page
        req.getRequestDispatcher("OrderConfirmation.jsp")
           .forward(req, resp);
    }
}