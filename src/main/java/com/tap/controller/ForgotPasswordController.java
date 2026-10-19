package com.tap.controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Locale;

import org.mindrot.jbcrypt.BCrypt;

import com.tap.DAOImpl.UserDAOImpl;
import com.tap.model.User;
import com.tap.util.EmailUtil;

import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({
    "/forgotPassword",
    "/verifyResetOTP",
    "/resetPassword"
})
public class ForgotPasswordController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final SecureRandom RANDOM = new SecureRandom();

    private static final long OTP_VALIDITY_MILLIS =
            5 * 60 * 1000L;

    private static final long RESEND_COOLDOWN_MILLIS =
            30 * 1000L;

    private static final long VERIFIED_RESET_VALIDITY_MILLIS =
            10 * 60 * 1000L;

    private static final int MAX_OTP_ATTEMPTS = 5;

    private static final int MAX_OTP_RESENDS = 3;

    private static final String PENDING_EMAIL =
            "pendingResetEmail";

    private static final String PENDING_USER_ID =
            "pendingResetUserId";

    private static final String OTP_HASH =
            "pendingResetOtpHash";

    private static final String OTP_EXPIRY =
            "pendingResetOtpExpiresAt";

    private static final String OTP_ATTEMPTS =
            "pendingResetOtpAttempts";

    private static final String OTP_SENT_AT =
            "pendingResetOtpSentAt";

    private static final String OTP_RESENDS =
            "pendingResetOtpResendCount";

    private static final String RESET_USER_ID =
            "resetUserId";

    private static final String RESET_VERIFIED =
            "resetOtpVerified";

    private static final String RESET_VERIFIED_AT =
            "resetOtpVerifiedAt";


    // =====================================================
    // GET REQUESTS
    // =====================================================

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        HttpSession session = req.getSession(false);

        // VERIFY OTP PAGE
        if ("/verifyResetOTP".equals(path)) {

            if (!hasPendingOtp(session)) {
                resp.sendRedirect(
                        req.getContextPath() + "/forgotPassword");
                return;
            }

            req.getRequestDispatcher(
                    "/VerifyResetOTP.jsp").forward(req, resp);

            return;
        }

        // RESET PASSWORD PAGE
        if ("/resetPassword".equals(path)) {

            if (!isResetVerified(session)) {
                clearAllResetState(session);

                resp.sendRedirect(
                        req.getContextPath() + "/forgotPassword");
                return;
            }

            long verifiedAt =
                    getSessionLong(session, RESET_VERIFIED_AT);

            if (System.currentTimeMillis() - verifiedAt
                    > VERIFIED_RESET_VALIDITY_MILLIS) {

                clearAllResetState(session);

                req.setAttribute(
                        "error",
                        "Your verification session expired. Please start again.");

                req.getRequestDispatcher(
                        "/ForgotPassword.jsp").forward(req, resp);

                return;
            }

            req.getRequestDispatcher(
                    "/ResetPassword.jsp").forward(req, resp);

            return;
        }

        // FORGOT PASSWORD PAGE
        clearAllResetState(session);

        req.getRequestDispatcher(
                "/ForgotPassword.jsp").forward(req, resp);
    }


    // =====================================================
    // POST REQUESTS
    // =====================================================

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("sendOtp".equals(action)) {
            sendOtp(req, resp);
            return;
        }

        if ("verifyOtp".equals(action)) {
            verifyOtp(req, resp);
            return;
        }

        if ("resendOtp".equals(action)) {
            resendOtp(req, resp);
            return;
        }

        if ("resetPassword".equals(action)) {
            resetPassword(req, resp);
            return;
        }

        resp.sendRedirect(
                req.getContextPath() + "/forgotPassword");
    }


    // =====================================================
    // STEP 1: SEND OTP
    // =====================================================

    private void sendOtp(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            forwardForgotPage(
                    req, resp, "Please enter your registered email.");
            return;
        }

        email = email.trim().toLowerCase(Locale.ROOT);

        if (email.length() > 254
                || !email.matches(
                        "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {

            forwardForgotPage(
                    req, resp, "Please enter a valid email address.");
            return;
        }

        HttpSession session = req.getSession(true);

        // Clear previous reset attempts.
        clearAllResetState(session);

        UserDAOImpl userDAO = new UserDAOImpl();

        User user = userDAO.getUserByEmail(email);

        String otp = generateOtp();

        // Send email only if an account exists.
        if (user != null) {

            try {
                EmailUtil.sendPasswordResetOtp(email, otp);

            } catch (MessagingException e) {

                getServletContext().log(
                        "Unable to send password-reset email.", e);

                forwardForgotPage(
                        req,
                        resp,
                        "We could not start password recovery right now. "
                        + "Please try again later.");

                return;
            }
        }

        /*
         * Store -1 when no account was found.
         * The public response remains the same so the page does not
         * reveal whether the email is registered.
         */
        int userId = (user == null) ? -1 : user.getId();

        storeOtp(session, email, userId, otp, 0);

        resp.sendRedirect(
                req.getContextPath() + "/verifyResetOTP");
    }


    // =====================================================
    // STEP 2: VERIFY OTP
    // =====================================================

    private void verifyOtp(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (!hasPendingOtp(session)) {
            forwardForgotPage(
                    req, resp, "Please start password recovery again.");
            return;
        }

        long expiry = getSessionLong(session, OTP_EXPIRY);

        if (System.currentTimeMillis() > expiry) {

            clearAllResetState(session);

            forwardForgotPage(
                    req, resp,
                    "Your verification code expired. Please request a new one.");

            return;
        }

        String email =
                (String) session.getAttribute(PENDING_EMAIL);

        String enteredOtp = req.getParameter("otp");

        String savedHash =
                (String) session.getAttribute(OTP_HASH);

        Integer pendingUserId =
                (Integer) session.getAttribute(PENDING_USER_ID);

        boolean otpMatches = false;

        if (enteredOtp != null
                && enteredOtp.matches("[0-9]{6}")
                && savedHash != null
                && pendingUserId != null
                && pendingUserId > 0) {

            String enteredHash = hashOtp(email, enteredOtp);

            otpMatches = MessageDigest.isEqual(
                    savedHash.getBytes(StandardCharsets.UTF_8),
                    enteredHash.getBytes(StandardCharsets.UTF_8));
        }

        if (!otpMatches) {

            int attempts =
                    getSessionInt(session, OTP_ATTEMPTS) + 1;

            session.setAttribute(OTP_ATTEMPTS, attempts);

            if (attempts >= MAX_OTP_ATTEMPTS) {

                clearAllResetState(session);

                forwardForgotPage(
                        req, resp,
                        "Too many incorrect attempts. Please start again.");

                return;
            }

            req.setAttribute(
                    "error",
                    "Invalid verification code. Please try again.");

            req.getRequestDispatcher(
                    "/VerifyResetOTP.jsp").forward(req, resp);

            return;
        }

        // Confirm the user still exists.
        UserDAOImpl userDAO = new UserDAOImpl();

        User user = userDAO.getUser(pendingUserId);

        if (user == null) {

            clearAllResetState(session);

            forwardForgotPage(
                    req, resp,
                    "Unable to continue. Please start password recovery again.");

            return;
        }

        // Only a successfully verified user gets reset permission.
        session.setAttribute(RESET_USER_ID, pendingUserId);
        session.setAttribute(RESET_VERIFIED, Boolean.TRUE);
        session.setAttribute(
                RESET_VERIFIED_AT, System.currentTimeMillis());

        clearPendingOtp(session);

        resp.sendRedirect(
                req.getContextPath() + "/resetPassword");
    }


    // =====================================================
    // RESEND OTP
    // =====================================================

    private void resendOtp(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (!hasPendingOtp(session)) {
            forwardForgotPage(
                    req, resp, "Please start password recovery again.");
            return;
        }

        long now = System.currentTimeMillis();

        long expiry = getSessionLong(session, OTP_EXPIRY);

        if (now > expiry) {

            clearAllResetState(session);

            forwardForgotPage(
                    req, resp,
                    "Your verification code expired. Please start again.");

            return;
        }

        long lastSentAt = getSessionLong(session, OTP_SENT_AT);

        if (now - lastSentAt < RESEND_COOLDOWN_MILLIS) {

            req.setAttribute(
                    "error",
                    "Please wait 30 seconds before requesting another code.");

            req.getRequestDispatcher(
                    "/VerifyResetOTP.jsp").forward(req, resp);

            return;
        }

        int resendCount = getSessionInt(session, OTP_RESENDS);

        if (resendCount >= MAX_OTP_RESENDS) {

            clearAllResetState(session);

            forwardForgotPage(
                    req, resp,
                    "You have reached the resend limit. Please start again.");

            return;
        }

        String email =
                (String) session.getAttribute(PENDING_EMAIL);

        Integer pendingUserId =
                (Integer) session.getAttribute(PENDING_USER_ID);

        int userId = pendingUserId == null ? -1 : pendingUserId;

        String otp = generateOtp();

        // Send only when a corresponding account exists.
        if (userId > 0) {

            UserDAOImpl userDAO = new UserDAOImpl();

            User user = userDAO.getUser(userId);

            if (user == null) {
                userId = -1;

            } else {
                try {
                    EmailUtil.sendPasswordResetOtp(email, otp);

                } catch (MessagingException e) {

                    getServletContext().log(
                            "Unable to resend password-reset email.", e);

                    req.setAttribute(
                            "error",
                            "Unable to send a new code right now. "
                            + "Please try again later.");

                    req.getRequestDispatcher(
                            "/VerifyResetOTP.jsp").forward(req, resp);

                    return;
                }
            }
        }

        storeOtp(session, email, userId, otp, resendCount + 1);

        req.setAttribute(
                "success",
                "If an account matches this email, a new code has been sent.");

        req.getRequestDispatcher(
                "/VerifyResetOTP.jsp").forward(req, resp);
    }


    // =====================================================
    // STEP 3: RESET PASSWORD AFTER OTP VERIFICATION
    // =====================================================

    private void resetPassword(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (!isResetVerified(session)) {

            clearAllResetState(session);

            resp.sendRedirect(
                    req.getContextPath() + "/forgotPassword");

            return;
        }

        long verifiedAt =
                getSessionLong(session, RESET_VERIFIED_AT);

        if (System.currentTimeMillis() - verifiedAt
                > VERIFIED_RESET_VALIDITY_MILLIS) {

            clearAllResetState(session);

            forwardForgotPage(
                    req, resp,
                    "Your verification session expired. Please start again.");

            return;
        }

        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (newPassword == null
                || newPassword.length() < 8
                || newPassword.length() > 72) {

            req.setAttribute(
                    "error",
                    "Password must contain between 8 and 72 characters.");

            req.getRequestDispatcher(
                    "/ResetPassword.jsp").forward(req, resp);

            return;
        }

        if (confirmPassword == null
                || !newPassword.equals(confirmPassword)) {

            req.setAttribute(
                    "error",
                    "New password and confirm password do not match.");

            req.getRequestDispatcher(
                    "/ResetPassword.jsp").forward(req, resp);

            return;
        }

        Integer userId = (Integer) session.getAttribute(RESET_USER_ID);

        UserDAOImpl userDAO = new UserDAOImpl();

        User user = userDAO.getUser(userId);

        if (user == null) {

            clearAllResetState(session);

            forwardForgotPage(
                    req, resp,
                    "Unable to reset this account. Please start again.");

            return;
        }

        // Always store a BCrypt hash, never the plain password.
        String hashedPassword = BCrypt.hashpw(
                newPassword,
                BCrypt.gensalt());

        boolean updated = userDAO.updatePassword(
                userId, hashedPassword);

        if (!updated) {

            req.setAttribute(
                    "error",
                    "We could not update your password. Please try again.");

            req.getRequestDispatcher(
                    "/ResetPassword.jsp").forward(req, resp);

            return;
        }

        clearAllResetState(session);

        resp.sendRedirect(
                req.getContextPath() + "/login?passwordReset=success");
    }


    // =====================================================
    // OTP HELPERS
    // =====================================================

    private String generateOtp() {

        int number = RANDOM.nextInt(1_000_000);

        return String.format("%06d", number);
    }


    private String hashOtp(String email, String otp) {

        try {
            MessageDigest digest =
                    MessageDigest.getInstance("SHA-256");

            String value = email + ":" + otp;

            byte[] bytes = digest.digest(
                    value.getBytes(StandardCharsets.UTF_8));

            StringBuilder hex = new StringBuilder();

            for (byte b : bytes) {
                hex.append(String.format("%02x", b & 0xff));
            }

            return hex.toString();

        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException(
                    "SHA-256 is not available.", e);
        }
    }


    private void storeOtp(
            HttpSession session,
            String email,
            int userId,
            String otp,
            int resendCount) {

        long now = System.currentTimeMillis();

        session.setAttribute(PENDING_EMAIL, email);
        session.setAttribute(PENDING_USER_ID, userId);
        session.setAttribute(OTP_HASH, hashOtp(email, otp));
        session.setAttribute(
                OTP_EXPIRY, now + OTP_VALIDITY_MILLIS);
        session.setAttribute(OTP_ATTEMPTS, 0);
        session.setAttribute(OTP_SENT_AT, now);
        session.setAttribute(OTP_RESENDS, resendCount);
    }


    private boolean hasPendingOtp(HttpSession session) {

        return session != null
                && session.getAttribute(PENDING_EMAIL) instanceof String
                && session.getAttribute(PENDING_USER_ID) instanceof Integer
                && session.getAttribute(OTP_HASH) instanceof String
                && session.getAttribute(OTP_EXPIRY) instanceof Long;
    }


    private boolean isResetVerified(HttpSession session) {

        return session != null
                && session.getAttribute(RESET_USER_ID) instanceof Integer
                && Boolean.TRUE.equals(
                        session.getAttribute(RESET_VERIFIED))
                && session.getAttribute(RESET_VERIFIED_AT) instanceof Long;
    }


    private int getSessionInt(
            HttpSession session, String key) {

        Object value = session.getAttribute(key);

        return value instanceof Number
                ? ((Number) value).intValue()
                : 0;
    }


    private long getSessionLong(
            HttpSession session, String key) {

        Object value = session.getAttribute(key);

        return value instanceof Number
                ? ((Number) value).longValue()
                : 0L;
    }


    private void clearPendingOtp(HttpSession session) {

        if (session == null) {
            return;
        }

        session.removeAttribute(PENDING_EMAIL);
        session.removeAttribute(PENDING_USER_ID);
        session.removeAttribute(OTP_HASH);
        session.removeAttribute(OTP_EXPIRY);
        session.removeAttribute(OTP_ATTEMPTS);
        session.removeAttribute(OTP_SENT_AT);
        session.removeAttribute(OTP_RESENDS);
    }


    private void clearAllResetState(HttpSession session) {

        if (session == null) {
            return;
        }

        clearPendingOtp(session);

        session.removeAttribute(RESET_USER_ID);
        session.removeAttribute(RESET_VERIFIED);
        session.removeAttribute(RESET_VERIFIED_AT);
    }


    private void forwardForgotPage(
            HttpServletRequest req,
            HttpServletResponse resp,
            String error)
            throws ServletException, IOException {

        req.setAttribute("error", error);

        req.getRequestDispatcher(
                "/ForgotPassword.jsp").forward(req, resp);
    }
}