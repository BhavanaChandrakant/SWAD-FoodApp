<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.tap.model.User" %>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>My Profile - SWAD</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/Profile.css">
	<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/navbar.css?v=30">
</head>


<body>

<%@ include file="includes/navbar.jsp" %>


<!-- ================= GET USER ================= -->

<%
    User user =
            (User) request.getAttribute("user");
%>



<!-- ================= PROFILE CONTAINER ================= -->

<div class="profile-container">


    <!-- ================= PROFILE HEADER ================= -->

    <div class="profile-header">


        <div class="large-profile-icon">

            <%= user.getName()
                    .substring(0, 1)
                    .toUpperCase() %>

        </div>


        <div class="profile-heading">

            <h1>
                My Profile
            </h1>

            <p>
                Manage your account information
            </p>

        </div>


    </div>



    <!-- ================= PERSONAL INFORMATION ================= -->

    <div class="profile-card">


        <div class="card-title">

            <h2>
                Personal Information
            </h2>

        </div>


        <div class="profile-details">


            <!-- Full Name -->

            <div class="detail-item">

                <span class="detail-label">
                    Full Name
                </span>

                <span class="detail-value">

                    <%= user.getName() %>

                </span>

            </div>



            <!-- Email -->

            <div class="detail-item">

                <span class="detail-label">
                    Email
                </span>

                <span class="detail-value">

                    <%= user.getEmail() %>

                </span>

            </div>



            <!-- Phone -->

            <div class="detail-item">

                <span class="detail-label">
                    Phone Number
                </span>

                <span class="detail-value">

                    <%= user.getPhone() != null
                            && !user.getPhone().isEmpty()
                            ? user.getPhone()
                            : "Not provided" %>

                </span>

            </div>



            <!-- Address -->

            <div class="detail-item address-item">

                <span class="detail-label">
                    Address
                </span>

                <span class="detail-value">

                    <%= user.getAddress() != null
                            && !user.getAddress().isEmpty()
                            ? user.getAddress()
                            : "Not provided" %>

                </span>

            </div>



            <!-- Account Type -->

            <div class="detail-item">

                <span class="detail-label">
                    Account Type
                </span>

                <span class="detail-value">

                    <%= user.getRole() %>

                </span>

            </div>


        </div>

    </div>



    <!-- ================= ACCOUNT INFORMATION ================= -->

    <div class="profile-card">


        <div class="card-title">

            <h2>
                Account Information
            </h2>

        </div>


        <div class="profile-details">


            <!-- User ID -->

            <div class="detail-item">

                <span class="detail-label">
                    User ID
                </span>

                <span class="detail-value">

                    <%= user.getId() %>

                </span>

            </div>



            <!-- Account Created -->

            <div class="detail-item">

                <span class="detail-label">
                    Account Created
                </span>

                <span class="detail-value">

                    <%= user.getCreated_date() != null
                            ? user.getCreated_date()
                            : "Not available" %>

                </span>

            </div>



            <!-- Last Login -->

            <div class="detail-item">

                <span class="detail-label">
                    Last Login
                </span>

                <span class="detail-value">

                    <%= user.getLastLogin_date() != null
                            ? user.getLastLogin_date()
                            : "Not available" %>

                </span>

            </div>


        </div>

    </div>



    <!-- ================= ACTION BUTTONS ================= -->

    <div class="profile-actions">


        <!-- EDIT PROFILE -->

        <a href="${pageContext.request.contextPath}/profile?action=edit"
           class="edit-button">

            Edit Profile

        </a>



        <!-- CHANGE PASSWORD -->

        <a href="${pageContext.request.contextPath}/profile?action=password"
           class="password-button">

            Change Password

        </a>



        <!-- MY ORDERS -->

        <a href="${pageContext.request.contextPath}/orders"
           class="orders-button">

            View My Orders

        </a>



        <!-- LOGOUT -->

        <a href="${pageContext.request.contextPath}/logout"
           class="logout-button">

            Logout

        </a>


    </div>


</div>


</body>

</html>