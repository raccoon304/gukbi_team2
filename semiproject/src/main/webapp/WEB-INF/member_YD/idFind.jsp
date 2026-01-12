<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이디 찾기 결과</title>

    <link rel="stylesheet" href="<%= ctxPath %>/css/member_YD/member.css">

    <!-- Tailwind / Feather / jQuery -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/feather-icons/dist/feather.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

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

    <style>
        .result-card {
            border: 1px solid #e5e7eb;
            border-radius: 18px;
            padding: 18px 16px;
            background: #fff;
        }
        .result-card.success { border-color: #86efac; background: #f0fdf4; }
        .result-card.fail { border-color: #fecaca; background: #fef2f2; }
    </style>
</head>

<body class="bg-gray-50 min-h-screen">
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex flex-col md:flex-row min-h-screen">

        <!-- 좌측단 -->
        <div class="w-full md:w-1/2 bg-gradient-to-br from-primary-100 to-secondary-100 flex items-center justify-center p-12">
            <div class="max-w-md text-center">
                <h1 class="text-4xl font-bold text-primary-700 mb-4">아이디 찾기</h1>
                <p class="text-lg text-gray-700 mb-8">아이디 찾기 결과를 확인해주세요.</p>
                <img src="http://static.photos/technology/640x360/75" alt="Find account" class="rounded-xl shadow-lg w-full">
            </div>
        </div>

        <!-- 우측단 -->
        <div class="w-full md:w-1/2 flex items-center justify-center p-8">
            <div class="w-full max-w-md">

                <div class="text-center mb-6">
                    <h2 class="text-3xl font-bold text-gray-800">아이디 찾기 결과</h2>
                    <p class="text-gray-600 mt-2">
                        홈으로 돌아가기
                        <a href="<%=ctxPath%>/index.hp" class="text-primary-600 hover:text-primary-700 font-medium">&nbsp;home</a>
                    </p>
                </div>

                <!-- 성공시 아이디 결과만 -->
                <c:if test="${not empty maskedMemberId}">
                    <div class="result-card success mb-4">
                        <div class="flex items-start gap-3">
                            <div class="mt-1">
                                <i data-feather="check-circle" class="text-green-600"></i>
                            </div>
                            <div class="w-full">
                                <div class="text-sm font-semibold text-green-800 mb-2">아이디 찾기 완료</div>
                                <div class="text-gray-800">
                                    회원님의 아이디는
                                </div>
                                <div class="mt-2 text-2xl font-extrabold text-green-700 tracking-wider">
                                    ${maskedMemberId}
                                </div>
                                <div class="text-xs text-green-700 mt-3">보안상 아이디 일부만 표시됩니다.</div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!--실패 시 에러만 -->
                <c:if test="${empty maskedMemberId}">
                    <div class="result-card fail mb-4">
                        <div class="flex items-start gap-3">
                            <div class="mt-1">
                                <i data-feather="alert-triangle" class="text-red-600"></i>
                            </div>
                            <div class="w-full">
                                <div class="text-sm font-semibold text-red-800 mb-2">아이디 찾기 실패</div>
                                <div class="text-gray-800">
                                    <c:out value="${empty errorMsg ? '일치하는 회원정보가 없습니다.' : errorMsg}" />
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <div class="flex flex-col gap-2">
                    <a href="<%=ctxPath%>/index.hp"
                       class="w-full flex justify-center py-3 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition duration-150">
                        홈으로 이동
                    </a>

                    <a href="<%=ctxPath%>/member/accountFind.hp"
                       class="w-full flex justify-center py-3 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none transition duration-150">
                        다시 찾기
                    </a>
                </div>

            </div>
        </div>
    </div>
</div>

<script>
    feather.replace();
</script>

</body>
</html>
