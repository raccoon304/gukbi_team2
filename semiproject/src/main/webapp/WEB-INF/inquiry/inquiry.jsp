<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
  String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <title>문의 페이지</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- Bootstrap CSS -->
  <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

  <!-- Font Awesome 6 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">

  <!-- 사용자 CSS -->
  <link rel="stylesheet" href="<%=ctxPath%>/css/inquiry/inquiry.css">

  <!-- JS -->
  <script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
  <script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>


<script>
const ctxPath = "<%=ctxPath%>";

  $(function(){
	  
	  $(document).on("change", "#onlyUnanswered", function () {
		  $("#currentShowPageNo").val("1");
		  $("#filterFrm").submit();
		});
	  
	  $("#inquiryTypeFilter").on("change", function () {
	      $("#currentShowPageNo").val("1");
	      $("#filterFrm").submit();
	   });
	  
  });
  
  var isLoggedIn = ${not empty sessionScope.loginUser ? 'true' : 'false'};

  <c:choose>
    <c:when test="${not empty sessionScope.loginUser}">
      var currentUser = "${fn:escapeXml(sessionScope.loginUser.memberid)}";
    </c:when>
    <c:otherwise>
      var currentUser = null;
    </c:otherwise>
  </c:choose>
    
  </script>


  <!-- 사용자 JS -->
  <script type="text/javascript" src="<%=ctxPath%>/js/inquiry/inquiry.js"></script>


  

 
</head>

<body>

<%-- 
  <!-- 상단 네비(메인 톤과 통일) -->
  <nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container">
      <a class="navbar-brand" href="<%=ctxPath%>/index.hp">MyShop</a>
	
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#topNav"
              aria-controls="topNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>

      <!-- collapse 영역(구조 깨지면 레이아웃/여백 이상해짐) -->
      <div class="collapse navbar-collapse" id="topNav">
        <ul class="navbar-nav mr-auto">
          <!-- 필요시 메뉴 추가 -->
        </ul>

        <!-- 기존 버튼 id 유지 -->
        <button id="addInquiryBtn" class="btn btn-primary" type="button">
          <i class="fa-solid fa-pen-to-square mr-2"></i>문의 등록
        </button>
      </div>
    </div>
  </nav>
--%>
<nav class="navbar navbar-expand-lg navbar-custom">
  <div class="container">	  
  	<jsp:include page="../header.jsp"/>
  </div>
