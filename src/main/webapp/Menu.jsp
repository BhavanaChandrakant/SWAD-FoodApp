
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.LinkedHashSet"%>
<%@ page import="java.util.Locale"%>
<%@ page import="com.tap.model.Menu"%>
<%@ page import="com.tap.model.Cart"%>
<%@ page import="com.tap.model.CartItem"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>SWAD | Our Menu</title>

<link rel="stylesheet"
    href="${pageContext.request.contextPath}/css/common.css?v=1">
<link rel="stylesheet"
    href="${pageContext.request.contextPath}/css/menu.css?v=12">
<link rel="stylesheet"
    href="${pageContext.request.contextPath}/css/navbar.css?v=25">

<style>
.swad-switch-overlay {
    position: fixed;
    inset: 0;
    z-index: 10000;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
    background: rgba(20, 20, 20, 0.65);
    backdrop-filter: blur(3px);
}

.swad-switch-overlay[hidden] {
    display: none !important;
}

.swad-switch-modal {
    width: 100%;
    max-width: 430px;
    max-height: 90vh;
    overflow-y: auto;
    padding: 28px;
    background: #fff;
    border-radius: 18px;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.25);
    text-align: center;
    animation: swadPopupIn 0.22s ease-out;
}

.swad-switch-icon {
    width: 64px;
    height: 64px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 18px;
    border-radius: 50%;
    background: #fff0e6;
    font-size: 30px;
}

.swad-switch-modal h2 {
    margin: 0 0 12px;
    color: #252525;
    font-size: 23px;
    line-height: 1.35;
}

.swad-switch-modal p {
    margin: 0 0 12px;
    color: #666;
    font-size: 15px;
    line-height: 1.65;
}

.swad-switch-note {
    padding: 12px;
    margin: 16px 0 20px;
    border-radius: 10px;
    background: #fff7f0;
    color: #8b4100;
    font-size: 13px;
    line-height: 1.5;
}

