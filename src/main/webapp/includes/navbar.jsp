
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.DAOImpl.UserDAOImpl" %>

<%
    Cart navbarCart = (Cart) session.getAttribute("cart");

    if (navbarCart == null) {
        navbarCart = (Cart) request.getAttribute("cart");
    }

    int navbarCartCount =
        (navbarCart == null) ? 0 : navbarCart.getTotalItems();

    String loggedInEmail =
        (String) session.getAttribute("userEmail");

    User loggedInUser = null;
    String navbarUserName = "";

    if (loggedInEmail != null && !loggedInEmail.trim().isEmpty()) {
        UserDAOImpl userDao = new UserDAOImpl();
        loggedInUser = userDao.getUserByEmail(loggedInEmail.trim());

        if (loggedInUser != null && loggedInUser.getName() != null) {
            navbarUserName = loggedInUser.getName().trim();
        }
    }

    String contextPath = request.getContextPath();
%>

<!-- Navbar stylesheet: update this path if your CSS is elsewhere -->
<link rel="stylesheet"
      href="<%= contextPath %>/css/navbar.css">

<nav class="swad-navbar">

    <!-- SWAD LOGO -->
    <div class="swad-navbar-brand">
        <a href="<%= contextPath %>/index.jsp"
           aria-label="SWAD Home">

            <span class="swad-navbar-logo-icon">
                <svg xmlns="http://www.w3.org/2000/svg"
                     viewBox="0 0 24 24"
                     fill="none"
                     stroke="currentColor"
                     stroke-width="1.8"
                     stroke-linecap="round"
                     stroke-linejoin="round"
                     aria-hidden="true">
                    <path d="M6 3v6"></path>
                    <path d="M3.5 3v4"></path>
                    <path d="M8.5 3v4"></path>
                    <path d="M3.5 7c0 2 1 3 2.5 3s2.5-1 2.5-3"></path>
                    <path d="M6 10v11"></path>
                    <path d="M16 3c-2 3-3 5.5-3 9h3v9"></path>
                </svg>
            </span>

            <span class="swad-navbar-logo-text">SWAD</span>
        </a>
    </div>

    <!-- MOBILE / TABLET HAMBURGER TOGGLE -->
    <input type="checkbox"
           id="swad-menu-toggle"
           class="swad-menu-toggle"
           aria-label="Toggle navigation menu"
           aria-controls="swad-navbar-links">

    <label for="swad-menu-toggle"
           class="swad-navbar-toggle"
           aria-hidden="true">
        <span></span>
        <span></span>
        <span></span>
    </label>

    <!-- NAVIGATION LINKS -->
    <div class="swad-navbar-links" id="swad-navbar-links">

        <a class="swad-navbar-link"
           href="<%= contextPath %>/index.jsp">Home</a>

        <a class="swad-navbar-link"
           href="<%= contextPath %>/restaurant">Restaurants</a>

        <!-- SHOPPING CART -->
        <div class="swad-navbar-cart">
            <a class="swad-navbar-link swad-navbar-cart-link"
               href="<%= contextPath %>/cart"
               aria-label="Shopping cart, <%= navbarCartCount %> items">

                <svg xmlns="http://www.w3.org/2000/svg"
                     viewBox="0 0 24 24"
                     width="27"
                     height="27"
                     fill="none"
                     stroke="currentColor"
                     stroke-width="1.8"
                     stroke-linecap="round"
                     stroke-linejoin="round"
                     aria-hidden="true">
                    <path d="M2 3h2l2.2 11.2a2 2 0 0 0 2 1.6h9.5a2 2 0 0 0 1.9-1.5L22 7H5"></path>
                    <path d="M9 7l1 7"></path>
                    <path d="M15 7l-1 7"></path>
                    <circle cx="10" cy="20" r="1"></circle>
                    <circle cx="18" cy="20" r="1"></circle>
                </svg>

                <% if (navbarCartCount > 0) { %>
                    <span class="swad-navbar-cart-count">
                        <%= navbarCartCount > 99 ? "99+" : navbarCartCount %>
                    </span>
                <% } %>
            </a>
        </div>

        <!-- LOGIN OR PROFILE -->
        <% if (loggedInUser == null) { %>

            <a class="swad-navbar-link"
               href="<%= contextPath %>/login">Login</a>

        <% } else { %>

            <div class="swad-navbar-profile">

                <button type="button"
                        class="swad-navbar-profile-button"
                        aria-label="Open user profile menu">
                    <%= navbarUserName.isEmpty()
                        ? "U"
                        : navbarUserName.substring(0, 1).toUpperCase() %>
                </button>

                <div class="swad-navbar-dropdown">

                    <div class="swad-navbar-user-name">
                        <%= navbarUserName.isEmpty()
                            ? "User"
                            : navbarUserName %>
                    </div>

                    <div class="swad-navbar-divider"></div>

                    <a href="<%= contextPath %>/orders">My Orders</a>
                    <a href="<%= contextPath %>/profile">Profile</a>

                    <div class="swad-navbar-divider"></div>

                    <a class="swad-navbar-logout"
                       href="<%= contextPath %>/logout">Logout</a>
                </div>
            </div>

        <% } %>

    </div>
</nav>
