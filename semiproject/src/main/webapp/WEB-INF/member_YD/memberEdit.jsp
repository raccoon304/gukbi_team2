<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- header.jsp (수정 금지) -->
<jsp:include page="/WEB-INF/header.jsp" />

<script>const ctxPath = "${pageContext.request.contextPath}";</script>
<script src="${pageContext.request.contextPath}/js/myPage_YD/memberEdit.js"></script>


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
             class="list-group-item list-group-item-action">
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

          <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="font-weight-bold mb-0">회원정보 변경</h4>

            <a href="${pageContext.request.contextPath}/myPage/myPage.hp"
               class="btn btn-outline-secondary">
              <i class="fa-solid fa-arrow-left mr-1"></i> 돌아가기
            </a>
          </div>

          <!-- 안내 메시지 -->
          <div class="alert alert-light border small mb-4">
            <i class="fa-solid fa-circle-info mr-1"></i>
            아이디/가입일자는 변경할 수 없습니다. 이름/이메일/전화번호/비밀번호만 수정 가능합니다.
          </div>

          <!-- 회원정보 수정 폼 -->
          <form method="post"
                action="${pageContext.request.contextPath}/myPage/memberEditEnd.hp"
                id="memberEditEndForm">

            <!-- 아이디(수정불가) -->
            <div class="form-group">
              <label class="font-weight-bold">아이디</label>
              <input type="text"
                     class="form-control"
                     value="<c:out value='${memberInfo.memberid}'/>"
                     readonly />
              <small class="text-muted">아이디는 변경할 수 없습니다.</small>
            </div>

            <!-- 가입일(수정불가) -->
            <div class="form-group">
              <label class="font-weight-bold">회원가입일자</label>
              <input type="text"
                     class="form-control"
                     value="<c:out value='${memberInfo.registerday}'/>"
                     readonly />
            </div>

            <hr class="my-4" />

            <div class="row">
              <!-- 이름 -->
              <div class="col-md-6">
                <div class="form-group">
                  <label class="font-weight-bold" for="name">성 명</label>
                  <input type="text"
                         class="form-control"
                         id="name"
                         name="name"
                         value="<c:out value='${memberInfo.name}'/>"
                         required />
                </div>
              </div>

              <!-- 전화번호 -->
              <div class="col-md-6">
                <div class="form-group">
                  <label class="font-weight-bold" for="mobile">전화번호</label>
                  <input type="text"
                         class="form-control"
                         id="mobile"
                         name="mobile"
                         value="<c:out value='${memberInfo.mobile}'/>"
                         placeholder="예) 01012345678"
                         required />
                </div>
              </div>
            </div>

            <!-- 이메일 -->
            <div class="form-group">
              <label class="font-weight-bold" for="email">이메일</label>
              <input type="email"
                     class="form-control"
                     id="email"
                     name="email"
                     value="<c:out value='${memberInfo.email}'/>"
                     required />
            </div>
            
            <hr class="my-4" />

            <div class="row">
              <!-- 비밀번호 -->
              <div class="col-md-6">
                <div class="form-group">
                  <label class="font-weight-bold" for="password">비밀 번호</label>
                  <input type="password"
                         class="form-control"
                         id="password"
                         name="password"
                         value=""
                         placeholder="특수문자,대,소문자를 포함한 8-15자이내"
                          />
                </div>
              </div>

              <!-- 비밀번호확인 -->
              <div class="col-md-6">
                <div class="form-group">
                  <label class="font-weight-bold" for="passwordChk">비밀번호확인</label>
                  <input type="password"
                         class="form-control"
                         id="passwordChk"
                         name="passwordChk"
                         value=""
                         placeholder="특수문자,대,소문자를 포함한 8-15자이내"
                          />
                </div>
              </div>
            </div>

            <div class="d-flex justify-content-end mt-4">
              <a href="${pageContext.request.contextPath}/myPage/myPage.hp"
                 class="btn btn-outline-secondary mr-2">
                취소
              </a>

              <button type="submit" class="btn btn-primary">
                <i class="fa-regular fa-floppy-disk mr-1"></i> 저장하기
              </button>
            </div>
          </form>

        </div>
      </div>
    </div>

  </div>
</div>

<!-- footer.jsp (수정 금지) -->
<jsp:include page="/WEB-INF/footer.jsp" />
