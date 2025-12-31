<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath=request.getContextPath();%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- 헤더부분 가져오기 -->
<jsp:include page="../header.jsp"/>

<!-- 사용자 JS -->
<script type="text/javascript" src="<%=ctxPath%>/js/product_TH/productList.js"></script>



<div class="text-center mt-6" style="margin-top: 5%;">
	<div style="font-size: 20pt">
		<a href="<%=ctxPath%>/product/productDetail.hp">
			<i class="fa-solid fa-list"></i> [임시]상품상세페이지 가기
		</a>
		
		<br>
		<br>
		
		<a href="<%=ctxPath%>/product/TESTproductList.hp">
			<i class="fa-solid fa-list"></i> 테스트상품페이지 가기
		</a>
	</div>
	
	
	
	 	<table class="table table-bordered" id="memberTbl" style="margin-top: 100px; width: 80%; margin: 2% auto;">
       <thead>
           <tr>
           	  <th>번호</th>
              <th>제품상세번호</th>
              <th>제품코드참조키</th>
              <th>색상</th>
              <th>저장용량</th>
              <th>가격</th>
              <th>재고</th>
              <th>이미지경로</th>
           </tr>
       </thead>
       <tbody>
			 <c:forEach items="${proOptionList}" var="productOptionDto" varStatus="status">
			     <tr>
			        <td>${status.count}</td>
			        <td>
			        	<span style="display: none;">${productOptionDto.optionId}</span>
			        	${productOptionDto.optionId}
			        </td>
			        <td>${productOptionDto.fkProductCode}</td>
			        <td>${productOptionDto.color}</td>
			        <td>${productOptionDto.storageSize}</td>
			        <td>${productOptionDto.price}</td>
			        <td>${productOptionDto.stockQty}</td>
			        <td>${productOptionDto.imagePath}</td>
			     </tr>
			 </c:forEach>
       </tbody>
    </table>
</div>


<!-- 특정 회원 정보를 보기 위해 전송 방식을 POST 방식으로 사용하려면 form 태그를 사용해야 함!!
		 POST 방식으로 하려면 form 태그 속에 전달해야할 데이터를 넣고 보내야 함!! -->
<form name="seqFrm">
	<input type="hidden" name="seq"/>
</form>



<!-- 푸터부분 가져오기 -->
<jsp:include page="../footer.jsp"/>