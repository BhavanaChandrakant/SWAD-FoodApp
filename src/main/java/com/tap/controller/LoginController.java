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

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
                         throws ServletException, IOException {

        req.getRequestDispatcher("Login.jsp")
           .forward(req, resp);
    }


    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
                          throws ServletException, IOException {

        String email =
                req.getParameter("email");

        String password =
                req.getParameter("password");


        // ================= GET USER =================

        UserDAOImpl userDao =
                new UserDAOImpl();

        User user =
                userDao.getUserByEmail(email);


        // ================= CHECK PASSWORD =================

        if (user != null &&
            password != null &&
            BCrypt.checkpw(
                    password,
                    user.getPassward())) {


            // ================= LOGIN SUCCESS =================

            HttpSession session =
                    req.getSession();

            session.setAttribute(
                    "user",
                    user
            );


            // ================= AFTER LOGIN =================

            String afterLogin =
                    (String) session.getAttribute(
                            "afterLogin"
                    );


            if ("cart".equals(afterLogin)) {

                session.removeAttribute(
                        "afterLogin"
                );

                resp.sendRedirect(
                        req.getContextPath() + "/cart"
                );

            } else {

                resp.sendRedirect(
                        req.getContextPath() + "/restaurant"
                );
            }


        } else {


            // ================= LOGIN FAILED =================

            req.setAttribute(
                    "error",
                    "Invalid email or password"
            );

            req.getRequestDispatcher(
                    "Login.jsp"
            ).forward(req, resp);
        }
    }
}