<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Marketplace gói thi"/>
<c:set var="activeMenu" value="marketplace"/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Marketplace gói thi</h2>
        <form class="d-flex" method="get">
            <input name="q" value="${q}" class="form-control form-control-sm me-2" placeholder="Tìm gói thi..."/>
            <select name="sortBy" class="form-select form-select-sm me-2">
                <option value="createdAt" ${sortBy == 'createdAt' || sortBy == null ? 'selected' : ''}>Mới nhất</option>
                <option value="price" ${sortBy == 'price' ? 'selected' : ''}>Giá</option>
                <option value="averageRating" ${sortBy == 'averageRating' ? 'selected' : ''}>Rating</option>
            </select>
            <select name="direction" class="form-select form-select-sm me-2">
                <option value="desc" ${direction == 'desc' || direction == null ? 'selected' : ''}>Giảm dần</option>
                <option value="asc" ${direction == 'asc' ? 'selected' : ''}>Tăng dần</option>
            </select>
            <button class="btn btn-primary btn-sm" type="submit">Lọc / Sắp xếp</button>
        </form>
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
                    <div class="col-md-4">
                        <div class="card h-100 shadow-sm">
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title">${pkg.name}</h5>
                                <p class="card-text text-muted small">${pkg.description}</p>
                                <p class="mb-1"><strong>Số đề:</strong> ${pkg.numberOfExams}</p>
                                <p class="mb-1"><strong>Giá:</strong> ${pkg.price} VNĐ</p>
                                <p class="mb-3"><strong>Rating:</strong>
                                    <c:out value="${pkg.averageRating != null ? pkg.averageRating : 'Chưa có'}"/>
                                </p>
                                <div class="mt-auto d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/packages/${pkg.id}"
                                       class="btn btn-outline-primary btn-sm">Chi tiết</a>
                                    <a href="${pageContext.request.contextPath}/purchase/${pkg.id}"
                                       class="btn btn-primary btn-sm">Mua ngay</a>
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
