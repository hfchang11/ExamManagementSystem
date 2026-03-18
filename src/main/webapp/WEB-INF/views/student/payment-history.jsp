<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Lịch sử thanh toán"/>
<c:set var="activeMenu" value="payment-history"/>
<c:set var="breadcrumb" value="Trang chủ  ›  Lịch sử thanh toán"/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>
    <div class="d-flex align-items-start justify-content-between gap-3 mb-3">
        <div>
            <h2 class="mb-1">Lịch sử thanh toán</h2>
            <div class="text-muted">Theo dõi giao dịch mua gói đề thi của bạn</div>
        </div>
    </div>

    <div class="row g-3 mb-3">
        <div class="col-12 col-md-6 col-xl-3">
            <div class="card shadow-soft stat-card">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="stat-icon bg-soft-success text-success"><i class="bi bi-credit-card"></i></div>
                    <div>
                        <div class="text-muted small">Tổng giao dịch</div>
                        <div class="stat-value">${kpiTotalTx}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-12 col-md-6 col-xl-3">
            <div class="card shadow-soft stat-card">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="stat-icon bg-soft-success text-success"><i class="bi bi-check-circle"></i></div>
                    <div>
                        <div class="text-muted small">Thành công</div>
                        <div class="stat-value">${kpiSuccessTx}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-12 col-md-6 col-xl-3">
            <div class="card shadow-soft stat-card">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="stat-icon bg-soft-danger text-danger"><i class="bi bi-x-circle"></i></div>
                    <div>
                        <div class="text-muted small">Thất bại</div>
                        <div class="stat-value">${kpiFailedTx}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-12 col-md-6 col-xl-3">
            <div class="card shadow-soft stat-card">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="stat-icon bg-soft-primary text-primary"><i class="bi bi-cash-stack"></i></div>
                    <div>
                        <div class="text-muted small">Tổng chi tiêu</div>
                        <div class="stat-value">${kpiTotalSpend}</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow-soft filters-card mb-3">
        <div class="card-body">
            <form class="row g-2 align-items-center" method="get">
                <div class="col-12 col-lg">
                    <div class="position-relative">
                        <i class="bi bi-search search-in-input"></i>
                        <input class="form-control form-control-lg ps-5" type="text" name="q" value="${q}"
                               placeholder="Tìm theo mã giao dịch hoặc tên gói..."/>
                    </div>
                </div>
                <div class="col-12 col-md-6 col-lg-3">
                    <div class="input-group input-group-lg">
                        <span class="input-group-text"><i class="bi bi-funnel"></i></span>
                        <select class="form-select" name="status">
                            <option value="" ${empty status ? 'selected' : ''}>Tất cả trạng thái</option>
                            <option value="PENDING" ${status == 'PENDING' ? 'selected' : ''}>Đang xử lý</option>
                            <option value="SUCCESS" ${status == 'SUCCESS' ? 'selected' : ''}>Thành công</option>
                            <option value="FAILED" ${status == 'FAILED' ? 'selected' : ''}>Thất bại</option>
                        </select>
                    </div>
                </div>
                <div class="col-12 col-md-6 col-lg-3">
                    <div class="input-group input-group-lg">
                        <span class="input-group-text"><i class="bi bi-calendar3"></i></span>
                        <input class="form-control" type="date" name="from" value="${from}"/>
                        <input class="form-control" type="date" name="to" value="${to}"/>
                    </div>
                </div>
                <div class="col-12 col-lg-auto">
                    <button class="btn btn-brand btn-lg w-100" type="submit">
                        <i class="bi bi-search me-1"></i> Lọc
                    </button>
                </div>
            </form>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty transactions.content}">
            <div class="alert alert-info">
                Không có giao dịch thanh toán nào.
            </div>
        </c:when>
        <c:otherwise>
            <div class="card shadow-soft data-card">
                <div class="card-body">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <div class="h5 mb-0">Danh sách giao dịch</div>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle table-clean mb-0">
                            <thead>
                            <tr>
                                <th style="width: 190px;">Mã giao dịch</th>
                                <th>Gói đề thi</th>
                                <th style="width: 150px;">Số tiền</th>
                                <th style="width: 130px;">Trạng thái</th>
                                <th style="width: 190px;">Thời gian</th>
                                <th style="width: 90px;" class="text-end">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="tx" items="${transactions.content}">
                                <tr>
                                    <td class="fw-semibold text-nowrap">${tx.transactionId}</td>
                                    <td>
                                        <div class="fw-semibold">${tx.purchase.examPackage.name}</div>
                                        <div class="text-muted small">Payment ID: ${tx.id}</div>
                                    </td>
                                    <td class="fw-semibold text-nowrap">${tx.amount} VND</td>
                                    <td class="text-nowrap">
                                        <span class="pill ${tx.paymentStatus == 'SUCCESS' ? 'pill-success' :
                                           (tx.paymentStatus == 'FAILED' ? 'pill-danger' : 'pill-muted')}">
                                            ${tx.paymentStatus == 'SUCCESS' ? 'Thành công' :
                                                    (tx.paymentStatus == 'FAILED' ? 'Thất bại' : 'Đang xử lý')}
                                        </span>
                                    </td>
                                    <td class="text-nowrap">${tx.paymentDate}</td>
                                    <td class="text-end text-nowrap">
                                        <span class="text-muted small">—</span>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <nav class="mt-3">
                <ul class="pagination">
                    <c:forEach begin="0" end="${transactions.totalPages - 1}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link"
                               href="?page=${i}&size=${pageSize}&q=${q}&status=${status}&from=${from}&to=${to}">${i + 1}</a>
                        </li>
                    </c:forEach>
                </ul>
            </nav>
        </c:otherwise>
    </c:choose>
<%@ include file="/WEB-INF/views/partials/layout-bottom.jspf" %>
