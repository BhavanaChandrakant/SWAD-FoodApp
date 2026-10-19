
<%@ page import="com.tap.model.User"%>
<%@ page import="com.tap.model.Cart"%>

<%
// Get the cart from the current session.
Cart navbarCart = (Cart) session.getAttribute("cart");

if (navbarCart == null) {
	navbarCart = (Cart) request.getAttribute("cart");
}

// Count total quantities, including repeated items.
int navbarCartCount = (navbarCart == null) ? 0 : navbarCart.getTotalItems();

// Get the logged-in user.
User loggedInUser = (User) session.getAttribute("user");

String navbarUserName = "";

if (loggedInUser != null && loggedInUser.getName() != null) {
	navbarUserName = loggedInUser.getName().trim();
}
%>

<nav class="swad-navbar">

	<!-- SWAD LOGO -->
	<div class="swad-navbar-brand">
		<a href="${pageContext.request.contextPath}/index.jsp"
			aria-label="SWAD Home"> <span class="swad-navbar-logo-icon">
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
					fill="none" stroke="currentColor" stroke-width="1.8"
					stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">

                    <path d="M6 3v6"></path>
                    <path d="M3.5 3v4"></path>
                    <path d="M8.5 3v4"></path>
                    <path d="M3.5 7c0 2 1 3 2.5 3s2.5-1 2.5-3"></path>
                    <path d="M6 10v11"></path>
                    <path d="M16 3c-2 3-3 5.5-3 9h3v9"></path>

                </svg>
		</span> <span class="swad-navbar-logo-text">SWAD</span>

		</a>
	</div>


	<!-- NAVIGATION LINKS -->
	<div class="swad-navbar-links">

		<a  class="swad-navbar-link"
		     href="${pageContext.request.contextPath}/index.jsp"> Home </a>

		<!-- RESTAURANTS -->
		<a class="swad-navbar-link"
			href="${pageContext.request.contextPath}/restaurant"> Restaurants
		</a>


		<!-- CART WITH ITEM COUNT -->
		<div class="swad-navbar-cart">

			<a class="swad-navbar-link swad-navbar-cart-link"
				href="${pageContext.request.contextPath}/cart"
				aria-label="Shopping cart, <%= navbarCartCount %> items"> Cart </a>

			<%
			if (navbarCartCount > 0) {
			%>

			<span class="swad-navbar-cart-count"> <%=navbarCartCount > 99 ? "99+" : navbarCartCount%>
			</span>

			<%
			}
			%>

		</div>


		<!-- LOGIN OR PROFILE -->
		<%
		if (loggedInUser == null) {
		%>

		<a class="swad-navbar-link"
			href="${pageContext.request.contextPath}/login"> Login </a>

		<%
		} else {
		%>

		<div class="swad-navbar-profile">

			<!-- USER INITIAL -->
			<button type="button" class="swad-navbar-profile-button"
				aria-label="Open user profile menu">

				<%=navbarUserName.isEmpty() ? "U" : navbarUserName.substring(0, 1).toUpperCase()%>

			</button>


			<!-- PROFILE DROPDOWN -->
			<div class="swad-navbar-dropdown">

				<div class="swad-navbar-user-name">
					<%=navbarUserName.isEmpty() ? "User" : navbarUserName%>
				</div>

				<div class="swad-navbar-divider"></div>

				<a href="${pageContext.request.contextPath}/orders"> My Orders </a>

				<a href="${pageContext.request.contextPath}/profile"> Profile </a>

				<div class="swad-navbar-divider"></div>

				<a class="swad-navbar-logout"
					href="${pageContext.request.contextPath}/logout"> Logout </a>

			</div>

		</div>

		<%
		}
		%>

	</div>

</nav>