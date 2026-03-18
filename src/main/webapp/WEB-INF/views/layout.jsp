<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><c:out value="${pageTitle != null ? pageTitle : 'Luyện thi online'}"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .wrapper {
            display: flex;
            flex: 1;
            overflow: hidden;
        }
        #sidebar {
            width: 260px;
            background-color: #343a40;
            color: #fff;
            transition: margin-left 0.3s ease;
        }
        #sidebar.collapsed {
            margin-left: -260px;
        }
        #sidebar a {
            color: #adb5bd;
            text-decoration: none;
        }
        #sidebar a.active, #sidebar a:hover {
            color: #fff;
        }
        #content {
            flex: 1;
            padding: 1.5rem;
            overflow-y: auto;
        }
        header.navbar {
            z-index: 1030;
        }
        footer {
            background-color: #f8f9fa;
            padding: 1rem;
            text-align: center;
            border-top: 1px solid #e9ecef;
        }
    </style>
</head>
<body>
<header class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <button class="btn btn-outline-light me-2" id="sidebarToggle">☰</button>
        <a class="navbar-brand" href="${pageContext.request.contextPath}/packages">Luyện Thi Online</a>
        <div class="ms-auto">
            <span class="navbar-text text-light me-3">Xin chào, Student</span>
        </div>
    </div>
</header>

<div class="wrapper">
    <nav id="sidebar" class="d-flex flex-column p-3">
        <h5 class="text-white">Menu</h5>
        <ul class="nav nav-pills flex-column mb-auto">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/packages"
                   class="nav-link ${activeMenu == 'marketplace' ? 'active' : ''}">
                    Marketplace gói thi
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/my-packages"
                   class="nav-link ${activeMenu == 'my-packages' ? 'active' : ''}">
                    Gói thi đã mua
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/payment-history"
                   class="nav-link ${activeMenu == 'payment-history' ? 'active' : ''}">
                    Lịch sử thanh toán
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/exam-history"
                   class="nav-link ${activeMenu == 'exam-history' ? 'active' : ''}">
                    Lịch sử làm bài
                </a>
            </li>
        </ul>
    </nav>

    <main id="content">
        <jsp:doBody/>
    </main>
</div>

<footer>
    <small>&copy; 2026 Luyện thi online. All rights reserved.</small>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('sidebarToggle').addEventListener('click', function () {
        document.getElementById('sidebar').classList.toggle('collapsed');
    });
</script>
</body>
</html>

