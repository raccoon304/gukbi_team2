<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SignUpSavvy - Membership Registration</title>
    
    <link rel="stylesheet" href="<%= ctxPath%>/css/member_YD/member.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
    
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
    <script type="text/javascript" src="<%= ctxPath%>/js/member_YD/memberRegister.js"></script>
    
    <script>
   	tailwind.config = {
    	theme: {
        	extend: {
            	colors: {
            		primary: {
	                50: '#f0f9ff',
	                100: '#e0f2fe',
	                500: '#3b82f6',
	                600: '#2563eb',
	                700: '#1d4ed8',
              		},
              		secondary: {
	                50: '#f5f3ff',
	                100: '#ede9fe',
	                500: '#8b5cf6',
	                600: '#7c3aed',
	                700: '#6d28d9',
              		}
            	}
          	}
        }
    }
	</script>
</head>

<body class="bg-gray-50 min-h-screen">
	<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    	<div class="flex flex-col md:flex-row min-h-screen">
        	<!-- 좌측단 -->
        	<div class="w-full md:w-1/2 bg-gradient-to-br from-primary-100 to-secondary-100 flex items-center justify-center p-12">
                <div class="max-w-md text-center">
                    <h1 class="text-4xl font-bold text-primary-700 mb-4">회원가입</h1>
                    <p class="text-lg text-gray-700 mb-8">회원가입 페이지입니다.</p>
                    <img src="http://static.photos/technology/640x360/75" alt="Happy members" class="rounded-xl shadow-lg w-full">
                </div>
            </div>

            <!-- 우측단 -->
            <div class="w-full md:w-1/2 flex items-center justify-center p-8">
				<div class="w-full max-w-md">
                    <div class="text-center mb-8">
                        <h2 class="text-3xl font-bold text-gray-800">회원가입</h2>
                        <p class="text-gray-600 mt-2">아이디가 있으신가요?<a href="#" class="text-primary-600 hover:text-primary-700 font-medium">&nbsp; 로그인</a></p>
                    </div>

                    <form class="space-y-6">
					<!-- Form Fields -->
                        <div class="space-y-4">
                            <div>
                                <label for="member-id" class="block text-sm font-medium text-gray-700">아이디</label>
                                <div class="mt-1 relative rounded-md shadow-sm">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <i data-feather="hash" class="text-gray-400"></i>
                                    </div>
                                    <input type="text" id="member-id" class="focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 sm:text-sm border-gray-300 rounded-md py-3" placeholder="Enter your ID">
                                </div>
                            </div>

                            <div>
                                <label for="full-name" class="block text-sm font-medium text-gray-700">성 명</label>
                                <div class="mt-1 relative rounded-md shadow-sm">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <i data-feather="user" class="text-gray-400"></i>
                                    </div>
                                    <input type="text" id="full-name" class="focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 sm:text-sm border-gray-300 rounded-md py-3" placeholder="Enter your Name">
                                </div>
                            </div>

                            <div>
                                <label for="mobile" class="block text-sm font-medium text-gray-700">전화 번호</label>
                                <div class="mt-1 relative rounded-md shadow-sm">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <i data-feather="phone" class="text-gray-400"></i>
                                    </div>
                                    <input type="tel" id="mobile" class="focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 sm:text-sm border-gray-300 rounded-md py-3" placeholder="010-0000-0000">
                                </div>
                            </div>

                            <div class="grid grid-cols-2 gap-4">
                                <div>
                                    <label for="zip-code" class="block text-sm font-medium text-gray-700">우편번호</label>
                                    
                                    <div class="mt-1 relative rounded-md shadow-sm">                          
                                        <input type="text" id="zip-code" class="focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md py-3" placeholder="12345">
                                    </div>
                                    
                                    <img src="<%= ctxPath%>/images/b_zipcode.gif" id="zipcodeSearch" />
                                </div>
                                <div>
                                    <label for="gender" class="block text-sm font-medium text-gray-700">성별</label>
                                    <select id="gender" class="mt-1 block w-full pl-3 pr-10 py-3 text-base border-gray-300 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm rounded-md">
                                        <option value="" disabled selected>성별 선택</option>
                                        <option value="male">남성</option>
                                        <option value="female">여성</option>
                                    </select>
                                </div>
                            </div>

                            <div>
                                <label for="address" class="block text-sm font-medium text-gray-700">주소</label>
                                <div class="mt-1 relative rounded-md shadow-sm">
                                    <input type="text" id="address" class="focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md py-3" placeholder="Street Address">
                                </div>
                            </div>

                            <div>
                                <label for="detailed-address" class="block text-sm font-medium text-gray-700">상세 주소</label>
                                <div class="mt-1 relative rounded-md shadow-sm">
                                    <textarea id="detailed-address" rows="2" class="focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md py-3" placeholder="아파트, 층, 호수, 등"></textarea>
                                </div>
                            </div>

                            <div>
                                <label for="dob" class="block text-sm font-medium text-gray-700">생년월일</label>
                                <div class="mt-1 relative rounded-md shadow-sm">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <i data-feather="calendar" class="text-gray-400"></i>
                                    </div>
                                    <input type="date" id="dob" class="focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 sm:text-sm border-gray-300 rounded-md py-3">
                                </div>
                            </div>

                            <div>
                                <label for="email" class="block text-sm font-medium text-gray-700">이메일</label>
                                <div class="mt-1 relative rounded-md shadow-sm">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <i data-feather="mail" class="text-gray-400"></i>
                                    </div>
                                    <input type="email" id="email" class="focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 sm:text-sm border-gray-300 rounded-md py-3" placeholder="you@example.com">
                                </div>
                            </div>

                            <div>
                                <label for="password" class="block text-sm font-medium text-gray-700">비밀번호</label>
                                <div class="mt-1 relative rounded-md shadow-sm">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <i data-feather="lock" class="text-gray-400"></i>
                                    </div>
                                    <input type="password" id="password" class="focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 sm:text-sm border-gray-300 rounded-md py-3" placeholder="••••••••">
                                </div>
                            </div>

                            <div>
                                <label for="confirm-password" class="block text-sm font-medium text-gray-700">비밀번호 확인</label>
                                <div class="mt-1 relative rounded-md shadow-sm">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <i data-feather="lock" class="text-gray-400"></i>
                                    </div>
                                    <input type="password" id="confirm-password" class="focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 sm:text-sm border-gray-300 rounded-md py-3" placeholder="••••••••">
                                </div>
                            </div>
                        </div>
						<div class="flex items-center">
                            <input id="terms" name="terms" type="checkbox" class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded" />
                            <label for="terms" class="ml-2 block text-sm text-gray-700">
								해당약관에 동의합니다.
							  	<a href="javascript:void(0)" id="openTerms" class="text-primary-600 hover:text-primary-700 font-medium">
							    	약관보기
							  	</a>
							</label>
                        </div>

                        <div>
                            <button type="submit" class="w-full flex justify-center py-3 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition duration-150">
                                계정 생성하기.
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
	<script>
	  feather.replace();
	</script>
	
	<!-- 모달 -->
	<div id="termsModal" class="fixed inset-0 z-50 hidden" aria-hidden="true">
	  	<!-- 뒷 창 -->
	  	<div id="termsBackdrop" class="absolute inset-0 bg-black/50"></div>
	
	  	<!-- modal panel -->
	  	<div class="relative min-h-screen flex items-center justify-center p-4">
	    	<div class="w-full max-w-3xl bg-white rounded-2xl shadow-xl overflow-hidden">
	      		<div class="flex items-center justify-between px-5 py-4 border-b">
	        		<h3 class="text-lg font-semibold text-gray-800">정책 및 약관</h3>
	        		<button type="button" id="closeTerms" class="text-gray-500 hover:text-gray-700 text-2xl leading-none">&times;</button>
	      		</div>
	      		<div class="p-4">
	        		<!-- 모달로 뜨는 HTML -->
	        		<iframe src="<%= ctxPath%>/iframe_agree/agree.html" width="100%" height="420" class="w-full border border-gray-200 rounded-lg"></iframe>
	      		</div>
	      		<div class="flex justify-end gap-2 px-5 py-4 border-t">
	        		<button type="button" id="closeTerms2" class="px-4 py-2 rounded-md border border-gray-300 text-gray-700 hover:bg-gray-50">
	          		닫기
	        		</button>
	        		<button type="button" id="agreeAndClose" class="px-4 py-2 rounded-md bg-primary-600 text-white hover:bg-primary-700">
	          		동의합니다.
	        		</button>
	      		</div>
	    	</div>
	  	</div>
	</div>
</body>
</html>