<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tap.model.User" %>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Change Password - SWAD</title>

    <!-- CSS FILE -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/ChangePassword.css">
    <link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/navbar.css?v=30">      

</head>

<body>

<%@ include file="includes/navbar.jsp" %>


<div class="password-container">

    <div class="password-card">

        <div class="password-header">

            <div class="password-icon">
                🔒
            </div>

            <div>

                <h1>Change Password</h1>

                <p>
                    Update your password to keep your account secure.
                </p>

            </div>

        </div>


        <%
            String error =
                    (String) request.getAttribute("error");
        %>


        <% if (error != null) { %>

            <div class="error-message">
                <%= error %>
            </div>

        <% } %>


        <!-- CHANGE PASSWORD FORM -->

        <form action="${pageContext.request.contextPath}/profile"
              method="post">

            <input type="hidden"
                   name="action"
                   value="changePassword">


            <div class="form-group">

                <label for="currentPassword">
                    Current Password
                </label>

                <input
                    type="password"
                    id="currentPassword"
                    name="currentPassword"
                    placeholder="Enter your current password"
                    required>

            </div>


            <div class="form-group">

                <label for="newPassword">
                    New Password
                </label>

                <input
                    type="password"
                    id="newPassword"
                    name="newPassword"
                    placeholder="Enter your new password"
                    required>

            </div>


            <div class="form-group">

                <label for="confirmPassword">
                    Confirm New Password
                </label>

                <input
                    type="password"
                    id="confirmPassword"
                    name="confirmPassword"
                    placeholder="Confirm your new password"
                    required>

            </div>


            <div class="form-actions">

                <a href="${pageContext.request.contextPath}/profile"
                   class="cancel-button">

                    Cancel

                </a>


                <button
                    type="submit"
                    class="save-button">

                    Change Password

                </button>

            </div>

        </form>

    </div>

</div>

</body>
</html>