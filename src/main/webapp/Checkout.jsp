
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>

<%
    String contextPath = request.getContextPath();

    User user = (User) request.getAttribute("user");
    Cart cart = (Cart) request.getAttribute("cart");

    /*
     * CheckoutController must load the user and cart before
     * forwarding the request to this JSP.
     */
    if (user == null) {
        response.sendError(
            HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
            "User details were not loaded. Please check CheckoutController."
        );
        return;
    }

    if (cart == null || cart.getTotalItems() <= 0) {
        response.sendRedirect(contextPath + "/cart");
        return;
    }

    String name = user.getName() == null ? "" : user.getName();
    String email = user.getEmail() == null ? "" : user.getEmail();
    String phone = user.getPhone() == null ? "" : user.getPhone();

    String address = "";
    try {
        if (user.getAddress() != null) {
            address = user.getAddress();
        }
    } catch (Exception ignored) {
        address = "";
    }

    String errorMessage = (String) request.getAttribute("errorMessage");

    // Escape values before displaying them in HTML.
    java.util.function.Function<String, String> escapeHtml = value -> {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    };
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout | SWAD</title>

    <style>
        .checkout-page,
        .checkout-page *,
        .checkout-page *::before,
        .checkout-page *::after {
            box-sizing: border-box;
        }

        .checkout-page {
            width: 100%;
            min-height: 80vh;
            padding: 30px 18px 50px;
            background: #f7f7f7;
            color: #252525;
            font-family: Arial, Helvetica, sans-serif;
        }

        .checkout-page .checkout-container {
            width: 100%;
            max-width: 1100px;
            margin: 0 auto;
        }

        .checkout-page .checkout-heading {
            margin: 0 0 25px;
            color: #252525;
            font-size: 30px;
            font-weight: 700;
            text-align: center;
        }

        .checkout-page .checkout-layout {
            display: grid;
            grid-template-columns: minmax(0, 1.4fr) minmax(0, 1fr);
            gap: 24px;
            align-items: start;
        }

        .checkout-page .checkout-card {
            min-width: 0;
            padding: 24px;
            background: #fff;
            border: 1px solid #e5e5e5;
            border-radius: 12px;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.05);
        }

        .checkout-page .checkout-card h2 {
            margin: 0 0 20px;
            color: #252525;
            font-size: 21px;
        }

        .checkout-page .checkout-note {
            margin: 0 0 18px;
            color: #666;
            font-size: 13px;
            line-height: 1.6;
        }

        .checkout-page .checkout-error {
            margin-bottom: 18px;
            padding: 12px;
            border: 1px solid #f0b8b8;
            border-radius: 7px;
            background: #fff0f0;
            color: #b00020;
        }

        .checkout-page .checkout-field {
            margin-bottom: 18px;
        }

        .checkout-page .checkout-field label {
            display: block;
            margin-bottom: 7px;
            color: #333;
            font-size: 14px;
            font-weight: 600;
        }

        .checkout-page .checkout-field input,
        .checkout-page .checkout-field textarea {
            display: block;
            width: 100%;
            max-width: 100%;
            min-height: 44px;
            padding: 11px 12px;
            border: 1px solid #d5d5d5;
            border-radius: 7px;
            background: #fff;
            color: #222;
            font-family: Arial, Helvetica, sans-serif;
            font-size: 15px;
        }

        .checkout-page .checkout-field textarea {
            min-height: 90px;
            resize: vertical;
        }

        .checkout-page .checkout-field input:focus,
        .checkout-page .checkout-field textarea:focus {
            border-color: #e6532f;
            outline: 2px solid rgba(230, 83, 47, 0.12);
        }

        .checkout-page .checkout-email-note {
            margin-top: 6px;
            color: #777;
            font-size: 12px;
            overflow-wrap: anywhere;
        }

        .checkout-page .checkout-payment-option {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 12px;
            padding: 13px;
            border: 1px solid #dedede;
            border-radius: 8px;
            color: #333;
            cursor: pointer;
        }

        .checkout-page .checkout-payment-option input {
            width: 17px;
            height: 17px;
            margin: 0;
            accent-color: #e6532f;
        }

        .checkout-page .checkout-payment-details {
            display: none;
            margin: 0 0 15px;
            padding: 13px;
            border-radius: 8px;
            background: #fff6f2;
            color: #444;
            font-size: 14px;
            line-height: 1.6;
        }

        .checkout-page .checkout-payment-details.active {
            display: block;
        }

        .checkout-page .checkout-divider {
            margin: 22px 0;
            border: 0;
            border-top: 1px solid #eee;
        }

        .checkout-page .checkout-place-order {
            display: block;
            width: 100%;
            min-height: 48px;
            margin-top: 22px;
            padding: 13px 18px;
            border: 0;
            border-radius: 8px;
            background: #e6532f;
            color: #fff;
            font-family: Arial, Helvetica, sans-serif;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
        }

        .checkout-page .checkout-place-order:hover {
            background: #c94222;
        }

        @media (max-width: 768px) {
            .checkout-page {
                padding: 22px 12px 35px;
            }

            .checkout-page .checkout-heading {
                font-size: 25px;
            }

            .checkout-page .checkout-layout {
                grid-template-columns: minmax(0, 1fr);
                gap: 18px;
            }

            .checkout-page .checkout-card {
                padding: 18px;
            }
        }

        @media (max-width: 380px) {
            .checkout-page .checkout-card {
                padding: 14px;
            }

            .checkout-page .checkout-heading {
                font-size: 23px;
            }
        }
    </style>
</head>

