<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Order Confirmation - SWAD</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/common.css?v=1">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/navbar.css?v=25">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/order-confirmation.css?v=2">
</head>

<body>

	<%@ include file="includes/navbar.jsp"%>

	<main class="confirmation-page">

		<div class="confirmation-card">

			<div class="success-icon">✓</div>

			<h1>Order Placed Successfully!</h1>

			<p class="success-message">Thank you for ordering with SWAD.</p>

			<div class="order-details">

				<div class="detail-row">
					<span>Order ID</span> <strong>${orderId}</strong>
				</div>

				<div class="detail-row">
					<span>Total Amount</span> <strong>₹${totalAmount}</strong>
				</div>

				<div class="detail-row">
					<span>Payment Method</span> <strong>${paymentMethod}</strong>
				</div>

				<div class="detail-row">
					<span>Order Status</span> <strong class="status"> Pending
					</strong>
				</div>

			</div>

			<div class="confirmation-actions">

				<a href="${pageContext.request.contextPath}/index.jsp"
					class="continue-btn"> Continue Shopping </a> <a
					href="${pageContext.request.contextPath}/orders" class="orders-btn">
					View My Orders </a>

			</div>

		</div>

	</main>

	<%@ include file="includes/footer.jsp"%>
	
	<script>
    document.addEventListener("DOMContentLoaded", function () {

        try {
            const pendingDetails =
                sessionStorage.getItem("swadPendingDeliveryDetails");

            if (!pendingDetails) {
                return;
            }

            const details = JSON.parse(pendingDetails);

            localStorage.setItem(
                "swadDeliveryDetails",
                JSON.stringify(details)
            );

            sessionStorage.removeItem(
                "swadPendingDeliveryDetails"
            );

        } catch (error) {
            console.warn("Could not remember delivery details.");
        }
    });
</script>

</body>
</html>