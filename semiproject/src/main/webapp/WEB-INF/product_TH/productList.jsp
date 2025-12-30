<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath=request.getContextPath();%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- 헤더부분 가져오기 -->
<jsp:include page="../header.jsp"/>

<div class="text-center mt-6" style="margin-top: 5%;">
	<div style="font-size: 20pt">
		<p>안녕하세요~</p>
		<a href="<%=ctxPath%>/product/productDetail.hp">
			<i class="fa-solid fa-list"></i> 상품상세페이지 가기
		</a>
	</div>
	
    <table class="table table-bordered" id="memberTbl" style="margin-top: 100px; width: 80%; margin: 2% auto;">
       <thead>
           <tr>
           	  <th>번호</th>
              <th>제품코드</th>
              <th>제품명</th>
              <th>브랜드명</th>
              <th>제품설명</th>
              <th>판매상태</th>
           </tr>
       </thead>
       <tbody>
			 <c:forEach items="${requestScope.proList}" var="productDto" varStatus="status">
			     <tr>
			        <td>${status.count}</td>
			        <td>${productDto.productCode}</td>
			        <td>${productDto.productName}</td>
			        <td>${productDto.brandName}</td>
			        <td>${productDto.productDesc}</td>
			        <td>${productDto.saleStatus}</td>
			     </tr>
			 </c:forEach>
       </tbody>
    </table>
    
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
			        <td>${productOptionDto.optionId}</td>
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


<!-- 푸터부분 가져오기 -->
<jsp:include page="../footer.jsp"/>