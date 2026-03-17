<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Lịch sử thanh toán"/>
<c:set var="activeMenu" value="payment-history"/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="mb-0">Lịch sử thanh toán</h2>
        <form class="d-flex gap-2" method="get">
            <input class="form-control form-control-sm" type="text" name="q" value="${q}" placeholder="Tìm theo tên gói"/>
            <select class="form-select form-select-sm" name="status">
                <option value="" ${empty status ? 'selected' : ''}>Tất cả</option>
                <option value="PENDING" ${status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                <option value="SUCCESS" ${status == 'SUCCESS' ? 'selected' : ''}>SUCCESS</option>
                <option value="FAILED" ${status == 'FAILED' ? 'selected' : ''}>FAILED</option>
            </select>
            <input class="form-control form-control-sm" type="date" name="from" value="${from}"/>
            <input class="form-control form-control-sm" type="date" name="to" value="${to}"/>
            <button class="btn btn-sm btn-primary" type="submit">Lọc</button>
        </form>
    </div>

    <c:choose>
        <c:when test="${empty transactions.content}">
            <div class="alert alert-info">
                Không có giao dịch thanh toán nào.
            </div>
        </c:when>
        <c:otherwise>
            <table class="table table-hover">
                <thead>
                <tr>
                    <th>Mã giao dịch</th>
                    <th>Gói thi</th>
                    <th>Số tiền</th>
                    <th>Trạng thái</th>
                    <th>Thời gian</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="tx" items="${transactions.content}">
                    <tr>
                        <td>${tx.id}</td>
                        <td>${tx.purchase.examPackage.name}</td>
                        <td>${tx.amount}</td>
                        <td>
                            <span class="badge
                                ${tx.paymentStatus == 'SUCCESS' ? 'bg-success' :
                                   (tx.paymentStatus == 'FAILED' ? 'bg-danger' : 'bg-secondary')}">
                                ${tx.paymentStatus}
                            </span>
                        </td>
                        <td>${tx.paymentDate}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

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
