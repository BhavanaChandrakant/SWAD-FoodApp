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

@WebServlet("/signup")
public class SignupController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
                         throws ServletException, IOException {

        req.getRequestDispatcher("Signup.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
                          throws ServletException, IOException {

        String name =
                req.getParameter("name");

        String email =
                req.getParameter("email");

        String password =
                req.getParameter("password");

        String phone =
                req.getParameter("phone");

        String address =
                req.getParameter("address");

        String role =
                req.getParameter("role");


        // =============================================
        // VALIDATION
        // =============================================

        if (name == null ||
            name.trim().isEmpty() ||

            email == null ||
            email.trim().isEmpty() ||

            password == null ||
            password.trim().isEmpty()) {

            req.setAttribute(
                    "error",
                    "Name, Email and Password are required."
            );

            req.getRequestDispatcher(
                    "Signup.jsp"
            ).forward(req, resp);

            return;
        }


        // =============================================
        // USER DAO
        // =============================================

        UserDAOImpl userDAO =
                new UserDAOImpl();


        // =============================================
        // CHECK EMAIL ALREADY EXISTS
        // =============================================

        User existingUser =
                userDAO.getUserByEmail(
                        email.trim()
                );

        if (existingUser != null) {

            req.setAttribute(
                    "error",
                    "Email already registered."
            );

            req.getRequestDispatcher(
                    "Signup.jsp"
            ).forward(req, resp);

            return;
        }


        // =============================================
        // HASH PASSWORD USING BCrypt
        // =============================================

        String hashedPassword =
                BCrypt.hashpw(
                        password,
                        BCrypt.gensalt()
                );


        // =============================================
        // SET DEFAULT ROLE
        // =============================================

        if (role == null ||
            role.trim().isEmpty()) {

            role = "customer";
        }


        // Only customer or admin is allowed

        if (!role.equals("customer") &&
            !role.equals("admin")) {

            role = "customer";
        }


        // =============================================
        // CREATE USER
        // =============================================

        User user =
                new User(
                        name.trim(),
                        email.trim(),
                        hashedPassword,
                        phone == null
                                ? ""
                                : phone.trim(),
                        address == null
                                ? ""
                                : address.trim(),
                        role
                );


        // =============================================
        // INSERT USER INTO DATABASE
        // =============================================

        userDAO.addUser(user);


        // =============================================
        // GET THE NEWLY CREATED USER
        // =============================================

        User createdUser =
                userDAO.getUserByEmail(
                        email.trim()
                );


        // =============================================
        // CREATE LOGIN SESSION
        // =============================================

        if (createdUser != null) {

            HttpSession session =
                    req.getSession();

            session.setAttribute(
                    "user",
                    createdUser
            );


            // =========================================
            // GO TO RESTAURANTS PAGE
            // =========================================

            resp.sendRedirect(
                    req.getContextPath() + "/restaurant"
            );

        } else {

            // User was not found after signup

            req.setAttribute(
                    "error",
                    "Account created, but login could not be completed."
            );

            req.getRequestDispatcher(
                    "Login.jsp"
            ).forward(req, resp);
        }
    }
}