<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Create Account | SWAD</title>

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/common.css?v=1">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/Signup.css">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/navbar.css?v=25">

</head>

<body>

	<%@ include file="includes/navbar.jsp"%>

	<!-- HEADER -->
	<header class="header">

		<a href="<%=request.getContextPath()%>/restaurant" class="brand"
			aria-label="SWAD home"> <span class="brand-icon"
			aria-hidden="true"> <svg viewBox="0 0 24 24" fill="none"
					stroke="currentColor" stroke-width="1.8" stroke-linecap="round"
					stroke-linejoin="round">
                    <path d="M3 2v7a4 4 0 0 0 8 0V2" />
                    <path d="M7 2v20" />
                    <path d="M21 15V2" />
                    <path d="M18 15h3" />
                    <path d="M21 15v7" />
                </svg>
		</span> <span class="brand-name">SWAD</span>
		</a>

		<nav class="header-links" aria-label="Main navigation">
			<a href="<%=request.getContextPath()%>/restaurant">Restaurants</a>
			<a href="<%=request.getContextPath()%>/cart">Cart</a> <a
				href="<%=request.getContextPath()%>/login">Login</a>
		</nav>

	</header>


	<!-- MAIN CONTENT -->
	<main class="signup-container">

		<section class="signup-box">

			<!-- FORM HEADING -->
			<div class="signup-heading">

				<div class="signup-mini-logo" aria-hidden="true">
					<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 2v7a4 4 0 0 0 8 0V2" />
                        <path d="M7 2v20" />
                        <path d="M21 15V2" />
                        <path d="M18 15h3" />
                        <path d="M21 15v7" />
                    </svg>
				</div>

				<p class="signup-eyebrow">JOIN THE SWAD FAMILY</p>

				<h1>Create Account</h1>

				<p class="signup-subtitle">Create your account and start your
					delicious journey.</p>

			</div>


			<!-- ERROR MESSAGE -->
			<%
			String error = (String) request.getAttribute("error");

			if (error != null) {
			%>

			<div class="message error-message" role="alert">
				<span class="message-icon" aria-hidden="true">!</span> <span>
					<%=error.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'",
		"&#39;")%>
				</span>
			</div>

			<%
			}
			%>


			<!-- SUCCESS MESSAGE -->
			<%
			String success = (String) request.getAttribute("success");

			if (success != null) {
			%>

			<div class="message success-message" role="status">
				<span class="message-icon" aria-hidden="true"> &#10003; </span> <span>
					<%=success.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'",
		"&#39;")%>
				</span>
			</div>

			<%
			}
			%>


			<!-- SIGNUP FORM -->
			<form action="<%=request.getContextPath()%>/signup" method="post"
				class="signup-form" id="signupForm">

				<!-- NAME -->
				<div class="form-group">

					<label for="name">Full Name</label> <input type="text" id="name"
						name="name" placeholder="Enter your full name" autocomplete="name"
						required>

				</div>


				<!-- EMAIL -->
				<div class="form-group">

					<label for="email">Email Address</label> <input type="email"
						id="email" name="email" placeholder="Enter your email address"
						autocomplete="email" required>

				</div>


				<!-- PHONE -->
				<div class="form-group">

					<label for="phone">Phone Number</label> <input type="tel"
						id="phone" name="phone" placeholder="Enter your phone number"
						autocomplete="tel" required>

				</div>


				<!-- ADDRESS -->
				<div class="form-group">

					<label for="address">Delivery Address</label>

					<textarea id="address" name="address"
						placeholder="Enter your delivery address"
						autocomplete="street-address" required></textarea>

				</div>


				<!-- PASSWORD -->
				<div class="form-group">

					<label for="password">Password</label>

					<div class="password-wrapper">

						<input type="password" id="password" name="password"
							placeholder="Create a password" autocomplete="new-password"
							required>

						<button type="button" class="toggle-password"
							data-target="password" aria-label="Show password"
							aria-pressed="false">
							<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
								stroke-width="1.8" stroke-linecap="round"
								stroke-linejoin="round" aria-hidden="true">
                                <path
									d="M2 12s3.6-7 10-7 10 7 10 7-3.6 7-10 7-10-7-10-7z" />
                                <circle cx="12" cy="12" r="3" />
                            </svg>
						</button>

					</div>

				</div>


				<!-- CONFIRM PASSWORD -->
				<div class="form-group">

					<label for="confirmPassword">Confirm Password</label>

					<div class="password-wrapper">

						<input type="password" id="confirmPassword" name="confirmPassword"
							placeholder="Enter your password again"
							autocomplete="new-password" required>

						<button type="button" class="toggle-password"
							data-target="confirmPassword" aria-label="Show confirm password"
							aria-pressed="false">
							<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
								stroke-width="1.8" stroke-linecap="round"
								stroke-linejoin="round" aria-hidden="true">
                                <path
									d="M2 12s3.6-7 10-7 10 7 10 7-3.6 7-10 7-10-7-10-7z" />
                                <circle cx="12" cy="12" r="3" />
                            </svg>
						</button>

					</div>

					<p class="field-hint" id="passwordMatchStatus" aria-live="polite"></p>

				</div>


				<!-- TERMS NOTE -->
				<p class="terms-note">Please make sure your details are correct
					before creating your account.</p>


				<!-- SUBMIT BUTTON -->
				<button type="submit" class="signup-btn">
					<span>Create Account</span> <span class="signup-arrow"
						aria-hidden="true">&rarr;</span>
				</button>

			</form>


			<!-- LOGIN LINK -->
			<div class="login-link">
				<span>Already have an account?</span> <a
					href="<%=request.getContextPath()%>/login"> Login </a>
			</div>

		</section>

		<p class="page-footer-text">GOOD FOOD. GOOD MOOD.</p>

	</main>


	<!-- PASSWORD VISIBILITY AND MATCH VALIDATION -->
	<script>
		document.addEventListener("DOMContentLoaded", function() {

			const password = document.getElementById("password");
			const confirmPassword = document.getElementById("confirmPassword");

			const signupForm = document.getElementById("signupForm");

			const matchStatus = document.getElementById("passwordMatchStatus");

			// Show or hide either password field.
			document.querySelectorAll(".toggle-password").forEach(
					function(button) {

						button.addEventListener("click", function() {

							const input = document.getElementById(button
									.getAttribute("data-target"));

							const shouldShow = input.type === "password";

							input.type = shouldShow ? "text" : "password";

							button.setAttribute("aria-label",
									shouldShow ? "Hide password"
											: "Show password");

							button.setAttribute("aria-pressed",
									String(shouldShow));

						});
					});

			// Check that both password values match.
			function checkPasswords() {

				if (confirmPassword.value === "") {
					confirmPassword.setCustomValidity("");
					matchStatus.textContent = "";
					matchStatus.className = "field-hint";
					return true;
				}

				const matches = password.value === confirmPassword.value;

				confirmPassword.setCustomValidity(matches ? ""
						: "Passwords do not match.");

				matchStatus.textContent = matches ? "Passwords match."
						: "Passwords do not match.";

				matchStatus.className = matches ? "field-hint match-success"
						: "field-hint match-error";

				return matches;
			}

			password.addEventListener("input", checkPasswords);
			confirmPassword.addEventListener("input", checkPasswords);

			signupForm.addEventListener("submit", function(event) {

				if (!checkPasswords()) {
					event.preventDefault();
					confirmPassword.reportValidity();
				}

			});

		});
	</script>

</body>
</html>