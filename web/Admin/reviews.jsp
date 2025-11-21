<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý đánh giá - Admin</title>

        <link rel="stylesheet" href="<c:url value='/css-admin/admin.css'/>">
        <link rel="stylesheet" href="<c:url value='/css-admin/admin-responsive.css'/>">
        <link rel="stylesheet" href="<c:url value='/css-admin/reviews.css'/>">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>
    <body>

        <div class="admin-wrapper">

            <jsp:include page="sidebar.jsp" />

            <main class="admin-main">

                <header class="admin-header">
                    <h1 class="header-title">
                        <i class="fas fa-star"></i> Quản lý đánh giá
                    </h1>
                </header>

                <div class="admin-content">

                    <!-- Alerts -->
                    <c:if test="${not empty sessionScope.success}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            ${sessionScope.success}
                        </div>
                        <c:remove var="success" scope="session"/>
                    </c:if>

                    <c:if test="${not empty sessionScope.error}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i>
                            ${sessionScope.error}
                        </div>
                        <c:remove var="error" scope="session"/>
                    </c:if>

                    <!-- Stats -->
                    <div class="stats-grid">
                        <div class="stat-card primary">
                            <div class="stat-header">
                                <div class="stat-title">Tổng đánh giá</div>
                                <div class="stat-icon primary">
                                    <i class="fas fa-comments"></i>
                                </div>
                            </div>
                            <div class="stat-value">${totalReviews}</div>
                        </div>

                        <div class="stat-card warning">
                            <div class="stat-header">
                                <div class="stat-title">Chờ duyệt</div>
                                <div class="stat-icon warning">
                                    <i class="fas fa-clock"></i>
                                </div>
                            </div>
                            <div class="stat-value">${pendingReviews}</div>
                        </div>

                        <div class="stat-card success">
                            <div class="stat-header">
                                <div class="stat-title">Đã duyệt</div>
                                <div class="stat-icon success">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                            </div>
                            <div class="stat-value">${approvedReviews}</div>
                        </div>

                        <div class="stat-card info">
                            <div class="stat-header">
                                <div class="stat-title">Đánh giá TB</div>
                                <div class="stat-icon info">
                                    <i class="fas fa-star"></i>
                                </div>
                            </div>
                            <div class="stat-value">
                                <fmt:formatNumber value="${avgRating}" pattern="#.#"/>
                                <i class="fas fa-star" style="font-size: 18px; color: #f39c12;"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Filters -->
                    <div class="card" style="margin-bottom: 20px;">
                        <div class="card-body">
                            <form method="get" action="<c:url value='/Admin/reviews'/>" style="display: flex; gap: 1rem; align-items: center; flex-wrap: wrap;">
                                <input type="text" 
                                       name="search" 
                                       class="form-control" 
                                       placeholder="Tìm theo khách hàng, sản phẩm..."
                                       value="${searchQuery}"
                                       style="flex: 1; min-width: 250px;">

                                <select class="form-control" name="status" style="max-width: 180px;">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="pending" ${statusFilter eq 'pending' ? 'selected' : ''}>Chờ duyệt</option>
                                    <option value="approved" ${statusFilter eq 'approved' ? 'selected' : ''}>Đã duyệt</option>
                                    <option value="rejected" ${statusFilter eq 'rejected' ? 'selected' : ''}>Đã từ chối</option>
                                </select>

                                <select class="form-control" name="rating" style="max-width: 150px;">
                                    <option value="">Tất cả sao</option>
                                    <option value="5" ${ratingFilter eq '5' ? 'selected' : ''}>⭐⭐⭐⭐⭐</option>
                                    <option value="4" ${ratingFilter eq '4' ? 'selected' : ''}>⭐⭐⭐⭐</option>
                                    <option value="3" ${ratingFilter eq '3' ? 'selected' : ''}>⭐⭐⭐</option>
                                    <option value="2" ${ratingFilter eq '2' ? 'selected' : ''}>⭐⭐</option>
                                    <option value="1" ${ratingFilter eq '1' ? 'selected' : ''}>⭐</option>
                                </select>

                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i> Lọc
                                </button>

                                <a href="<c:url value='/Admin/reviews'/>" class="btn btn-secondary">
                                    <i class="fas fa-redo"></i> Đặt lại
                                </a>
                            </form>
                        </div>
                    </div>

                    <!-- Reviews List -->
                    <div class="reviews-container">
                        <c:forEach var="review" items="${reviews}">
                            <div class="review-card">
                                <div class="review-header">
                                    <div class="review-product">
                                        <img src="<c:url value='${review.product.thumbnail}'/>" alt="${review.product.name}">
                                        <div>
                                            <h4>${review.product.name}</h4>
                                            <div class="review-rating">
                                                <c:forEach begin="1" end="${review.rating}">
                                                    <i class="fas fa-star" style="color: #f39c12;"></i>
                                                </c:forEach>
                                                <c:forEach begin="${review.rating + 1}" end="5">
                                                    <i class="far fa-star" style="color: #ddd;"></i>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="review-status">
                                        <c:choose>
                                            <c:when test="${review.status eq 'pending'}">
                                                <span class="badge badge-warning">
                                                    <i class="fas fa-clock"></i> Chờ duyệt
                                                </span>
                                            </c:when>
                                            <c:when test="${review.status eq 'approved'}">
                                                <span class="badge badge-success">
                                                    <i class="fas fa-check"></i> Đã duyệt
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-danger">
                                                    <i class="fas fa-times"></i> Đã từ chối
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="review-body">
                                    <div class="review-user">
                                        <div class="user-avatar">
                                            ${fn:substring(review.user.fullname, 0, 1)}
                                        </div>
                                        <div>
                                            <strong>${review.user.fullname}</strong>
                                            <small><fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy HH:mm"/></small>
                                        </div>
                                    </div>

                                    <div class="review-comment">
                                        ${review.comment}
                                    </div>

                                    <c:if test="${not empty review.adminReply}">
                                        <div class="admin-reply">
                                            <i class="fas fa-reply"></i>
                                            <strong>Phản hồi từ Admin:</strong>
                                            <p>${review.adminReply}</p>
                                        </div>
                                    </c:if>
                                </div>

                                <div class="review-actions">
                                    <c:if test="${review.status eq 'pending'}">
                                        <button onclick="approveReview(${review.id})" class="btn btn-sm btn-success">
                                            <i class="fas fa-check"></i> Duyệt
                                        </button>
                                        <button onclick="rejectReview(${review.id})" class="btn btn-sm btn-danger">
                                            <i class="fas fa-times"></i> Từ chối
                                        </button>
                                    </c:if>

                                    <c:if test="${empty review.adminReply}">
                                        <button onclick="showReplyModal(${review.id})" class="btn btn-sm btn-primary">
                                            <i class="fas fa-reply"></i> Phản hồi
                                        </button>
                                    </c:if>

                                    <button onclick="deleteReview(${review.id}, '${review.user.fullname}')" class="btn btn-sm btn-danger">
                                        <i class="fas fa-trash"></i> Xóa
                                    </button>
                                </div>
                            </div>
                        </c:forEach>

                        <c:if test="${empty reviews}">
                            <div class="no-data">
                                <i class="fas fa-comment-slash"></i>
                                <h3>Không có đánh giá nào</h3>
                                <p>Chưa có đánh giá nào từ khách hàng</p>
                            </div>
                        </c:if>
                    </div>

                </div>

            </main>

        </div>

        <!-- Reply Modal -->
        <div id="replyModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title">
                        <i class="fas fa-reply"></i> Phản hồi đánh giá
                    </h3>
                </div>
                <form method="post" action="<c:url value='/Admin/reviews'/>">
                    <input type="hidden" name="action" value="reply">
                    <input type="hidden" name="reviewId" id="replyReviewId">

                    <div class="modal-body">
                        <div class="form-group">
                            <label class="form-label">Nội dung phản hồi <span style="color: #e74c3c;">*</span></label>
                            <textarea name="reply" class="form-control" rows="5" required placeholder="Nhập nội dung phản hồi..."></textarea>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" onclick="closeReplyModal()" class="btn btn-secondary">
                            Hủy
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane"></i> Gửi phản hồi
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function approveReview(id) {
                if (confirm('✅ Bạn có chắc muốn duyệt đánh giá này?')) {
                    window.location.href = '<c:url value="/Admin/reviews"/>?action=approve&id=' + id;
                }
            }

            function rejectReview(id) {
                if (confirm('❌ Bạn có chắc muốn từ chối đánh giá này?')) {
                    window.location.href = '<c:url value="/Admin/reviews"/>?action=reject&id=' + id;
                }
            }

            function deleteReview(id, userName) {
                if (confirm('⚠️ Bạn có chắc muốn xóa đánh giá của "' + userName + '"?\n\nHành động này KHÔNG THỂ hoàn tác!')) {
                    window.location.href = '<c:url value="/Admin/reviews"/>?action=delete&id=' + id;
                }
            }

            function showReplyModal(reviewId) {
                document.getElementById('replyReviewId').value = reviewId;
                document.getElementById('replyModal').classList.add('show');
            }

            function closeReplyModal() {
                document.getElementById('replyModal').classList.remove('show');
            }

            document.getElementById('replyModal').addEventListener('click', function (e) {
                if (e.target === this) {
                    closeReplyModal();
                }
            });

            // Auto hide alerts
            setTimeout(() => {
                document.querySelectorAll('.alert').forEach(alert => {
                    alert.style.transition = 'opacity 0.5s';
                    alert.style.opacity = '0';
                    setTimeout(() => alert.remove(), 500);
                });
            }, 5000);
        </script>

    </body>
</html>