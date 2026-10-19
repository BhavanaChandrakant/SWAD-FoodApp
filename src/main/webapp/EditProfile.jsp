<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tap.model.User" %>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Edit Profile - SWAD</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/EditProfile.css">
    <link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/navbar.css?v=30">      

</head>

<body>

<%@ include file="includes/navbar.jsp" %>

<%
    /*
     * User object is sent from ProfileController.
     */
    User user =
            (User) request.getAttribute("user");


    /*
     * Error message is sent from ProfileController
     * when validation fails.
     */
    String error =
            (String) request.getAttribute("error");
%>



<!-- ================= EDIT PROFILE ================= -->

<div class="edit-container">


    <div class="edit-card">


        <!-- HEADER -->

        <div class="edit-header">


            <div class="large-profile-icon">

                <%= user.getName()
                        .substring(0, 1)
                        .toUpperCase() %>

            </div>


            <div>

                <h1>
                    Edit Profile
                </h1>

                <p>
                    Update your personal information
                </p>

            </div>

        </div>



        <!-- ERROR MESSAGE -->

        <% if (error != null) { %>

            <div class="error-message">

                <%= error %>

            </div>

        <% } %>



        <!-- ================= FORM ================= -->

        <form action="${pageContext.request.contextPath}/profile"
              method="post">


            <!-- FULL NAME -->

            <div class="form-group">

                <label for="name">
                    Full Name
                </label>


                <input
                    type="text"
                    id="name"
                    name="name"
                    value="<%= user.getName() != null
                            ? user.getName()
                            : "" %>"
                    required>

            </div>



            <!-- EMAIL -->

            <div class="form-group">

                <label for="email">
                    Email
                </label>


                <input
                    type="email"
                    id="email"
                    name="email"
                    value="<%= user.getEmail() != null
                            ? user.getEmail()
                            : "" %>"
                    required>

            </div>



            <!-- PHONE -->

            <div class="form-group">

                <label for="phone">
                    Phone Number
                </label>


                <input
                    type="text"
                    id="phone"
                    name="phone"
                    value="<%= user.getPhone() != null
                            ? user.getPhone()
                            : "" %>">

            </div>



            <!-- ADDRESS -->

            <div class="form-group">

                <label for="address">
                    Address
                </label>


                <textarea
                    id="address"
                    name="address"
                    rows="4"><%= user.getAddress() != null
                            ? user.getAddress()
                            : "" %></textarea>

            </div>



            <!-- BUTTONS -->

            <div class="form-actions">


                <!-- CANCEL -->

                <a href="${pageContext.request.contextPath}/profile"
                   class="cancel-button">

                    Cancel

                </a>



                <!-- SAVE -->

                <button
                    type="submit"
                    class="save-button">

                    Save Changes

                </button>


            </div>


        </form>


    </div>

</div>


</body>
</html>