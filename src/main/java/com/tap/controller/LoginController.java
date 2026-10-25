
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

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAOImpl userDAO;

    @Override
    public void init() {
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty()
                || password == null || password.isEmpty()) {

            request.setAttribute(
                "errorMessage",
                "Please enter your email and password."
            );

            request.getRequestDispatcher("/Login.jsp")
                   .forward(request, response);
            return;
        }

        email = email.trim();

        try {
            User user = userDAO.getUserByEmail(email);

            if (user == null
                    || user.getPassward() == null
                    || !BCrypt.checkpw(password, user.getPassward())) {

                request.setAttribute(
                    "errorMessage",
                    "Invalid email or password."
                );

                request.getRequestDispatcher("/Login.jsp")
                       .forward(request, response);
                return;
            }

            // Preserve the existing cart and other session attributes.
            HttpSession session = request.getSession(true);

            // Prevent session fixation without creating a new session.
            request.changeSessionId();

            // Store only the email, not the User object.
            session.setAttribute("userEmail", user.getEmail());

            String afterLogin =
                (String) session.getAttribute("afterLogin");

            session.removeAttribute("afterLogin");

            if ("checkout".equals(afterLogin)) {
                response.sendRedirect(
                    request.getContextPath() + "/checkout"
                );
            } else if ("cart".equals(afterLogin)) {
                response.sendRedirect(
                    request.getContextPath() + "/cart"
                );
            } else {
                response.sendRedirect(
                    request.getContextPath() + "/restaurant"
                );
            }

        } catch (Exception e) {

            getServletContext().log("Login failed.", e);

            request.setAttribute(
                "errorMessage",
                "Something went wrong during login. Please try again."
            );

            request.getRequestDispatcher("/Login.jsp")
                   .forward(request, response);
        }
    }
}