</nav>  
  <!-- 페이지 전체 래퍼: 위아래 간격 + 좌우 꽉 차 보이게 -->
  <div class="container inquiry-page-wrap">
  
    <!-- 페이지 헤더 -->
    <div class="page-header">
      <h2>1:1 문의</h2>
      <div class="subtext">궁금하신 사항을 문의해 주세요.</div>
      <button id="addInquiryBtn" class="btn btn-primary mt-4" type="button">
          <i class="fa-solid fa-pen-to-square mr-2"></i>문의 등록
      </button>
    </div>

    <div class="row inquiry-grid">
      <!-- 문의 목록 -->
      <div class="col-lg-6 mb-4">
		  <div class="card inquiry-card">
		
		    <div class="card-header d-flex align-items-center justify-content-between">
		      <div class="d-flex align-items-center">
		        <div style="font-weight:700;">문의 목록</div>
		        <small class="text-muted ml-3 d-none d-md-inline" style="font-weight:500;">클릭하면 상세가 열립니다</small>
		      </div>
		
		      <!-- form은 오른쪽으로 따로(헤더 안에서 분리) -->
		      <form id="filterFrm" action="<%=ctxPath%>/inquiry/inquiryList.hp" method="get" class="mb-0 d-flex align-items-center">
		        <input type="hidden" name="currentShowPageNo" id="currentShowPageNo"
                        value="${empty currentShowPageNo ? 1 : currentShowPageNo}">

		
		        <select name="inquiryType" id="inquiryTypeFilter" class="form-control form-control-sm" style="min-width:140px;">
	              <option value="" <c:if test="${empty inquiryType}">selected</c:if>>전체</option>
	              <option value="서비스 문의" <c:if test="${inquiryType eq '서비스 문의'}">selected</c:if>>서비스 문의</option>
	              <option value="기술 지원"   <c:if test="${inquiryType eq '기술 지원'}">selected</c:if>>기술 지원</option>
	              <option value="결제 문의"   <c:if test="${inquiryType eq '결제 문의'}">selected</c:if>>결제 문의</option>
	              <option value="계정 문의"   <c:if test="${inquiryType eq '계정 문의'}">selected</c:if>>계정 문의</option>
	              <option value="기타"       <c:if test="${inquiryType eq '기타'}">selected</c:if>>기타</option>
	            </select>
	            
	            <c:if test="${not empty sessionScope.loginUser and sessionScope.loginUser.memberid eq 'admin'}">
				  <div class="ml-2">
				    <input type="checkbox" class="d-none" id="onlyUnanswered" name="onlyUnanswered" value="Y"
				           <c:if test="${onlyUnanswered eq 'Y'}">checked</c:if>>
				
				    <label for="onlyUnanswered"
					       class="btn btn-sm mb-0 only-unanswered-btn ${onlyUnanswered eq 'Y' ? 'btn-primary' : 'btn-outline-primary'}">
					  미답변만
					</label>
				  </div>
				</c:if>

		      </form>
		    </div>

          <!-- 목록 -->
          <div class="card-body inquiry-list" id="inquiryList">
          
          	  
		
		      <c:if test="${empty inquiryList}">
		        <div class="p-3 text-muted">문의가 없습니다.</div>
		      </c:if>
		
		      <c:if test="${not empty inquiryList}">
		        <c:forEach var="inq" items="${inquiryList}">
		          <div class="inquiry-item p-3 border-bottom" data-id="${inq.inquiryNumber}" data-secret="${inq.isSecret}" >
		            <div class="d-flex justify-content-between align-items-center mb-2">
		              <span class="badge badge-primary">${inq.inquiryType}</span>
		
		              <c:choose>
		                <c:when test="${inq.replyStatus == 0}">
		                  <span class="badge status-badge badge-secondary">보류</span>
		                </c:when>
		                <c:when test="${inq.replyStatus == 1}">
		                  <span class="badge status-badge badge-info">접수</span>
		                </c:when>
		                <c:when test="${inq.replyStatus == 2}">
		                  <span class="badge status-badge badge-success">답변완료</span>
		                </c:when>
		                <c:otherwise>
		                  <span class="badge status-badge badge-secondary">-</span>
		                </c:otherwise>
		              </c:choose>
		            </div>
		
		            <h6 class="mb-1">
					  <c:if test="${inq.isSecret == 1}">
					    <i class="fa-solid fa-lock mr-1"></i>
					  </c:if>
					  <c:out value="${inq.title}" />
					</h6>
		
		            <small class="text-muted">
		              <c:out value="${inq.registerday}" />
		            </small>
		          </div>
		        </c:forEach>
		      </c:if>

          </div>
          
          <!-- 페이지바 -->
          <div class="card-footer bg-white py-2">
			  <div class="d-flex align-items-center">
			
			    <!-- 왼쪽: 총 건수 -->
			    <div class="flex-grow-1">
			      <small class="text-muted">총 ${totalCount}건</small>
			    </div>
			
			    <!-- 가운데: 페이지바 -->
			    <nav aria-label="inquiry pagination" class="flex-grow-0">
			      <ul class="pagination pagination-sm mb-0 justify-content-center inquiry-pagination">
			        ${pageBar}
			      </ul>
			    </nav>
			
			    <!-- 오른쪽: 비워서 가운데 정렬 유지 -->
			    <div class="flex-grow-1"></div>
			
			  </div>
			</div>
          
          
        </div>
      </div>

      <!-- 문의 상세 -->
      <div class="col-lg-6 mb-4">
        <div id="inquiryDetailPlaceholder" class="text-center text-muted inquiry-placeholder">
          <div>
            <i class="fa-regular fa-comment-dots fa-2x mb-3"></i>
            <h4 style="font-weight:700;">문의 내역을 선택해주세요</h4>
            <div class="mt-2">왼쪽 목록에서 문의를 클릭하면 상세가 표시됩니다.</div>
          </div>
        </div>

        <div id="inquiryDetail" style="display:none;">
          <!-- JS로 상세  -->
        </div>
      </div>
    </div>
  </div>

  <!-- 문의 등록 모달 (id 유지) -->
  <div class="modal fade" id="inquiryModal" tabindex="-1" role="dialog"
       aria-labelledby="modalTitle" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
      <div class="modal-content" style="border-radius:14px;">
        <div class="modal-header text-white"
             style="background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);
                    border-top-left-radius:14px; border-top-right-radius:14px;">
          <h5 class="modal-title" id="modalTitle">문의 등록</h5>
          <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>

        <div class="modal-body">
          <form id="inquiryForm">
            <div class="form-group">
              <label for="inquiryType"><strong>문의 유형</strong> <span class="text-danger">*</span></label>
              <select class="form-control" id="inquiryType" required>
                <option value="">선택해주세요</option>
                <option value="서비스 문의">서비스 문의</option>
                <option value="기술 지원">기술 지원</option>
                <option value="결제 문의">결제 문의</option>
                <option value="계정 문의">계정 문의</option>
                <option value="기타">기타</option>
              </select>
            </div>

			<div class="form-group">
			  <div class="d-flex align-items-center flex-wrap">	
				  <div class="custom-control custom-checkbox mr-3">
				    <input type="checkbox" class="custom-control-input" id="isSecret" value="1">
				    <label class="custom-control-label" for="isSecret">
				      <i class="fa-solid fa-lock mr-1"></i> 비밀글
				    </label>
				  </div>
				  <small class="text-muted mt-1">비밀글은 작성자와 관리자만 조회할 수 있습니다.</small>
			  </div>
			</div>

            <div class="form-group">
              <label for="inquiryTitle"><strong>제목</strong> <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="inquiryTitle"
                     placeholder="문의 제목을 입력해주세요" required>
            </div>

            <div class="form-group">
              <label for="inquiryContent"><strong>내용</strong> <span class="text-danger">*</span></label>
              <textarea class="form-control" id="inquiryContent" rows="8"
                        placeholder="문의 내용을 상세히 입력해주세요" required></textarea>
            </div>
          </form>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">취소</button>
          <button type="button" class="btn btn-primary" id="submitInquiry">등록하기</button>
        </div>
      </div>
    </div>
  </div>

  <template id="tplInquiryDetail">
	  <div class="inquiry-detail border rounded p-3">
	    <div class="d-flex justify-content-between align-items-start mb-3">
	      <div>
	        <h4 class="mb-2" data-field="title"></h4>
	        <span class="badge badge-primary mr-2" data-field="type"></span>
	        <span id="detailStatusBadge" class="badge" data-field="status"></span>
	      </div>
	
	      <div data-field="btnWrap">
	        <button type="button" class="btn btn-sm btn-outline-primary mr-1" data-action="edit">수정</button>
	        <button type="button" class="btn btn-sm btn-outline-danger" data-action="delete">삭제</button>
	      </div>
	    </div>
	
	    <div class="message-box">
	      <div class="d-flex justify-content-between mb-2">
	        <strong data-field="author"></strong>
	        <small class="text-muted" data-field="date"></small>
	      </div>
	      <p class="mb-0" data-field="content"></p>
	    </div>
	
	    <!-- 관리자 답변 보기 -->
	    <div id="adminReplyViewWrap" class="message-box admin-message mt-3">
	      <div class="d-flex justify-content-between mb-2">
	        <strong>관리자 답변</strong>
	        <small class="text-muted" data-field="replyDate"></small>
	      </div>
	
	      <p class="mb-0" data-field="replyContent"></p>
	
	      <div class="text-right mt-2" data-field="replyBtnWrap">
	        <button type="button" class="btn btn-sm btn-outline-primary" data-action="openReplyEditor"></button>
	      </div>
	    </div>
	
	    <!-- 관리자 답변 편집 -->
	    <div id="adminReplyEditorWrap" class="message-box admin-message mt-3" style="display:none;">
	      <div class="d-flex justify-content-between mb-2 align-items-center">
	        <strong data-field="replyEditorTitle"></strong>
	        <small class="text-muted" data-field="replyEditorDate"></small>
	      </div>
	
	      <textarea id="adminReplyContent" class="form-control" rows="5" placeholder="답변 내용을 입력하세요"></textarea>
	
	      <div class="mt-2 text-right">
	        <button type="button" class="btn btn-sm btn-outline-secondary mr-2" data-action="closeReplyEditor">취소</button>
	        <button type="button" class="btn btn-sm btn-primary" data-action="saveReply">저장</button>
	      </div>
	    </div>
	  </div>
	</template>

  <jsp:include page="../footer.jsp"/>


</body>
</html>
