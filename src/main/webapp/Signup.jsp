<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Create Account | SWAD</title>

    <link rel="stylesheet"
          href="<%=request.getContextPath()%>/css/common.css?v=1">

    <link rel="stylesheet"
          href="<%=request.getContextPath()%>/css/Signup.css">

    <link rel="stylesheet"
          href="<%=request.getContextPath()%>/css/navbar.css?v=25">
</head>

<body>

    <%@ include file="includes/navbar.jsp" %>

    <main class="signup-container">

        <div class="signup-box">

            <div class="signup-heading">
                <div class="signup-mini-logo">
                    SWAD
                </div>

                <p class="signup-eyebrow">WELCOME TO SWAD</p>

                <h1>Create Account</h1>

                <p class="signup-subtitle">
                    Create your account and enjoy delicious food.
                </p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="message error-message">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <% if (request.getAttribute("success") != null) { %>
                <div class="message success-message">
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>

            <form action="<%=request.getContextPath()%>/signup"
                  method="post"
                  class="signup-form"
                  id="signupForm"
                  novalidate>

                <div class="form-group">
                    <label for="name">Full Name</label>

                    <input type="text"
                           id="name"
                           name="name"
                           placeholder="Enter your full name"
                           autocomplete="name"
                           required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>

                    <input type="email"
                           id="email"
                           name="email"
                           placeholder="Enter your email address"
                           autocomplete="email"
                           required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>

                    <input type="tel"
                           id="phone"
                           name="phone"
                           placeholder="Enter 10-digit phone number"
                           inputmode="numeric"
                           maxlength="10"
                           minlength="10"
                           pattern="[0-9]{10}"
                           autocomplete="tel"
                           required>
                </div>

                <div class="form-group">
                    <label for="address">Address</label>

                    <input type="text"
                           id="address"
                           name="address"
                           placeholder="Enter your address"
                           autocomplete="street-address"
                           required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>

                    <div class="password-wrapper">
                        <input type="password"
                               id="password"
                               name="password"
                               placeholder="Create a password"
                               autocomplete="new-password"
                               required>

                        <button type="button"
                                class="toggle-password"
                                data-target="password"
                                aria-label="Show password"
                                aria-pressed="false">
                            Show
                        </button>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>

                    <div class="password-wrapper">
                        <input type="password"
                               id="confirmPassword"
                               name="confirmPassword"
                               placeholder="Confirm your password"
                               autocomplete="new-password"
                               required>

                        <button type="button"
                                class="toggle-password"
                                data-target="confirmPassword"
                                aria-label="Show confirm password"
                                aria-pressed="false">
                            Show
                        </button>
                    </div>

                    <p id="passwordMatchStatus" class="field-hint"></p>
                </div>

                <p class="terms-note">
                    By creating an account, you agree to use SWAD responsibly.
                </p>

                <button type="submit" class="signup-btn">
                    Create Account
                    <span class="signup-arrow">→</span>
                </button>

                <p class="login-link">
                    Already have an account?
                    <a href="<%=request.getContextPath()%>/login">
                        Login
                    </a>
                </p>

            </form>

        </div>

        <p class="page-footer-text">
            Made with love for food lovers.
        </p>

    </main>

    <script>
        document.addEventListener("DOMContentLoaded", function () {

            const signupForm = document.getElementById("signupForm");

            const nameInput = document.getElementById("name");
            const emailInput = document.getElementById("email");
            const phoneInput = document.getElementById("phone");
            const addressInput = document.getElementById("address");
            const passwordInput = document.getElementById("password");
            const confirmPasswordInput =
                document.getElementById("confirmPassword");

            const passwordMatchStatus =
                document.getElementById("passwordMatchStatus");

            // Show and hide passwords.
            document.querySelectorAll(".toggle-password")
                .forEach(function (button) {

                    button.addEventListener("click", function () {

                        const targetId = this.getAttribute("data-target");
                        const input = document.getElementById(targetId);

                        if (!input) {
                            return;
                        }

                        const shouldShow = input.type === "password";

                        input.type = shouldShow ? "text" : "password";
                        this.textContent = shouldShow ? "Hide" : "Show";

                        this.setAttribute(
                            "aria-label",
                            shouldShow ? "Hide password" : "Show password"
                        );

                        this.setAttribute(
                            "aria-pressed",
                            String(shouldShow)
                        );
                    });
                });

            // Permit digits only, up to 10 digits.
            phoneInput.addEventListener("input", function () {

                this.value = this.value
                    .replace(/[^0-9]/g, "")
                    .slice(0, 10);
            });

            // Check whether the two passwords match.
            function checkPasswords() {

                const password = passwordInput.value;
                const confirmPassword = confirmPasswordInput.value;

                confirmPasswordInput.setCustomValidity("");

                if (confirmPassword === "") {
                    passwordMatchStatus.textContent = "";
                    passwordMatchStatus.classList.remove(
                        "match-success",
                        "match-error"
                    );
                    return;
                }

                if (password === confirmPassword) {

                    passwordMatchStatus.textContent = "Passwords match.";

                    passwordMatchStatus.classList.remove("match-error");
                    passwordMatchStatus.classList.add("match-success");

                } else {

                    passwordMatchStatus.textContent =
                        "Passwords do not match.";

                    passwordMatchStatus.classList.remove("match-success");
                    passwordMatchStatus.classList.add("match-error");

                    confirmPasswordInput.setCustomValidity(
                        "Passwords do not match."
                    );
                }
            }

            passwordInput.addEventListener("input", checkPasswords);
            confirmPasswordInput.addEventListener("input", checkPasswords);

            // Validate everything before submitting.
            signupForm.addEventListener("submit", function (event) {

                event.preventDefault();

                if (nameInput.value.trim() === "") {
                    alert("Please enter your full name.");
                    nameInput.focus();
                    return;
                }

                if (emailInput.value.trim() === "" ||
                    !emailInput.checkValidity()) {

                    alert("Please enter a valid email address.");
                    emailInput.focus();
                    return;
                }

                // STRICT PHONE VALIDATION.
                // A phone number with fewer or more than 10 digits is rejected.
                if (!/^[0-9]{10}$/.test(phoneInput.value)) {

                    alert("Phone number must contain exactly 10 digits.");

                    phoneInput.focus();
                    return;
                }

                if (addressInput.value.trim() === "") {
                    alert("Please enter your address.");
                    addressInput.focus();
                    return;
                }

                const password = passwordInput.value;

                // Password requirements appear only in this popup.
                const passwordIsValid =
                    password.length >= 8 &&
                    /[A-Z]/.test(password) &&
                    /[a-z]/.test(password) &&
                    /[0-9]/.test(password) &&
                    /[^A-Za-z0-9]/.test(password);

                if (!passwordIsValid) {

                    alert(
                        "Please enter a valid password.\n\n" +
                        "Password requirements:\n" +
                        "- At least 8 characters\n" +
                        "- One uppercase letter (A-Z)\n" +
                        "- One lowercase letter (a-z)\n" +
                        "- One number (0-9)\n" +
                        "- One special character (!@#$ etc.)"
                    );

                    passwordInput.focus();
                    return;
                }

                if (confirmPasswordInput.value === "") {
                    alert("Please confirm your password.");
                    confirmPasswordInput.focus();
                    return;
                }

                if (password !== confirmPasswordInput.value) {
                    alert("Password and confirm password do not match.");
                    confirmPasswordInput.focus();
                    return;
                }

                // All checks passed. Submit to the existing servlet.
                signupForm.submit();
            });

        });
    </script>

</body>
</html>