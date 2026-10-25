
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

    private static final long serialVersionUID = 1L;

    private UserDAOImpl userDAO;

    @Override
    public void init() {
        userDAO = new UserDAOImpl();
    }

    // ==========================================
    // GET: VIEW PROFILE / EDIT / CHANGE PASSWORD
    // ==========================================
    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String userEmail =
                (String) session.getAttribute("userEmail");

        if (userEmail == null || userEmail.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            User user = userDAO.getUserByEmail(userEmail.trim());

            if (user == null) {
                session.removeAttribute("userEmail");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            String action = req.getParameter("action");

            req.setAttribute("user", user);

            if ("edit".equals(action)) {
                req.getRequestDispatcher("/EditProfile.jsp")
                   .forward(req, resp);
                return;
            }

            if ("password".equals(action)) {
                req.getRequestDispatcher("/ChangePassword.jsp")
                   .forward(req, resp);
                return;
            }

            req.getRequestDispatcher("/Profile.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            getServletContext().log("Unable to load profile.", e);
            resp.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load your profile."
            );
        }
    }

    // ==========================================
    // POST: UPDATE PROFILE / CHANGE PASSWORD
    // ==========================================
    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);

        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String userEmail =
                (String) session.getAttribute("userEmail");

        if (userEmail == null || userEmail.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            User user = userDAO.getUserByEmail(userEmail.trim());

            if (user == null) {
                session.removeAttribute("userEmail");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            String action = req.getParameter("action");

            // ======================================
            // CHANGE PASSWORD
            // ======================================
            if ("changePassword".equals(action)) {

                String currentPassword =
                        req.getParameter("currentPassword");

                String newPassword =
                        req.getParameter("newPassword");

                String confirmPassword =
                        req.getParameter("confirmPassword");

                if (currentPassword == null
                        || currentPassword.isEmpty()
                        || user.getPassward() == null
                        || !BCrypt.checkpw(
                                currentPassword,
                                user.getPassward())) {

                    req.setAttribute(
                        "error",
                        "Current password is incorrect."
                    );
                    req.setAttribute("user", user);
                    req.getRequestDispatcher("/ChangePassword.jsp")
                       .forward(req, resp);
                    return;
                }

                if (newPassword == null
                        || newPassword.trim().isEmpty()) {

                    req.setAttribute(
                        "error",
                        "New password cannot be empty."
                    );
                    req.setAttribute("user", user);
                    req.getRequestDispatcher("/ChangePassword.jsp")
                       .forward(req, resp);
                    return;
                }

                if (confirmPassword == null
                        || !newPassword.equals(confirmPassword)) {

                    req.setAttribute(
                        "error",
                        "New password and confirm password do not match."
                    );
                    req.setAttribute("user", user);
                    req.getRequestDispatcher("/ChangePassword.jsp")
                       .forward(req, resp);
                    return;
                }

                if (newPassword.equals(currentPassword)) {
                    req.setAttribute(
                        "error",
                        "New password must differ from the current password."
                    );
                    req.setAttribute("user", user);
                    req.getRequestDispatcher("/ChangePassword.jsp")
                       .forward(req, resp);
                    return;
                }

                user.setPassward(
                    BCrypt.hashpw(newPassword, BCrypt.gensalt())
                );

                userDAO.updateUser(user);

                // No User object is stored in the session.
                resp.sendRedirect(req.getContextPath() + "/profile");
                return;
            }

            // ======================================
            // UPDATE PROFILE
            // ======================================
            String name = req.getParameter("name");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String address = req.getParameter("address");

            if (name == null || name.trim().isEmpty()
                    || email == null || email.trim().isEmpty()) {

                req.setAttribute(
                    "error",
                    "Name and Email are required."
                );
                req.setAttribute("user", user);
                req.getRequestDispatcher("/EditProfile.jsp")
                   .forward(req, resp);
                return;
            }

            user.setName(name.trim());
            user.setEmail(email.trim());
            user.setPhone(phone == null ? "" : phone.trim());
            user.setAddress(address == null ? "" : address.trim());

            userDAO.updateUser(user);

            // Keep the session email in sync if the email changed.
            session.setAttribute("userEmail", user.getEmail());

            resp.sendRedirect(req.getContextPath() + "/profile");

        } catch (Exception e) {
            getServletContext().log("Unable to update profile.", e);
            resp.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to update your profile. Please try again."
            );
        }
    }
}
