<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Checkout - SWAD</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css?v=1">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/checkout.css?v=5">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/navbar.css?v=27">
</head>

<body>

    <%@ include file="includes/navbar.jsp" %>

    <%
        Cart cart = (Cart) request.getAttribute("cart");
    %>

    <main class="checkout-page">

        <!-- CHECKOUT HERO -->
        <section class="checkout-hero">
            <div class="checkout-hero-content">
                <p class="checkout-label">SWAD • FINAL STEP</p>
                <h1>Checkout</h1>
                <p>Complete your details and place your order.</p>
            </div>
        </section>

        <!-- CHECKOUT CONTENT -->
        <section class="checkout-container">

            <div class="checkout-main">

                <form id="checkoutForm"
                      action="<%= request.getContextPath() %>/placeOrder"
                      method="post">

                    <!-- 01: DELIVERY DETAILS -->
                    <section class="checkout-section">

                        <div class="section-heading">
                            <span class="section-number">01</span>
                            <div>
                                <h2>Delivery Details</h2>
                                <p>Where should we deliver your order?</p>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input
                                type="text"
                                id="name"
                                name="name"
                                placeholder="Enter your full name"
                                autocomplete="name"
                                required>
                        </div>

                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input
                                type="tel"
                                id="phone"
                                name="phone"
                                placeholder="Enter 10-digit mobile number"
                                inputmode="numeric"
                                pattern="[6-9][0-9]{9}"
                                minlength="10"
                                maxlength="10"
                                title="Enter a 10-digit Indian mobile number starting with 6, 7, 8, or 9."
                                autocomplete="tel"
                                required>
                        </div>

                        <div class="form-group">
                            <label for="address">Delivery Address</label>
                            <textarea
                                id="address"
                                name="address"
                                placeholder="House number, street, area and landmark"
                                autocomplete="street-address"
                                rows="3"
                                required></textarea>
                        </div>

                        <div class="form-group">
                            <label for="pincode">PIN Code</label>
                            <input
                                type="text"
                                id="pincode"
                                name="pincode"
                                placeholder="Enter 6-digit PIN code"
                                inputmode="numeric"
                                pattern="[1-9][0-9]{5}"
                                minlength="6"
                                maxlength="6"
                                title="Enter a valid 6-digit Indian PIN code."
                                autocomplete="postal-code"
                                required>
                        </div>

                    </section>

                    <!-- 02: YOUR ORDER -->
                    <section class="checkout-section">

                        <div class="section-heading">
                            <span class="section-number">02</span>
                            <div>
                                <h2>Your Order</h2>
                                <p>Review your selected items.</p>
                            </div>
                        </div>

                        <div class="order-list">

                            <%
                                if (cart != null && cart.getItems() != null) {
                                    for (CartItem item : cart.getItems().values()) {
                            %>

                            <article class="order-item">

                                <div class="order-image-container">
                                    <img
                                        src="<%= item.getImagePath() %>"
                                        alt="<%= item.getItemName() %>"
                                        class="order-image">
                                </div>

                                <div class="order-details">
                                    <h3><%= item.getItemName() %></h3>
                                    <p>
                                        ₹<%= item.getPrice() %>
                                        ×
                                        <%= item.getQuantity() %>
                                    </p>
                                </div>

                                <div class="order-total">
                                    ₹<%= item.getItemTotal() %>
                                </div>

                            </article>

                            <%
                                    }
                                }
                            %>

                        </div>

                        <div class="grand-total">
                            <span>Grand Total</span>
                            <strong>
                                ₹<%= cart != null ? cart.getTotal() : 0 %>
                            </strong>
                        </div>

                    </section>

                    <!-- 03: PAYMENT METHOD -->
                    <section class="checkout-section">

                        <div class="section-heading">
                            <span class="section-number">03</span>
                            <div>
                                <h2>Payment Method</h2>
                                <p>Choose how you would like to pay.</p>
                            </div>
                        </div>

                        <div class="payment-options">

                            <label class="payment-option" for="upi">
                                <input
                                    type="radio"
                                    id="upi"
                                    name="paymentMethod"
                                    value="UPI"
                                    required>

                                <span class="payment-radio"></span>

                                <span class="payment-text">
                                    <strong>UPI</strong>
                                    <small>Google Pay, PhonePe, BHIM and more</small>
                                </span>

                                <span class="payment-symbol">↗</span>
                            </label>

                            <label class="payment-option" for="card">
                                <input
                                    type="radio"
                                    id="card"
                                    name="paymentMethod"
                                    value="Card">

                                <span class="payment-radio"></span>

                                <span class="payment-text">
                                    <strong>Credit or Debit Card</strong>
                                    <small>Visa, Mastercard and other supported cards</small>
                                </span>

                                <span class="payment-symbol">▣</span>
                            </label>

                            <label class="payment-option" for="cash">
                                <input
                                    type="radio"
                                    id="cash"
                                    name="paymentMethod"
                                    value="Cash">

                                <span class="payment-radio"></span>

                                <span class="payment-text">
                                    <strong>Cash on Delivery</strong>
                                    <small>Pay when your order arrives</small>
                                </span>

                                <span class="payment-symbol">₹</span>
                            </label>

                        </div>

                        <!-- UPI DETAILS -->
                        <div class="payment-details"
                             id="upiDetails"
                             hidden>

                            <div class="payment-details-heading">
                                <div class="payment-details-icon">↗</div>
                                <div>
                                    <h3>UPI Details</h3>
                                    <p>Enter your UPI ID to continue.</p>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="upiId">UPI ID</label>
                                <input
                                    type="text"
                                    id="upiId"
                                    placeholder="Example: yourname@bank"
                                    pattern="[A-Za-z0-9._-]{2,}@[A-Za-z0-9.-]{2,}"
                                    title="Enter a UPI ID in a format such as yourname@bank."
                                    autocomplete="off">

                                <small class="field-hint">
                                    Never enter or share your UPI PIN here.
                                </small>
                            </div>

                            <p class="payment-demo-note">
                                Demo checkout only. Entering a UPI ID does not
                                initiate a payment.
                            </p>
                        </div>

                        <!-- CARD DETAILS -->
                        <div class="payment-details"
                             id="cardDetails"
                             hidden>

                            <div class="payment-details-heading">
                                <div class="payment-details-icon">▣</div>
                                <div>
                                    <h3>Card Details</h3>
                                    <p>Demo fields for the checkout interface.</p>
                                </div>
                            </div>

                            <p class="payment-demo-warning">
                                Do not enter real card details. This demo does
                                not process payments.
                            </p>

                            <div class="form-group">
                                <label for="cardholderName">Name on Card</label>
                                <input
                                    type="text"
                                    id="cardholderName"
                                    placeholder="Enter cardholder name"
                                    autocomplete="off">
                            </div>

                            <div class="form-group">
                                <label for="cardNumber">Card Number</label>
                                <input
                                    type="text"
                                    id="cardNumber"
                                    placeholder="Enter sample card number"
                                    inputmode="numeric"
                                    pattern="[0-9]{13,19}"
                                    minlength="13"
                                    maxlength="19"
                                    autocomplete="off">
                            </div>

                            <div class="card-fields-row">

                                <div class="form-group">
                                    <label for="cardExpiry">Expiry Date</label>
                                    <input
                                        type="text"
                                        id="cardExpiry"
                                        placeholder="MM/YY"
                                        inputmode="numeric"
                                        pattern="(0[1-9]|1[0-2])/[0-9]{2}"
                                        maxlength="5"
                                        autocomplete="off">
                                </div>

                                <div class="form-group">
                                    <label for="cardCvv">CVV</label>
                                    <input
                                        type="password"
                                        id="cardCvv"
                                        placeholder="CVV"
                                        inputmode="numeric"
                                        pattern="[0-9]{3,4}"
                                        minlength="3"
                                        maxlength="4"
                                        autocomplete="off">
                                </div>

                            </div>

                        </div>

                        <!-- CASH ON DELIVERY -->
                        <div class="payment-details cod-details"
                             id="cashDetails"
                             hidden>

                            <div class="payment-details-heading">
                                <div class="payment-details-icon">₹</div>
                                <div>
                                    <h3>Cash on Delivery</h3>
                                    <p>You can pay when your order arrives.</p>
                                </div>
                            </div>

                            <p class="cod-message">
                                Please keep the payment amount ready at delivery.
                            </p>

                        </div>

                    </section>

                    <!-- CHECKOUT ACTIONS -->
                    <section class="checkout-actions">

                        <button type="submit" class="place-order-btn">
                            Place Order <span>→</span>
                        </button>

                        <a href="<%= request.getContextPath() %>/cart"
                           class="back-cart-btn">
                            ← Back to Cart
                        </a>

                    </section>

                </form>

            </div>

            <!-- ORDER SUMMARY -->
            <aside class="checkout-summary">

                <div class="summary-top">
                    <p>ORDER SUMMARY</p>
                    <h2>Your Order</h2>
                </div>

                <div class="summary-items">

                    <%
                        if (cart != null && cart.getItems() != null) {
                            for (CartItem item : cart.getItems().values()) {
                    %>

                    <div class="summary-item">
                        <span>
                            <%= item.getItemName() %>
                            ×
                            <%= item.getQuantity() %>
                        </span>

                        <strong>
                            ₹<%= item.getItemTotal() %>
                        </strong>
                    </div>

                    <%
                            }
                        }
                    %>

                </div>

                <div class="summary-divider"></div>

                <div class="summary-total">
                    <span>Total</span>
                    <strong>
                        ₹<%= cart != null ? cart.getTotal() : 0 %>
                    </strong>
                </div>

                <div class="secure-message">
                    <span class="secure-icon">✓</span>
                    <p>Your order details are securely handled.</p>
                </div>

            </aside>

        </section>

    </main>

    <%@ include file="includes/footer.jsp" %>

    <script>
        document.addEventListener("DOMContentLoaded", function () {

            const checkoutForm = document.getElementById("checkoutForm");

            const nameField = document.getElementById("name");
            const phoneField = document.getElementById("phone");
            const addressField = document.getElementById("address");
            const pincodeField = document.getElementById("pincode");

            /*
             * 1. LOAD SAVED DELIVERY DETAILS
             * Read previously remembered details from this browser.
             */
            try {
                const savedDetails =
                    localStorage.getItem("swadDeliveryDetails");

                if (savedDetails) {
                    const details = JSON.parse(savedDetails);

                    nameField.value = details.name || "";
                    phoneField.value = details.phone || "";
                    addressField.value = details.address || "";
                    pincodeField.value = details.pincode || "";
                }
            } catch (error) {
                console.warn("Could not load saved delivery details.");
            }

            /*
             * 2. PAYMENT METHOD PANELS
             */
            const paymentRadios =
                document.querySelectorAll('input[name="paymentMethod"]');

            const upiDetails = document.getElementById("upiDetails");
            const cardDetails = document.getElementById("cardDetails");
            const cashDetails = document.getElementById("cashDetails");

            const cardNumber = document.getElementById("cardNumber");
            const cardExpiry = document.getElementById("cardExpiry");
            const cardCvv = document.getElementById("cardCvv");

            function setPanel(panel, show) {
                panel.hidden = !show;

                panel.querySelectorAll("input").forEach(function (input) {
                    input.required = show;

                    if (!show) {
                        input.setCustomValidity("");
                    }
                });
            }

            function updatePaymentDetails() {
                const selected = document.querySelector(
                    'input[name="paymentMethod"]:checked'
                );

                const method = selected ? selected.value : "";

                setPanel(upiDetails, method === "UPI");
                setPanel(cardDetails, method === "Card");
                setPanel(cashDetails, method === "Cash");
            }

            paymentRadios.forEach(function (radio) {
                radio.addEventListener("change", updatePaymentDetails);
            });

            /*
             * 3. ALLOW DIGITS ONLY IN PHONE AND PIN CODE
             */
            [phoneField, pincodeField, cardNumber, cardCvv]
                .forEach(function (field) {
                    field.addEventListener("input", function () {
                        field.value = field.value.replace(/\D/g, "");
                    });
                });

            /*
             * 4. FORMAT CARD EXPIRY AS MM/YY
             */
            function validateExpiry() {
                const value = cardExpiry.value;

                if (!value) {
                    cardExpiry.setCustomValidity("");
                    return;
                }

                if (!/^(0[1-9]|1[0-2])\/[0-9]{2}$/.test(value)) {
                    cardExpiry.setCustomValidity(
                        "Enter the expiry date in MM/YY format."
                    );
                    return;
                }

                const parts = value.split("/");
                const month = Number(parts[0]);
                const year = 2000 + Number(parts[1]);

                const today = new Date();
                const currentMonth = today.getMonth() + 1;
                const currentYear = today.getFullYear();

                if (year < currentYear ||
                    (year === currentYear && month < currentMonth)) {
                    cardExpiry.setCustomValidity(
                        "The expiry date must not be in the past."
                    );
                } else {
                    cardExpiry.setCustomValidity("");
                }
            }

            cardExpiry.addEventListener("input", function () {
                let value = cardExpiry.value.replace(/\D/g, "").slice(0, 4);

                if (value.length > 2) {
                    value = value.slice(0, 2) + "/" + value.slice(2);
                }

                cardExpiry.value = value;
                validateExpiry();
            });

            cardExpiry.addEventListener("blur", validateExpiry);

            /*
             * 5. STAGE DELIVERY DETAILS FOR A SUCCESSFUL ORDER
             *
             * The browser's required-field validation runs before this
             * submit event. These details remain temporary until the
             * confirmation page copies them into localStorage.
             */
            checkoutForm.addEventListener("submit", function () {

                const details = {
                    name: nameField.value.trim(),
                    phone: phoneField.value.trim(),
                    address: addressField.value.trim(),
                    pincode: pincodeField.value.trim()
                };

                try {
                    sessionStorage.setItem(
                        "swadPendingDeliveryDetails",
                        JSON.stringify(details)
                    );
                } catch (error) {
                    console.warn("Could not temporarily save delivery details.");
                }
            });

            updatePaymentDetails();
        });
    </script>

</body>
</html>