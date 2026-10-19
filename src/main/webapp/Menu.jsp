<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.LinkedHashSet"%>
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
      href="${pageContext.request.contextPath}/css/menu.css?v=2">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/navbar.css?v=25">
</head>

<body>

	<%@ include file="includes/navbar.jsp"%>

	<%
	Cart cart = (Cart) session.getAttribute("cart");

	if (cart == null) {
		cart = new Cart();
		session.setAttribute("cart", cart);
	}

	List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");

	Object switchMessage = request.getAttribute("differentRestaurant");

	String differentRestaurant = switchMessage == null ? null : switchMessage.toString();
	%>


	<!-- MENU TITLE LEFT, SEARCH AND CATEGORIES RIGHT -->
	<section class="menu-top-section">

		<!-- LEFT SIDE -->
		<div class="menu-hero-content">

			<p class="menu-label">FRESH • DELICIOUS • SWAD</p>

			<h1>Our Menu</h1>

		</div>


		<!-- RIGHT SIDE -->
		<%
		if (menuList != null && !menuList.isEmpty()) {
		%>

		<div class="menu-toolbar">

			<div class="menu-toolbar-content">

				<!-- SEARCH BAR -->
				<div class="menu-search-area">

					<svg class="menu-search-icon" xmlns="http://www.w3.org/2000/svg"
						width="20" height="20" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="2" stroke-linecap="round"
						stroke-linejoin="round" aria-hidden="true">

                            <circle cx="11" cy="11" r="7"></circle>
                            <path d="m20 20-4-4"></path>

                        </svg>

					<input type="search" id="menuSearch"
						placeholder="Search dishes, dosa, biryani..." autocomplete="off"
						aria-label="Search dishes"> <span id="menuCount"
						class="visually-hidden" aria-live="polite"> Showing <%=menuList.size()%>
						dishes.
					</span>

				</div>


				<!-- CATEGORY BUTTONS -->
				<div class="category-filters" id="categoryFilters">

					<button type="button" class="category-filter active"
						data-category="all">All</button>

					<%
					Set<String> categories = new LinkedHashSet<String>();

					for (Menu menu : menuList) {

						String categoryName = menu.getCategory();

						if (categoryName != null && !categoryName.trim().isEmpty()) {

							categories.add(categoryName.trim());
						}
					}

					for (String category : categories) {
					%>

					<button type="button" class="category-filter"
						data-category="<%=category.toLowerCase()%>">

						<%=category%>

					</button>

					<%
					}
					%>

				</div>

			</div>

		</div>

		<%
		}
		%>

	</section>


	<main class="menu-container">


		<!-- RESTAURANT SWITCH CONFIRMATION -->
		<%
		if (differentRestaurant != null && !differentRestaurant.trim().isEmpty()) {
		%>

		<div class="error-message">

			<div class="error-content">

				<h3>Switch restaurant?</h3>

				<p><%=differentRestaurant%></p>

				<p>Your current cart will be cleared before adding this item.</p>

			</div>

			<form action="<%=request.getContextPath()%>/cart" method="post"
				class="switch-restaurant-form">

				<input type="hidden" name="action" value="clearAndAdd"> <input
					type="hidden" name="menuId"
					value="<%=request.getAttribute("menuId")%>"> <input
					type="hidden" name="restaurantId"
					value="<%=request.getAttribute("restaurantId")%>"> <input
					type="hidden" name="itemName"
					value="<%=request.getAttribute("itemName")%>"> <input
					type="hidden" name="price"
					value="<%=request.getAttribute("price")%>"> <input
					type="hidden" name="imagePath"
					value="<%=request.getAttribute("imagePath")%>">

				<button type="submit" class="clear-cart-btn">Clear Cart
					&amp; Add Item</button>

			</form>

		</div>

		<%
		}
		%>


		<%
		if (menuList != null && !menuList.isEmpty()) {
		%>


		<!-- NO SEARCH RESULTS -->
		<div id="noSearchResults" class="empty-message" style="display: none;">

			<h3>No dishes found</h3>

			<p>Try another search or select a different category.</p>

		</div>


		<!-- MENU CARDS -->
		<div class="menu-grid" id="menuGrid">

			<%
			for (Menu menu : menuList) {

				CartItem cartItem = cart.getItems().get(menu.getMenuID());

				String categoryValue = menu.getCategory() == null ? "" : menu.getCategory().trim().toLowerCase();

				String imagePath = menu.getImagePath() == null ? "" : menu.getImagePath();

				String description = menu.getDescription() == null ? "" : menu.getDescription();
			%>

			<article class="menu-card" data-category="<%=categoryValue%>">


				<!-- FOOD IMAGE -->
				<div class="menu-image-container">

					<%
					if (!imagePath.trim().isEmpty()) {
					%>

					<img src="<%=imagePath%>" alt="<%=menu.getItemName()%>"
						class="menu-image" loading="lazy">

					<%
					} else {
					%>

					<div class="menu-image-placeholder">SWAD</div>

					<%
					}
					%>

				</div>


				<!-- FOOD DETAILS -->
				<div class="menu-details">

					<h3 class="food-name">
						<%=menu.getItemName()%>
					</h3>

					<%
					if (!description.trim().isEmpty()) {
					%>

					<p class="description">
						<%=description%>
					</p>

					<%
					}
					%>


					<%
					if (menu.getCategory() != null && !menu.getCategory().trim().isEmpty()) {
					%>

					<span class="category"> <%=menu.getCategory()%>
					</span>

					<%
					}
					%>


					<!-- PRICE AND AVAILABILITY -->
					<div class="bottom-row">

						<span class="price"> ₹<%=menu.getPrice()%>
						</span>

						<%
						if (menu.getIsAvailable() == 1) {
						%>

						<span class="available"> Available </span>

						<%
						} else {
						%>

						<span class="not-available"> Unavailable </span>

						<%
						}
						%>

					</div>


					<!-- CART CONTROLS -->
					<%
					if (menu.getIsAvailable() == 1) {
					%>

					<%
					if (cartItem == null) {
					%>

					<!-- ADD TO CART -->
					<form action="<%=request.getContextPath()%>/cart" method="post"
						class="cart-form">

						<input type="hidden" name="action" value="add"> <input
							type="hidden" name="menuId" value="<%=menu.getMenuID()%>">

						<input type="hidden" name="restaurantId"
							value="<%=menu.getRestaurantID()%>"> <input
							type="hidden" name="itemName" value="<%=menu.getItemName()%>">

						<input type="hidden" name="price" value="<%=menu.getPrice()%>">

						<input type="hidden" name="imagePath" value="<%=imagePath%>">

						<button type="submit" class="cart-btn">ADD TO CART</button>

					</form>

					<%
					} else {
					%>

					<!-- CHANGE QUANTITY -->
					<div class="quantity-control">

						<form action="<%=request.getContextPath()%>/cart" method="post">

							<input type="hidden" name="action" value="decrease"> <input
								type="hidden" name="menuId" value="<%=menu.getMenuID()%>">

							<button type="submit" class="quantity-btn"
								aria-label="Decrease quantity">−</button>

						</form>


						<span class="quantity-number"> <%=cartItem.getQuantity()%>
						</span>


						<form action="<%=request.getContextPath()%>/cart" method="post">

							<input type="hidden" name="action" value="increase"> <input
								type="hidden" name="menuId" value="<%=menu.getMenuID()%>">

							<button type="submit" class="quantity-btn"
								aria-label="Increase quantity">+</button>

						</form>

					</div>

					<%
					}
					%>

					<%
					} else {
					%>

					<button type="button" class="cart-btn unavailable-btn" disabled>
						CURRENTLY UNAVAILABLE</button>

					<%
					}
					%>

				</div>

			</article>

			<%
			}
			%>

		</div>


		<%
		} else {
		%>

		<!-- EMPTY MENU -->
		<div class="empty-message">

			<h3>No menu items available</h3>

			<p>There are no dishes available for this restaurant right now.</p>

		</div>

		<%
		}
		%>

	</main>


	<%@ include file="includes/footer.jsp"%>


	<!-- SEARCH AND CATEGORY FILTERING -->
	<script>
		document
				.addEventListener(
						"DOMContentLoaded",
						function() {

							const searchInput = document
									.getElementById("menuSearch");

							const categoryButtons = document
									.querySelectorAll(".category-filter");

							const menuCards = document
									.querySelectorAll(".menu-card");

							const menuCount = document
									.getElementById("menuCount");

							const noSearchResults = document
									.getElementById("noSearchResults");

							if (!searchInput) {
								return;
							}

							let selectedCategory = "all";

							function filterMenu() {

								const searchText = searchInput.value.trim()
										.toLowerCase();

								let visibleCount = 0;

								menuCards
										.forEach(function(card) {

											const cardText = card.textContent
													.toLowerCase();

											const cardCategory = (card.dataset.category || "")
													.toLowerCase();

											const matchesSearch = cardText
													.includes(searchText);

											const matchesCategory = selectedCategory === "all"
													|| cardCategory === selectedCategory;

											const shouldShow = matchesSearch
													&& matchesCategory;

											card.style.display = shouldShow ? ""
													: "none";

											if (shouldShow) {
												visibleCount++;
											}

										});

								if (menuCount) {
									menuCount.textContent = "Showing "
											+ visibleCount
											+ (visibleCount === 1 ? " dish."
													: " dishes.");
								}

								if (noSearchResults) {
									noSearchResults.style.display = visibleCount === 0 ? "block"
											: "none";
								}

							}

							searchInput.addEventListener("input", filterMenu);

							categoryButtons
									.forEach(function(button) {

										button
												.addEventListener(
														"click",
														function() {

															categoryButtons
																	.forEach(function(
																			item) {
																		item.classList
																				.remove("active");
																	});

															button.classList
																	.add("active");

															selectedCategory = (button.dataset.category || "all")
																	.toLowerCase();

															filterMenu();

														});

									});

							filterMenu();

						});

		// Preserve scroll position after cart actions.
		document.querySelectorAll('form[action$="/cart"]').forEach(
				function(form) {

					form.addEventListener("submit", function() {

						sessionStorage.setItem("menuScrollPosition",
								window.scrollY);

					});

				});

		window.addEventListener("load", function() {

			const savedPosition = sessionStorage.getItem("menuScrollPosition");

			if (savedPosition !== null) {

				sessionStorage.removeItem("menuScrollPosition");

				window.scrollTo(0, parseInt(savedPosition, 10) || 0);

			}

		});
	</script>

</body>
</html>