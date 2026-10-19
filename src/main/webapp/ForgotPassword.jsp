<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Forgot Password - SWAD</title>

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
                <div class="forgot-icon">🔑</div>

                <div>
                    <h1>Forgot Password?</h1>
                    <p>
                        Enter your registered email address to receive
                        a verification code.
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

            <form action="${pageContext.request.contextPath}/forgotPassword"
                  method="post">

                <input type="hidden" name="action" value="sendOtp">

                <div class="form-group">
                    <label for="email">Registered Email</label>

                    <input
                        type="email"
                        id="email"
                        name="email"
                        placeholder="Enter your registered email"
                        autocomplete="email"
                        maxlength="254"
                        required>
                </div>

                <button type="submit" class="continue-button">
                    Send Verification Code
                </button>

            </form>

            <div class="back-login">
                <a href="${pageContext.request.contextPath}/login">
                    ← Back to Login
                </a>
            </div>

        </div>
    </div>

</body>
</html>