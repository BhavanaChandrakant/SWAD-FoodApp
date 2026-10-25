
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.text.DecimalFormat" %>

<%
    String swadConfirmationContextPath = request.getContextPath();

    Object swadConfirmationOrderId =
            request.getAttribute("orderId");

    Object swadConfirmationTotalAmount =
            request.getAttribute("totalAmount");

    Object swadConfirmationPaymentMethod =
            request.getAttribute("paymentMethod");

    DecimalFormat swadConfirmationMoneyFormat =
            new DecimalFormat("#,##0.00");

    String swadConfirmationFormattedTotal = "0.00";

    if (swadConfirmationTotalAmount instanceof Number) {
        swadConfirmationFormattedTotal =
                swadConfirmationMoneyFormat.format(
                    ((Number) swadConfirmationTotalAmount).doubleValue()
                );
    } else if (swadConfirmationTotalAmount != null) {
        try {
            swadConfirmationFormattedTotal =
                    swadConfirmationMoneyFormat.format(
                        Double.parseDouble(
                            swadConfirmationTotalAmount.toString()
                        )
                    );
        } catch (NumberFormatException swadConfirmationNumberException) {
            swadConfirmationFormattedTotal =
                    swadConfirmationTotalAmount.toString();
        }
    }

    String swadConfirmationSafeOrderId =
            swadConfirmationOrderId == null
                    ? "Confirmed"
                    : swadConfirmationOrderId.toString();

    String swadConfirmationSafePaymentMethod =
            swadConfirmationPaymentMethod == null
                    ? "Not specified"
                    : swadConfirmationPaymentMethod.toString();
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Order Successful | SWAD</title>

    <link rel="stylesheet"
          href="<%= swadConfirmationContextPath %>/css/common.css">

    <link rel="stylesheet"
          href="<%= swadConfirmationContextPath %>/css/order-confirmation.css">

    <style>
        .swad-success-page {
            min-height: 75vh;
            padding: 55px 18px 70px;
            display: flex;
            justify-content: center;
            align-items: center;
            background:
                radial-gradient(circle at top left, #e7f8ed, transparent 38%),
                linear-gradient(180deg, #fbfdfb, #f5f8f5);
        }

        .swad-success-card {
            width: 100%;
            max-width: 620px;
            box-sizing: border-box;
            padding: 42px 35px;
            text-align: center;
            background: #ffffff;
            border: 1px solid #e8eee9;
            border-radius: 24px;
            box-shadow: 0 18px 55px rgba(22, 70, 42, 0.10);
            animation: swadConfirmationAppear 0.65s ease-out both;
        }

        .swad-success-icon {
            width: 94px;
            height: 94px;
            margin: 0 auto 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            background: #21864a;
            border-radius: 50%;
            box-shadow: 0 0 0 12px #e9f7ed;
            animation: swadConfirmationPop 0.65s 0.1s ease-out both;
        }

        .swad-success-icon svg {
            width: 48px;
            height: 48px;
        }

        .swad-success-label {
            margin-bottom: 10px;
            color: #21864a;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 2.5px;
            text-transform: uppercase;
        }

        .swad-success-title {
            margin: 0 0 12px;
            color: #173d28;
            font-size: clamp(28px, 5vw, 38px);
            font-weight: 800;
            letter-spacing: -1px;
        }

        .swad-success-message {
            max-width: 420px;
            margin: 0 auto 28px;
            color: #68756c;
            font-size: 15px;
            line-height: 1.7;
        }

        .swad-order-number {
            display: inline-block;
            margin-bottom: 25px;
            padding: 10px 17px;
            color: #245f39;
            background: #eff8f1;
            border: 1px dashed #b5d8bd;
            border-radius: 10px;
            font-size: 14px;
        }

        .swad-order-number strong {
            color: #173d28;
        }

        .swad-order-details {
            margin: 0 0 28px;
            padding: 0;
            overflow: hidden;
            text-align: left;
            background: #fafcfb;
            border: 1px solid #e8eee9;
            border-radius: 15px;
        }

        .swad-detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            padding: 17px 19px;
            border-bottom: 1px solid #edf1ed;
        }

        .swad-detail-row:last-child {
            border-bottom: none;
        }

        .swad-detail-label {
            color: #718076;
            font-size: 14px;
        }

        .swad-detail-value {
            color: #233c2c;
            font-size: 14px;
            font-weight: 700;
            text-align: right;
            overflow-wrap: anywhere;
        }

        .swad-status {
            display: inline-block;
            padding: 6px 11px;
            color: #986516;
            background: #fff4d9;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 800;
        }

        .swad-success-actions {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        .swad-success-btn {
            min-height: 48px;
            box-sizing: border-box;
            padding: 13px 20px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            border: 1px solid transparent;
            border-radius: 11px;
            font-size: 14px;
            font-weight: 750;
            text-decoration: none;
            transition: transform 0.2s, box-shadow 0.2s, background 0.2s;
        }

        .swad-success-btn:hover {
            transform: translateY(-2px);
        }

        .swad-primary-btn {
            color: #ffffff;
            background: #21864a;
            box-shadow: 0 6px 18px rgba(33, 134, 74, 0.2);
        }

        .swad-primary-btn:hover {
            color: #ffffff;
            background: #176d39;
        }

        .swad-secondary-btn {
            color: #244a31;
            background: #ffffff;
            border-color: #dce7de;
        }

        .swad-secondary-btn:hover {
            background: #f3f8f4;
        }

        .swad-success-note {
            margin: 23px 0 0;
            color: #849087;
            font-size: 12px;
            line-height: 1.6;
        }

        @keyframes swadConfirmationAppear {
            from {
                opacity: 0;
                transform: translateY(16px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes swadConfirmationPop {
            0% {
                transform: scale(0.55);
            }
            70% {
                transform: scale(1.1);
            }
            100% {
                transform: scale(1);
            }
        }

        @media (max-width: 480px) {
            .swad-success-page {
                padding: 35px 13px 45px;
            }

            .swad-success-card {
                padding: 34px 19px;
                border-radius: 19px;
            }

            .swad-detail-row {
                padding: 15px 13px;
            }

            .swad-success-actions {
                flex-direction: column;
            }

            .swad-success-btn {
                width: 100%;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            .swad-success-card,
            .swad-success-icon {
                animation: none;
            }

            .swad-success-btn {
                transition: none;
            }
        }
    </style>
</head>

<body>

    <%@ include file="includes/navbar.jsp" %>

    <main class="swad-success-page">

        <section class="swad-success-card"
                 aria-labelledby="swadSuccessTitle">

            <div class="swad-success-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24"
                     fill="none"
                     stroke="currentColor"
                     stroke-width="2.5"
                     stroke-linecap="round"
                     stroke-linejoin="round">
                    <path d="M5 12.5l4.5 4.5L19 7"/>
                </svg>
            </div>

            <div class="swad-success-label">
                Order confirmed
            </div>

            <h1 class="swad-success-title" id="swadSuccessTitle">
                Your order is on its way to happiness!
            </h1>

            <p class="swad-success-message">
                Thank you for choosing SWAD. Your order has been placed
                successfully. Sit back, relax, and get ready for something delicious!
            </p>

            <div class="swad-order-number">
                Order ID:
                <strong>#<%= swadConfirmationSafeOrderId %></strong>
            </div>

            <div class="swad-order-details">

                <div class="swad-detail-row">
                    <span class="swad-detail-label">Order number</span>
                    <span class="swad-detail-value">
                        #<%= swadConfirmationSafeOrderId %>
                    </span>
                </div>

                <div class="swad-detail-row">
                    <span class="swad-detail-label">Payment method</span>
                    <span class="swad-detail-value">
                        <%= swadConfirmationSafePaymentMethod %>
                    </span>
                </div>

                <div class="swad-detail-row">
                    <span class="swad-detail-label">Order status</span>
                    <span class="swad-status">Pending</span>
                </div>

                <div class="swad-detail-row">
                    <span class="swad-detail-label">Order total</span>
                    <span class="swad-detail-value">
                        &#8377; <%= swadConfirmationFormattedTotal %>
                    </span>
                </div>

            </div>

            <div class="swad-success-actions">

                <a class="swad-success-btn swad-primary-btn"
                   href="<%= swadConfirmationContextPath %>/orders">
                    View My Orders &#8594;
                </a>

                <a class="swad-success-btn swad-secondary-btn"
                   href="<%= swadConfirmationContextPath %>/index.jsp">
                    Continue Shopping
                </a>

            </div>

            <p class="swad-success-note">
                This project uses demo payments. No real payment is processed.
            </p>

        </section>

    </main>

    <%@ include file="includes/footer.jsp" %>

    <!-- Confetti animation -->
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.9.3/dist/confetti.browser.min.js"></script>

    <script>
        window.addEventListener("load", function () {

            if (typeof confetti !== "function") {
                return;
            }

            if (window.matchMedia(
                "(prefers-reduced-motion: reduce)"
            ).matches) {
                return;
            }

            confetti({
                particleCount: 110,
                spread: 85,
                startVelocity: 42,
                origin: {
                    x: 0.5,
                    y: 0.62
                },
                zIndex: 9999
            });

            setTimeout(function () {

                confetti({
                    particleCount: 55,
                    spread: 110,
                    startVelocity: 34,
                    origin: {
                        x: 0.15,
                        y: 0.65
                    },
                    zIndex: 9999
                });

                confetti({
                    particleCount: 55,
                    spread: 110,
                    startVelocity: 34,
                    origin: {
                        x: 0.85,
                        y: 0.65
                    },
                    zIndex: 9999
                });

            }, 350);

        });
    </script>

</body>
</html>
