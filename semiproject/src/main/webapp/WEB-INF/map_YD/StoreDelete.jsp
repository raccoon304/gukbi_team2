<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/header.jsp" />

<div class="container" style="max-width:900px; margin:200px auto 60px;">
  <div class="card shadow-sm">
    <div class="card-body">

      <h4 class="font-weight-bold mb-3">매장 관리</h4>
      <p class="text-muted" style="font-size:13px;">
        선택한 매장의 상태를 <strong>활성 ↔ 비활성</strong> 으로 변경합니다.
      </p>

      <form method="post" action="${pageContext.request.contextPath}/map/storeDelete.hp"
            onsubmit="return confirm('선택한 매장의 활성/비활성 상태를 변경할까요?');">

        <div class="form-group">
          <label class="font-weight-bold">매장 선택</label>
          <select name="store_id" class="form-control" required>
            <option value="">-- 선택 --</option>

            <c:forEach var="s" items="${storeList}">
              <option value="${s.storeId}">
                ${s.storeName} (${s.storeCode})
                / ${s.address}
                / 상태: <c:choose>
                         <c:when test="${s.isActive eq 1}">ACTIVE</c:when>
                         <c:otherwise>DEACTIVE</c:otherwise>
                       </c:choose>
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="d-flex justify-content-end mt-4">
          <a href="${pageContext.request.contextPath}/map/mapView.hp"
             class="btn btn-outline-secondary mr-2">돌아가기</a>
          <button type="submit" class="btn btn-danger">상태 변경</button>
        </div>

      </form>

      <hr/>

      <!-- 상태 표로 나타내주기 ( !!!! 어떤걸 나타낼지 추후 수정 고민중..!!!! ) -->
      <div class="table-responsive">
        <table class="table table-sm table-bordered mb-0">
          <thead class="thead-light">
            <tr>
              <th style="width:90px;">ID</th>
              <th style="width:120px;">코드</th>
              <th>매장명</th>
              <th>주소</th>
              <th style="width:110px;">상태</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="s" items="${storeList}">
              <tr>
                <td>${s.storeId}</td>
                <td>${s.storeCode}</td>
                <td>${s.storeName}</td>
                <td>${s.address}</td>
                <td>
                  <c:choose>
                    <c:when test="${s.isActive eq 1}">
                      <span class="badge badge-success">ACTIVE</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge badge-secondary">DEACTIVE</span>
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>

    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/footer.jsp" />
