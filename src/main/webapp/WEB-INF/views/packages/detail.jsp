<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Chi tiết gói thi"/>
<c:set var="activeMenu" value="marketplace"/>
<%@ include file="/WEB-INF/views/partials/layout-top.jspf" %>
            <div class="mb-3">
                <a href="${pageContext.request.contextPath}/packages" class="btn btn-link">&laquo; Quay lại danh sách</a>
            </div>

            <div class="card shadow-sm">
                <div class="card-body">
                    <h3 class="card-title mb-3">${examPackage.name}</h3>
                    <p class="card-text">${examPackage.description}</p>
                    <p><strong>Số đề:</strong> ${examPackage.numberOfExams}</p>
                    <p><strong>Giá:</strong> ${examPackage.price} VNĐ</p>
                    <p><strong>Rating:</strong>
                        <c:out value="${examPackage.averageRating != null ? examPackage.averageRating : 'Chưa có'}"/>
                    </p>

                    <a href="${pageContext.request.contextPath}/purchase/${examPackage.id}"
                       class="btn btn-primary">Mua gói thi</a>
                </div>
            </div>
<%@ include file="/WEB-INF/views/partials/layout-bottom.jspf" %>
