<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- header.jsp (수정 금지) -->
<jsp:include page="/WEB-INF/header.jsp" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member_YD/myPage.css" />

<div class="container my-5">
  <div class="card shadow-sm">
    <div class="card-body">
      <h4 class="font-weight-bold mb-3">휴면 계정 안내</h4>

      <p class="text-muted mb-4">
        3개월 이상 접속 기록이 없어 계정이 휴면 처리되었습니다.<br/>
        휴면 해제를 진행하면 바로 이용이 가능합니다.
      </p>

      <div class="mb-3">
        <small class="text-muted d-block">대상 아이디</small>
        <div class="font-weight-bold">
          <c:out value="${dormantMemberId}" />
        </div>
      </div>

      <form method="post" action="${pageContext.request.contextPath}/member/dormantUnlockEnd.hp">
        <button type="submit" class="btn btn-primary">
          휴면 해제하기
        </button>

        <a class="btn btn-outline-secondary"
           href="${pageContext.request.contextPath}/index.hp">
          취소
        </a>
      </form>

    </div>
  </div>
</div>

<!-- footer.jsp (수정 금지) -->
<jsp:include page="/WEB-INF/footer.jsp" />
