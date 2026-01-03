<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" pattern="yyyyMMdd" var="todayYmd" />

<table style="display:none">
  <tbody id="issuedRows">

    <c:if test="${empty issuedList}">
      <tr>
        <td colspan="6" class="text-center text-muted py-3">발급 내역이 없습니다.</td>
      </tr>
    </c:if>

    <c:forEach var="row" items="${issuedList}">
      <c:set var="expireYmd"
             value="${empty row.expireDate ? '' : fn:replace(fn:substring(row.expireDate,0,10),'-','')}" />

      <tr>
        <td>${row.couponCategoryNo}-${row.couponId}</td>
        <td>${row.memberId}</td>
        <td>${row.memberName}</td>
        <td>${row.issueDate}</td>
        <td>${row.expireDate}</td>
        <td>
          <c:choose>
            <c:when test="${row.usedYn == 1}">
            		<span class="badge badge-secondary">사용</span>
            </c:when>
            <c:when test="${not empty expireYmd and expireYmd lt todayYmd}">
            		<span class="badge badge-warning">기간만료</span>
            </c:when>
            <c:otherwise>
            		<span class="badge badge-success">미사용</span>
            </c:otherwise>
          </c:choose>
        </td>
      </tr>
    </c:forEach>

  </tbody>
</table>

<ul id="issuedPageBarHtml" style="display:none;">
  ${issuedPageBar}
</ul>