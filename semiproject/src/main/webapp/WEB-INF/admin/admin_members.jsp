<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%String ctxPath=request.getContextPath();%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0 shrink-to-fit=no">
    <title>회원 관리 - PhoneStore 관리자</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
    
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">
   <!-- <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">-->
    
    <!-- 직접 만든 CSS -->
    <link href="<%=ctxPath%>/css/admin/admin.css" rel="stylesheet" />
    
    <!-- Optional JavaScript -->
	<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
	<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script> 
    
    <%-- jQueryUI CSS 및 JS --%>
	<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
	<script type="text/javascript" src="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>
	
	<%-- 직접 만든 JS --%>
    <script src="<%=ctxPath%>/js/admin/members.js"></script>

<script type="text/javascript">
  $(function(){
	  
	  if("${requestScope.searchType}" != "" &&
		 "${requestScope.searchWord}" != "" ) {
		  $('select[name="searchType"]').val("${requestScope.searchType}");
		  $('input:text[name="searchWord"]').val("${requestScope.searchWord}");
	  }
	  
	  
	  $('select[name="sizePerPage"]').val("${requestScope.sizePerPage}");
	  
	  
	  $('input:text[name="searchWord"]').bind("keydown", function(e){
		  if(e.keyCode == 13) {
			  goSearch();
		  }
	  });
	  
	  
	  // **** select 태그에 대한 이벤트는 click 이 아니라 change 이다. **** // 
	  $('select[name="sizePerPage"]').bind("change", function(){
		  const frm = document.member_search_frm;
	   // frm.action = "memberList.up";  // form 태그에 action 이 명기되지 않았으면 현재보이는 URL 경로로 submit 되어진다. 
	   // frm.method = "get";            // form 태그에 method 를 명기하지 않으면 "get" 방식이다.  
		  frm.submit(); 
	  });
	  
	  
	  $(document).on("click", "tr.memberRow", function () {
	      const memberId = $(this).data("memberid");

	      const ctxPath = "<%=ctxPath%>";
	      const searchType = "${requestScope.searchType}";
	      const searchWord = "${requestScope.searchWord}";
	      const sizePerPage = "${requestScope.sizePerPage}";
	      const currentShowPageNo = "${requestScope.currentShowPageNo}";

	      const url = ctxPath + "/admin/members.hp"
	        + "?searchType=" + encodeURIComponent(searchType)
	        + "&searchWord=" + encodeURIComponent(searchWord)
	        + "&sizePerPage=" + encodeURIComponent(sizePerPage)
	        + "&currentShowPageNo=" + encodeURIComponent(currentShowPageNo)
	        + "&detailMemberId=" + encodeURIComponent(memberId);

	      location.href = url;
	    });

	    // 서버가 detailMember를 내려줬으면 모달 자동 오픈
	    const hasDetail = "${not empty requestScope.detailMember}";
	    if (hasDetail === "true") {
	      $("#memberDetailModal").modal("show");
	    }
	
  });// end of $(function(){})------------------------------------
  
  
  // Function Declaration
  function goBackToList() {
	  
	    const ctxPath = "<%=ctxPath%>";
	    const searchType = "${requestScope.searchType}";
	    const searchWord = "${requestScope.searchWord}";
	    const sizePerPage = "${requestScope.sizePerPage}";
	    const currentShowPageNo = "${requestScope.currentShowPageNo}";
	
	    const url = ctxPath + "/admin/members.hp"
	      + "?searchType=" + encodeURIComponent(searchType)
	      + "&searchWord=" + encodeURIComponent(searchWord)
	      + "&sizePerPage=" + encodeURIComponent(sizePerPage)
	      + "&currentShowPageNo=" + encodeURIComponent(currentShowPageNo);
	
	    location.href = url;
  }
  
  
  
  function goSearch() {
	  
	  const searchType = $('select[name="searchType"]').val();
	  const searchWord = $('input:text[name="searchWord"]').val().trim();
	  
	/* 
	  if(searchType == "") {
		  alert("검색대상을 선택하세요!!");
		  return; // goSearch() 함수를 종료한다. 
	  }
	*/
	
	  if(searchType != "" && searchWord == "") {
		  alert("검색어를 입력하세요");
		  return; // goSearch() 함수를 종료한다. 
	  }
	  
	  const frm = document.member_search_frm;
   // frm.action = "memberList.up";  // form 태그에 action 이 명기되지 않았으면 현재보이는 URL 경로로 submit 되어진다. 
   // frm.method = "get";            // form 태그에 method 를 명기하지 않으면 "get" 방식이다.  
	  frm.submit();   
   
  }// end of function goSearch()--------------------
  
