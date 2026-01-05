<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="memberRowsHtml" style="display:none;">
  <table>
    <tbody id="memberRows">

      <c:if test="${empty memberList}">
        <tr>
          <td colspan="6" class="text-center text-muted py-4">회원이 없습니다.</td>
        </tr>
      </c:if>

      <c:forEach var="m" items="${memberList}">
        <tr>
          <td><input type="checkbox" class="member-checkbox" data-member-id="${m.memberid}"></td>
          <td>${m.memberid}</td>
          <td>${m.name}</td>
          <td>
          	<c:set var="orderCnt" value="${empty statMap[m.memberid] ? 0 : statMap[m.memberid]['order_cnt']}" />
      		<fmt:formatNumber value="${orderCnt}" />
          </td>
          <td>
          	<c:set var="paySum" value="${empty statMap[m.memberid] ? 0 : statMap[m.memberid]['real_pay_sum']}" />
      		<fmt:formatNumber value="${paySum}" pattern="#,###" /> 원
          </td>
          <td>${m.registerday}</td>
        </tr>
      </c:forEach>

    </tbody>
  </table>
</div>

<div id="modalPageBarHtml" style="display:none;">
  <c:out value="${pageBar}" escapeXml="false" />
</div>

<!-- 전체건수(전체선택 카운트 계산용) -->
<div id="totalCountHtml" style="display:none;">${totalCount}</div>