.swad-switch-actions {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.swad-switch-actions form {
    width: 100%;
    margin: 0;
}

.swad-switch-confirm,
.swad-switch-cancel {
    display: block;
    width: 100%;
    min-height: 46px;
    padding: 12px 16px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 700;
    cursor: pointer;
    transition: background 0.2s ease, transform 0.2s ease;
}

.swad-switch-confirm {
    border: none;
    background: #e65c00;
    color: #fff;
}

.swad-switch-confirm:hover {
    background: #c94e00;
    transform: translateY(-1px);
}

.swad-switch-cancel {
    border: 1px solid #ddd;
    background: #fff;
    color: #444;
}

.swad-switch-cancel:hover {
    background: #f5f5f5;
}

body.swad-modal-open {
    overflow: hidden;
}

@keyframes swadPopupIn {
    from {
        opacity: 0;
        transform: translateY(12px) scale(0.97);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

@media (max-width: 480px) {
    .swad-switch-modal {
        padding: 24px 20px;
    }

    .swad-switch-modal h2 {
        font-size: 21px;
    }
}
</style>
</head>

<body>

<%@ include file="includes/navbar.jsp"%>

<%
Cart cart = (Cart) session.getAttribute("cart");

if (cart == null) {
    cart = new Cart();
    session.setAttribute("cart", cart);
}

List<Menu> menuList =
    (List<Menu>) request.getAttribute("menuList");

/*
 * IMPORTANT:
 * CartServlet stores popup data in the session before redirecting
 * to /menu. Therefore, read popup data from the session here.
 */
Object switchMessage =
    session.getAttribute("swadDifferentRestaurant");

String differentRestaurant =
    switchMessage == null ? null : switchMessage.toString();

Object pendingMenuId =
    session.getAttribute("swadPendingMenuId");

Object pendingRestaurantId =
    session.getAttribute("swadPendingRestaurantId");

Object pendingItemName =
    session.getAttribute("swadPendingItemName");

Object pendingPrice =
    session.getAttribute("swadPendingPrice");

Object pendingImagePath =
    session.getAttribute("swadPendingImagePath");

int totalCartItems = 0;
double cartTotal = 0.0;

if (cart.getItems() != null) {
    for (CartItem item : cart.getItems().values()) {
        if (item != null && item.getQuantity() > 0) {
            totalCartItems += item.getQuantity();
            cartTotal += item.getQuantity() * item.getPrice();
        }
    }
}
%>

<section class="menu-top-section">

    <div class="menu-hero-content">
        <p class="menu-label">FRESH • DELICIOUS • SWAD</p>
        <h1>Our Menu</h1>
    </div>

    <% if (menuList != null && !menuList.isEmpty()) { %>

    <div class="menu-toolbar">
        <div class="menu-toolbar-content">

            <div class="menu-search-area">
                <svg class="menu-search-icon"
                    xmlns="http://www.w3.org/2000/svg"
                    width="20" height="20" viewBox="0 0 24 24"
                    fill="none" stroke="currentColor"
                    stroke-width="2" stroke-linecap="round"
                    stroke-linejoin="round" aria-hidden="true">
                    <circle cx="11" cy="11" r="7"></circle>
                    <path d="m20 20-4-4"></path>
                </svg>

                <input type="search"
                    id="menuSearch"
                    placeholder="Search dishes, dosa, biryani..."
                    autocomplete="off"
                    aria-label="Search dishes">

                <span id="menuCount"
                    class="visually-hidden"
                    aria-live="polite">
                    Showing <%=menuList.size()%> dishes.
                </span>
            </div>

            <div class="category-filters" id="categoryFilters">

                <button type="button"
                    class="category-filter active"
                    data-category="all">All</button>

                <%
                Set<String> categories = new LinkedHashSet<String>();

                for (Menu menu : menuList) {
                    String categoryName = menu.getCategory();

                    if (categoryName != null
                            && !categoryName.trim().isEmpty()) {
                        categories.add(categoryName.trim());
                    }
                }

                for (String category : categories) {
                %>

                <button type="button"
                    class="category-filter"
                    data-category="<%=category.toLowerCase(Locale.ROOT)%>">
                    <%=category%>
                </button>

                <% } %>

            </div>
        </div>
    </div>

    <% } %>

</section>

<main class="menu-container">

    <% if (menuList != null && !menuList.isEmpty()) { %>

    <div id="noSearchResults"
        class="empty-message"
        style="display:none;">

        <h3>No dishes found</h3>
        <p>Try another search or select a different category.</p>
    </div>

    <div class="menu-grid" id="menuGrid">

        <% for (Menu menu : menuList) {

            CartItem cartItem =
                cart.getItems().get(menu.getMenuID());

            String categoryValue = menu.getCategory() == null
                ? "" : menu.getCategory().trim().toLowerCase(Locale.ROOT);

            String imagePath = menu.getImagePath() == null
                ? "" : menu.getImagePath();

            String description = menu.getDescription() == null
                ? "" : menu.getDescription();
        %>

        <article class="menu-card"
            data-category="<%=categoryValue%>">

            <div class="menu-image-container">

                <% if (!imagePath.trim().isEmpty()) { %>

                <img src="<%=imagePath%>"
                    alt="<%=menu.getItemName()%>"
                    class="menu-image"
                    loading="lazy">

                <% } else { %>

                <div class="menu-image-placeholder">SWAD</div>

                <% } %>

            </div>

            <div class="menu-details">

                <h3 class="food-name"><%=menu.getItemName()%></h3>

                <% if (!description.trim().isEmpty()) { %>
                <p class="description"><%=description%></p>
                <% } %>

                <% if (menu.getCategory() != null
                        && !menu.getCategory().trim().isEmpty()) { %>
                <span class="category"><%=menu.getCategory()%></span>
                <% } %>

                <div class="bottom-row">

                    <span class="price">₹<%=menu.getPrice()%></span>

                    <% if (menu.getIsAvailable() == 1) { %>
                    <span class="available">Available</span>
                    <% } else { %>
                    <span class="not-available">Unavailable</span>
                    <% } %>

                </div>

                <% if (menu.getIsAvailable() == 1) { %>

                    <% if (cartItem == null) { %>

                    <form action="${pageContext.request.contextPath}/cart"
                        method="post"
                        class="cart-form">

                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="source" value="menu">

                        <input type="hidden" name="menuId"
                            value="<%=menu.getMenuID()%>">

                        <input type="hidden" name="restaurantId"
                            value="<%=menu.getRestaurantID()%>">

                        <input type="hidden" name="itemName"
                            value="<%=menu.getItemName()%>">

                        <input type="hidden" name="price"
                            value="<%=menu.getPrice()%>">

                        <input type="hidden" name="imagePath"
                            value="<%=imagePath%>">

                        <button type="submit" class="cart-btn">
                            ADD TO CART
                        </button>

                    </form>

                    <% } else { %>

                    <div class="quantity-control">

                        <form action="${pageContext.request.contextPath}/cart"
                            method="post">

                            <input type="hidden" name="action"
                                value="decrease">
                            <input type="hidden" name="source"
                                value="menu">

                            <input type="hidden" name="menuId"
                                value="<%=menu.getMenuID()%>">

                            <input type="hidden" name="restaurantId"
                                value="<%=menu.getRestaurantID()%>">

                            <button type="submit"
                                class="quantity-btn"
                                aria-label="Decrease quantity">−</button>

                        </form>

                        <span class="quantity-number">
                            <%=cartItem.getQuantity()%>
                        </span>

                        <form action="${pageContext.request.contextPath}/cart"
                            method="post">

                            <input type="hidden" name="action"
                                value="increase">
                            <input type="hidden" name="source"
                                value="menu">

                            <input type="hidden" name="menuId"
                                value="<%=menu.getMenuID()%>">

                            <input type="hidden" name="restaurantId"
                                value="<%=menu.getRestaurantID()%>">

                            <button type="submit"
                                class="quantity-btn"
                                aria-label="Increase quantity">+</button>

                        </form>

                    </div>

                    <% } %>

                <% } else { %>

                <button type="button"
                    class="cart-btn unavailable-btn"
                    disabled>
                    CURRENTLY UNAVAILABLE
                </button>

                <% } %>

            </div>
        </article>

        <% } %>

    </div>

    <% } else { %>

    <div class="empty-message">
        <h3>No menu items available</h3>
        <p>There are no dishes available for this restaurant right now.</p>
    </div>

    <% } %>

</main>

<!-- AUTOMATIC SWITCH RESTAURANT POPUP -->
<%
boolean showSwitchPopup =
    differentRestaurant != null
    && !differentRestaurant.trim().isEmpty()
    && pendingMenuId != null
    && pendingRestaurantId != null
    && pendingItemName != null
    && pendingPrice != null;
%>

<% if (showSwitchPopup) { %>

<div class="swad-switch-overlay"
     id="swadSwitchOverlay"
     role="presentation">

    <section class="swad-switch-modal"
             role="dialog"
             aria-modal="true"
             aria-labelledby="swadSwitchTitle"
             aria-describedby="swadSwitchDescription">

        <div class="swad-switch-icon" aria-hidden="true">🛒</div>

        <h2 id="swadSwitchTitle">Switch restaurant?</h2>

        <p id="swadSwitchDescription">
            Your cart contains items from another restaurant.
            Would you like to clear your existing cart and add
            this item instead?
        </p>

        <div class="swad-switch-note">
            <strong>Please note:</strong>
            Your current cart items will be removed if you switch
            restaurants.
        </div>

        <div class="swad-switch-actions">

            <!-- Clear the old cart and add the selected item -->
            <form action="${pageContext.request.contextPath}/cart"
                  method="post">

                <input type="hidden" name="action" value="clearAndAdd">
                <input type="hidden" name="source" value="menu">

                <input type="hidden" name="menuId"
                    value="<%=pendingMenuId%>">

                <input type="hidden" name="restaurantId"
                    value="<%=pendingRestaurantId%>">

                <input type="hidden" name="itemName"
                    value="<%=pendingItemName.toString()
                        .replace("&", "&amp;")
                        .replace("\"", "&quot;")
                        .replace("<", "&lt;")
                        .replace(">", "&gt;")%>">

                <input type="hidden" name="price"
                    value="<%=pendingPrice%>">

                <input type="hidden" name="imagePath"
                    value="<%=pendingImagePath == null ? "" :
                        pendingImagePath.toString()
                            .replace("&", "&amp;")
                            .replace("\"", "&quot;")
                            .replace("<", "&lt;")
                            .replace(">", "&gt;")%>">

                <button type="submit" class="swad-switch-confirm">
                    Clear Cart &amp; Add Item
                </button>

            </form>

            <!-- Clear pending popup data; keep existing cart -->
            <form action="${pageContext.request.contextPath}/cart"
                  method="post">

                <input type="hidden" name="action" value="keepCart">
                <input type="hidden" name="source" value="menu">

                <input type="hidden" name="restaurantId"
                    value="<%=pendingRestaurantId%>">

                <button type="submit" class="swad-switch-cancel">
                    Keep My Cart
                </button>

            </form>

        </div>
    </section>
</div>

<% } %>

<%@ include file="includes/footer.jsp"%>

<!-- FLOATING VIEW CART BAR -->
<div id="swadFloatingCart"
    class="swad-floating-cart"
    <%=totalCartItems <= 0 ? "hidden" : ""%>>

    <div class="swad-cart-summary">

        <div class="swad-cart-items">
            <strong id="swadCartItemCount"><%=totalCartItems%></strong>

            <span id="swadCartItemLabel">
                <%=totalCartItems == 1 ? "item" : "items"%>
            </span>

            in cart
        </div>

        <div class="swad-cart-price">
            ₹<span id="swadCartTotal"><%=String.format(Locale.US, "%.2f", cartTotal)%></span>
        </div>

    </div>

    <form action="${pageContext.request.contextPath}/cart"
        method="get"
        class="swad-cart-action">

        <button type="submit" class="swad-view-cart-button">
            View Cart
            <span class="swad-cart-arrow" aria-hidden="true">➜</span>
        </button>

    </form>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {

    const searchInput = document.getElementById("menuSearch");
    const categoryButtons =
        document.querySelectorAll(".category-filter");
    const menuCards = document.querySelectorAll(".menu-card");
    const menuCount = document.getElementById("menuCount");
    const noSearchResults = document.getElementById("noSearchResults");

    let selectedCategory = "all";

    function filterMenu() {
        const searchText = searchInput
            ? searchInput.value.trim().toLowerCase()
            : "";

        let visibleCount = 0;

        menuCards.forEach(function (card) {
            const cardText = card.textContent.toLowerCase();
            const cardCategory =
                (card.dataset.category || "").toLowerCase();

            const matchesSearch = cardText.includes(searchText);
            const matchesCategory =
                selectedCategory === "all" ||
                cardCategory === selectedCategory;

            const shouldShow = matchesSearch && matchesCategory;

            card.style.display = shouldShow ? "" : "none";

            if (shouldShow) {
                visibleCount++;
            }
        });

        if (menuCount) {
            menuCount.textContent =
                "Showing " + visibleCount +
                (visibleCount === 1 ? " dish." : " dishes.");
        }

        if (noSearchResults) {
            noSearchResults.style.display =
                visibleCount === 0 ? "block" : "none";
        }
    }

    if (searchInput) {
        searchInput.addEventListener("input", filterMenu);
    }

    categoryButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            categoryButtons.forEach(function (item) {
                item.classList.remove("active");
            });

            button.classList.add("active");

            selectedCategory =
                (button.dataset.category || "all").toLowerCase();

            filterMenu();
        });
    });

    // Popup behavior
    const switchOverlay =
        document.getElementById("swadSwitchOverlay");

    if (switchOverlay) {
        document.body.classList.add("swad-modal-open");

        document.addEventListener("keydown", function (event) {
            if (event.key === "Escape") {
                /*
                 * Escape hides the popup visually only.
                 * Use Keep My Cart to clear the saved pending item.
                 */
                switchOverlay.hidden = true;
                document.body.classList.remove("swad-modal-open");
            }
        });
    }

    // Preserve scroll position after menu cart actions
    if ("scrollRestoration" in history) {
        history.scrollRestoration = "manual";
    }

    document.querySelectorAll(
        'form[action$="/cart"][method="post"]'
    ).forEach(function (form) {
        form.addEventListener("submit", function () {
            sessionStorage.setItem(
                "swadMenuScrollPosition",
                String(window.scrollY)
            );
        });
    });

    const savedPosition =
        sessionStorage.getItem("swadMenuScrollPosition");

    if (savedPosition !== null) {
        sessionStorage.removeItem("swadMenuScrollPosition");

        window.addEventListener("load", function () {
            window.scrollTo(0, parseInt(savedPosition, 10) || 0);
        });
    }

    filterMenu();
});
</script>

</body>
</html>