</script>
    
</head>
<body>
    <div class="wrapper">
        <jsp:include page="/WEB-INF/admin/admin_sidebar.jsp" />
        
        <div class="main-content">
            <jsp:include page="/WEB-INF/admin/admin_header.jsp" />
            
            <div class="content-wrapper">
                <div class="container-fluid p-4">
                    <div class="mb-4">
                        <h2 class="mb-2">가입회원 조회</h2>
                        <p class="text-muted">회원 정보를 조회할 수 있습니다</p>
                    </div>
                    
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">회원 목록</h5>
                        </div>
                        <div class="card-body">
                        		
                        		<form name="member_search_frm">
							    <div class="row mb-3">
							
							      <div class="col-md-3">
							        <select class="custom-select" id="searchType" name="searchType">
							          <option value="">검색대상</option>
							          <option value="member_id">아이디</option>
							          <option value="name">이름</option>
							          <option value="email">이메일</option>
							        </select>
							      </div>
							
							      <div class="col-md-6">
							        <div class="input-group">
							          <input type="text" class="form-control" id="searchWord" name="searchWord" placeholder="검색">
							          <input type="text" style="display:none;" />
							          <div class="input-group-append">
							            <button type="button" class="btn btn-outline-secondary" id="searchBtn" onclick="goSearch()">
							              <i class="fas fa-search"></i> 검색
							            </button>
							          </div>
							        </div>
							      </div>
							
							      <div class="col-md-3">
							        <select class="custom-select" id="sizePerPage" name="sizePerPage">
							          <option value="10">10명씩 보기</option>
							          <option value="5">5명씩 보기</option>
							          <option value="3">3명씩 보기</option>
							        </select>
							      </div>
							
							    </div> 
							  </form>
                                
                            <div class="table-responsive">
                                <table class="table table-hover" id="memberTbl">
                                    <thead>
                                        <tr>
                                        	<th>번호</th>
                                            <th>아이디</th>
                                            <th>이름</th>
                                            <th>이메일</th>
                                            <th>성별</th>
                                            <th>가입일</th>
                                            <%-- <th>주문건수</th> --%>
                                            <%-- <th>총 결제액</th> --%>
                                        </tr>
                                    </thead>
                                    <tbody id="memberTableBody">
                                    	  <c:if test="${not empty requestScope.memberList}">
								         <c:forEach var="mbrDto" items="${requestScope.memberList}" varStatus="status">
								             <tr class="memberRow" data-memberid="${mbrDto.memberid}">
								             
								                <fmt:parseNumber var="currentShowPageNo" value="${requestScope.currentShowPageNo}" />   
								                <fmt:parseNumber var="sizePerPage" value="${requestScope.sizePerPage}" />
								                <%-- fmt:parseNumber 은 문자열을 숫자형식으로 형변환 시키는 것이다. --%> 
								                
								                <td>${(requestScope.totalMemberCount) - (currentShowPageNo - 1) * sizePerPage - (status.index)}</td> 
								                <%-- >>> 페이징 처리시 보여주는 순번 공식 <<<
													   데이터개수 - (페이지번호 - 1) * 1페이지당보여줄개수 - 인덱스번호 => 순번 
													
													   <예제>
													   데이터개수 : 12
													   1페이지당보여줄개수 : 5
													
													   ==> 1 페이지       
													   12 - (1-1) * 5 - 0  => 12
													   12 - (1-1) * 5 - 1  => 11
													   12 - (1-1) * 5 - 2  => 10
													   12 - (1-1) * 5 - 3  =>  9
													   12 - (1-1) * 5 - 4  =>  8
													
													   ==> 2 페이지
													   12 - (2-1) * 5 - 0  =>  7
													   12 - (2-1) * 5 - 1  =>  6
													   12 - (2-1) * 5 - 2  =>  5
													   12 - (2-1) * 5 - 3  =>  4
													   12 - (2-1) * 5 - 4  =>  3
													
													   ==> 3 페이지
													   12 - (3-1) * 5 - 0  =>  2
													   12 - (3-1) * 5 - 1  =>  1 
												  --%>
								                <td>${mbrDto.memberid}</td>
								                <td>${mbrDto.name}</td>
								                <td>${mbrDto.email}</td>
								                <td>
								                   <c:choose>
								                      <c:when test="${mbrDto.gender == 0}">남</c:when>
								                      <c:otherwise>여</c:otherwise>
								                   </c:choose>
								                </td>
								                <td>${mbrDto.registerday}</td>
								                <%-- <td class="text-right">--%> 
												  <%-- ${requestScope.orderStatMap[mbrDto.memberid]["order_cnt"]} --%>
												<%--</td>--%>
												
												<%--<td class="text-right">--%>
												  <%-- <fmt:formatNumber value='${requestScope.orderStatMap[mbrDto.memberid]["real_pay_sum"]}' pattern="#,###" />원 --%>
												<%--</td>--%>
								             </tr>
								         </c:forEach> 
								      </c:if>
								      
								      <c:if test="${empty requestScope.memberList}">
								         <tr>
								             <td colspan="8">데이터가 존재하지 않습니다</td>
								         </tr>
								      </c:if>
                                    </tbody>
                                </table>
                            </div>
                            
                            <div id="pageBar">
							   <nav>
							  	  <ul class="pagination justify-content-center">${requestScope.pageBar}</ul>
							   </nav>
						    </div>
						</div>
                     </div>
                  </div>
              </div>
              
              <div class="modal fade" id="memberDetailModal" tabindex="-1" role="dialog" aria-hidden="true">
				  <div class="modal-dialog modal-lg" role="document">
				    <div class="modal-content">
				
				      <div class="modal-header">
				        <h5 class="modal-title">회원 상세 정보</h5>
				        <button type="button" class="close" aria-label="Close" onclick="goBackToList()">
				          <span aria-hidden="true">&times;</span>
				        </button>
				      </div>
				
				      <div class="modal-body">
				        <c:if test="${not empty requestScope.detailMember}">
				          <div class="row">
				            <div class="col-md-6 mb-2"><b>아이디:</b> ${detailMember.member_id}</div>
				            <div class="col-md-6 mb-2"><b>이름:</b> ${detailMember.name}</div>
				
				            <div class="col-md-6 mb-2"><b>이메일:</b> ${detailMember.email}</div>
				            <div class="col-md-6 mb-2"><b>성별:</b> ${detailMember.gender_text}</div>
				
				            <div class="col-md-6 mb-2"><b>전화번호:</b> 
					            <c:set var="hp" value="${detailMember.mobile_phone}" />
								${fn:substring(hp,0,3)}-${fn:substring(hp,3,7)}-${fn:substring(hp,7,11)}
				            </div>
				            <div class="col-md-6 mb-2"><b>가입일:</b> ${detailMember.created_at}</div>
				
				            <div class="col-md-6 mb-2"><b>휴면여부:</b> ${detailMember.idle_text}</div>
				            <%-- <div class="col-md-6 mb-2"><b>탈퇴여부:</b> ${detailMember.status_text}</div> --%>
				
				            <div class="col-md-12 mt-2">
				              <b>기본배송지:</b>
				              <c:choose>
				                <c:when test="${not empty detailMember.full_address}">
				                  ${detailMember.full_address}
				                </c:when>
				                <c:otherwise>
				                  등록된 배송지가 없습니다
				                </c:otherwise>
				              </c:choose>
				            </div>
				
				            <hr class="col-md-12">
				
				            <div class="col-md-6 mb-2"><b>주문건수:</b> ${requestScope.detailOrderCnt}</div>
				            <div class="col-md-6 mb-2">
				              <b>총 결제액:</b>
				              <fmt:formatNumber value="${requestScope.detailRealPaySum}" pattern="#,###" />원
				            </div>
				          </div>
				        </c:if>
				      </div>
				
				      <div class="modal-footer">
				        <button type="button" class="btn btn-secondary" onclick="goBackToList()">닫기</button>
				      </div>
				
				    </div>
				 </div>
			</div>
              
         </div>  
    </div>
    
   
</body>
</html>