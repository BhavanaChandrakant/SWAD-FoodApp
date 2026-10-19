<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="com.tap.model.Cart"%>
<%@ page import="com.tap.model.CartItem"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Your Cart | SWAD</title>

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/common.css?v=1">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/cart.css?v=14">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/navbar.css?v=25">
</head>

<body>

	<%@ include file="includes/navbar.jsp"%>

	<%
	// Get cart from request first, then fall back to session.
	Cart cart = (Cart) request.getAttribute("cart");

	if (cart == null) {
		cart = (Cart) session.getAttribute("cart");
	}

	// Create an empty cart if none exists.
	if (cart == null) {
		cart = new Cart();
		session.setAttribute("cart", cart);
	}

	boolean cartIsEmpty = cart.isEmpty();
	%>

	<main class="cart-page">

		<!-- CART HEADER -->
		<section class="cart-hero">

			<div class="cart-hero-content">

				<p class="cart-label">
					SWAD <span aria-hidden="true">•</span> YOUR ORDER
				</p>

				<h1>Your Cart</h1>

			</div>

			<%
			if (!cartIsEmpty) {
			%>

			<div class="cart-header-count">

				<span class="count-number"> <%=cart.getTotalItems()%>
				</span> <span> <%=cart.getTotalItems() == 1 ? "item" : "items"%>
				</span>

			</div>

			<%
			}
			%>

		</section>


		<!-- CART CONTENT -->
		<section class="cart-container">

			<%
			if (!cartIsEmpty) {
			%>

			<!-- LEFT: CART ITEMS -->
			<div class="cart-items-section">

				<div class="cart-section-heading">

					<h2>Your Items</h2>

					<span> <%=cart.getTotalItems()%> <%=cart.getTotalItems() == 1 ? "item" : "items"%>
					</span>

				</div>


				<!-- LOOP THROUGH CART ITEMS -->
				<%
				for (CartItem item : cart.getItems().values()) {
				%>

				<article class="cart-item">

					<!-- FOOD IMAGE -->
					<div class="cart-image-container">

						<%
						if (item.getImagePath() != null && !item.getImagePath().trim().isEmpty()) {
						%>

						<img src="<%=item.getImagePath()%>"
							alt="<%=item.getItemName()%>" class="cart-image" loading="lazy">

						<%
						} else {
						%>

						<div class="cart-image-placeholder"
							aria-label="Food image unavailable">SWAD</div>

						<%
						}
						%>

					</div>


					<!-- FOOD DETAILS -->
					<div class="item-details">

						<h3>
							<%=item.getItemName()%>
						</h3>

						<p class="unit-price">
							₹<%=item.getPrice()%>
							<span>per item</span>
						</p>


						<!-- QUANTITY CONTROLS -->
						<div class="quantity-control" aria-label="Change quantity">

							<!-- DECREASE QUANTITY -->
							<form action="<%=request.getContextPath()%>/cart" method="post">

								<input type="hidden" name="action" value="decrease"> <input
									type="hidden" name="menuId" value="<%=item.getMenuId()%>">

								<input type="hidden" name="source" value="cart">

								<button type="submit" class="quantity-btn"
									aria-label="Decrease quantity">−</button>

							</form>


							<!-- CURRENT QUANTITY -->
							<span class="quantity-number"> <%=item.getQuantity()%>
							</span>


							<!-- INCREASE QUANTITY -->
							<form action="<%=request.getContextPath()%>/cart" method="post">

								<input type="hidden" name="action" value="increase"> <input
									type="hidden" name="menuId" value="<%=item.getMenuId()%>">

								<input type="hidden" name="restaurantId"
									value="<%=item.getRestaurantId()%>"> <input
									type="hidden" name="source" value="cart">

								<button type="submit" class="quantity-btn"
									aria-label="Increase quantity">+</button>

							</form>

						</div>

					</div>


					<!-- ITEM TOTAL -->
					<div class="item-total">

						<span>Item total</span> <strong> ₹<%=item.getItemTotal()%>
						</strong>

					</div>

				</article>

				<%
				}
				%>


				<!-- CONTINUE SHOPPING -->
				<a class="back-to-menu"
					href="<%=request.getContextPath()%>/menu?restaurantId=<%=cart.getItems().values().iterator().next().getRestaurantId()%>">

					<span aria-hidden="true">←</span> Continue shopping

				</a>

			</div>


			<!-- RIGHT: ORDER SUMMARY -->
			<aside class="cart-summary">

				<div class="summary-heading">

					<span class="summary-kicker"> YOUR ORDER </span>

					<h2>Order Summary</h2>

				</div>


				<!-- TOTAL ITEMS -->
				<div class="summary-row">

					<span>Total items</span> <strong> <%=cart.getTotalItems()%>
					</strong>

				</div>


				<div class="summary-divider"></div>


				<!-- GRAND TOTAL -->
				<div class="summary-total">

					<span>Grand total</span> <strong> ₹<%=cart.getTotal()%>
					</strong>

				</div>


				<!-- CHECKOUT -->
				<a href="<%=request.getContextPath()%>/checkout"
					class="checkout-btn"> Proceed to Checkout <span
					aria-hidden="true">→</span>

				</a>


				<!-- CLEAR CART -->
				<form action="<%=request.getContextPath()%>/cart" method="post"
					class="clear-cart-form"
					onsubmit="return confirm('Are you sure you want to clear your cart?');">

					<input type="hidden" name="action" value="clear">

					<button type="submit" class="clear-btn">Clear Cart</button>

				</form>


				<p class="summary-note">Check your items before proceeding to
					checkout.</p>

			</aside>


			<%
			} else {
			%>

			<!-- EMPTY CART -->
			<section class="empty-cart">

				<div class="empty-cart-icon" aria-hidden="true">

					<svg xmlns="http://www.w3.org/2000/svg" width="54" height="54"
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">

                            <circle cx="9" cy="21" r="1"></circle>

                            <circle cx="20" cy="21" r="1"></circle>

                            <path
							d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>

                        </svg>

				</div>

				<h2>Your Cart is Empty</h2>

				<p>Your cart is waiting for something delicious. Explore our
					restaurants and find your next favourite dish.</p>

				<a href="<%=request.getContextPath()%>/restaurant"
					class="browse-btn"> Explore Restaurants <span
					aria-hidden="true">→</span>

				</a>

			</section>

			<%
			}
			%>

		</section>

	</main>

	<%@ include file="includes/footer.jsp"%>

</body>
</html>