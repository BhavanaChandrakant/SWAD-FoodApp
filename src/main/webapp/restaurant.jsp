<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.tap.model.Restaurant"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Restaurants | SWAD</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/common.css?v=1">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/restaurant.css?v=6">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/navbar.css?v=25">
</head>

<body>

	<%@ include file="includes/navbar.jsp"%>

	<main class="page-content">

		<!-- ================= HERO SECTION ================= -->

		<section class="restaurant-hero">

			<div class="hero-content">

				<p class="hero-small-title">YOUR NEXT DELICIOUS MEAL</p>

				<h1>
					Good food. <span>Good mood.</span>
				</h1>

				<p class="hero-description">Discover amazing restaurants,
					explore their menus, and find something delicious for your next
					meal.</p>

				<a href="#restaurant-list" class="hero-button"> <span
					class="hero-button-text"> Explore Restaurants </span> <span
					class="hero-button-arrow" aria-hidden="true">↓</span>
				</a>

			</div>

			<!-- FOOD IMAGE -->

			<div class="hero-visual">

				<div class="hero-image-wrap">

					<img
						src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=85"
						alt="A delicious spread of food" class="hero-food-image">

				</div>

				<div class="hero-floating-card">

					<div class="hero-card-star">★</div>

					<div class="hero-card-text">
						<strong>Good food, happy mood!</strong> <span>Find your
							next favourite meal</span>
					</div>

				</div>

			</div>

			<!-- DECORATIVE BACKGROUND -->

			<div class="hero-decoration" aria-hidden="true">

				<span class="decoration-circle circle-one"></span> <span
					class="decoration-circle circle-two"></span> <span
					class="decoration-circle circle-three"></span>

			</div>

		</section>


		<!-- ================= RESTAURANT LISTING ================= -->

		<section class="restaurant-section" id="restaurant-list">

			<!-- HEADING AND SEARCH -->

			<div class="restaurant-toolbar">

				<div class="section-heading">

					<p class="section-label">EXPLORE OUR COLLECTION</p>

					<h2>Restaurants for you</h2>

					<p class="section-description">Find your favourite place and
						discover its menu.</p>

				</div>


				<!-- RESTAURANT SEARCH -->

				<div class="restaurant-search">

					<label for="restaurantSearch" class="search-label"> Find a
						restaurant </label>

					<div class="search-input-wrap">

						<span class="search-icon" aria-hidden="true">&#9906;</span> <input
							type="search" id="restaurantSearch"
							placeholder="Search for restaurant, cuisine or a dish..."
							autocomplete="off" aria-describedby="searchStatus">

						<button type="button" id="clearSearch" class="search-clear"
							aria-label="Clear restaurant search" hidden>&times;</button>

					</div>

					<!-- Remains hidden until there is search feedback -->

					<p id="searchStatus" class="search-status" role="status"
						aria-live="polite"></p>

				</div>

			</div>


			<!-- ================= RESTAURANT CARDS ================= -->

			<div class="restaurant-container">

				<%
				List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");

				if (restaurants != null && !restaurants.isEmpty()) {

					for (Restaurant restaurant : restaurants) {
				%>

				<article class="restaurant-card">

					<!-- RESTAURANT IMAGE -->

					<div class="image-container">

						<img class="restaurant-image" src="<%=restaurant.getImagePath()%>"
							alt="<%=restaurant.getName()%>" loading="lazy"> <span
							class="image-badge"> Discover </span>

					</div>


					<!-- RESTAURANT DETAILS -->

					<div class="card-content">

						<h3 class="restaurant-name">
							<%=restaurant.getName()%>
						</h3>

						<p class="cuisine">
							<span class="detail-icon" aria-hidden="true">🍽</span>

							<%=restaurant.getCuisineType()%>
						</p>

						<p class="address">
							<span class="detail-icon" aria-hidden="true">📍</span>

							<%=restaurant.getAddress()%>
						</p>


						<!-- RESTAURANT RATING -->

						<div class="card-bottom">

							<span class="rating"> <span aria-hidden="true">★</span> <%=restaurant.getRating()%>
							</span> <span class="rating-caption"> Restaurant rating </span>

						</div>


						<!-- VIEW MENU -->

						<a
							href="<%=request.getContextPath()%>/menu?restaurantId=<%=restaurant.getRestaurantId()%>"
							class="view-menu"> <span>View Menu</span> <span class="arrow"
							aria-hidden="true">→</span>

						</a>

					</div>

				</article>

				<%
				}

				} else {
				%>

				<!-- NO RESTAURANTS -->

				<div class="no-restaurants">

					<div class="empty-icon" aria-hidden="true">🍽</div>

					<h3>No restaurants available</h3>

					<p>There are no restaurants to display right now. Please check
						again later.</p>

				</div>

				<%
				}
				%>


				<!-- NO SEARCH RESULTS -->

				<div class="no-search-results" id="noSearchResults" hidden>

					<div class="empty-icon" aria-hidden="true">&#128269;</div>

					<h3>No matching restaurants found</h3>

					<p>Try another restaurant name, cuisine, or location.</p>

				</div>

			</div>

		</section>

	</main>

	<!-- COMMON FOOTER -->

	<%@ include file="includes/footer.jsp"%>


	<!-- ================= SEARCH AND PLACEHOLDER ANIMATION ================= -->

	<script>
        document.addEventListener("DOMContentLoaded", function () {

            const searchInput =
                document.getElementById("restaurantSearch");

            const clearButton =
                document.getElementById("clearSearch");

            const searchStatus =
                document.getElementById("searchStatus");

            const noResults =
                document.getElementById("noSearchResults");

            const cards = Array.from(
                document.querySelectorAll(".restaurant-card")
            );


            // ==========================================
            // ZOMATO-STYLE TYPE-AND-DELETE PLACEHOLDER
            // ==========================================

            const placeholderPhrases = [
    "Search for MTR...",
    "Search for Udupi Garden...",
    "Search for Empire...",
    "Search for Meghana Foods...",
    "Search for Truffles...",
    "Search for Vidyarthi Bhavan...",
    "Search for Nagarjuna..."
];

            const defaultPlaceholder =
                "Search for restaurant, cuisine or a dish...";

            let phraseIndex = 0;
            let characterIndex = 0;
            let isDeleting = false;
            let animationTimer = null;
            let isSearchFocused = false;


            function stopPlaceholderAnimation() {

                if (animationTimer !== null) {
                    clearTimeout(animationTimer);
                    animationTimer = null;
                }
            }


            function animatePlaceholder() {

                // Do not animate while the user is using the search.
                if (isSearchFocused ||
                    searchInput.value.trim() !== "") {
                    return;
                }

                const phrase = placeholderPhrases[phraseIndex];

                if (!isDeleting) {

                    // Type one character at a time.
                    characterIndex++;

                    searchInput.placeholder =
                        phrase.substring(0, characterIndex);

                    if (characterIndex >= phrase.length) {

                        isDeleting = true;

                        // Keep the complete phrase visible briefly.
                        animationTimer = setTimeout(
                            animatePlaceholder,
                            1200
                        );

                        return;
                    }

                    animationTimer = setTimeout(
                        animatePlaceholder,
                        75
                    );

                } else {

                    // Delete one character at a time.
                    characterIndex--;

                    searchInput.placeholder =
                        phrase.substring(0, characterIndex);

                    if (characterIndex <= 0) {

                        isDeleting = false;

                        phraseIndex =
                            (phraseIndex + 1) %
                            placeholderPhrases.length;

                        animationTimer = setTimeout(
                            animatePlaceholder,
                            350
                        );

                        return;
                    }

                    animationTimer = setTimeout(
                        animatePlaceholder,
                        35
                    );
                }
            }


            function startPlaceholderAnimation() {

                stopPlaceholderAnimation();

                if (searchInput.value.trim() !== "") {
                    return;
                }

                isSearchFocused = false;
                characterIndex = 0;
                isDeleting = false;

                searchInput.placeholder = "";

                animationTimer = setTimeout(
                    animatePlaceholder,
                    400
                );
            }


            // Pause animation while the user focuses the input.
            searchInput.addEventListener("focus", function () {

                isSearchFocused = true;

                stopPlaceholderAnimation();

                searchInput.placeholder = defaultPlaceholder;

            });


            // Resume only when the search is empty.
            searchInput.addEventListener("blur", function () {

                if (searchInput.value.trim() === "") {
                    startPlaceholderAnimation();
                }

            });


            // ==========================================
            // SEARCH HELPERS
            // ==========================================

            function normalize(value) {
                return value.trim().toLowerCase();
            }


            // ==========================================
            // FILTER RESTAURANTS
            // ==========================================

            function searchRestaurants() {

                const query = normalize(searchInput.value);

                let visibleCount = 0;

                cards.forEach(function (card) {

                    const name = normalize(
                        card.querySelector(".restaurant-name")
                            ?.textContent || ""
                    );

                    const cuisine = normalize(
                        card.querySelector(".cuisine")
                            ?.textContent || ""
                    );

                    const address = normalize(
                        card.querySelector(".address")
                            ?.textContent || ""
                    );

                    const matches =
                        query === "" ||
                        name.includes(query) ||
                        cuisine.includes(query) ||
                        address.includes(query);

                    card.style.display =
                        matches ? "" : "none";

                    if (matches) {
                        visibleCount++;
                    }

                });


                // Clear button appears only when searching.
                clearButton.hidden = query.length === 0;


                // Display the no-results panel only when needed.
                noResults.hidden =
                    visibleCount > 0 || cards.length === 0;


                // Keep the status line empty before searching.
                if (query === "") {

                    searchStatus.textContent = "";

                } else if (cards.length === 0) {

                    searchStatus.textContent =
                        "No restaurants are currently available.";

                } else if (visibleCount === 0) {

                    searchStatus.textContent =
                        "No matching restaurants found.";

                } else {

                    searchStatus.textContent =
                        "Found " + visibleCount +
                        (visibleCount === 1
                            ? " restaurant."
                            : " restaurants.");
                }

            }


            // ==========================================
            // SEARCH EVENT LISTENERS
            // ==========================================

            searchInput.addEventListener(
                "input",
                function () {

                    searchRestaurants();

                    // Keep the user's typed text untouched.
                    if (searchInput.value.trim() !== "") {
                        stopPlaceholderAnimation();
                    }

                }
            );


            clearButton.addEventListener("click", function () {

                searchInput.value = "";

                searchRestaurants();

                searchInput.focus();

            });


            // ==========================================
            // SCROLL POSITION RESTORATION
            // ==========================================

            const scrollKey =
                "scrollPosition_" + window.location.pathname;

            document.addEventListener("submit", function (event) {

                if (event.target.tagName === "FORM") {

                    sessionStorage.setItem(
                        scrollKey,
                        window.scrollY
                    );

                }

            });

            window.addEventListener("load", function () {

                const scrollPosition =
                    sessionStorage.getItem(scrollKey);

                if (scrollPosition !== null) {

                    window.scrollTo(
                        0,
                        parseInt(scrollPosition, 10)
                    );

                    sessionStorage.removeItem(scrollKey);
                }

            });


            // INITIALIZE
            searchRestaurants();
            startPlaceholderAnimation();

        });
    </script>

</body>
</html>