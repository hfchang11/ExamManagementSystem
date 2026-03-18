<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Lịch sử làm bài"/>
<c:set var="activeMenu" value="exam-history"/>
<c:set var="breadcrumb" value="Trang chủ  ›  Lịch sử làm bài"/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>
    <div class="d-flex align-items-start justify-content-between gap-3 mb-3">
        <div>
            <h2 class="mb-1">Lịch sử làm bài</h2>
            <div class="text-muted">Theo dõi tiến độ luyện tập và kết quả của bạn</div>
        </div>
    </div>

    <div class="row g-3 mb-3">
        <div class="col-12 col-md-6 col-xl-3">
            <div class="card shadow-soft stat-card">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="stat-icon bg-soft-success text-success"><i class="bi bi-journal-text"></i></div>
                    <div>
                        <div class="text-muted small">Tổng lượt làm</div>
                        <div class="stat-value">${kpiTotalAttempts}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-12 col-md-6 col-xl-3">
            <div class="card shadow-soft stat-card">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="stat-icon bg-soft-primary text-primary"><i class="bi bi-bar-chart"></i></div>
                    <div>
                        <div class="text-muted small">Điểm trung bình</div>
                        <div class="stat-value">
                            <c:out value="${kpiAvgScore}"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-12 col-md-6 col-xl-3">
            <div class="card shadow-soft stat-card">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="stat-icon bg-soft-success text-success"><i class="bi bi-trophy"></i></div>
                    <div>
                        <div class="text-muted small">Điểm cao nhất</div>
                        <div class="stat-value">${kpiBestScore}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-12 col-md-6 col-xl-3">
            <div class="card shadow-soft stat-card">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="stat-icon bg-soft-success text-success"><i class="bi bi-check2-circle"></i></div>
                    <div>
                        <div class="text-muted small">Tổng câu đúng</div>
                        <div class="stat-value">${kpiTotalCorrect}</div>
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
                               placeholder="Tìm theo tên bài thi..."/>
                    </div>
                </div>
                <div class="col-12 col-md-6 col-lg-4">
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
        <c:when test="${empty results.content}">
            <div class="alert alert-info">
                Bạn chưa có bài thi nào được lưu.
            </div>
        </c:when>
        <c:otherwise>
            <div class="card shadow-soft data-card">
                <div class="card-body">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <div class="h5 mb-0">Danh sách bài đã làm</div>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle table-clean mb-0">
                            <thead>
                            <tr>
                                <th>Bài thi</th>
                                <th style="width: 140px;">Điểm</th>
                                <th style="width: 170px;">Đúng / Sai</th>
                                <th style="width: 190px;">Thời gian</th>
                                <th style="width: 90px;" class="text-end">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="r" items="${results.content}">
                                <tr>
                                    <td>
                                        <div class="fw-semibold">${r.exam.title}</div>
                                        <div class="text-muted small">Attempt: ${r.id}</div>
                                    </td>
                                    <td class="fw-semibold text-nowrap">${r.score}</td>
                                    <td class="text-nowrap">
                                        <span class="pill">${r.correctAnswers} đúng</span>
                                        <span class="pill">${r.wrongAnswers} sai</span>
                                    </td>
                                    <td class="text-nowrap">${r.submittedAt}</td>
                                    <td class="text-end text-nowrap">
                                        <a class="icon-action" href="${pageContext.request.contextPath}/exam-history/${r.id}" title="Xem">
                                            <i class="bi bi-eye"></i>
                                        </a>
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
                    <c:forEach begin="0" end="${results.totalPages - 1}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link"
                               href="?page=${i}&size=${pageSize}&q=${q}&from=${from}&to=${to}">${i + 1}</a>
                        </li>
                    </c:forEach>
                </ul>
            </nav>
        </c:otherwise>
    </c:choose>
<%@ include file="/WEB-INF/views/partials/layout-bottom.jspf" %>
