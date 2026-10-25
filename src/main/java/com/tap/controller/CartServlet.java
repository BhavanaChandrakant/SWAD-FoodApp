
package com.tap.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import com.tap.model.Cart;
import com.tap.model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);

        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        request.setAttribute("cart", cart);
        request.getRequestDispatcher("/Cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(true);

        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        String action = request.getParameter("action");
        String source = request.getParameter("source");
        String restaurantIdValue = request.getParameter("restaurantId");
        String menuIdValue = request.getParameter("menuId");

        try {

            if (action == null || action.trim().isEmpty()) {
                redirectAfterAction(
                    request, response, source, restaurantIdValue
                );
                return;
            }

            // The user chose to keep the existing cart.
            if ("keepCart".equals(action)) {
                clearPendingItem(session);

                redirectAfterAction(
                    request, response, source, restaurantIdValue
                );
                return;
            }

            int menuId = 0;

            if (requiresMenuId(action)) {
                menuId = parsePositiveInt(menuIdValue, "menuId");
            }

            switch (action) {

                case "add":
                case "clearAndAdd": {

                    int restaurantId = parsePositiveInt(
                        restaurantIdValue, "restaurantId"
                    );

                    String itemName = request.getParameter("itemName");
                    String priceValue = request.getParameter("price");
                    String imagePath = request.getParameter("imagePath");

                    if (itemName == null || itemName.trim().isEmpty()) {
                        throw new IllegalArgumentException(
                            "Item name is missing."
                        );
                    }

                    double price = parsePrice(priceValue);

                    /*
                     * Detect a different restaurant before changing
                     * the current cart.
                     */
                    if ("add".equals(action) && !cart.getItems().isEmpty()) {

                        CartItem firstItem =
                            cart.getItems().values().iterator().next();

                        if (firstItem.getRestaurantId() != restaurantId) {

                            // Save the selected item temporarily.
                            session.setAttribute(
                                "swadPendingMenuId", menuId
                            );
                            session.setAttribute(
                                "swadPendingRestaurantId", restaurantId
                            );
                            session.setAttribute(
                                "swadPendingItemName", itemName.trim()
                            );
                            session.setAttribute(
                                "swadPendingPrice", price
                            );
                            session.setAttribute(
                                "swadPendingImagePath", imagePath
                            );
                            session.setAttribute(
                                "swadDifferentRestaurant",
                                "Your cart contains items from another restaurant."
                            );

                            // Redirect uses GET, so it avoids HTTP 405.
                            response.sendRedirect(
                                request.getContextPath()
                                + "/menu?restaurantId="
                                + restaurantId
                                + "&switchCart=1"
                            );

                            return;
                        }
                    }

                    /*
                     * The user selected Clear Cart & Add Item.
                     */
                    if ("clearAndAdd".equals(action)) {
                        cart.clearCart();
                    }

                    CartItem existingItem = cart.getItems().get(menuId);

                    if (existingItem != null) {

                        existingItem.setQuantity(
                            existingItem.getQuantity() + 1
                        );

                    } else {

                        CartItem newItem = new CartItem();

                        newItem.setMenuId(menuId);
                        newItem.setRestaurantId(restaurantId);
                        newItem.setItemName(itemName.trim());
                        newItem.setPrice((float) price);
                        newItem.setImagePath(imagePath);
                        newItem.setQuantity(1);

                        cart.addItem(newItem);
                    }

                    // Clear the saved popup item after processing.
                    clearPendingItem(session);
                    break;
                }

                case "increase": {

                    CartItem item = cart.getItems().get(menuId);

                    if (item != null) {
                        item.setQuantity(item.getQuantity() + 1);
                    }

                    break;
                }

                case "decrease": {

                    CartItem item = cart.getItems().get(menuId);

                    if (item != null) {
                        int quantity = item.getQuantity() - 1;

                        if (quantity <= 0) {
                            cart.removeItem(menuId);
                        } else {
                            item.setQuantity(quantity);
                        }
                    }

                    break;
                }

                case "remove": {
                    cart.removeItem(menuId);
                    break;
                }

                case "clear": {
                    cart.clearCart();
                    break;
                }

                case "update": {

                    int quantity = parseNonNegativeInt(
                        request.getParameter("quantity"), "quantity"
                    );

                    CartItem item = cart.getItems().get(menuId);

                    if (item != null) {
                        if (quantity == 0) {
                            cart.removeItem(menuId);
                        } else {
                            item.setQuantity(quantity);
                        }
                    }

                    break;
                }

                default:
                    throw new IllegalArgumentException(
                        "Unknown cart action: " + action
                    );
            }

            session.setAttribute("cart", cart);

        } catch (NumberFormatException e) {

            getServletContext().log(
                "Invalid numeric cart value: menuId=[" + menuIdValue
                + "], restaurantId=[" + restaurantIdValue
                + "], price=[" + request.getParameter("price") + "]",
                e
            );

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid numeric cart details."
            );
            return;

        } catch (IllegalArgumentException e) {

            getServletContext().log(
                "Cart validation error: " + e.getMessage(), e
            );

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid cart details."
            );
            return;

        } catch (Exception e) {

            getServletContext().log(
                "Cart processing error. Action=[" + action + "]", e
            );

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to update your cart."
            );
            return;
        }

        redirectAfterAction(
            request, response, source, restaurantIdValue
        );
    }

    private void clearPendingItem(HttpSession session) {
        session.removeAttribute("swadPendingMenuId");
        session.removeAttribute("swadPendingRestaurantId");
        session.removeAttribute("swadPendingItemName");
        session.removeAttribute("swadPendingPrice");
        session.removeAttribute("swadPendingImagePath");
        session.removeAttribute("swadDifferentRestaurant");
    }

    private boolean requiresMenuId(String action) {
        return "add".equals(action)
            || "clearAndAdd".equals(action)
            || "increase".equals(action)
            || "decrease".equals(action)
            || "remove".equals(action)
            || "update".equals(action);
    }

    private int parsePositiveInt(String value, String fieldName) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(fieldName + " is missing.");
        }

        int number = Integer.parseInt(value.trim());

        if (number <= 0) {
            throw new IllegalArgumentException(
                fieldName + " must be greater than zero."
            );
        }

        return number;
    }

    private int parseNonNegativeInt(String value, String fieldName) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(fieldName + " is missing.");
        }

        int number = Integer.parseInt(value.trim());

        if (number < 0) {
            throw new IllegalArgumentException(
                fieldName + " cannot be negative."
            );
        }

        return number;
    }

    private double parsePrice(String value) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException("Price is missing.");
        }

        double price = Double.parseDouble(value.trim());

        if (!Double.isFinite(price) || price < 0) {
            throw new IllegalArgumentException(
                "Price must be a non-negative number."
            );
        }

        return price;
    }

    private void redirectAfterAction(
            HttpServletRequest request,
            HttpServletResponse response,
            String source,
            String restaurantId) throws IOException {

        String contextPath = request.getContextPath();

        if ("menu".equals(source)
                && restaurantId != null
                && !restaurantId.trim().isEmpty()) {

            response.sendRedirect(
                contextPath + "/menu?restaurantId="
                + URLEncoder.encode(
                    restaurantId.trim(),
                    StandardCharsets.UTF_8
                )
            );

        } else {
            response.sendRedirect(contextPath + "/cart");
        }
    }
}
