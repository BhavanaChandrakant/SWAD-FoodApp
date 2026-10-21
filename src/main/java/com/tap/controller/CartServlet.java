
package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.DAOImpl.MenuDAOImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        req.setAttribute("cart", cart);
        req.getRequestDispatcher("Cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Missing cart action parameter.");
            return;
        }

        HttpSession session = req.getSession();

        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        try {

            // ADD ITEM
            if ("add".equals(action)) {

                int menuId = getRequiredInt(req, "menuId");
                int restaurantId = getRequiredInt(req, "restaurantId");

                String itemName = getRequiredString(req, "itemName");
                float price = getRequiredFloat(req, "price");
                String imagePath = req.getParameter("imagePath");

                CartItem cartItem = new CartItem(
                        menuId,
                        restaurantId,
                        itemName,
                        price,
                        1,
                        imagePath
                );

                boolean added = cart.addItem(cartItem);

                if (added) {
                    resp.sendRedirect(
                            req.getContextPath()
                            + "/menu?restaurantId=" + restaurantId
                    );
                } else {
                    req.setAttribute("differentRestaurant", true);
                    req.setAttribute("menuId", menuId);
                    req.setAttribute("restaurantId", restaurantId);
                    req.setAttribute("itemName", itemName);
                    req.setAttribute("price", price);
                    req.setAttribute("imagePath", imagePath);

                    MenuDAOImpl menuDao = new MenuDAOImpl();

                    List<Menu> menuList =
                            menuDao.getAllMenuItemsByRestaurantId(restaurantId);

                    req.setAttribute("menuList", menuList);
                    req.getRequestDispatcher("Menu.jsp").forward(req, resp);
                }
            }

            // CLEAR CART AND ADD NEW ITEM
            else if ("clearAndAdd".equals(action)) {

                int menuId = getRequiredInt(req, "menuId");
                int restaurantId = getRequiredInt(req, "restaurantId");

                String itemName = getRequiredString(req, "itemName");
                float price = getRequiredFloat(req, "price");
                String imagePath = req.getParameter("imagePath");

                cart.clearCart();

                CartItem cartItem = new CartItem(
                        menuId,
                        restaurantId,
                        itemName,
                        price,
                        1,
                        imagePath
                );

                cart.addItem(cartItem);
                session.setAttribute("cart", cart);

                resp.sendRedirect(
                        req.getContextPath()
                        + "/menu?restaurantId=" + restaurantId
                );
            }

            // UPDATE QUANTITY
            else if ("update".equals(action)) {

                int menuId = getRequiredInt(req, "menuId");
                int quantity = getRequiredInt(req, "quantity");

                if (quantity > 0) {
                    cart.updateItem(menuId, quantity);
                } else {
                    cart.removeItem(menuId);
                }

                session.setAttribute("cart", cart);
                resp.sendRedirect(req.getContextPath() + "/cart");
            }

            // REMOVE ITEM
            else if ("remove".equals(action)) {

                int menuId = getRequiredInt(req, "menuId");

                cart.removeItem(menuId);
                session.setAttribute("cart", cart);

                resp.sendRedirect(req.getContextPath() + "/cart");
            }

            // INCREASE QUANTITY
            else if ("increase".equals(action)) {

                int menuId = getRequiredInt(req, "menuId");

                CartItem item = cart.getItems().get(menuId);

                if (item != null) {
                    item.setQuantity(item.getQuantity() + 1);
                }

                session.setAttribute("cart", cart);

                redirectAfterQuantityChange(req, resp);
            }

            // DECREASE QUANTITY
            else if ("decrease".equals(action)) {

                int menuId = getRequiredInt(req, "menuId");

                CartItem item = cart.getItems().get(menuId);

                if (item != null) {
                    if (item.getQuantity() > 1) {
                        item.setQuantity(item.getQuantity() - 1);
                    } else {
                        cart.removeItem(menuId);
                    }
                }

                session.setAttribute("cart", cart);

                redirectAfterQuantityChange(req, resp);
            }

            // CLEAR CART
            else if ("clear".equals(action)) {

                cart.clearCart();
                session.setAttribute("cart", cart);

                resp.sendRedirect(req.getContextPath() + "/cart");
            }

            // UNKNOWN ACTION
            else {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "Unknown cart action: " + action);
            }

        } catch (IllegalArgumentException e) {

            getServletContext().log("CartServlet request error", e);

            resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage()
            );
        }
    }

    private void redirectAfterQuantityChange(
            HttpServletRequest req,
            HttpServletResponse resp) throws IOException {

        String source = req.getParameter("source");

        if ("cart".equals(source)) {
            resp.sendRedirect(req.getContextPath() + "/cart");
        } else {
            int restaurantId = getRequiredInt(req, "restaurantId");

            resp.sendRedirect(
                    req.getContextPath()
                    + "/menu?restaurantId=" + restaurantId
            );
        }
    }

    private int getRequiredInt(HttpServletRequest req, String name) {

        String value = req.getParameter(name);

        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Missing required request parameter: " + name
            );
        }

        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "Invalid integer value for parameter: " + name
            );
        }
    }

    private float getRequiredFloat(HttpServletRequest req, String name) {

        String value = getRequiredString(req, name);

        try {
            float number = Float.parseFloat(value);

            if (!Float.isFinite(number) || number < 0) {
                throw new IllegalArgumentException(
                        "Invalid price value."
                );
            }

            return number;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "Invalid decimal value for parameter: " + name
            );
        }
    }

    private String getRequiredString(HttpServletRequest req, String name) {

        String value = req.getParameter(name);

        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Missing required request parameter: " + name
            );
        }

        return value.trim();
    }
}
