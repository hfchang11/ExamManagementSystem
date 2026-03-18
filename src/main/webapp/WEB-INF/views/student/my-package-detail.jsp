<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="${examPackage.name}"/>
<c:set var="activeMenu" value="my-packages"/>
<c:set var="breadcrumb" value="Trang chủ  ›  Gói đề thi của tôi  ›  ${examPackage.name}"/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>

    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/my-packages" class="btn btn-link ps-0">
            &laquo; Quay lại danh sách gói đã mua
        </a>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-lg-8">
            <div class="card shadow-soft">
                <div class="card-body d-flex gap-3 align-items-start">
                    <div class="stat-icon bg-soft-success text-success flex-shrink-0">
                        <i class="bi bi-journal-text"></i>
                    </div>
                    <div>
                        <h3 class="mb-2">${examPackage.name}</h3>
                        <p class="text-muted mb-3">
                            <c:out value="${examPackage.description}"/>
                        </p>
                        <div class="d-flex flex-wrap align-items-center gap-3 small text-muted">
                            <span>
                                <i class="bi bi-file-earmark-text me-1"></i>
                                <c:out value="${examCount}"/> đề trong gói
                            </span>
                            <span>
                                <i class="bi bi-check2-circle me-1"></i>
                                Đã làm <c:out value="${examDoneCount}"/>/<c:out value="${examCount}"/> đề
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card shadow-soft">
                <div class="card-body">
                    <div class="text-muted small mb-1">Giá đã mua</div>
                    <div class="stat-value mb-2"><c:out value="${examPackage.price}"/> VND</div>
                    <a href="${pageContext.request.contextPath}/exam-history"
                       class="btn btn-outline-secondary w-100">
                        Xem lịch sử làm bài
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="card data-card">
        <div class="card-body">
            <h5 class="mb-3">Danh sách đề trong gói</h5>
            <c:if test="${empty exams}">
                <p class="text-muted mb-0">Chưa có đề thi nào trong gói này.</p>
            </c:if>
            <c:if test="${not empty exams}">
                <div class="list-group border-0">
                    <c:forEach var="exam" items="${exams}" varStatus="st">
                        <div class="list-group-item border-0 d-flex align-items-center justify-content-between px-0">
                            <div class="d-flex align-items-center gap-3">
                                <div class="rounded-circle bg-success-subtle text-success fw-bold d-flex align-items-center justify-content-center"
                                     style="width:40px;height:40px;">
                                    ${st.index + 1}
                                </div>
                                <div>
                                    <div class="fw-semibold">${exam.title}</div>
                                    <div class="small text-muted">
                                        <c:out value="${exam.totalQuestions}"/> câu hỏi
                                    </div>
                                </div>
                            </div>
                            <span class="badge rounded-pill bg-light text-muted small">
                                Xem chi tiết trong lịch sử làm bài
                            </span>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </div>

<%@ include file="/WEB-INF/views/partials/layout-bottom.jspf" %>

