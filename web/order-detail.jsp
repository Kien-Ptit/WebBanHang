<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<div class="container py-4">
  <a href="${ctx}/orders" class="btn btn-link">&larr; Quay lại đơn hàng</a>

  <h3 class="mb-2">Đơn #OD-${order.id}</h3>
  <div class="text-muted mb-3">
    <span>Ngày tạo: <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
    &nbsp;•&nbsp;
    <span>Người nhận: ${order.fullname} - ${order.phone}</span>
    <br/>
    <span>Địa chỉ: ${order.address}</span>
    <c:if test="${not empty order.note}">
      <br/><span>Ghi chú: ${order.note}</span>
    </c:if>
  </div>

  <div class="table-responsive">
    <table class="table">
      <thead>
        <tr>
          <th>Sản phẩm</th>
          <th class="text-end">Giá</th>
          <th class="text-end">SL</th>
          <th class="text-end">Thành tiền</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="it" items="${order.items}">
          <tr>
            <td>
              <div class="d-flex align-items-center gap-2">
                <c:if test="${not empty it.productImage}">
                  <img src="${it.productImage}" width="48" height="48" style="object-fit:cover;border-radius:8px"/>
                </c:if>
                <div>${it.productName}</div>
              </div>
            </td>
            <td class="text-end"><fmt:formatNumber value="${it.price}" type="currency"/></td>
            <td class="text-end">${it.quantity}</td>
            <td class="text-end"><fmt:formatNumber value="${it.price * it.quantity}" type="currency"/></td>
          </tr>
        </c:forEach>
      </tbody>
      <tfoot>
        <tr>
          <th colspan="3" class="text-end">Tổng tiền</th>
          <th class="text-end"><fmt:formatNumber value="${order.totalAmount}" type="currency"/></th>
        </tr>
      </tfoot>
    </table>
  </div>
</div>