<body>

    <%-- Keep the existing navbar unchanged. --%>
    <jsp:include page="/includes/navbar.jsp" />

    <main class="checkout-page">
        <div class="checkout-container">

            <h1 class="checkout-heading">Checkout</h1>

            <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
                <div class="checkout-error">
                    <%= escapeHtml.apply(errorMessage) %>
                </div>
            <% } %>

            <form id="checkoutForm"
                  action="<%= contextPath %>/placeOrder"
                  method="post">

                <div class="checkout-layout">

                    <section class="checkout-card">
                        <h2>Delivery Details</h2>

                        <p class="checkout-note">
                            Enter the details for your food delivery.
                        </p>

                        <div class="checkout-field">
                            <label for="checkoutName">Full Name *</label>
                            <input type="text"
                                   id="checkoutName"
                                   name="name"
                                   value="<%= escapeHtml.apply(name) %>"
                                   maxlength="100"
                                   autocomplete="name"
                                   required>
                        </div>

                        <div class="checkout-field">
                            <label for="checkoutEmail">Email Address</label>
                            <input type="email"
                                   id="checkoutEmail"
                                   value="<%= escapeHtml.apply(email) %>"
                                   readonly>
                            <div class="checkout-email-note">
                                Email from your account.
                            </div>
                        </div>

                        <div class="checkout-field">
                            <label for="checkoutPhone">Phone Number *</label>
                            <input type="tel"
                                   id="checkoutPhone"
                                   name="phone"
                                   value="<%= escapeHtml.apply(phone) %>"
                                   inputmode="numeric"
                                   pattern="[0-9]{10}"
                                   maxlength="10"
                                   autocomplete="tel"
                                   title="Enter exactly 10 digits"
                                   required>
                        </div>

                        <div class="checkout-field">
                            <label for="checkoutAddress">Delivery Address *</label>
                            <textarea id="checkoutAddress"
                                      name="address"
                                      maxlength="500"
                                      autocomplete="street-address"
                                      required><%= escapeHtml.apply(address) %></textarea>
                        </div>

                        <div class="checkout-field">
                            <label for="checkoutPincode">PIN Code *</label>
                            <input type="text"
                                   id="checkoutPincode"
                                   name="pincode"
                                   inputmode="numeric"
                                   pattern="[0-9]{6}"
                                   maxlength="6"
                                   autocomplete="postal-code"
                                   title="Enter a 6-digit PIN code"
                                   required>
                        </div>
                    </section>

                    <section class="checkout-card">
                        <h2>Payment Method</h2>

                        <p class="checkout-note">
                            Select your preferred payment method.
                        </p>

                        <label class="checkout-payment-option">
                            <input type="radio"
                                   name="paymentMethod"
                                   value="UPI"
                                   required>
                            <span>UPI</span>
                        </label>

                        <div class="checkout-payment-details"
                             id="checkoutUpiDetails">
                            Complete UPI payment through your payment provider
                            when the payment flow is implemented.
                        </div>

                        <label class="checkout-payment-option">
                            <input type="radio"
                                   name="paymentMethod"
                                   value="Card"
                                   required>
                            <span>Credit / Debit Card</span>
                        </label>

                        <div class="checkout-payment-details"
                             id="checkoutCardDetails">
                            Card payment must be completed through a secure
                            payment provider. Do not enter card details here.
                        </div>

                        <label class="checkout-payment-option">
                            <input type="radio"
                                   name="paymentMethod"
                                   value="Cash"
                                   required>
                            <span>Cash on Delivery</span>
                        </label>

                        <div class="checkout-payment-details"
                             id="checkoutCashDetails">
                            Pay in cash when your order is delivered.
                        </div>

                        <hr class="checkout-divider">

                        <h2>Order Information</h2>

                        <p class="checkout-note">
                            Please review your cart before placing your order.
                        </p>

                        <button type="submit" class="checkout-place-order">
                            Place Order
                        </button>
                    </section>

                </div>
            </form>
        </div>
    </main>

    <script>
        (function () {
            const form = document.getElementById("checkoutForm");
            const phone = document.getElementById("checkoutPhone");
            const pincode = document.getElementById("checkoutPincode");

            const paymentDetails = {
                UPI: document.getElementById("checkoutUpiDetails"),
                Card: document.getElementById("checkoutCardDetails"),
                Cash: document.getElementById("checkoutCashDetails")
            };

            const radios = document.querySelectorAll(
                '.checkout-page input[name="paymentMethod"]'
            );

            radios.forEach(function (radio) {
                radio.addEventListener("change", function () {
                    Object.keys(paymentDetails).forEach(function (method) {
                        paymentDetails[method].classList.remove("active");
                    });

                    if (paymentDetails[this.value]) {
                        paymentDetails[this.value].classList.add("active");
                    }
                });
            });

            phone.addEventListener("input", function () {
                this.value = this.value.replace(/\D/g, "").slice(0, 10);
            });

            pincode.addEventListener("input", function () {
                this.value = this.value.replace(/\D/g, "").slice(0, 6);
            });

            form.addEventListener("submit", function (event) {
                if (!/^[0-9]{10}$/.test(phone.value.trim())) {
                    event.preventDefault();
                    alert("Please enter a valid 10-digit phone number.");
                    phone.focus();
                    return;
                }

                if (!/^[0-9]{6}$/.test(pincode.value.trim())) {
                    event.preventDefault();
                    alert("Please enter a valid 6-digit PIN code.");
                    pincode.focus();
                    return;
                }

                const selectedPayment = document.querySelector(
                    '.checkout-page input[name="paymentMethod"]:checked'
                );

                if (!selectedPayment) {
                    event.preventDefault();
                    alert("Please select a payment method.");
                }
            });
        })();
    </script>

</body>
</html>
