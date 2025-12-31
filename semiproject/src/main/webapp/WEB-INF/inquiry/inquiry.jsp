<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
  String ctxPath = request.getContextPath();
  String memberID = (String)session.getAttribute("memberID");
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
	    
    <style>
        body {
            background-color: #f8f9fa;
            padding: 20px;
        }
        .inquiry-item {
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .inquiry-item:hover {
            background-color: #f0f0f0;
        }
        .inquiry-item.active {
            background-color: #e7f3ff;
        }
        .status-badge {
            font-size: 0.85rem;
        }
        .inquiry-detail {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .message-box {
            background-color: #f8f9fa;
            border-left: 4px solid #007bff;
            padding: 15px;
            margin-bottom: 15px;
        }
        .admin-message {
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
        }
        .inquiry-list {
            max-height: 600px;
            overflow-y: auto;
        }
    </style>

<script>
  const ctxPath = "<%=ctxPath%>";
  const isLoggedIn = <%= (memberID != null) ? "true" : "false" %>;
  const currentUser = <%= (memberID != null) ? ("\"" + memberID + "\"") : "null" %>;
</script>

</head>

<body>
    <div class="container-fluid">
        <div class="row mb-4">
            <div class="col">
                <h2>1:1 문의</h2>
                궁금하신 사항을 문의해 주세요.
            </div>
            <div class="col text-right">
            	<button id="loginBtn" class="btn btn-secondary mr-2">로그인</button>
                <button id="logoutBtn" class="btn btn-secondary mr-2" style="display:none;">로그아웃</button>
                <button id="addInquiryBtn" class="btn btn-primary">문의 등록</button>
            </div>
        </div>

        <div class="row">
            <!-- 문의 목록 -->
            <div class="col-md-5">
                <div class="card">
                    <div class="card-header">
                        <h5>문의 목록</h5>
                    </div>
                    <div class="card-body inquiry-list" id="inquiryList">
                        <!-- 문의 목록이 여기에 동적으로 추가됩니다 -->
                    </div>
                </div>
            </div>

            <!-- 문의 상세 -->
            <div class="col-md-7">
                <div id="inquiryDetailPlaceholder" class="text-center text-muted" style="padding: 100px 0;">
                    <h4>문의 내역을 선택해주세요</h4>
                </div>
                <div id="inquiryDetail" style="display:none;">
                    <!-- 문의 상세 내용이 여기에 표시됩니다 -->
                </div>
            </div>
        </div>
    </div>

    <!-- 문의 등록 모달 -->
    <div class="modal fade" id="inquiryModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="modalTitle">문의 등록</h5>
                    <button type="button" class="close text-white" data-dismiss="modal">
                        <span>&times;</span>
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
                            <label for="inquiryTitle"><strong>제목</strong> <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="inquiryTitle" placeholder="문의 제목을 입력해주세요" required>
                        </div>
                        <div class="form-group">
                            <label for="inquiryContent"><strong>내용</strong> <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="inquiryContent" rows="8" placeholder="문의 내용을 상세히 입력해주세요" required></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" id="submitInquiry">등록하기</button>
                </div>
            </div>
        </div>
    </div>
    <!-- JS -->
	<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
	<script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>

	<%-- 사용자 JS --%>
	<script type="text/javascript" src="<%=ctxPath%>/js/inquiry/inquiry.js"></script>
  </body>
</html>