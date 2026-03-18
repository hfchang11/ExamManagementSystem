<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="${examPackage.name}"/>
<c:set var="activeMenu" value="marketplace"/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>
            <div class="mb-3 d-flex align-items-center justify-content-between">
                <div>
                    <a href="${pageContext.request.contextPath}/packages" class="text-decoration-none text-muted small">
                        &laquo; Cửa hàng đề thi
                    </a>
                </div>
            </div>

            <div class="row g-4">
                <!-- Left: package hero -->
                <div class="col-lg-8">
                    <div class="card shadow-soft mb-3">
                        <div class="card-body d-flex gap-3 align-items-start">
                            <div class="pkg-hero flex-shrink-0" style="width:120px;height:120px;">
                                <i class="bi bi-file-earmark-text-fill"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="d-flex flex-wrap align-items-center gap-2 mb-2">
                                    <span class="pill">Gói đề thi</span>
                                </div>
                                <h3 class="mb-2">${examPackage.name}</h3>
                                <p class="mb-3 text-muted">${examPackage.description}</p>
                                <div class="d-flex flex-wrap align-items-center gap-3 small text-muted">
                                    <span>
                                        <i class="bi bi-file-earmark-text me-1"></i>
                                        <c:out value="${examCount}"/> đề thi
                                    </span>
                                    <c:if test="${examPackage.studentCount != null && examPackage.studentCount > 0}">
                                        <span>
                                            <i class="bi bi-people me-1"></i>
                                            <c:out value="${examPackage.studentCount}"/>+ học viên
                                        </span>
                                    </c:if>
                                </div>

                                <div class="d-flex align-items-center gap-2 mt-3">
                                    <div class="text-warning">
                                        <c:choose>
                                            <c:when test="${examPackage.averageRating != null && examPackage.averageRating >= 4.5}">
                                                <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                            </c:when>
                                            <c:when test="${examPackage.averageRating != null && examPackage.averageRating >= 3.5}">
                                                <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star"></i>
                                            </c:when>
                                            <c:when test="${examPackage.averageRating != null}">
                                                <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star"></i><i class="bi bi-star"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-star"></i><i class="bi bi-star"></i><i class="bi bi-star"></i><i class="bi bi-star"></i><i class="bi bi-star"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="small text-muted">
                                        <c:choose>
                                            <c:when test="${examPackage.averageRating != null}">
                                                <strong><c:out value="${examPackage.averageRating}"/></strong>
                                                (<c:out value="${examPackage.reviewCount != null ? examPackage.reviewCount : 0}"/> đánh giá)
                                            </c:when>
                                            <c:otherwise>
                                                Chưa có đánh giá
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right: summary / buy card -->
                <div class="col-lg-4">
                    <div class="card shadow-soft">
                        <div class="card-body">
                            <div class="mb-3">
                                <div class="text-muted small mb-1">Giá gói</div>
                                <div class="order-total mb-1">
                                    <c:out value="${examPackage.price}"/> VNĐ
                                </div>
                            </div>
                            <ul class="list-unstyled small text-muted mb-3">
                                <li class="mb-1">
                                    <i class="bi bi-check2 text-success me-1"></i> Truy cập trọn đời
                                </li>
                                <li class="mb-1">
                                    <i class="bi bi-check2 text-success me-1"></i> Giải chi tiết sau mỗi đề thi
                                </li>
                                <li class="mb-1">
                                    <i class="bi bi-check2 text-success me-1"></i> Hỗ trợ qua Zalo / Email
                                </li>
                                <li class="mb-1">
                                    <i class="bi bi-check2 text-success me-1"></i> Cập nhật đề thi miễn phí
                                </li>
                            </ul>
                            <a href="${pageContext.request.contextPath}/purchase/${examPackage.id}"
                               class="btn btn-brand w-100">
                                <i class="bi bi-cart-check me-2"></i> Mua ngay
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tabs -->
            <div class="card mt-4">
                <div class="card-header border-0 pb-0">
                    <ul class="nav nav-pills nav-fill small" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="tab-overview" data-bs-toggle="tab"
                                    data-bs-target="#pane-overview" type="button" role="tab">
                                Tổng quan
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="tab-exams" data-bs-toggle="tab"
                                    data-bs-target="#pane-exams" type="button" role="tab">
                                Danh sách đề thi
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="tab-reviews" data-bs-toggle="tab"
                                    data-bs-target="#pane-reviews" type="button" role="tab">
                                Đánh giá
                            </button>
                        </li>
                    </ul>
                </div>
                <div class="card-body tab-content">
                    <!-- Tổng quan -->
                    <div class="tab-pane fade show active" id="pane-overview" role="tabpanel"
                         aria-labelledby="tab-overview">
                        <h5 class="mb-3">Tổng quan gói đề thi</h5>
                        <p class="text-muted">${examPackage.description}</p>
                        <ul class="list-unstyled small text-muted mb-0">
                            <li class="mb-1">
                                <i class="bi bi-file-earmark-text me-1"></i>
                                <strong><c:out value="${examCount}"/> đề thi</strong> được chọn lọc từ ngân hàng đề.
                            </li>
                            <li class="mb-1">
                                <i class="bi bi-clock-history me-1"></i>
                                Thời hạn truy cập: trọn đời cho tài khoản đã mua.
                            </li>
                            <li class="mb-1">
                                <i class="bi bi-mortarboard me-1"></i>
                                Hoàn thành đầy đủ các đề thi để nắm vững cấu trúc và dạng câu hỏi.
                            </li>
                        </ul>
                    </div>

                    <!-- Danh sách đề thi -->
                    <div class="tab-pane fade" id="pane-exams" role="tabpanel"
                         aria-labelledby="tab-exams">
                        <h5 class="mb-3">
                            Danh sách đề thi
                            (<c:out value="${examCount}"/> đề)
                        </h5>
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
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>

                    <!-- Đánh giá -->
                    <div class="tab-pane fade" id="pane-reviews" role="tabpanel"
                         aria-labelledby="tab-reviews">
                        <h5 class="mb-3">Đánh giá từ học viên</h5>
                        <c:choose>
                            <c:when test="${examPackage.reviewCount != null && examPackage.reviewCount > 0}">
                                <p class="mb-3">
                                    <strong><c:out value="${examPackage.averageRating}"/></strong>/5
                                    từ <strong><c:out value="${examPackage.reviewCount}"/></strong> lượt đánh giá.
                                </p>
                                <c:forEach var="rv" items="${reviews}">
                                    <div class="border rounded-3 p-3 mb-2 bg-light">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <div class="fw-semibold small">
                                                <c:out value="${rv.student.username}"/>
                                            </div>
                                            <div class="text-warning small">
                                                <c:forEach begin="1" end="5" var="s">
                                                    <i class="bi ${s <= rv.rating ? 'bi-star-fill' : 'bi-star'}"></i>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div class="small text-muted mb-1">
                                            <c:out value="${rv.createdAt}"/>
                                        </div>
                                        <div class="small">
                                            <c:out value="${rv.comment}"/>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted mb-0">Chưa có đánh giá nào cho gói đề thi này.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
<%@ include file="/WEB-INF/views/partials/layout-bottom.jspf" %>
