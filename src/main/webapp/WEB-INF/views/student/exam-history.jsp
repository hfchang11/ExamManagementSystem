<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Lịch sử làm bài"/>
<c:set var="activeMenu" value="exam-history"/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="mb-0">Lịch sử làm bài</h2>
        <form class="d-flex gap-2" method="get">
            <input class="form-control form-control-sm" type="text" name="q" value="${q}" placeholder="Tìm theo tên bài thi"/>
            <input class="form-control form-control-sm" type="date" name="from" value="${from}"/>
            <input class="form-control form-control-sm" type="date" name="to" value="${to}"/>
            <button class="btn btn-sm btn-primary" type="submit">Lọc</button>
        </form>
    </div>

    <c:choose>
        <c:when test="${empty results.content}">
            <div class="alert alert-info">
                Bạn chưa có bài thi nào được lưu.
            </div>
        </c:when>
        <c:otherwise>
            <table class="table table-striped">
                <thead>
                <tr>
                    <th>Bài thi</th>
                    <th>Điểm</th>
                    <th>Đúng / Sai</th>
                    <th>Thời gian nộp</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="r" items="${results.content}">
                    <tr>
                        <td>${r.exam.title}</td>
                        <td>${r.score}</td>
                        <td>${r.correctAnswers} / ${r.wrongAnswers}</td>
                        <td>${r.submittedAt}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/exam-history/${r.id}"
                               class="btn btn-sm btn-outline-primary">Chi tiết</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

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
