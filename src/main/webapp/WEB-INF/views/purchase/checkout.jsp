<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Thanh toán gói thi"/>
<c:set var="breadcrumb" value="Trang  ›  Cửa hàng  ›  Thanh toán"/>
<c:set var="activeMenu" value="marketplace"/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>

    <div class="row g-3">
        <div class="col-lg-4">
            <div class="card shadow-soft h-100">
                <div class="card-body">
                    <div class="d-flex align-items-center gap-2 mb-2">
                        <i class="bi bi-qr-code-scan text-success"></i>
                        <div class="fw-bold">Quét mã QR để thanh toán</div>
                    </div>

                    <div class="qr-wrap text-center">
                        <img src="${vietQrUrl}" alt="VietQR" class="img-fluid bg-white rounded-4 p-3" style="max-width: 320px;"/>
                        <div class="text-muted small mt-2">Sử dụng ứng dụng ngân hàng để quét mã</div>
                        <span class="pill mt-2 d-inline-flex align-items-center gap-1">
                            <i class="bi bi-shield-check"></i> VietQR
                        </span>
                    </div>

                    <div class="mt-3">
                        <div class="text-muted small mb-1">Trạng thái thanh toán</div>
                        <div id="payment-status" class="mb-2"></div>
                        <div class="d-flex gap-2 flex-wrap">
                            <button id="manualCheckBtn" class="btn btn-light" type="button"
                                    style="border-radius: 12px; border: 1px solid rgba(16,24,40,.10);">
                                Kiểm tra
                            </button>
                            <button id="paidBtn" class="btn btn-brand" type="button" style="border-radius: 12px;">
                                <i class="bi bi-check2-circle me-1"></i> Tôi đã thanh toán
                            </button>
                            <button id="simulateSuccessBtn" class="btn btn-success" type="button" style="border-radius: 12px;">
                                Giả lập
                            </button>
                        </div>
                        <div class="small text-muted mt-2">
                            Hệ thống chỉ chuyển <strong>SUCCESS</strong> khi backend xác nhận (polling).
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card shadow-soft h-100">
                <div class="card-body">
                    <div class="fw-bold mb-3">Thông tin chuyển khoản</div>

                    <div class="text-muted small">NGÂN HÀNG</div>
                    <div class="fw-semibold mb-2">Techcombank</div>

                    <div class="text-muted small d-flex align-items-center justify-content-between">
                        <span>SỐ TÀI KHOẢN</span>
                    </div>
                    <div class="d-flex align-items-center gap-2 mb-3">
                        <div class="copy-field flex-grow-1" id="accountNoText"><c:out value="${accountNo}"/></div>
                        <button class="btn btn-light" type="button" id="copyAccountBtn"
                                style="border-radius: 12px; border: 1px solid rgba(16,24,40,.10);">
                            <i class="bi bi-copy"></i>
                        </button>
                    </div>

                    <div class="text-muted small">SỐ TIỀN</div>
                    <div class="d-flex align-items-center gap-2 mb-3">
                        <div class="copy-field flex-grow-1" id="amountText"><c:out value="${amount}"/> VNĐ</div>
                        <button class="btn btn-light" type="button" id="copyAmountBtn"
                                style="border-radius: 12px; border: 1px solid rgba(16,24,40,.10);">
                            <i class="bi bi-copy"></i>
                        </button>
                    </div>

                    <div class="text-muted small">NỘI DUNG CHUYỂN KHOẢN</div>
                    <div class="d-flex align-items-center gap-2">
                        <div class="copy-field flex-grow-1" id="contentText"><c:out value="${addInfo}"/></div>
                        <button class="btn btn-light" type="button" id="copyContentBtn"
                                style="border-radius: 12px; border: 1px solid rgba(16,24,40,.10);">
                            <i class="bi bi-copy"></i>
                        </button>
                    </div>
                    <div class="text-danger small mt-2">
                        * Vui lòng nhập chính xác nội dung chuyển khoản
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card shadow-soft h-100">
                <div class="card-body">
                    <div class="fw-bold mb-3">Thông tin đơn hàng</div>

                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <div class="text-muted">Mã đơn hàng</div>
                        <div class="pill" id="orderCodePill"><c:out value="${addInfo}"/></div>
                    </div>

                    <div class="d-flex align-items-start gap-3 mt-3">
                        <div class="brand-badge" style="width:52px;height:52px;border-radius:14px;">
                            <i class="bi bi-file-earmark-text" style="font-size:1.4rem;"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-bold">${examPackage.name}</div>
                            <div class="text-muted small">
                                <c:out value="${examPackage.numberOfExams}"/> đề thi
                            </div>
                            <a class="small text-decoration-none"
                               href="${pageContext.request.contextPath}/packages/${examPackage.id}">
                                Xem chi tiết gói thi
                            </a>
                        </div>
                    </div>

                    <hr class="my-3"/>

                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <div class="text-muted">Tổng thanh toán</div>
                        <div class="order-total"><c:out value="${amount}"/></div>
                    </div>
                    <div class="text-muted">VNĐ</div>

                    <div class="small text-muted mt-3 d-flex align-items-center gap-2">
                        <i class="bi bi-shield-lock"></i> Giao dịch được bảo mật
                    </div>
                </div>
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
            const cls = data.status === 'SUCCESS' ? 'bg-success' : (data.status === 'FAILED' ? 'bg-danger' : 'bg-secondary');
            el.innerHTML = '<span class="badge ' + cls + '" style="border-radius:999px; padding:.5rem .75rem;">Trạng thái: ' + data.status + '</span>';
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

    document.getElementById('paidBtn').addEventListener('click', function () {
        refreshStatus(true);
    });

    document.getElementById('simulateSuccessBtn').addEventListener('click', async function () {
        await fetch(simulateUrl, {method: 'POST'});
        await refreshStatus(true);
    });

    function copyText(text) {
        if (navigator.clipboard && window.isSecureContext) {
            return navigator.clipboard.writeText(text);
        }
        const ta = document.createElement('textarea');
        ta.value = text;
        ta.style.position = 'fixed';
        ta.style.left = '-9999px';
        document.body.appendChild(ta);
        ta.focus();
        ta.select();
        document.execCommand('copy');
        document.body.removeChild(ta);
        return Promise.resolve();
    }

    document.getElementById('copyAccountBtn').addEventListener('click', async function () {
        await copyText(document.getElementById('accountNoText').innerText.trim());
    });
    document.getElementById('copyAmountBtn').addEventListener('click', async function () {
        await copyText(document.getElementById('amountText').innerText.trim());
    });
    document.getElementById('copyContentBtn').addEventListener('click', async function () {
        await copyText(document.getElementById('contentText').innerText.trim());
    });

    // Auto-check: chỉ redirect khi backend trả SUCCESS (không tự success theo thời gian nữa)
    setInterval(function () { refreshStatus(true); }, 3000);
    refreshStatus(false);
</script>
<%@ include file="/WEB-INF/views/partials/layout-bottom.jspf" %>
