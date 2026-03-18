<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Gói thi đã mua"/>
<c:set var="activeMenu" value="my-packages"/>
<c:set var="breadcrumb" value="Trang chủ  ›  Gói đề thi của tôi"/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>
    <div class="d-flex align-items-start justify-content-between gap-3 mb-3">
        <div>
            <h2 class="mb-1">Gói đề thi của tôi</h2>
            <div class="text-muted">Quản lý và theo dõi tiến độ học tập của bạn</div>
        </div>
        <a class="btn btn-brand btn-lg" href="${pageContext.request.contextPath}/packages">
            <i class="bi bi-bag-plus me-1"></i> Mua thêm gói
        </a>
    </div>

    <div class="row g-3 mb-3">
        <div class="col-12 col-md-6 col-xl-4">
            <div class="card shadow-soft stat-card">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="stat-icon bg-soft-success text-success"><i class="bi bi-journal-text"></i></div>
                    <div>
                        <div class="text-muted small">Tổng gói đề thi</div>
                        <div class="stat-value">${kpiTotalPackages}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-12 col-md-6 col-xl-4">
            <div class="card shadow-soft stat-card">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="stat-icon bg-soft-success text-success"><i class="bi bi-check2-circle"></i></div>
                    <div>
                        <div class="text-muted small">Đề thi đã làm</div>
                        <div class="stat-value">${kpiTotalAttempts}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-12 col-md-6 col-xl-4">
            <div class="card shadow-soft stat-card">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="stat-icon bg-soft-primary text-primary"><i class="bi bi-bar-chart"></i></div>
                    <div>
                        <div class="text-muted small">Điểm trung bình</div>
                        <div class="stat-value"><c:out value="${kpiAvgScore}"/></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Đã bỏ filter theo trạng thái, chỉ giữ danh sách + phân trang -->

    <c:choose>
        <c:when test="${empty packages.content}">
            <div class="alert alert-info">
                Bạn chưa mua gói thi nào. Hãy vào marketplace để lựa chọn gói phù hợp.
            </div>
        </c:when>
        <c:otherwise>
            <div class="d-flex flex-column gap-3">
                <c:forEach var="pkg" items="${packages.content}">
                    <div class="card shadow-soft">
                        <div class="card-body d-flex align-items-center gap-3 flex-wrap">
                            <div class="stat-icon bg-soft-success text-success flex-shrink-0"><i class="bi bi-journal-text"></i></div>

                            <div class="flex-grow-1" style="min-width: 260px;">
                                <div class="d-flex align-items-center gap-2 flex-wrap">
                                    <span class="pill">Đã mua</span>
                                    <span class="pill text-muted">ID: <c:out value="${pkg.id}"/></span>
                                </div>
                                <div class="h5 mb-1 mt-2">${pkg.name}</div>
                                <div class="text-muted small">
                                    <c:out value="${pkg.description}"/>
                                </div>
                            </div>

                            <div class="d-flex align-items-center gap-3 flex-wrap" style="min-width: 260px;">
                                <div>
                                    <div class="text-muted small mb-1">Số đề</div>
                                    <div class="fw-semibold text-nowrap"><c:out value="${pkg.numberOfExams}"/> đề</div>
                                </div>
                                <div>
                                    <div class="text-muted small mb-1">Giá</div>
                                    <div class="fw-semibold text-nowrap"><c:out value="${pkg.price}"/> VND</div>
                                </div>
                                <div>
                                    <div class="text-muted small mb-1">Đánh giá</div>
                                    <div class="fw-semibold text-nowrap">
                                        <c:out value="${pkg.averageRating != null ? pkg.averageRating : '—'}"/>
                                    </div>
                                </div>
                            </div>

                            <div class="ms-auto">
                                <a href="${pageContext.request.contextPath}/my-packages/${pkg.id}"
                                   class="btn btn-brand btn-lg">
                                    Tiếp tục học <i class="bi bi-chevron-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <nav class="mt-3">
                <ul class="pagination">
                    <c:forEach begin="0" end="${packages.totalPages - 1}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link"
                               href="?page=${i}&size=${pageSize}&q=${q}">${i + 1}</a>
                        </li>
                    </c:forEach>
                </ul>
            </nav>
        </c:otherwise>
    </c:choose>
<%@ include file="/WEB-INF/views/partials/layout-bottom.jspf" %>
