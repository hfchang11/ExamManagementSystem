<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Thanh toán gói thi"/>
<c:set var="activeMenu" value="marketplace"/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>
    <h2 class="mb-3">Thanh toán gói thi</h2>

    <div class="row">
        <div class="col-md-6">
            <div class="card mb-3">
                <div class="card-body">
                    <h5 class="card-title">${examPackage.name}</h5>
                    <p class="card-text">${examPackage.description}</p>
                    <p><strong>Số đề:</strong> ${examPackage.numberOfExams}</p>
                    <p><strong>Giá:</strong> ${examPackage.price} VNĐ</p>
                    <a class="btn btn-link p-0"
                       href="${pageContext.request.contextPath}/packages/${examPackage.id}">
                        Xem chi tiết gói thi
                    </a>
                </div>
            </div>

            <div class="alert alert-info">
                Quét mã VietQR để thanh toán. STK: <strong>${accountNo}</strong> (Techcombank).<br/>
                Nội dung chuyển khoản: <strong>${addInfo}</strong><br/>
                Số tiền: <strong>${amount} VNĐ</strong>
            </div>
        </div>
        <div class="col-md-6 text-center">
            <h5>Mã VietQR</h5>
            <img src="${vietQrUrl}" alt="VietQR" class="img-fluid mb-3 border rounded" />

            <p class="small text-muted">
                Sau khi chuyển khoản thành công, hệ thống sẽ tự động kiểm tra trạng thái thanh toán.
            </p>
            <div id="payment-status" class="mb-2"></div>
            <div class="d-flex justify-content-center gap-2 flex-wrap">
                <button id="manualCheckBtn" class="btn btn-outline-secondary btn-sm" type="button">Kiểm tra trạng thái</button>
                <button id="simulateSuccessBtn" class="btn btn-success btn-sm" type="button">Giả lập đã thanh toán</button>
            </div>
        </div>
    </div>

<script>
    const paymentId = '${payment.id}';
    const statusUrl = '${pageContext.request.contextPath}/api/payments/' + paymentId + '/status';
    const simulateUrl = '${pageContext.request.contextPath}/api/payments/' + paymentId + '/simulate?success=true';
    const resultUrl = '${pageContext.request.contextPath}/payment/callback?paymentId=' + paymentId + '&success=true';

    async function fetchStatus() {
        const res = await fetch(statusUrl, {headers: {"Accept": "application/json"}});
        if (!res.ok) throw new Error('Cannot load status');
        return await res.json();
    }

    async function refreshStatus(shouldRedirectOnSuccess) {
        const el = document.getElementById('payment-status');
        try {
            const data = await fetchStatus();
            el.innerHTML = '<span class="badge bg-secondary">Trạng thái: ' + data.status + '</span>';
            if (shouldRedirectOnSuccess && data.status === 'SUCCESS') {
                window.location.href = resultUrl;
            }
        } catch (e) {
            el.innerHTML = '<span class="text-danger small">Không kiểm tra được trạng thái.</span>';
        }
    }

    document.getElementById('manualCheckBtn').addEventListener('click', function () {
        refreshStatus(true);
    });

    document.getElementById('simulateSuccessBtn').addEventListener('click', async function () {
        await fetch(simulateUrl, {method: 'POST'});
        await refreshStatus(true);
    });

    // Auto-check: chỉ redirect khi backend trả SUCCESS (không tự success theo thời gian nữa)
    setInterval(function () { refreshStatus(true); }, 3000);
    refreshStatus(false);
</script>
<%@ include file="/WEB-INF/views/partials/layout-bottom.jspf" %>
