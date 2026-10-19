
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Reset Password - SWAD</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css?v=1">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/ForgotPassword.css?v=2">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/navbar.css?v=27">
</head>
<body>

    <%@ include file="includes/navbar.jsp" %>

    <div class="forgot-container">
        <div class="forgot-card">

            <div class="forgot-header">
                <div class="forgot-icon">🔐</div>

                <div>
                    <h1>Create New Password</h1>
                    <p>
                        Your email has been verified.
                        Enter and confirm your new password.
                    </p>
                </div>
            </div>

            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="error-message">
                    <%= error %>
                </div>
            <%
                }
            %>

            <form id="resetForm"
                  action="${pageContext.request.contextPath}/resetPassword"
                  method="post">

                <input type="hidden" name="action" value="resetPassword">

                <div class="form-group">
                    <label for="newPassword">New Password</label>

                    <input
                        type="password"
                        id="newPassword"
                        name="newPassword"
                        placeholder="Create a new password"
                        minlength="8"
                        maxlength="72"
                        autocomplete="new-password"
                        required>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm New Password</label>

                    <input
                        type="password"
                        id="confirmPassword"
                        name="confirmPassword"
                        placeholder="Re-enter your new password"
                        minlength="8"
                        maxlength="72"
                        autocomplete="new-password"
                        required>
                </div>

                <button type="submit" class="continue-button">
                    Update Password
                </button>

            </form>

            <div class="back-login">
                <a href="${pageContext.request.contextPath}/login">
                    ← Back to Login
                </a>
            </div>

        </div>
    </div>

    <script>
        const resetForm = document.getElementById("resetForm");
        const newPassword = document.getElementById("newPassword");
        const confirmPassword = document.getElementById("confirmPassword");

        function checkPasswords() {
            if (confirmPassword.value &&
                newPassword.value !== confirmPassword.value) {
                confirmPassword.setCustomValidity(
                    "The passwords do not match."
                );
            } else {
                confirmPassword.setCustomValidity("");
            }
        }

        newPassword.addEventListener("input", checkPasswords);
        confirmPassword.addEventListener("input", checkPasswords);

        resetForm.addEventListener("submit", function (event) {
            checkPasswords();

            if (!resetForm.checkValidity()) {
                event.preventDefault();
                resetForm.reportValidity();
            }
        });
    </script>

</body>
</html>