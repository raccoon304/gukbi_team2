<<<<<<< HEAD
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- header.jsp (수정 금지) -->
<jsp:include page="/WEB-INF/header.jsp" />

<!-- myPage 전용 CSS (선택) -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member_YD/myPage.css" />

<div class="container my-5">
  <div class="row">

    <!-- Sidebar -->
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
          <a href="${pageContext.request.contextPath}/myPage/home.hp"
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

          <!-- wishlist / account settings 삭제 요청 반영 -->
        </div>
      </div>
    </div>

    <!-- Main Content -->
    <div class="col-md-9">
      <div class="card shadow-sm">
        <div class="card-body">
          <h4 class="font-weight-bold mb-4">내 정보</h4>

          <div class="row">
            <!-- Personal Information -->
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

            <!-- Account -->
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

              <!-- 멤버쉽 삭제 요청 반영 -->
            </div>
          </div>
        </div>
      </div>

      <!-- Recent Orders 삭제 요청 반영 -->
    </div>

  </div>
</div>

<!-- footer.jsp (수정 금지) -->
<jsp:include page="/WEB-INF/footer.jsp" />
=======

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- header.jsp (수정 금지) -->
<jsp:include page="/WEB-INF/header.jsp" />

<!-- myPage 전용 CSS (선택) -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member_YD/myPage.css" />

<div class="container my-5">
  <div class="row">

    <!-- Sidebar -->
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
          <a href="${pageContext.request.contextPath}/myPage/home.hp"
             class="list-group-item list-group-item-action active">
            <i class="fa-regular fa-user mr-2"></i> My Profile
          </a>

          <a href="${pageContext.request.contextPath}/myPage/orders.hp"
             class="list-group-item list-group-item-action">
            <i class="fa-solid fa-bag-shopping mr-2"></i> Order History
          </a>

          <a href="${pageContext.request.contextPath}/myPage/delivery.hp"
             class="list-group-item list-group-item-action">
            <i class="fa-solid fa-truck mr-2"></i> Delivery Addresses
          </a>

          <!-- wishlist / account settings 삭제 요청 반영 -->
        </div>
      </div>
    </div>

    <!-- Main Content -->
    <div class="col-md-9">
      <div class="card shadow-sm">
        <div class="card-body">
          <h4 class="font-weight-bold mb-4">My Profile</h4>

          <div class="row">
            <!-- Personal Information -->
            <div class="col-md-6 mb-4">
              <h6 class="font-weight-bold mb-3">Personal Information</h6>

              <div class="mb-3">
                <small class="text-muted d-block">Full Name</small>
                <div class="font-weight-bold">
                  <c:out value="${memberInfo.name}" />
                </div>
              </div>

              <div class="mb-3">
                <small class="text-muted d-block">Email</small>
                <div class="font-weight-bold">
                  <c:out value="${memberInfo.email}" />
                </div>
              </div>

              <div class="mb-3">
                <small class="text-muted d-block">Phone</small>
                <div class="font-weight-bold">
                  <c:out value="${memberInfo.mobile}" />
                </div>
              </div>

              <button type="button"
                      class="btn btn-outline-primary"
                      onclick="location.href='${pageContext.request.contextPath}/myPage/edit.hp';">
                <i class="fa-regular fa-pen-to-square mr-1"></i> Edit Information
              </button>
            </div>

            <!-- Account -->
            <div class="col-md-6 mb-4">
              <h6 class="font-weight-bold mb-3">Account</h6>

              <div class="mb-3">
                <small class="text-muted d-block">User ID</small>
                <div class="font-weight-bold">
                  <c:out value="${memberInfo.memberid}" />
                </div>
              </div>

              <div class="mb-3">
                <small class="text-muted d-block">Join Date</small>
                <div class="font-weight-bold">
                  <c:out value="${memberInfo.registerday}" />
                </div>
              </div>

              <!-- 멤버쉽 삭제 요청 반영 -->
            </div>
          </div>
        </div>
      </div>

      <!-- Recent Orders 삭제 요청 반영 -->
    </div>

  </div>
</div>

<!-- footer.jsp (수정 금지) -->
<jsp:include page="/WEB-INF/footer.jsp" />
=======
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- header.jsp (수정 금지) -->
<jsp:include page="/WEB-INF/header.jsp" />

<!-- myPage 전용 CSS (선택) -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member_YD/myPage.css" />

<div class="container my-5">
  <div class="row">

    <!-- Sidebar -->
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
          <a href="${pageContext.request.contextPath}/myPage/home.hp"
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

          <!-- wishlist / account settings 삭제 요청 반영 -->
        </div>
      </div>
    </div>

    <!-- Main Content -->
    <div class="col-md-9">
      <div class="card shadow-sm">
        <div class="card-body">
          <h4 class="font-weight-bold mb-4">내 정보</h4>

          <div class="row">
            <!-- Personal Information -->
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

              <button type="button"
                      class="btn btn-outline-primary"
                      onclick="location.href='${pageContext.request.contextPath}/myPage/edit.hp';">
                <i class="fa-regular fa-pen-to-square mr-1"></i> 정보 수정하기
              </button>
            </div>

            <!-- Account -->
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

              <!-- 멤버쉽 삭제 요청 반영 -->
            </div>
          </div>
        </div>
      </div>

      <!-- Recent Orders 삭제 요청 반영 -->
    </div>

  </div>
</div>

<!-- footer.jsp (수정 금지) -->
<jsp:include page="/WEB-INF/footer.jsp" />

>>>>>>> refs/heads/main
