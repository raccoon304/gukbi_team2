<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/header.jsp" />

<div class="container" style="max-width:900px; margin:200px auto 60px;">
  <div class="card shadow-sm">
    <div class="card-body">
      <h4 class="font-weight-bold mb-4">매장 추가</h4>

      <form method="post" action="${pageContext.request.contextPath}/map/storeAdd.hp">

        <div class="form-group">
          <label class="font-weight-bold">매장 코드(store_code)</label>
          <input type="text" name="store_code" class="form-control" placeholder="gangnam / hongdae / jeju" required />
        </div>

        <div class="form-group">
          <label class="font-weight-bold">매장명(store_name)</label>
          <input type="text" name="store_name" class="form-control" placeholder="강남점" required />
        </div>

        <div class="form-group">
          <label class="font-weight-bold">주소(address)</label>
          <input type="text" name="address" class="form-control" placeholder="서울 ..." required />
        </div>

        <div class="form-row">
          <div class="form-group col-md-6">
            <label class="font-weight-bold">위도(lat)</label>
            <input type="text" name="lat" class="form-control" placeholder="37.4979" required />
          </div>
          <div class="form-group col-md-6">
            <label class="font-weight-bold">경도(lng)</label>
            <input type="text" name="lng" class="form-control" placeholder="127.0276" required />
          </div>
        </div>

        <div class="form-group">
          <label class="font-weight-bold">매장 안내(description)</label>
          <textarea name="description" class="form-control" rows="5" placeholder="줄바꿈 가능"></textarea>
        </div>

        <div class="form-group">
          <label class="font-weight-bold">카카오 URL(kakao_url)</label>
          <input type="text" name="kakao_url" class="form-control" placeholder="https://place.map.kakao.com/..." />
          <small class="text-muted">없으면 비워도 됩니다.</small>
        </div>

        <div class="form-row">
          <div class="form-group col-md-6">
            <label class="font-weight-bold">전화(phone)</label>
            <input type="text" name="phone" class="form-control" placeholder="02-000-0000" />
          </div>
          <div class="form-group col-md-6">
            <label class="font-weight-bold">영업시간(business_hours)</label>
            <input type="text" name="business_hours" class="form-control" placeholder="10:00~20:00" />
          </div>
        </div>

        <div class="form-row">
          <div class="form-group col-md-6">
            <label class="font-weight-bold">활성(is_active)</label>
            <select name="is_active" class="form-control">
              <option value="1" selected>1 (사용)</option>
              <option value="0">0 (비활성)</option>
            </select>
          </div>

          <div class="form-group col-md-6">
            <label class="font-weight-bold">정렬순서(sort_no)</label>
            <input type="number" name="sort_no" class="form-control" value="10" required />
          </div>
        </div>

        <div class="d-flex justify-content-end mt-4">
          <a href="${pageContext.request.contextPath}/map/mapView.hp" class="btn btn-outline-secondary mr-2">취소</a>
          <button type="submit" class="btn btn-primary">저장</button>
        </div>

      </form>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/footer.jsp" />
