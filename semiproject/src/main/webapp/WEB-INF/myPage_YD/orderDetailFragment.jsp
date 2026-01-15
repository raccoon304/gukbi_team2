<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="msg" value="${errMsg}" />

<c:if test="${not empty msg}">
  <div class="text-center text-muted py-4">
    <c:out value="${msg}" />
  </div>
</c:if>

<c:if test="${empty msg}">

  <c:if test="${empty orderHeader}">
    <div class="text-center text-muted py-4">주문 정보를 찾을 수 없습니다.</div>
  </c:if>

  <c:if test="${not empty orderHeader}">
    <c:set var="status" value="${orderHeader['delivery_status']}" />

    <!-- Order Summary -->
    <div class="mb-4">
      <div class="yd-section-title">주문 정보</div>
      <div class="yd-box">
        <div class="yd-kv">
          <div class="k">주문 번호</div>
          <div class="v"><c:out value="${orderHeader['order_id']}" /></div>

          <div class="k">주문 일시</div>
          <div class="v"><c:out value="${orderHeader['order_date']}" /></div>

          <div class="k">총 금액</div>
          <div class="v">
            <fmt:formatNumber value="${orderHeader['total_amount']}" pattern="#,###" /> 원
          </div>

          <div class="k">할인가격</div>
          <div class="v">
            <fmt:formatNumber value="${orderHeader['discount_amount']}" pattern="#,###" /> 원
          </div>

          <div class="k">결제 금액</div>
          <div class="v">
            <fmt:formatNumber value="${orderHeader['final_amount']}" pattern="#,###" /> 원
          </div>

          <div class="k">주문상태</div>
          <div class="v">
            <c:choose>
              <c:when test="${status eq '0'}">배송준비중</c:when>
              <c:when test="${status eq '1'}">배송중</c:when>
              <c:when test="${status eq '2'}">배송 완료</c:when>
              <c:when test="${status eq '4'}">배송 취소</c:when>
              
              <c:otherwise><c:out value="${status}" /></c:otherwise>
            </c:choose>
          </div>

        </div>
      </div>
    </div>

    <!-- Items -->
	<div class="mb-4">
	  <div class="yd-section-title">상품 정보</div>
	  <div class="yd-box" id="mItemsWrap">
	
	    <!-- product 리스트가 있으면-->
	    <c:if test="${not empty product}">
	      <c:forEach var="p" items="${product}">
	        <div class="yd-item">
	          <div>
	            <div class="yd-item-name">
	              <!-- 상품 상세 페이지로 이동버튼  -->
	              <a class="yd-item-link"
	                 href="${pageContext.request.contextPath}/product/productOption.hp?productCode=${p['fkProductCode']}">
	                <c:out value="${p['product_name']}" />
	              </a>
	              
	              <!-- 리뷰 페이지로 이동 버튼 -->
				  <a class="btn btn-sm btn-outline-primary ml-2"
				     href="${pageContext.request.contextPath}/review/reviewList.hp?productCode=${p['fkProductCode']}">
				    리뷰보기
				  </a>
				  <!-- 리뷰 작성페이지로 이동 버튼 -->
				  <c:set var="isWritten" value="${p['is_review_written']}" />
					
				  <c:choose>
				  		<%-- 이미 작성한경우 --%>
					  <c:when test="${isWritten == 1}">
					    <a class="btn btn-sm btn-secondary ml-2 disabled"
					       href="javascript:void(0);"
					       aria-disabled="true"
					       tabindex="-1">
					      작성한 리뷰
					    </a>
					  </c:when>
					
					  <%-- 미작성 경우 --%>
					  <c:otherwise>
					    <a class="btn btn-sm btn-outline-primary ml-2"
					       href="${pageContext.request.contextPath}/review/reviewWrite.hp?productCode=${p['fkProductCode']}">
					      리뷰작성하기
					    </a>
					  </c:otherwise>
				  </c:choose>
				  
	            </div>
	
	            <div class="yd-item-opt">
	              브랜드: <c:out value="${p['brand_name']}" /><br/>
	
	              색상:
	              <c:choose>
	                <c:when test="${empty p['color']}">-</c:when>
	                <c:otherwise><c:out value="${p['color']}" /></c:otherwise>
	              </c:choose>
	
	              / 용량:
	              <c:choose>
	                <c:when test="${empty p['storage']}">-</c:when>
	                <c:otherwise><c:out value="${p['storage']}" /></c:otherwise>
	              </c:choose>
	              <br/>
	
	              수량: <c:out value="${p['quantity']}" />
	            </div>
	          </div>
	
	          <div class="yd-item-price">
	            <fmt:formatNumber value="${p['unit_price']}" pattern="#,###" /> 원
	          </div>
	        </div>
	      </c:forEach>
	    </c:if>
	
	    <!-- product가 없으면 items 보여주기 -->
	    <c:if test="${empty product}">
	      <c:if test="${empty items}">
	        <div class="text-muted">상품 정보가 없습니다.</div>
	      </c:if>
	
	      <c:forEach var="it" items="${items}">
	        <div class="yd-item">
	          <div>
	            <div class="yd-item-name"><c:out value="${it['product_name']}" /></div>
	            <div class="yd-item-opt">
	              브랜드: <c:out value="${it['brand_name']}" /><br/>
	              색상: - / 용량: -<br/>
	              수량: <c:out value="${it['quantity']}" />
	            </div>
	          </div>
	          <div class="yd-item-price">
	            <fmt:formatNumber value="${it['unit_price']}" pattern="#,###" /> 원
	          </div>
	        </div>
	      </c:forEach>
	    </c:if>
	
	  </div>
	</div>


    <!-- Shipping Information -->
    <div class="mb-2">
      <div class="yd-section-title">배송 정보</div>
      <div class="yd-box">
        <div class="yd-kv">
          <div class="k">수령인</div><div class="v"><c:out value="${orderHeader['recipient_name']}" /></div>
          <div class="k">휴대폰</div><div class="v"><c:out value="${orderHeader['recipient_phone']}" /></div>

          <div class="k">주소</div>
          <div class="v"><c:out value="${orderHeader['delivery_address']}" /></div>

          <div class="k">택배 번호</div>
          <div class="v">
            <c:choose>
              <c:when test="${status eq 'READY' or status eq 'PAID'}">준비중</c:when>
              <c:otherwise>-</c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
  
    </div>

  </c:if>
</c:if>
