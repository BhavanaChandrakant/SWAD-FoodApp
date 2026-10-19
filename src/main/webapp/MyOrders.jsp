<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%@ page import="com.tap.model.Ordertable" %>
<%@ page import="com.tap.model.Oderitem" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.model.Menu" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>My Orders - SWAD</title>

    <!-- Common Styles -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css?v=1">

    <!-- My Orders Styles -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/MyOrders.css?v=2">

    <!-- Updated Shared Navbar -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/navbar.css?v=27">

</head>

<body>

    <!-- ================= SHARED NAVBAR ================= -->
    <%@ include file="includes/navbar.jsp" %>


    <!-- ================= ORDERS ================= -->

    <div class="orders-container">

        <!-- PAGE HEADER -->

        <div class="page-header">

            <div class="page-icon">🛍️</div>

            <div>
                <h1>My Orders</h1>
                <p>View your previous orders and their details</p>
            </div>

        </div>


        <!-- ================= RETRIEVE ORDER DATA ================= -->

        <%
            List<Ordertable> orders =
                (List<Ordertable>) request.getAttribute("orders");

            Map<Integer, Restaurant> restaurants =
                (Map<Integer, Restaurant>) request.getAttribute("restaurants");

            Map<Integer, List<Oderitem>> orderItems =
                (Map<Integer, List<Oderitem>>) request.getAttribute("orderItems");

            Map<Integer, Menu> menuDetails =
                (Map<Integer, Menu>) request.getAttribute("menuDetails");
        %>


        <!-- ================= EMPTY ORDER CHECK ================= -->

        <%
            if (orders == null || orders.isEmpty()) {
        %>

            <div class="no-orders">

                <div class="empty-orders-icon">🛍️</div>

                <h2>No Orders Yet</h2>

                <p>You haven't placed any orders yet.</p>

                <a href="${pageContext.request.contextPath}/restaurant">
                    Order Food
                </a>

            </div>

        <%
            } else {
        %>


        <!-- ================= ORDERS LIST ================= -->

        <div class="orders-list">

            <%
                for (Ordertable order : orders) {

                    Restaurant restaurant = null;

                    if (restaurants != null) {
                        restaurant =
                            restaurants.get(order.getRestaurantId());
                    }

                    List<Oderitem> items = null;

                    if (orderItems != null) {
                        items = orderItems.get(order.getOrderId());
                    }

                    /*
                     * Display Pending as Placed.
                     * The database status is not changed.
                     */
                    String displayStatus = order.getStatus();

                    if (displayStatus == null
                            || displayStatus.trim().isEmpty()
                            || "Pending".equalsIgnoreCase(
                                    displayStatus.trim())) {

                        displayStatus = "Placed";
                    }
            %>


            <!-- ================= ORDER CARD ================= -->

            <div class="order-card">


                <!-- ORDER HEADER -->

                <div class="order-header">

                    <div>

                        <h2>
                            Order #<%= order.getOrderId() %>
                        </h2>

                        <p class="order-date">
                            <%= order.getOrderDate() %>
                        </p>

                    </div>

                    <!-- DISPLAY ORDER STATUS -->

                    <span class="order-status">
                        <%= displayStatus %>
                    </span>

                </div>


                <!-- ================= RESTAURANT DETAILS ================= -->

                <div class="restaurant-section">

                    <div class="restaurant-image">

                        <%
                            if (restaurant != null
                                    && restaurant.getImagePath() != null
                                    && !restaurant.getImagePath().trim().isEmpty()) {
                        %>

                            <img
                                src="<%= restaurant.getImagePath() %>"
                                alt="<%= restaurant.getName() %>">

                        <%
                            } else {
                        %>

                            🍴

                        <%
                            }
                        %>

                    </div>


                    <div class="restaurant-info">

                        <h2>
                            <%= restaurant != null
                                ? restaurant.getName()
                                : "Restaurant not found" %>
                        </h2>

                        <%
                            if (restaurant != null) {
                        %>

                            <p class="cuisine">
                                <%= restaurant.getCuisineType() %>
                            </p>

                            <p class="address">
                                📍 <%= restaurant.getAddress() %>
                            </p>

                        <%
                            }
                        %>

                    </div>

                </div>


                <!-- ================= ORDERED ITEMS ================= -->

                <div class="items-section">

                    <h3>Ordered Items</h3>

                    <%
                        if (items != null && !items.isEmpty()) {

                            for (Oderitem item : items) {

                                Menu menu = null;

                                if (menuDetails != null) {
                                    menu = menuDetails.get(item.getMenuId());
                                }
                    %>


                    <!-- INDIVIDUAL ITEM -->

                    <div class="ordered-item">


                        <!-- ITEM IMAGE -->

                        <div class="item-image">

                            <%
                                if (menu != null
                                        && menu.getImagePath() != null
                                        && !menu.getImagePath().trim().isEmpty()) {
                            %>

                                <img
                                    src="<%= menu.getImagePath() %>"
                                    alt="<%= menu.getItemName() %>">

                            <%
                                } else {
                            %>

                                🍽️

                            <%
                                }
                            %>

                        </div>


                        <!-- ITEM INFORMATION -->

                        <div class="item-info">

                            <h4>
                                <%= menu != null
                                    ? menu.getItemName()
                                    : "Unknown Item" %>
                            </h4>

                            <%
                                if (menu != null) {
                            %>

                                <p class="item-price">
                                    &#8377;<%= String.format(
                                        "%.2f",
                                        menu.getPrice()
                                    ) %>
                                    per item
                                </p>

                            <%
                                }
                            %>

                            <p class="quantity">
                                Quantity: <%= item.getQuantity() %>
                            </p>

                        </div>


                        <!-- ITEM TOTAL -->

                        <div class="item-total">
                            &#8377;<%= String.format(
                                "%.2f",
                                item.getItemTotal()
                            ) %>
                        </div>

                    </div>


                    <%
                            }

                        } else {
                    %>

                        <p class="no-items">
                            No items found for this order.
                        </p>

                    <%
                        }
                    %>

                </div>


                <!-- ================= ORDER FOOTER ================= -->

                <div class="order-footer">

                    <div>

                        <span>Payment</span>

                        <strong>
                            <%= order.getPaymentMethod() %>
                        </strong>

                    </div>

                    <div>

                        <span>Total</span>

                        <strong class="order-total">
                            &#8377;<%= String.format(
                                "%.2f",
                                order.getTotalAmount()
                            ) %>
                        </strong>

                    </div>

                </div>


            </div>
            <!-- END ORDER CARD -->


            <%
                }
            %>

        </div>
        <!-- END ORDERS LIST -->


        <%
            }
        %>

    </div>
    <!-- END ORDERS CONTAINER -->


    <!-- ================= COMMON FOOTER ================= -->

    <%@ include file="includes/footer.jsp" %>

</body>
</html>