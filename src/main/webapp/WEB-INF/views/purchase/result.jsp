<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Kết quả thanh toán"/>
<c:set var="activeMenu" value="marketplace"/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>
    <c:choose>
        <c:when test="${payment.paymentStatus == 'SUCCESS'}">
            <div class="alert alert-success">
                Thanh toán thành công! Bạn đã được cấp quyền truy cập gói thi:
                <strong>${payment.purchase.examPackage.name}</strong>.
            </div>
        </c:when>
        <c:when test="${payment.paymentStatus == 'FAILED'}">
            <div class="alert alert-danger">
                Thanh toán thất bại hoặc bị từ chối. Vui lòng thử lại.
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-warning">
                Giao dịch đang ở trạng thái: ${payment.paymentStatus}.
            </div>
        </c:otherwise>
    </c:choose>

    <p><strong>Mã thanh toán:</strong> ${payment.id}</p>
    <p><strong>Số tiền:</strong> ${payment.amount} VNĐ</p>
    <p class="mb-3">
        <a href="${pageContext.request.contextPath}/packages/${payment.purchase.examPackage.id}"
           class="btn btn-outline-primary btn-sm">
            Xem chi tiết gói thi
        </a>
    </p>

    <a href="${pageContext.request.contextPath}/my-packages" class="btn btn-primary">Xem gói thi đã mua</a>
    <a href="${pageContext.request.contextPath}/payment-history" class="btn btn-outline-secondary ms-2">Lịch sử thanh toán</a>
<%@ include file="/WEB-INF/views/partials/layout-bottom.jspf" %>
