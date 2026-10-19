package com.tap.controller;

import java.io.IOException;

import com.tap.DAOImpl.UserDAOImpl;
import com.tap.model.User;

import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {

    // =====================================================
    // GET
    // =====================================================

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
                         throws ServletException, IOException {

        HttpSession session = req.getSession();

        User loggedInUser =
                (User) session.getAttribute("user");


        // User is not logged in

        if (loggedInUser == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/login"
            );

            return;
        }


        UserDAOImpl userDAO =
                new UserDAOImpl();


        // Get latest user details from database

        User user =
                userDAO.getUser(
                        loggedInUser.getId()
                );


        if (user == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/login"
            );

            return;
        }


        String action =
                req.getParameter("action");


        // =================================================
        // EDIT PROFILE
        // =================================================

        if ("edit".equals(action)) {

            req.setAttribute(
                    "user",
                    user
            );

            req.getRequestDispatcher(
                    "EditProfile.jsp"
            ).forward(req, resp);

            return;
        }


        // =================================================
        // CHANGE PASSWORD
        // =================================================

        if ("password".equals(action)) {

            req.setAttribute(
                    "user",
                    user
            );

            req.getRequestDispatcher(
                    "ChangePassword.jsp"
            ).forward(req, resp);

            return;
        }


        // =================================================
        // PROFILE PAGE
        // =================================================

        req.setAttribute(
                "user",
                user
        );

        req.getRequestDispatcher(
                "Profile.jsp"
        ).forward(req, resp);
    }


    // =====================================================
    // POST
    // =====================================================

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
                          throws ServletException, IOException {

        HttpSession session =
                req.getSession();

        User loggedInUser =
                (User) session.getAttribute("user");


        // User is not logged in

        if (loggedInUser == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/login"
            );

            return;
        }


        String action =
                req.getParameter("action");


        // =================================================
        // CHANGE PASSWORD
        // =================================================

        if ("changePassword".equals(action)) {

            String currentPassword =
                    req.getParameter(
                            "currentPassword"
                    );

            String newPassword =
                    req.getParameter(
                            "newPassword"
                    );

            String confirmPassword =
                    req.getParameter(
                            "confirmPassword"
                    );


            UserDAOImpl userDAO =
                    new UserDAOImpl();


            User user =
                    userDAO.getUser(
                            loggedInUser.getId()
                    );


            if (user == null) {

                resp.sendRedirect(
                        req.getContextPath() + "/login"
                );

                return;
            }


            // =============================================
            // CHECK CURRENT PASSWORD
            // =============================================

            if (currentPassword == null ||
                currentPassword.trim().isEmpty()) {

                req.setAttribute(
                        "error",
                        "Please enter your current password."
                );

                req.setAttribute(
                        "user",
                        user
                );

                req.getRequestDispatcher(
                        "ChangePassword.jsp"
                ).forward(req, resp);

                return;
            }


            // =============================================
            // VERIFY CURRENT PASSWORD USING BCrypt
            // =============================================

            if (!BCrypt.checkpw(
                    currentPassword,
                    user.getPassward())) {

                req.setAttribute(
                        "error",
                        "Current password is incorrect."
                );

                req.setAttribute(
                        "user",
                        user
                );

                req.getRequestDispatcher(
                        "ChangePassword.jsp"
                ).forward(req, resp);

                return;
            }


            // =============================================
            // CHECK NEW PASSWORD
            // =============================================

            if (newPassword == null ||
                newPassword.trim().isEmpty()) {

                req.setAttribute(
                        "error",
                        "New password cannot be empty."
                );

                req.setAttribute(
                        "user",
                        user
                );

                req.getRequestDispatcher(
                        "ChangePassword.jsp"
                ).forward(req, resp);

                return;
            }


            // =============================================
            // CHECK CONFIRM PASSWORD
            // =============================================

            if (confirmPassword == null ||
                !newPassword.equals(confirmPassword)) {

                req.setAttribute(
                        "error",
                        "New password and confirm password do not match."
                );

                req.setAttribute(
                        "user",
                        user
                );

                req.getRequestDispatcher(
                        "ChangePassword.jsp"
                ).forward(req, resp);

                return;
            }


            // =============================================
            // NEW PASSWORD MUST BE DIFFERENT
            // =============================================

            if (newPassword.equals(currentPassword)) {

                req.setAttribute(
                        "error",
                        "New password must be different from current password."
                );

                req.setAttribute(
                        "user",
                        user
                );

                req.getRequestDispatcher(
                        "ChangePassword.jsp"
                ).forward(req, resp);

                return;
            }


            // =============================================
            // HASH NEW PASSWORD USING BCrypt
            // =============================================

            String hashedPassword =
                    BCrypt.hashpw(
                            newPassword,
                            BCrypt.gensalt()
                    );


            // Set hashed password

            user.setPassward(
                    hashedPassword
            );


            // Update database

            userDAO.updateUser(
                    user
            );


            // Update session user

            session.setAttribute(
                    "user",
                    user
            );


            // Go back to profile

            resp.sendRedirect(
                    req.getContextPath() + "/profile"
            );

            return;
        }


        // =================================================
        // EDIT PROFILE
        // =================================================

        String name =
                req.getParameter("name");

        String email =
                req.getParameter("email");

        String phone =
                req.getParameter("phone");

        String address =
                req.getParameter("address");


        // =============================================
        // VALIDATE NAME AND EMAIL
        // =============================================

        if (name == null ||
            name.trim().isEmpty() ||

            email == null ||
            email.trim().isEmpty()) {


            UserDAOImpl userDAO =
                    new UserDAOImpl();


            User user =
                    userDAO.getUser(
                            loggedInUser.getId()
                    );


            req.setAttribute(
                    "user",
                    user
            );


            req.setAttribute(
                    "error",
                    "Name and Email are required."
            );


            req.getRequestDispatcher(
                    "EditProfile.jsp"
            ).forward(req, resp);

            return;
        }


        // =============================================
        // GET CURRENT USER
        // =============================================

        UserDAOImpl userDAO =
                new UserDAOImpl();


        User user =
                userDAO.getUser(
                        loggedInUser.getId()
                );


        if (user == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/login"
            );

            return;
        }


        // =============================================
        // UPDATE PROFILE INFORMATION
        // =============================================

        user.setName(
                name.trim()
        );

        user.setEmail(
                email.trim()
        );

        user.setPhone(
                phone == null
                        ? ""
                        : phone.trim()
        );

        user.setAddress(
                address == null
                        ? ""
                        : address.trim()
        );


        // Update database

        userDAO.updateUser(
                user
        );


        // Update session

        session.setAttribute(
                "user",
                user
        );


        // Return to profile

        resp.sendRedirect(
                req.getContextPath() + "/profile"
        );
    }
}