<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Gói thi đã mua"/>
<c:set var="activeMenu" value="my-packages"/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="mb-0">Gói thi đã mua</h2>
        <form class="d-flex gap-2" method="get">
            <input class="form-control form-control-sm" type="text" name="q" value="${q}" placeholder="Tìm theo tên gói"/>
            <select class="form-select form-select-sm" name="status">
                <option value="" ${empty status ? 'selected' : ''}>Tất cả</option>
                <option value="PENDING" ${status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                <option value="COMPLETED" ${status == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                <option value="CANCELLED" ${status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
            </select>
            <button class="btn btn-sm btn-primary" type="submit">Lọc</button>
        </form>
    </div>

    <c:choose>
        <c:when test="${empty purchases.content}">
            <div class="alert alert-info">
                Bạn chưa mua gói thi nào. Hãy vào marketplace để lựa chọn gói phù hợp.
            </div>
        </c:when>
        <c:otherwise>
            <table class="table table-striped">
                <thead>
                <tr>
                    <th>Gói thi</th>
                    <th>Ngày mua</th>
                    <th>Trạng thái</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="p" items="${purchases.content}">
                    <tr>
                        <td>${p.examPackage.name}</td>
                        <td>${p.purchaseDate}</td>
                        <td>
                            <span class="badge ${p.status == 'COMPLETED' ? 'bg-success' : (p.status == 'PENDING' ? 'bg-secondary' : 'bg-danger')}">
                                ${p.status}
                            </span>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <nav class="mt-3">
                <ul class="pagination">
                    <c:forEach begin="0" end="${purchases.totalPages - 1}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link"
                               href="?page=${i}&size=${pageSize}&q=${q}&status=${status}">${i + 1}</a>
                        </li>
                    </c:forEach>
                </ul>
            </nav>
        </c:otherwise>
    </c:choose>
<%@ include file="/WEB-INF/views/partials/layout-bottom.jspf" %>
