package com.tap.util;

import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtil {

    private EmailUtil() {
    }

    public static void sendPasswordResetOtp(
            String recipientEmail,
            String otp) throws MessagingException {

        String host = System.getenv("SWAD_SMTP_HOST");
        String port = System.getenv("SWAD_SMTP_PORT");
        String username = System.getenv("SWAD_SMTP_USERNAME");
        String password = System.getenv("SWAD_SMTP_PASSWORD");
        String from = System.getenv("SWAD_SMTP_FROM");

        if (isBlank(host)
                || isBlank(port)
                || isBlank(username)
                || isBlank(password)
                || isBlank(from)) {

            throw new MessagingException(
                    "SMTP configuration is missing.");
        }

        Properties properties = new Properties();

        properties.put("mail.smtp.host", host);
        properties.put("mail.smtp.port", port);
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.starttls.required", "true");

        properties.put("mail.smtp.connectiontimeout", "10000");
        properties.put("mail.smtp.timeout", "10000");
        properties.put("mail.smtp.writetimeout", "10000");

        Session mailSession = Session.getInstance(
                properties,
                new Authenticator() {
                    @Override
                    protected PasswordAuthentication
                            getPasswordAuthentication() {

                        return new PasswordAuthentication(
                                username, password);
                    }
                });

        MimeMessage message = new MimeMessage(mailSession);

        message.setFrom(new InternetAddress(from));

        message.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(recipientEmail, false));

        message.setSubject(
                "SWAD Password Reset Verification Code", "UTF-8");

        message.setText(
                "Hello,\n\n"
                + "Your SWAD password reset verification code is: "
                + otp + "\n\n"
                + "This code expires in 5 minutes and can be used only once.\n\n"
                + "If you did not request a password reset, ignore this email.\n\n"
                + "SWAD Team",
                "UTF-8");

        Transport.send(message);
    }


    private static boolean isBlank(String value) {

        return value == null || value.trim().isEmpty();
    }
}