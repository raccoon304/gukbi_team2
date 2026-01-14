<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- header.jsp (수정 금지) -->
<jsp:include page="/WEB-INF/header.jsp" />

<!-- myPage 전용 CSS (선택) -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member_YD/myPage.css" />

<div class="container my-5">
  <div class="row">

    <!-- 사이드바 -->
    <div class="col-md-3 mb-4">
      <div class="card shadow-sm position-sticky" style="top: 100px;">
        <div class="card-body text-center">
          <h5 class="font-weight-bold mb-1">
            <c:out value="${memberInfo.name}" />
          </h5>
          <small class="text-muted">
            <c:out value="${memberInfo.memberid}" />
          </small>
        </div>

        <div class="list-group list-group-flush">
          <a href="${pageContext.request.contextPath}/myPage/myPage.hp"
             class="list-group-item list-group-item-action active">
            <i class="fa-regular fa-user mr-2"></i> 내 정보
          </a>

          <a href="${pageContext.request.contextPath}/myPage/orders.hp"
             class="list-group-item list-group-item-action">
            <i class="fa-solid fa-bag-shopping mr-2"></i> 주문내역
          </a>

          <a href="${pageContext.request.contextPath}/myPage/delivery.hp"
             class="list-group-item list-group-item-action">
            <i class="fa-solid fa-truck mr-2"></i> 배송지 관리
          </a>

        </div>
      </div>
    </div>

    <!-- 메인 컨텐츠 -->
    <div class="col-md-9">
      <div class="card shadow-sm">
        <div class="card-body">
          <h4 class="font-weight-bold mb-4">내 정보</h4>

          <div class="row">
            <!-- 개인정보 표시 -->
            <div class="col-md-6 mb-4">
              <h6 class="font-weight-bold mb-3">개인정보</h6>

              <div class="mb-3">
                <small class="text-muted d-block">성 명</small>
                <div class="font-weight-bold">
                  <c:out value="${memberInfo.name}" />
                </div>
              </div>

              <div class="mb-3">
                <small class="text-muted d-block">이메일</small>
                <div class="font-weight-bold">
                  <c:out value="${memberInfo.email}" />
                </div>
              </div>

              <div class="mb-3">
                <small class="text-muted d-block">전화번호</small>
                <div class="font-weight-bold">
                  <c:out value="${memberInfo.mobile}" />
                </div>
              </div>

			<form id="memberEditForm"
				method="get"
				action="${pageContext.request.contextPath}/myPage/memberEdit.hp"
				style="display:none;">
			</form>

			<button type="button"
			        class="btn btn-outline-primary"
			        onclick="document.getElementById('memberEditForm').submit();">
			  	<i class="fa-regular fa-pen-to-square mr-1"></i> 정보 수정하기
			</button>
            </div>

            <!-- 계정정보 표시 -->
            <div class="col-md-6 mb-4">
              <h6 class="font-weight-bold mb-3">계정 정보</h6>

              <div class="mb-3">
                <small class="text-muted d-block">아이디</small>
                <div class="font-weight-bold">
                  <c:out value="${memberInfo.memberid}" />
                </div>
              </div>

              <div class="mb-3">
                <small class="text-muted d-block">회원가입일자</small>
                <div class="font-weight-bold">
                  <c:out value="${memberInfo.registerday}" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
   
	  <!-- 사용자 쿠폰정보 -->
	  <div class="card shadow-sm mt-4">
	    <div class="card-body">
	      <h4 class="font-weight-bold mb-4">내 쿠폰</h4>
	
	      <c:choose>
	        <c:when test="${empty couponList}">
	          <div class="text-muted">보유한 쿠폰이 없습니다.</div>
	        </c:when>
	
  	      <c:otherwise>
	          <div class="table-responsive">
	            <table class="table table-bordered mb-0">
	              <thead class="thead-light">
	                <tr>
	                  <th style="width: 50%;">쿠폰명</th>
	                  <th style="width: 25%;">할인가격</th>
	                  <th style="width: 25%;">사용가능여부</th>
	                </tr>
	              </thead>
	
	              <tbody>
	                <c:forEach var="row" items="${couponList}">
	                  <tr>
	                    <td>
	                      <c:out value="${row['coupon'].couponName}" />
	                    </td>
			            <%-- 아래는 정액/정률에 따라 표시 방법이 달라짐. --%>
						<td>
						  <c:choose>
						    <c:when test="${row['coupon'].discountType == 0}">
						      <fmt:formatNumber value="${row['coupon'].discountValue}" type="number" />원
						    </c:when>
						    <c:otherwise>
						      <c:out value="${row['coupon'].discountValue}" />%
						    </c:otherwise>
						  </c:choose>
						</td>
						
	                    <td>
	                      <c:choose>
	                        <c:when test="${row['coupon'].usable == 1}">
	                          <c:choose>
	                            <c:when test="${row['issue'].usedYn == 1}">
	                              <span class="badge badge-secondary">사용 완료</span>
	                            </c:when>
	                            <c:otherwise>
	                              <span class="badge badge-success">사용 가능</span>
	                            </c:otherwise>
	                          </c:choose>
	                        </c:when>
	
	                        <c:otherwise>
	                          <span class="badge badge-secondary">사용 불가</span>
	                        </c:otherwise>
	                      </c:choose>
	                    </td>
	                  </tr>
	                </c:forEach>
	              </tbody>
	            </table>
	          </div>
	        </c:otherwise>
	      </c:choose>
	    </div>
	  </div>


      
      
      
      
      
      
      
    </div>
    
    
    
    
    
    
    
    
    
    
    
    

  </div>
</div>

<!-- footer.jsp (수정 금지) -->
<jsp:include page="/WEB-INF/footer.jsp" />
