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

        String action = req.getParameter("action");

        HttpSession session = req.getSession();

        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        // =========================================
        // ADD ITEM
        // =========================================
        if ("add".equals(action)) {

            int menuId = Integer.parseInt(req.getParameter("menuId"));
            int restaurantId = Integer.parseInt(req.getParameter("restaurantId"));

            String itemName = req.getParameter("itemName");
            float price = Float.parseFloat(req.getParameter("price"));
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
                        + "/menu?restaurantId="
                        + restaurantId
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

        // =========================================
        // CLEAR CART AND ADD NEW ITEM
        // =========================================
        else if ("clearAndAdd".equals(action)) {

            int menuId = Integer.parseInt(req.getParameter("menuId"));
            int restaurantId = Integer.parseInt(req.getParameter("restaurantId"));

            String itemName = req.getParameter("itemName");
            float price = Float.parseFloat(req.getParameter("price"));
            String imagePath = req.getParameter("imagePath");

            // Clear the previous restaurant's items.
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
                    + "/menu?restaurantId="
                    + restaurantId
            );
        }

        // =========================================
        // UPDATE QUANTITY
        // =========================================
        else if ("update".equals(action)) {

            int menuId = Integer.parseInt(req.getParameter("menuId"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));

            if (quantity > 0) {
                cart.updateItem(menuId, quantity);
            } else {
                cart.removeItem(menuId);
            }

            session.setAttribute("cart", cart);

            resp.sendRedirect(req.getContextPath() + "/cart");
        }

        // =========================================
        // REMOVE ITEM
        // =========================================
        else if ("remove".equals(action)) {

            int menuId = Integer.parseInt(req.getParameter("menuId"));

            cart.removeItem(menuId);

            session.setAttribute("cart", cart);

            resp.sendRedirect(req.getContextPath() + "/cart");
        }

        // =========================================
        // INCREASE QUANTITY
        // =========================================
        else if ("increase".equals(action)) {

            int menuId = Integer.parseInt(req.getParameter("menuId"));

            CartItem item = cart.getItems().get(menuId);

            if (item != null) {
                item.setQuantity(item.getQuantity() + 1);
            }

            session.setAttribute("cart", cart);

            String source = req.getParameter("source");

            if ("cart".equals(source)) {

                resp.sendRedirect(req.getContextPath() + "/cart");

            } else {

                int restaurantId =
                        Integer.parseInt(req.getParameter("restaurantId"));

                resp.sendRedirect(
                        req.getContextPath()
                        + "/menu?restaurantId="
                        + restaurantId
                );
            }
        }

        // =========================================
        // DECREASE QUANTITY
        // =========================================
        else if ("decrease".equals(action)) {

            int menuId = Integer.parseInt(req.getParameter("menuId"));

            CartItem item = cart.getItems().get(menuId);

            if (item != null) {

                if (item.getQuantity() > 1) {
                    item.setQuantity(item.getQuantity() - 1);
                } else {
                    cart.removeItem(menuId);
                }
            }

            session.setAttribute("cart", cart);

            String source = req.getParameter("source");

            if ("cart".equals(source)) {

                resp.sendRedirect(req.getContextPath() + "/cart");

            } else {

                int restaurantId =
                        Integer.parseInt(req.getParameter("restaurantId"));

                resp.sendRedirect(
                        req.getContextPath()
                        + "/menu?restaurantId="
                        + restaurantId
                );
            }
        }

        // =========================================
        // CLEAR CART — STAY ON CART PAGE
        // =========================================
        else if ("clear".equals(action)) {

            cart.clearCart();

            // Keep the cleared cart in the session.
            session.setAttribute("cart", cart);

            // Redirect to the cart page, NOT the restaurant page.
            resp.sendRedirect(req.getContextPath() + "/cart");

            return;
        }
    }
}