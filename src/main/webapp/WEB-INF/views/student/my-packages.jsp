<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Gói thi đã mua"/>
<c:set var="activeMenu" value="my-packages"/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="mb-0">Gói thi đã mua</h2>
        <form class="d-flex gap-2" method="get">
            <input class="form-control form-control-sm" type="text" name="q" value="${q}" placeholder="Tìm theo tên gói"/>
            <button class="btn btn-sm btn-primary" type="submit">Lọc</button>
        </form>
    </div>

    <c:choose>
        <c:when test="${empty packages.content}">
            <div class="alert alert-info">
                Bạn chưa mua gói thi nào. Hãy vào marketplace để lựa chọn gói phù hợp.
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-3">
                <c:forEach var="pkg" items="${packages.content}">
                    <div class="col-md-4">
                        <div class="card h-100 shadow-sm">
                            <div class="card-body d-flex flex-column">
                                <div class="d-flex align-items-start justify-content-between">
                                    <h5 class="card-title mb-1">${pkg.name}</h5>
                                    <span class="badge bg-success">Đã mua</span>
                                </div>
                                <p class="card-text text-muted small">${pkg.description}</p>
                                <p class="mb-1"><strong>Số đề:</strong> ${pkg.numberOfExams}</p>
                                <p class="mb-1"><strong>Giá:</strong> ${pkg.price} VNĐ</p>
                                <p class="mb-3"><strong>Rating:</strong>
                                    <c:out value="${pkg.averageRating != null ? pkg.averageRating : 'Chưa có'}"/>
                                </p>
                                <div class="mt-auto d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/packages/${pkg.id}"
                                       class="btn btn-outline-primary btn-sm">Xem chi tiết</a>
                                    <a href="${pageContext.request.contextPath}/purchase/${pkg.id}"
                                       class="btn btn-primary btn-sm">Mua lại</a>
                                </div>
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
