<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Chi tiết bài thi"/>
<c:set var="activeMenu" value="exam-history"/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>

<a href="${pageContext.request.contextPath}/exam-history" class="btn btn-link mb-3">&laquo; Quay lại lịch sử</a>

<h2>${result.exam.title}</h2>
<p><strong>Điểm:</strong> ${result.score}</p>
<p><strong>Đúng / Sai:</strong> ${result.correctAnswers} / ${result.wrongAnswers}</p>
<p><strong>Thời gian nộp:</strong> ${result.submittedAt}</p>

<%@ include file="/WEB-INF/views/partials/layout-bottom.jspf" %>
