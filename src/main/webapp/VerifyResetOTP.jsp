<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Verify Email - SWAD</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css?v=1">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/ForgotPassword.css?v=2">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/VerifyResetOTP.css?v=1">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/navbar.css?v=27">
</head>
<body>

    <%@ include file="includes/navbar.jsp" %>

    <div class="forgot-container">
        <div class="forgot-card">

            <div class="forgot-header">
                <div class="forgot-icon">✉️</div>

                <div>
                    <h1>Verify Your Email</h1>
                    <p>
                        If an account matches the email you entered,
                        a six-digit verification code will be sent.
                        The code expires in five minutes.
                    </p>
                </div>
            </div>

            <%
                String error = (String) request.getAttribute("error");
                String success = (String) request.getAttribute("success");

                if (error != null) {
            %>
                <div class="error-message">
                    <%= error %>
                </div>
            <%
                }

                if (success != null) {
            %>
                <div class="success-message">
                    <%= success %>
                </div>
            <%
                }
            %>

            <form action="${pageContext.request.contextPath}/forgotPassword"
                  method="post">

                <input type="hidden" name="action" value="verifyOtp">

                <div class="form-group">
                    <label for="otp">Six-Digit Verification Code</label>

                    <input
                        type="text"
                        id="otp"
                        name="otp"
                        placeholder="Enter 6-digit code"
                        inputmode="numeric"
                        autocomplete="one-time-code"
                        pattern="[0-9]{6}"
                        minlength="6"
                        maxlength="6"
                        required>
                </div>

                <button type="submit" class="continue-button">
                    Verify Code
                </button>

            </form>

            <form action="${pageContext.request.contextPath}/forgotPassword"
                  method="post"
                  class="resend-form">

                <input type="hidden" name="action" value="resendOtp">

                <button type="submit" class="resend-button">
                    Resend Verification Code
                </button>

            </form>

            <div class="back-login">
                <a href="${pageContext.request.contextPath}/forgotPassword">
                    ← Start Again
                </a>
            </div>

        </div>
    </div>

</body>
</html>