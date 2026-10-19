<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>SWAD | Good Food, Great Mood</title>

    <meta name="description"
          content="Discover restaurants and explore delicious food with SWAD. Find your next favourite meal.">

   <link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/common.css?v=1">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/navbar.css?v=25">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/home.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/home-animation.css?v=typed-v3">
          
  

</head>

<body>

    <%@ include file="includes/navbar.jsp" %>

    <main class="home-page">

        <!-- HERO SECTION -->
        <section class="home-hero food-hero" id="home">

            <!-- Looping background video -->
            <video class="hero-background-video"
                   autoplay
                   muted
                   loop
                   playsinline
                   preload="auto"
                   aria-hidden="true"
                   tabindex="-1">

                <source
                    src="<%= request.getContextPath() %>/videos/food_cinematic_5clips_16x9.mp4"
                    type="video/mp4">
            </video>

            <!-- Warm translucent video overlay -->
            <div class="hero-video-overlay" aria-hidden="true"></div>

            <!-- Centered hero content -->
            <div class="hero-shell food-hero-shell">

                <div class="hero-copy food-hero-copy">

                    <p class="hero-kicker">
                        <span class="kicker-dot"></span>
                        GOOD FOOD STARTS HERE
                    </p>

                    <!-- Typed headline -->
                    <h1 class="hero-headline">
                        Every craving

                        <span class="typed-headline-line">
                            <span id="typed-phrase">Food Lover</span><span
                                class="typed-cursor"
                                aria-hidden="true">|</span>
                        </span>
                    </h1>

                    <!-- Description with highlighted text -->
                    <p class="hero-description">
                        From comforting classics to exciting new flavours,
                        discover restaurants and find
                        <span class="description-highlight">
                            something delicious
                        </span>
                        to enjoy with SWAD.
                    </p>

                    <!-- Hero buttons -->
                    <div class="hero-actions">

                        <a class="home-btn home-btn-primary"
                           href="<%= request.getContextPath() %>/restaurant">

                            Explore Restaurants
                            <span aria-hidden="true">→</span>
                        </a>

                        <a class="hero-secondary-link"
                           href="#how-it-works">

                            Discover SWAD
                            <span aria-hidden="true">↓</span>
                        </a>

                    </div>

                    <!-- Animated tagline -->
                    <div class="hero-caption hero-tagline">

                        <span class="caption-line"></span>

                        <p class="hero-tagline-text">
                            <span class="tagline-word">Find it.</span>
                            <span class="tagline-word">Love it.</span>
                            <span class="tagline-word">Savour it.</span>
                        </p>

                    </div>

                </div>

            </div>

            <div class="hero-bottom-decoration"
                 aria-hidden="true"></div>

        </section>


        <!-- BENEFITS STRIP -->
        <section class="benefits-strip"
                 aria-label="Why explore SWAD">

            <div class="benefit-item">
                <span class="benefit-icon" aria-hidden="true">⌕</span>

                <div>
                    <strong>Explore</strong>
                    <p>Discover restaurants</p>
                </div>
            </div>

            <span class="benefit-divider" aria-hidden="true"></span>

            <div class="benefit-item">
                <span class="benefit-icon" aria-hidden="true">♡</span>

                <div>
                    <strong>Choose</strong>
                    <p>Find your favourites</p>
                </div>
            </div>

            <span class="benefit-divider" aria-hidden="true"></span>

            <div class="benefit-item">
                <span class="benefit-icon" aria-hidden="true">✦</span>

                <div>
                    <strong>Enjoy</strong>
                    <p>Make every meal special</p>
                </div>
            </div>

        </section>


        <!-- FOOD INSPIRATION SECTION -->
        <section class="food-section" id="explore">

            <div class="section-heading">

                <div>
                    <p class="section-eyebrow">
                        FOLLOW YOUR CRAVINGS
                    </p>

                    <h2>
                        What sounds
                        <span>delicious today?</span>
                    </h2>

                    <p class="section-description">
                        Get inspired, explore your options, and find
                        something that makes your day a little tastier.
                    </p>
                </div>

                <a class="section-link"
                   href="<%= request.getContextPath() %>/restaurant">

                    View Restaurants
                    <span aria-hidden="true">→</span>
                </a>

            </div>


            <div class="food-grid">

                <!-- FOOD CARD 1: INDIAN CLASSICS -->
                <a class="food-card"
                   href="<%= request.getContextPath() %>/restaurant"
                   aria-label="Explore restaurants for Indian classics">

                    <div class="food-image-wrap">

                        <img
                            src="https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&amp;fit=crop&amp;w=700&amp;q=80"
                            alt="Colourful Indian curry dishes"
                            loading="lazy">

                        <span class="food-image-tag">
                            Comfort food
                        </span>
                    </div>

                    <div class="food-card-content">

                        <div>
                            <h3>Indian Classics</h3>
                            <p>Rich flavours, timeless favourites.</p>
                        </div>

                        <span class="food-card-arrow"
                              aria-hidden="true">↗</span>
                    </div>

                </a>


                <!-- FOOD CARD 2: QUICK BITES -->
                <a class="food-card"
                   href="<%= request.getContextPath() %>/restaurant"
                   aria-label="Explore restaurants for pizza and quick bites">

                    <div class="food-image-wrap">

                        <img
                            src="https://images.unsplash.com/photo-1571407970349-bc81e7e96d47?auto=format&amp;fit=crop&amp;w=700&amp;q=80"
                            alt="Pizza topped with fresh ingredients"
                            loading="lazy">

                        <span class="food-image-tag">
                            Quick bites
                        </span>
                    </div>

                    <div class="food-card-content">

                        <div>
                            <h3>Quick Bites</h3>
                            <p>Easy favourites for any mood.</p>
                        </div>

                        <span class="food-card-arrow"
                              aria-hidden="true">↗</span>
                    </div>

                </a>


                <!-- FOOD CARD 3: NOODLES -->
                <a class="food-card"
                   href="<%= request.getContextPath() %>/restaurant"
                   aria-label="Explore restaurants for noodles and savoury dishes">

                    <div class="food-image-wrap">

                        <img
                            src="https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&amp;fit=crop&amp;w=700&amp;q=80"
                            alt="A bowl of noodles"
                            loading="lazy">

                        <span class="food-image-tag">
                            Full of flavour
                        </span>
                    </div>

                    <div class="food-card-content">

                        <div>
                            <h3>Flavour Favourites</h3>
                            <p>Discover something different.</p>
                        </div>

                        <span class="food-card-arrow"
                              aria-hidden="true">↗</span>
                    </div>

                </a>


                <!-- FOOD CARD 4: SWEET TREATS -->
                <a class="food-card"
                   href="<%= request.getContextPath() %>/restaurant"
                   aria-label="Explore restaurants for desserts and sweet treats">

                    <div class="food-image-wrap">

                        <img
                            src="https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&amp;fit=crop&amp;w=700&amp;q=80"
                            alt="A sweet dessert"
                            loading="lazy">

                        <span class="food-image-tag">
                            Sweet moments
                        </span>
                    </div>

                    <div class="food-card-content">

                        <div>
                            <h3>Sweet Treats</h3>
                            <p>A little sweetness goes a long way.</p>
                        </div>

                        <span class="food-card-arrow"
                              aria-hidden="true">↗</span>
                    </div>

                </a>

            </div>

            <p class="food-section-note">
                These are food inspirations. Browse restaurants to see
                the actual menus available in SWAD.
            </p>

        </section>


        <!-- HOW SWAD WORKS -->
        <section class="how-section" id="how-it-works">

            <div class="how-inner">

                <div class="how-intro">

                    <p class="section-eyebrow">
                        A SIMPLE WAY TO EXPLORE
                    </p>

                    <h2>
                        Your food journey,
                        <span>made simple.</span>
                    </h2>

                    <p>
                        Discover places to eat and explore their menus
                        with just a few simple steps.
                    </p>

                    <a class="home-btn home-btn-dark"
                       href="<%= request.getContextPath() %>/restaurant">

                        Start Exploring
                        <span aria-hidden="true">→</span>
                    </a>

                </div>


                <div class="steps-list">

                    <article class="step-card">

                        <span class="step-number">01</span>

                        <div class="step-icon" aria-hidden="true">⌕</div>

                        <div class="step-content">
                            <h3>Find a restaurant</h3>

                            <p>
                                Explore the restaurants listed on SWAD
                                and discover your options.
                            </p>
                        </div>

                    </article>


                    <article class="step-card">

                        <span class="step-number">02</span>

                        <div class="step-icon" aria-hidden="true">☷</div>

                        <div class="step-content">
                            <h3>Explore the menu</h3>

                            <p>
                                Open a restaurant to view its available
                                dishes and prices.
                            </p>
                        </div>

                    </article>


                    <article class="step-card">

                        <span class="step-number">03</span>

                        <div class="step-icon" aria-hidden="true">♡</div>

                        <div class="step-content">
                            <h3>Choose what you love</h3>

                            <p>
                                Find something that matches your appetite
                                and continue through the existing ordering flow.
                            </p>
                        </div>

                    </article>

                </div>

            </div>

        </section>


        <!-- FINAL CALL TO ACTION -->
        <section class="final-cta">

            <div class="cta-decoration cta-decoration-one"
                 aria-hidden="true"></div>

            <div class="cta-decoration cta-decoration-two"
                 aria-hidden="true"></div>

            <div class="cta-content">

                <p class="cta-eyebrow">
                    YOUR NEXT BITE IS WAITING
                </p>

                <h2>
                    Bring a little more
                    <span>SWAD to your day.</span>
                </h2>

                <p>
                    Start exploring restaurants and discover
                    something delicious.
                </p>

                <a class="home-btn home-btn-white"
                   href="<%= request.getContextPath() %>/restaurant">

                    Explore Restaurants
                    <span aria-hidden="true">→</span>
                </a>

            </div>

        </section>

    </main>

    <%@ include file="includes/footer.jsp" %>


    <!-- TYPED HEADLINE ANIMATION -->
    <script>
    (function () {
        "use strict";

        function startTypedHeadline() {

            var typedElement =
                document.getElementById("typed-phrase");

            var cursor =
                document.querySelector(".typed-cursor");

            if (!typedElement) {
                return;
            }

            var phrases = [
                "Food Lover",
                "Biryani Fan",
                "Pizza Lover",
                "Dessert Lover"
            ];

            var phraseIndex = 0;
            var characterIndex = 0;
            var deleting = false;

            var typingSpeed = 85;
            var deletingSpeed = 42;
            var phrasePause = 1400;
            var betweenPhrasesPause = 250;

            var reduceMotion =
                window.matchMedia &&
                window.matchMedia(
                    "(prefers-reduced-motion: reduce)"
                ).matches;

            if (reduceMotion) {
                typedElement.textContent = phrases[0];

                if (cursor) {
                    cursor.style.display = "none";
                }

                return;
            }

            typedElement.textContent = "";

            function animateTyping() {

                var currentPhrase = phrases[phraseIndex];

                if (!deleting) {

                    characterIndex++;

                    typedElement.textContent =
                        currentPhrase.substring(0, characterIndex);

                    if (characterIndex >= currentPhrase.length) {

                        deleting = true;

                        window.setTimeout(
                            animateTyping,
                            phrasePause
                        );

                    } else {

                        window.setTimeout(
                            animateTyping,
                            typingSpeed
                        );
                    }

                } else {

                    characterIndex--;

                    typedElement.textContent =
                        currentPhrase.substring(0, characterIndex);

                    if (characterIndex <= 0) {

                        deleting = false;

                        phraseIndex =
                            (phraseIndex + 1) % phrases.length;

                        window.setTimeout(
                            animateTyping,
                            betweenPhrasesPause
                        );

                    } else {

                        window.setTimeout(
                            animateTyping,
                            deletingSpeed
                        );
                    }
                }
            }

            window.setTimeout(animateTyping, 250);
        }

        if (document.readyState === "loading") {

            document.addEventListener(
                "DOMContentLoaded",
                startTypedHeadline,
                { once: true }
            );

        } else {

            startTypedHeadline();
        }

        // Retry video playback if the browser delays autoplay.
        function startHeroVideo() {

            var video =
                document.querySelector(".hero-background-video");

            if (!video) {
                return;
            }

            video.muted = true;

            var playPromise = video.play();

            if (playPromise &&
                typeof playPromise.catch === "function") {

                playPromise.catch(function () {
                    // Playback may be blocked by browser policy.
                });
            }
        }

        if (document.readyState === "loading") {

            document.addEventListener(
                "DOMContentLoaded",
                startHeroVideo,
                { once: true }
            );

        } else {

            startHeroVideo();
        }

    })();
    </script>

</body>
</html>