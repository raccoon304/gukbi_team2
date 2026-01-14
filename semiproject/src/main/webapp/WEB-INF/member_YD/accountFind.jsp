<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<script>const ctxPath = "<%= ctxPath %>";</script>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>계정정보 찾기</title>

    <link rel="stylesheet" href="<%= ctxPath %>/css/member_YD/member.css">

    <!-- Tailwind / Feather / jQuery -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <!-- Bootstrap -->
    <link rel="stylesheet" href="<%= ctxPath %>/bootstrap-4.6.2-dist/css/bootstrap.min.css" type="text/css">

    <script>
    	tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: { 50:'#f0f9ff',100:'#e0f2fe',500:'#3b82f6',600:'#2563eb',700:'#1d4ed8' },
                        secondary:{ 50:'#f5f3ff',100:'#ede9fe',500:'#8b5cf6',600:'#7c3aed',700:'#6d28d9' }
                    }
                }
            }
        }
    </script>

    <style>
        .find-tabs { border-bottom:2px solid #2563eb; display:flex; gap:0; margin-bottom:18px; }
        .find-tab { appearance:none; border:1px solid #d1d5db; border-bottom:none; background:#fff; padding:12px 18px; font-weight:700; font-size:14px; cursor:pointer; color:#4b5563; }
        .find-tab.active { color:#111827; border-color:#2563eb; position:relative; }
        .find-tab.active::after { content:""; position:absolute; left:0; right:0; bottom:-2px; height:2px; background:#fff; }
        .radio-pill { border:1px solid #e5e7eb; border-radius:12px; padding:12px 14px; }

        .result-card { border:1px solid #e5e7eb; border-radius:14px; padding:14px 14px; background:#fff; }
        .result-card.success { border-color:#86efac; background:#f0fdf4; }
        .result-card.fail { border-color:#fecaca; background:#fef2f2; }
        .result-card.warn { border-color:#fde68a; background:#fffbeb; }
    </style>

    <!-- 상태값을 받아서 뷰에서 계속 유지할 수 있도록하기 위해 저장 -->
    <script>
        const ACTIVE_TAB   = "${requestScope.activeTab}";
        const PWD_POSTED   = "${requestScope.pwd_posted}";
        const PWD_FIND_TYPE= "${requestScope.pwdFindType}";
        const PWD_STATUS   = "${requestScope.pwd_status}";
        
     	// 비번찾기 인증 만료시각(ms)
          window.PWD_EXPIRE_AT_MS = Number("${sessionScope.pwdfind_cert_expire}");

    </script>

</head>

<body class="bg-gray-50 min-h-screen">
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex flex-col md:flex-row min-h-screen">

        <!-- 좌측단 -->
        <div class="w-full md:w-1/2 bg-gradient-to-br from-primary-100 to-secondary-100 flex items-center justify-center p-12">
            <div class="max-w-md text-center">
                <h1 class="text-4xl font-bold text-primary-700 mb-4">계정정보 찾기</h1>
                <p class="text-lg text-gray-700 mb-8">등록된 정보로 아이디/비밀번호를 찾을 수 있습니다.</p>
                <img src="http://static.photos/technology/640x360/75" alt="Find account" class="rounded-xl shadow-lg w-full">
            </div>
        </div>

        <!-- 우측단 -->
        <div class="w-full md:w-1/2 flex items-center justify-center p-8">
            <div class="w-full max-w-md">

                <div class="text-center mb-6">
                    <h2 class="text-3xl font-bold text-gray-800">계정정보 찾기</h2>
                    <p class="text-gray-600 mt-2">
                        홈으로 돌아가기
                        <a href="<%=ctxPath%>/index.hp" class="text-primary-600 hover:text-primary-700 font-medium">&nbsp; home</a>
                    </p>
                </div>

                <!-- 상단 탭 -->
                <div class="find-tabs">
                    <button type="button" class="find-tab active" id="tabIdFind">아이디(이메일)찾기</button>
                    <button type="button" class="find-tab" id="tabPwdFind">비밀번호 찾기</button>
                </div>

                <!-- ===== 아이디 찾기 폼 ===== -->
                <form id="idFindForm" class="space-y-6" method="post" action="<%=ctxPath%>/member/idFind.hp">
                	<div class="space-y-4">
                       	<div>
                            <label class="block text-sm font-medium text-gray-700">찾기 방법</label>
                            <div class="mt-2 radio-pill space-y-2">
                                <label class="flex items-center gap-2 cursor-pointer">
                                    <input type="radio" name="idFindType" value="email" checked>
                                    <span class="text-sm text-gray-700">등록된 이메일로 찾기</span>
                                </label>
                                <label class="flex items-center gap-2 cursor-pointer">
                                    <input type="radio" name="idFindType" value="phone">
                                    <span class="text-sm text-gray-700">등록된 휴대폰으로 찾기</span>
                                </label>
                            </div>
                        </div>

                        <div>
                            <label for="idfind_name" class="block text-sm font-medium text-gray-700">성 명</label>
                            <div class="mt-1 relative rounded-md shadow-sm">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i data-feather="user" class="text-gray-400"></i>
                                </div>
                                <input type="text" name="name" id="idfind_name" class="focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 sm:text-sm border-gray-300 rounded-md py-3"
                                       placeholder="성명 입력" required>
                            </div>
                        </div>

                        <div id="idFindByEmail">
                            <label for="idfind_email" class="block text-sm font-medium text-gray-700">이메일</label>
                            <div class="mt-1 relative rounded-md shadow-sm">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i data-feather="mail" class="text-gray-400"></i>
                                </div>
                                <input type="email" name="email" id="idfind_email" class="focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 sm:text-sm border-gray-300 rounded-md py-3"
                                       placeholder="sistsix@example.com">
                            </div>
                        </div>

                        <div id="idFindByPhone" class="hidden">
                            <label for="idfind_phone" class="block text-sm font-medium text-gray-700">휴대폰 번호</label>
                            <div class="mt-1 relative rounded-md shadow-sm">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i data-feather="phone" class="text-gray-400"></i>
                                </div>
                                <input type="tel" name="mobile" id="idfind_phone" inputmode="numeric" pattern="[0-9]*" maxlength="11"
                                       class="focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 sm:text-sm border-gray-300 rounded-md py-3" placeholder="01000000000">
                            </div>
                            <p class="text-xs text-gray-500 mt-1">‘-’ 없이 숫자만 입력</p>
                        </div>
                    </div>

                    <div>
                        <button type="submit" class="w-full flex justify-center py-3 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition duration-150">
                            아이디 찾기
                        </button>
                    </div>
                </form>

                <!-- ===== 비밀번호 찾기 폼 ===== -->
                <form id="pwdFindForm" class="space-y-6 hidden" method="post" action="<%=ctxPath%>/member/pwdFind.hp">
                    <div class="space-y-4">

                        <div>
                            <label class="block text-sm font-medium text-gray-700">찾기 방법</label>
                            <div class="mt-2 radio-pill space-y-2">
                                <label class="flex items-center gap-2 cursor-pointer">
                                    <input type="radio" name="pwdFindType" value="phone">
                                    <span class="text-sm text-gray-700">등록된 휴대폰으로 찾기 (개발 예정)</span>
                                </label>

                                <label class="flex items-center gap-2 cursor-pointer">
                                    <input type="radio" name="pwdFindType" value="email" checked>
                                    <span class="text-sm text-gray-700">등록된 이메일로 찾기</span>
                                </label>
                            </div>
                        </div>

                        <div>
                            <label for="pwdfind_id" class="block text-sm font-medium text-gray-700">아이디</label>
                            <div class="mt-1 relative rounded-md shadow-sm">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i data-feather="hash" class="text-gray-400"></i>
                                </div>
                                <input type="text" name="memberid" id="pwdfind_id"
                                       value="${requestScope.pwd_memberid}"
                                       class="focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 sm:text-sm border-gray-300 rounded-md py-3"
                                       placeholder="아이디 입력" required>
                            </div>
                        </div>

                        <div>
                            <label for="pwdfind_name" class="block text-sm font-medium text-gray-700">성 명</label>
                            <div class="mt-1 relative rounded-md shadow-sm">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i data-feather="user" class="text-gray-400"></i>
                                </div>
                                <input type="text" name="name" id="pwdfind_name" value="${requestScope.pwd_name}" class="focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 sm:text-sm border-gray-300 rounded-md py-3"
                                       placeholder="성명 입력" required>
                            </div>
                        </div>

                        <div id="pwdFindByEmail">
                            <label for="pwdfind_email" class="block text-sm font-medium text-gray-700">이메일</label>
                            <div class="mt-1 relative rounded-md shadow-sm">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i data-feather="mail" class="text-gray-400"></i>
                                </div>
                                <input type="email" name="email" id="pwdfind_email" value="${requestScope.pwd_email}"
                                       class="focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 sm:text-sm border-gray-300 rounded-md py-3"
                                       placeholder="sistsix@example.com">
                            </div>
                        </div>

                        <div id="pwdFindByPhone" class="hidden">
                            <label for="pwdfind_phone" class="block text-sm font-medium text-gray-700">휴대폰 번호</label>
                            <div class="mt-1 relative rounded-md shadow-sm">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i data-feather="phone" class="text-gray-400"></i>
                                </div>
                                <input type="tel" name="mobile" id="pwdfind_phone" inputmode="numeric" pattern="[0-9]*" maxlength="11"
                                       value="${requestScope.pwd_mobile}"  class="focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 sm:text-sm border-gray-300 rounded-md py-3"
                                       placeholder="01000000000">
                            </div>
                            <p class="text-xs text-gray-500 mt-1">‘-’ 없이 숫자만 입력</p>
                        </div>

                        <div class="bg-gray-50 border border-gray-200 rounded-xl p-4 text-sm text-gray-600">
                            인증코드를 이메일로 발송 후, 인증 성공 시 임시비밀번호가 이메일로 전송됩니다.
                        </div>

                    </div>

                    <c:if test="${requestScope.pwd_status ne 'MAIL_SENT'}">
						<div>
	    					<button type="submit" id="pwdFindBtn"
	            				class="w-full flex justify-center py-3 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition duration-150">
	      						비밀번호 찾기
	    					</button>
	  					</div>
					</c:if>	
                </form>

                <!-- 비밀번호 찾기 결과/인증코드 입력 영역 -->
                <div id="pwdFindResultArea" class="mt-4 hidden">

                    <!-- pwd_status에 따라 보이는 문구가 달라지게. -->
					<c:if test="${requestScope.pwd_posted eq true}">
	   					<c:choose>
	
	        			<%-- 휴대폰 준비중 --%>
	        				<c:when test="${requestScope.pwd_status eq 'NOT_READY'}">
	            				<div class="result-card warn">
	                				<div class="flex items-start gap-3">
	                   					 <div class="mt-1"><i data-feather="alert-circle" class="text-yellow-600"></i></div>
	                   					 <div class="text-sm text-gray-800"> 휴대폰 인증은 준비중입니다. 이메일로만 가능합니다.</div>
	               					</div>
	           					</div>
	       					</c:when>
	       					
	        				<%-- 입력값 누락/유효성 실패 --%>
	        				<c:when test="${requestScope.pwd_status eq 'INVALID'}">
	            				<div class="result-card fail">
	                				<div class="flex items-start gap-3">
	                    				<div class="mt-1"><i data-feather="alert-triangle" class="text-red-600"></i></div>
	                    				<div class="text-sm text-gray-800">아이디/성명/이메일을 모두 입력해주세요.</div>
	                				</div>
	            				</div>
	        				</c:when>
	
	        				<%-- 사용자 없음 --%>
	        				<c:when test="${requestScope.pwd_status eq 'NO_USER'}">
	            				<div class="result-card fail">
	                				<div class="flex items-start gap-3">
	                    				<div class="mt-1"><i data-feather="alert-triangle" class="text-red-600"></i></div>
	                   					<div class="text-sm text-gray-800">일치하는 회원정보가 없습니다.</div>
	                				</div>
	            				</div>
	        				</c:when>
	
	        				<%-- 메일 발송 성공 --%>
	        				<c:when test="${requestScope.pwd_status eq 'MAIL_SENT'}">
	           	 				<div class="result-card success">
	                				<div class="flex items-start gap-3">
	                    				<div class="mt-1"><i data-feather="check-circle" class="text-green-600"></i></div>
	                    				<div class="w-full">
	                        				<div class="text-sm font-semibold text-green-800 mb-1">인증코드 발송 완료</div>
	                        				<div class="text-sm text-gray-800">
	                            				인증코드가 <b>${requestScope.pwd_email}</b> 로 발송되었습니다.<br>
	                            				아래에 인증코드를 입력해주세요.
	                        				</div>
	                        				<div class="mt-2 text-sm text-gray-700">
											  인증번호 유효시간: <span id="pwdExpireTimer" class="font-weight-bold">--:--</span>
											</div>
											<div class="mt-3">
	                            				<input type="text" id="pwd_input_confirmCode"
	                                   				class="focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md py-2 px-3"
	                                   				placeholder="인증코드 입력" autocomplete="off">
	                        				</div>
	
	                        				<div class="mt-3">
	                            				<button type="button" id="btnPwdVerify"
	                                    			class="w-full flex justify-center py-2 px-4 rounded-md shadow-sm text-sm font-medium text-white bg-green-600 hover:bg-green-700 transition">
	                                				인증하기
	                            				</button>
	                        				</div>
	                    				</div>
	                				</div>
	            				</div>
								<form name="verifyCertificationFrm">
	                				<input type="hidden" name="userCertificationCode" />
	                				<input type="hidden" name="userid" />
	            				</form>
	        				</c:when>
							
							<%-- 메일 발송 실패 --%>
	        				<c:when test="${requestScope.pwd_status eq 'MAIL_FAIL'}">
	            				<div class="result-card fail">
	                				<div class="flex items-start gap-3">
	                    				<div class="mt-1"><i data-feather="alert-triangle" class="text-red-600"></i></div>
	                    				<div class="text-sm text-gray-800">
	                        				메일 발송에 실패했습니다. 잠시 후 다시 시도해주세요.
	                    				</div>
	                				</div>
	            				</div>
	        				</c:when>
	
	        				<%-- 그 외 --%>
	        				<c:otherwise>
	            				<div class="result-card fail">
	                				<div class="flex items-start gap-3">
	                    				<div class="mt-1"><i data-feather="alert-triangle" class="text-red-600"></i></div>
	                    				<div class="text-sm text-gray-800">
	                        				처리 중 오류가 발생했습니다. 다시 시도해주세요.
	                    				</div>
	                				</div>
	            				</div>
	        				</c:otherwise>
	    				</c:choose>
					</c:if>
				</div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript" src="<%=ctxPath%>/js/member_YD/accountFind.js?v=<%=System.currentTimeMillis()%>"></script>
</body>
</html>
