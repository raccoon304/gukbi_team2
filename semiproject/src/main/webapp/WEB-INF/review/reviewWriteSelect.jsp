<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<jsp:include page="../header.jsp"/>

<div class="container" style="max-width:760px; margin-top:5%;">
  <h4 class="mb-3">리뷰 작성할 구매건 선택</h4>

  <div class="alert alert-light border">
    같은 상품을 여러 번 구매하셨습니다. 리뷰를 작성할 구매건(옵션)을 선택하세요.
  </div>

  <div class="list-group">
    <c:forEach var="w" items="${writableList}">
      <a class="list-group-item list-group-item-action"
         href="<%=ctxPath%>/review/reviewWrite.hp?orderDetailId=${w.orderDetailId}&optionId=${w.optionId}">
        주문상세 #${w.orderDetailId} / 옵션: ${w.optionName}
      </a>
    </c:forEach>
  </div>

  <div class="mt-3">
    <button type="button" class="btn btn-light" onclick="history.back()">뒤로</button>
  </div>
</div>

<jsp:include page="../footer.jsp"/>