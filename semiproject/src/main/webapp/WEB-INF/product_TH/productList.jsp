<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath=request.getContextPath();%>
<!-- 헤더부분 가져오기 -->
<jsp:include page="../header.jsp"/>

<div class="text-center mt-6" style="margin-top: 100px; font-size: 20pt">
	<p style="font-size: 30pt">안녕하세요~</p>
	<a href="<%=ctxPath%>/product/productDetail.hp">
		<i class="fa-solid fa-list"></i> 상품상세페이지 가기
	</a>
</div>


<!-- 푸터부분 가져오기 -->
<jsp:include page="../footer.jsp"/>