<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Cửa hàng đề thi"/>
<c:set var="breadcrumb" value="Trang chủ  ›  Cửa hàng  ›  Đề thi"/>
<c:set var="activeMenu" value="marketplace"/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>

    <div class="market-toolbar card shadow-soft mb-3">
        <div class="card-body">
            <form method="get" class="row g-2 align-items-center">
                <div class="col-12 col-lg-5 position-relative">
                    <i class="bi bi-search search-in-input"></i>
                    <input name="q" value="${q}" class="form-control ps-5" placeholder="Tìm kiếm gói đề thi..."/>
                </div>
                <div class="col-12 col-lg-4">
                    <input type="hidden" name="sortBy" value="price"/>
                    <select class="form-select" name="direction">
                        <option value="" ${empty direction ? 'selected' : ''}>Sắp xếp theo giá</option>
                        <option value="asc" ${direction == 'asc' ? 'selected' : ''}>Giá tăng dần</option>
                        <option value="desc" ${direction == 'desc' ? 'selected' : ''}>Giá giảm dần</option>
                    </select>
                </div>
                <div class="col-12 col-lg-3 d-grid">
                    <button class="btn btn-brand" type="submit">Áp dụng</button>
                </div>
            </form>
            <c:if test="${(q != null && not empty q) || (direction != null && not empty direction)}">
                <div class="mt-2">
                    <a class="small text-muted text-decoration-none"
                       href="${pageContext.request.contextPath}/packages">
                        Xoá bộ lọc
                    </a>
                </div>
            </c:if>
        </div>
    </div>

    <div class="d-flex align-items-center justify-content-between mb-2">
        <div class="text-muted">
            Hiển thị <strong><c:out value="${packages.totalElements}"/></strong> gói đề thi
        </div>
    </div>

    <c:choose>
        <c:when test="${empty packages.content}">
            <div class="alert alert-info">
                Không có gói thi nào khả dụng.
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-3">
                <c:forEach var="pkg" items="${packages.content}">
                    <div class="col-md-6 col-xl-4">
                        <div class="card pkg-card h-100 shadow-soft">
                            <div class="card-body d-flex flex-column gap-2">
                                <div class="pkg-hero mb-1">
                                    <i class="bi bi-file-earmark-text"></i>
                                </div>

                                <div class="d-flex align-items-center justify-content-between">
                                    <div class="pkg-code">PKG</div>
                                    <span class="pill">Gói đề thi</span>
                                </div>

                                <div class="fw-bold fs-5">${pkg.name}</div>
                                <div class="text-muted" style="min-height: 44px;">
                                    <c:out value="${pkg.description}"/>
                                </div>

                                <div class="d-flex align-items-center gap-3 text-muted">
                                    <div><i class="bi bi-journal-text me-1"></i> <c:out value="${pkg.numberOfExams}"/> đề thi</div>
                                </div>

                                <div class="d-flex align-items-center gap-2">
                                    <div class="text-warning">
                                        <c:choose>
                                            <c:when test="${pkg.averageRating != null && pkg.averageRating >= 4.5}">
                                                <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                            </c:when>
                                            <c:when test="${pkg.averageRating != null && pkg.averageRating >= 3.5}">
                                                <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star"></i>
                                            </c:when>
                                            <c:when test="${pkg.averageRating != null}">
                                                <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star"></i><i class="bi bi-star"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-star"></i><i class="bi bi-star"></i><i class="bi bi-star"></i><i class="bi bi-star"></i><i class="bi bi-star"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="text-muted small">
                                        <c:out value="${pkg.averageRating != null ? pkg.averageRating : 'Chưa có đánh giá'}"/>
                                    </div>
                                </div>

                                <div class="d-flex align-items-end justify-content-between mt-1">
                                    <div class="price"><c:out value="${pkg.price}"/> VNĐ</div>
                                </div>

                                <div class="mt-auto d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/packages/${pkg.id}"
                                       class="btn btn-light w-50" style="border-radius: 12px; border: 1px solid rgba(16,24,40,.10);">
                                        Xem chi tiết
                                    </a>
                                    <a href="${pageContext.request.contextPath}/purchase/${pkg.id}"
                                       class="btn btn-brand w-50" style="border-radius: 12px;">
                                        Mua ngay
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <nav class="mt-4">
                <ul class="pagination">
                    <c:forEach begin="0" end="${packages.totalPages - 1}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link"
                               href="?page=${i}&size=${pageSize}&q=${q}&sortBy=${sortBy}&direction=${direction}">${i + 1}</a>
                        </li>
                    </c:forEach>
                </ul>
            </nav>
        </c:otherwise>
    </c:choose>
<%@ include file="/WEB-INF/views/partials/layout-bottom.jspf" %>
