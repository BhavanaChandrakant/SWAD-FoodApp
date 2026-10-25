
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

        req.getRequestDispatcher("/Signup.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String role = req.getParameter("role");

        // =============================================
        // VALIDATION
        // =============================================

        if (name == null || name.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || password == null || password.isEmpty()) {

            req.setAttribute(
                    "error",
                    "Name, Email and Password are required."
            );

            req.getRequestDispatcher("/Signup.jsp")
               .forward(req, resp);
            return;
        }

        name = name.trim();
        email = email.trim();

        // =============================================
        // USER DAO
        // =============================================

        UserDAOImpl userDAO = new UserDAOImpl();

        // =============================================
        // CHECK WHETHER EMAIL ALREADY EXISTS
        // =============================================

        User existingUser = userDAO.getUserByEmail(email);

        if (existingUser != null) {

            req.setAttribute(
                    "error",
                    "Email already registered. Please log in."
            );

            req.getRequestDispatcher("/Signup.jsp")
               .forward(req, resp);
            return;
        }

        // =============================================
        // HASH PASSWORD
        // =============================================

        String hashedPassword = BCrypt.hashpw(
                password,
                BCrypt.gensalt()
        );

        // =============================================
        // SET DEFAULT ROLE
        // =============================================

        // Public signup must always create a customer.
        // Do not allow a visitor to register as admin.
        role = "customer";

        // =============================================
        // CREATE USER
        // =============================================

        User user = new User(
                name,
                email,
                hashedPassword,
                phone == null ? "" : phone.trim(),
                address == null ? "" : address.trim(),
                role
        );

        // =============================================
        // INSERT USER INTO DATABASE
        // =============================================

        userDAO.addUser(user);

        // =============================================
        // VERIFY THAT USER WAS CREATED
        // =============================================

        User createdUser = userDAO.getUserByEmail(email);

        if (createdUser == null) {

            req.setAttribute(
                    "error",
                    "Registration could not be completed. Please try again."
            );

            req.getRequestDispatcher("/Signup.jsp")
               .forward(req, resp);
            return;
        }

        // =============================================
        // AUTOMATIC LOGIN AFTER SIGNUP
        // =============================================

        HttpSession session = req.getSession(true);

        // Remove previous user's cart if a different
        // user was already logged in.
        String previousEmail =
                (String) session.getAttribute("userEmail");

        if (previousEmail != null
                && !previousEmail.equalsIgnoreCase(email)) {
            session.removeAttribute("cart");
        }

        // Remove old session-based user details.
        session.removeAttribute("user");
        session.removeAttribute("checkoutUser");
        session.removeAttribute("checkoutAddress");
        session.removeAttribute("checkoutPhone");
        session.removeAttribute("checkoutPincode");

        // Change session ID after authentication.
        req.changeSessionId();

        // Store only the registered user's email.
        session.setAttribute(
                "userEmail",
                createdUser.getEmail()
        );

        session.removeAttribute("afterLogin");

        // =============================================
        // REDIRECT TO RESTAURANTS
        // =============================================

        resp.sendRedirect(
                req.getContextPath() + "/restaurant"
        );
    }
}
