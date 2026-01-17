<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/header.jsp" />
<%
    String ctxPath = request.getContextPath();
%>

<style>
  /* 지도만 보이게 최소 스타일 */
  #map_container {
    width: 100%;
    max-width: 1000px;   
    margin: 200px auto 40px;
    padding: 0 16px;
  }
  #map {
    width: 100%;
    height: 520px;
    border: 1px solid #e9ecef;
    border-radius: 12px;
    overflow: hidden;
  }
</style>

<div id="map_container">
  <div id="map"></div>
</div>

<!-- ✅ 카카오 지도 SDK: appkey 1개만! (중복 include 금지) -->
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=fdd26aed348276cbc1ee6c0ef42c2d5e"></script>

<script>
(function () {
  const ctxPath = "<%=ctxPath%>";
  const mapEl = document.getElementById("map");

  // 1) 기본 지도 먼저 생성(서울 시청 근처 등 기본값)
  const map = new kakao.maps.Map(mapEl, {
    center: new kakao.maps.LatLng(37.5665, 126.9780),
    level: 6
  });

  // 2) 매장 데이터(JSON) 받아서 마커 표시
  fetch(ctxPath + "/shop/storeLocationJSON.up", {
    method: "GET",
    headers: { "X-Requested-With": "XMLHttpRequest" }
  })
  .then(res => {
    if (!res.ok) throw new Error("HTTP " + res.status);
    return res.json();
  })
  .then(list => {
    if (!Array.isArray(list) || list.length === 0) {
      // 데이터 없으면 그냥 기본 지도만 유지
      return;
    }

    const bounds = new kakao.maps.LatLngBounds();

    list.forEach(item => {
      // item.lat, item.lng 가 숫자/문자열 섞여도 대비
      const lat = Number(item.lat);
      const lng = Number(item.lng);
      if (Number.isNaN(lat) || Number.isNaN(lng)) return;

      const pos = new kakao.maps.LatLng(lat, lng);

      new kakao.maps.Marker({
        map: map,
        position: pos
      });

      bounds.extend(pos);
    });

    // 마커들이 모두 보이게 지도 범위 맞추기
    map.setBounds(bounds);
  })
  .catch(err => {
    console.error(err);
    // 실패해도 지도는 떠 있으니, 알림은 최소만
    // alert("매장 위치 정보를 불러오지 못했습니다.");
  });
})();
</script>

<jsp:include page="/WEB-INF/footer.jsp" />
