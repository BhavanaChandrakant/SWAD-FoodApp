
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Login | SWAD</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css?v=1">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/Login.css?v=5">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/navbar.css?v=25">
</head>

<body>

    <%@ include file="includes/navbar.jsp" %>

    <main class="login-container">

        <div class="login-layout">

            <!-- LEFT FOOD PANEL -->
            <section class="login-visual">

                <img
                    src="https://cdn.spotapps.co/spothopper/image/fetch/f_auto%2Cq_auto%3Abest%2Cc_fit%2Ch_1200/http%3A/static.spotapps.co/spots/d9/c6fafb57a24dfab6f90e990ae85dc9/%3Aoriginal"
                    alt="A spread of delicious Indian food"
                    class="login-food-image">

                <div class="visual-overlay"></div>

                <div class="visual-content">

                    <p class="visual-label">WELCOME TO SWAD</p>

                    <h1>
                        Good food. <span>Good mood.</span>
                    </h1>

                    <p class="visual-description">
                        Your favourite meals, your favourite restaurants,
                        and a little more happiness in every bite.
                    </p>

                    <div class="visual-feature">
                        <span class="feature-icon" aria-hidden="true">
                            &#10003;
                        </span>
                        <span>Discover food you'll love</span>
                    </div>

                </div>

                <div class="visual-bottom">
                    MADE WITH LOVE, SERVED WITH SWAD
                </div>

            </section>

            <!-- RIGHT LOGIN PANEL -->
            <section class="login-form-panel">

                <div class="login-box">

                    <!-- LOGIN HEADING -->
                    <div class="login-heading">

                        <div class="login-mini-logo" aria-hidden="true">

                            <svg xmlns="http://www.w3.org/2000/svg"
                                 viewBox="0 0 24 24"
                                 fill="none"
                                 stroke="currentColor"
                                 stroke-width="1.8"
                                 stroke-linecap="round"
                                 stroke-linejoin="round">

                                <path d="M3 2v7a4 4 0 0 0 8 0V2"></path>
                                <path d="M7 2v20"></path>
                                <path d="M21 15V2"></path>
                                <path d="M18 15h3"></path>
                                <path d="M21 15v7"></path>

                            </svg>

                        </div>

                        <p class="login-eyebrow">YOUR TABLE IS WAITING</p>

                        <h2>Welcome Back!</h2>

                        <p class="login-subtitle">
                            Log in to continue your delicious journey.
                        </p>

                    </div>

                    <!-- ERROR MESSAGE: FIXED ATTRIBUTE NAME -->
                    <%
                        String errorMessage =
                            (String) request.getAttribute("errorMessage");

                        if (errorMessage != null) {
                            String safeError = errorMessage
                                .replace("&", "&amp;")
                                .replace("<", "&lt;")
                                .replace(">", "&gt;")
                                .replace("\"", "&quot;")
                                .replace("'", "&#39;");
                    %>

                    <div class="error-message" role="alert">
                        <span class="error-icon" aria-hidden="true">!</span>
                        <span><%= safeError %></span>
                    </div>

                    <%
                        }
                    %>

                    <!-- LOGIN FORM -->
                    <form
                        action="${pageContext.request.contextPath}/login"
                        method="post"
                        class="login-form">

                        <!-- EMAIL -->
                        <div class="form-group">

                            <label for="email">Email Address</label>

                            <div class="input-wrapper">

                                <span class="input-icon" aria-hidden="true">
                                    &#9993;
                                </span>

                                <input
                                    type="email"
                                    id="email"
                                    name="email"
                                    placeholder="Enter your email address"
                                    autocomplete="email"
                                    required>

                            </div>

                        </div>

                        <!-- PASSWORD -->
                        <div class="form-group">

                            <div class="label-row">

                                <label for="password">Password</label>

                                <a
                                    href="${pageContext.request.contextPath}/forgotPassword"
                                    class="forgot-inline">
                                    Forgot Password?
                                </a>

                            </div>

                            <div class="input-wrapper password-wrapper">

                                <span class="input-icon" aria-hidden="true">
                                    &#128274;
                                </span>

                                <input
                                    type="password"
                                    id="password"
                                    name="password"
                                    placeholder="Enter your password"
                                    autocomplete="current-password"
                                    required>

                                <!-- SHOW / HIDE PASSWORD -->
                                <button
                                    type="button"
                                    class="toggle-password"
                                    id="togglePassword"
                                    aria-label="Show password"
                                    aria-pressed="false">

                                    <svg
                                        xmlns="http://www.w3.org/2000/svg"
                                        viewBox="0 0 24 24"
                                        width="21"
                                        height="21"
                                        fill="none"
                                        stroke="currentColor"
                                        stroke-width="1.8"
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        aria-hidden="true">

                                        <path
                                            d="M2 12s3.6-7 10-7 10 7 10 7-3.6 7-10 7-10-7-10-7z">
                                        </path>

                                        <circle cx="12" cy="12" r="3"></circle>

                                    </svg>

                                </button>

                            </div>

                        </div>

                        <!-- LOGIN BUTTON -->
                        <button type="submit" class="login-btn">

                            <span>Login to SWAD</span>

                            <span class="login-arrow" aria-hidden="true">
                                &rarr;
                            </span>

                        </button>

                    </form>

                    <!-- SIGNUP LINK -->
                    <div class="signup-text">

                        <span>New to SWAD?</span>

                        <a href="${pageContext.request.contextPath}/signup">
                            Create an account
                        </a>

                    </div>

                    <!-- BOTTOM DIVIDER -->
                    <div class="login-divider">

                        <span></span>

                        <p>GOOD FOOD IS JUST AHEAD</p>

                        <span></span>

                    </div>

                </div>

            </section>

        </div>

    </main>

    <!-- PASSWORD VISIBILITY -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {

            const passwordInput =
                document.getElementById("password");

            const toggleButton =
                document.getElementById("togglePassword");

            if (!passwordInput || !toggleButton) {
                return;
            }

            toggleButton.addEventListener("click", function () {

                const isPasswordHidden =
                    passwordInput.type === "password";

                passwordInput.type =
                    isPasswordHidden ? "text" : "password";

                toggleButton.setAttribute(
                    "aria-label",
                    isPasswordHidden ? "Hide password" : "Show password"
                );

                toggleButton.setAttribute(
                    "aria-pressed",
                    String(isPasswordHidden)
                );

            });

        });
    </script>

</body>
</html>
