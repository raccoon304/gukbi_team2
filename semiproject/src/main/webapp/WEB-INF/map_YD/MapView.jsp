<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/header.jsp" />
<%
    String ctxPath = request.getContextPath();
%>

<c:set var="loginUser" value="${sessionScope.loginUser}" />

<style>
  #map_container {
    max-width: 1600px;
    margin: 200px auto 40px;
    padding: 0 16px;
  }

  #map {
    width: 100%;
    height: 520px;
    border: 1px solid #e9ecef;
    border-radius: 12px;
    overflow: hidden;
    background: #fff;
  }

  /* ✅ 지점 탭(사이드바용) */
  .store-tabs { padding: .75rem; border-top: 1px solid #eee; }
  .store-tabs .store-btn{
    width: 100%;
    text-align: left;
    border: 1px solid #e9ecef;
    background: #fff;
    padding: .65rem .8rem;
    border-radius: .6rem;
    margin-bottom: .55rem;
    cursor: pointer;
    font-weight: 700;
    font-size: 14px;
    transition: background .15s ease, border-color .15s ease, color .15s ease;
  }
  .store-tabs .store-btn:hover{
    background: rgba(13,110,253,.04);
    border-color: rgba(13,110,253,.35);
  }
  .store-tabs .store-btn.active{
    border-color: #0d6efd;
    color: #0d6efd;
    background: rgba(13,110,253,.08);
  }

  /* ✅ 우측 매장 상세 패널 (디자인 맞춤) */
  .store-detail{
    border: 1px solid #e9ecef;
    border-radius: 12px;
    background: #fff;
    height: 520px;
    overflow: hidden;
    display: flex;
    flex-direction: column;
    box-shadow: 0 6px 18px rgba(0,0,0,.04);
  }

  .store-detail-head{
    padding: 14px 16px 12px;
    border-bottom: 1px solid #f1f3f5;
    background: linear-gradient(180deg, rgba(13,110,253,.06), rgba(255,255,255,0));
  }

  .store-title-row{
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 10px;
  }

  .store-detail-title{
    font-weight: 800;
    font-size: 16px;
    margin: 0;
  }

  .store-badge{
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: .25rem .55rem;
    border-radius: 999px;
    font-size: 11px;
    font-weight: 800;
    border: 1px solid rgba(13,110,253,.25);
    background: rgba(13,110,253,.08);
    color: #0d6efd;
    white-space: nowrap;
  }

  .store-detail-body{
    padding: 14px 16px;
    overflow: auto;
  }

  .store-meta{
    display: grid;
    grid-template-columns: 22px 1fr;
    gap: 8px 10px;
    font-size: 13px;
    color: #495057;
    margin-bottom: 14px;
  }
  .store-meta i{
    color: #0d6efd;
    margin-top: 2px;
  }

  .store-desc-box{
    border: 1px solid #f1f3f5;
    background: #f8f9fa;
    border-radius: 10px;
    padding: 12px 12px;
  }

  .store-desc-title{
    font-weight: 800;
    font-size: 13px;
    margin-bottom: 6px;
    color: #212529;
  }

  .store-detail-desc{
    font-size: 13px;
    line-height: 1.65;
    color: #495057;
    white-space: pre-line;
    margin: 0;
  }

  .store-detail-foot{
    padding: 12px 16px;
    border-top: 1px solid #f1f3f5;
    display: flex;
    justify-content: flex-end;
    gap: 8px;
    background: #fff;
  }

  .btn-soft{
    border: 1px solid rgba(13,110,253,.25);
    background: rgba(13,110,253,.08);
    color: #0d6efd;
    font-weight: 700;
    font-size: 12px;
    padding: .4rem .65rem;
    border-radius: .55rem;
    cursor: pointer;
  }
  .btn-soft:hover{
    background: rgba(13,110,253,.12);
  }

  .btn-outline-soft{
    border: 1px solid #e9ecef;
    background: #fff;
    color: #495057;
    font-weight: 700;
    font-size: 12px;
    padding: .4rem .65rem;
    border-radius: .55rem;
    cursor: pointer;
  }
  .btn-outline-soft:hover{
    background: #f8f9fa;
  }

  .admin-add-wrap{
    padding: .75rem .75rem 0;
  }
</style>

<div id="map_container" class="container">
  <div class="row">

    <!-- ✅ 왼쪽 네비게이션(지점 리스트) -->
    <div class="col-md-2 mb-4">
      <div class="card shadow-sm position-sticky" style="top: 100px;">
        <div class="card-body text-center">
          <h5 class="font-weight-bold mb-1">매장 위치</h5>
          <small class="text-muted"></small>
        </div>

        <!-- ✅ admin이면 “매장 추가” 버튼 노출 -->
        <c:if test="${not empty loginUser and loginUser.memberid eq 'admin'}">
          <div class="admin-add-wrap">
            <a href="${pageContext.request.contextPath}/map/storeAdd.hp" class="btn btn-sm btn-primary btn-block">
              <i class="fa-solid fa-plus mr-1"></i> 매장 추가
            </a>
          </div>
        </c:if>

        <!-- 탭 버튼 들어갈 영역(동적) -->
        <div class="store-tabs" id="storeTabs">
          <div class="text-muted" style="font-size:13px;">매장 정보를 불러오는 중...</div>
        </div>
      </div>
    </div>

    <!-- ✅ 오른쪽(지도 + 상세) 영역 -->
    <div class="col-md-10 mb-4">
      <div class="row">

        <!-- 지도 -->
        <div class="col-md-9 mb-3 mb-md-0">
          <div id="map"></div>
        </div>

        <!-- 매장 상세 패널 -->
        <div class="col-md-3">
          <div id="storeDetail" class="store-detail">

            <div class="store-detail-head">
              <div class="store-title-row">
                <h4 class="store-detail-title" id="sdName">-</h4>
                <span class="store-badge"><i class="fa-solid fa-location-dot"></i> Store</span>
              </div>
            </div>

            <div class="store-detail-body">
              <div class="store-meta">
                <i class="fa-solid fa-map-location-dot"></i>
                <div id="sdAddr">-</div>

                <i class="fa-solid fa-circle-info"></i>
                <div id="sdHint">매장 방문 전, 재고/상담 가능 여부를 확인하면 더 편합니다.</div>
              </div>

              <div class="store-desc-box">
                <div class="store-desc-title">매장 안내</div>
                <p class="store-detail-desc" id="sdDesc">-</p>
              </div>
            </div>

            <div class="store-detail-foot">
              <button type="button" class="btn-outline-soft" id="btnCopyAddr">
                <i class="fa-regular fa-copy mr-1"></i> 주소 복사
              </button>
              <button type="button" class="btn-soft" id="btnOpenKakao">
                <i class="fa-solid fa-arrow-up-right-from-square mr-1"></i> 지도 보기
              </button>
            </div>

          </div>
        </div>

      </div>
    </div>

  </div>
</div>

<!-- ✅ 카카오 지도 SDK -->
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=fdd26aed348276cbc1ee6c0ef42c2d5e"></script>

<script>
(function () {
  const ctxPath = "<%=ctxPath%>";

  const mapEl = document.getElementById("map");
  const storeTabsEl = document.getElementById("storeTabs");

  const sdName = document.getElementById("sdName");
  const sdAddr = document.getElementById("sdAddr");
  const sdDesc = document.getElementById("sdDesc");

  const btnCopyAddr = document.getElementById("btnCopyAddr");
  const btnOpenKakao = document.getElementById("btnOpenKakao");

  // DB에서 받은 store 목록을 {code: storeObj} 형태로 보관
  let stores = {};
  let storeKeys = [];
  let currentKey = "";

  // 지도 생성(임시 기본값)
  const map = new kakao.maps.Map(mapEl, {
    center: new kakao.maps.LatLng(37.5665, 126.9780),
    level: 5
  });

  const markers = {};
  const infows = {};

  function closeAllInfo() {
    Object.keys(infows).forEach(k => infows[k].close());
  }

  function setActiveTab(key) {
    document.querySelectorAll(".store-btn").forEach(b => b.classList.remove("active"));
    const t = document.querySelector('.store-btn[data-store="' + key + '"]');
    if (t) t.classList.add("active");
  }

  function renderDetail(key) {
    const s = stores[key];
    if (!s) return;

    currentKey = key;
    sdName.textContent = s.storeName || "-";
    sdAddr.textContent = s.address || "-";
    sdDesc.textContent = s.description || "-";
  }

  function moveToStore(key) {
    const s = stores[key];
    if (!s) return;

    const lat = Number(s.lat);
    const lng = Number(s.lng);
    if (Number.isNaN(lat) || Number.isNaN(lng)) return;

    const pos = new kakao.maps.LatLng(lat, lng);

    // ✅ “대한민국 전체”처럼 멀어지는 것 방지: 선택할 때 줌 고정
    map.setLevel(4);
    map.panTo(pos);

    closeAllInfo();
    if (infows[key] && markers[key]) infows[key].open(map, markers[key]);

    renderDetail(key);
  }

  function buildTabs() {
    if (!storeKeys.length) {
      storeTabsEl.innerHTML = "<div class='text-muted' style='font-size:13px;'>등록된 매장이 없습니다.</div>";
      return;
    }

    let html = "";
    storeKeys.forEach((key, idx) => {
      const s = stores[key];
      const active = (idx === 0) ? "active" : "";
      html += '<button type="button" class="store-btn ' + active + '" data-store="' + key + '">' + (s.storeName || key) + '</button>';
    });

    storeTabsEl.innerHTML = html;
  }

  function buildMarkers() {
    // 기존 마커/인포윈도우 정리
    Object.keys(markers).forEach(k => markers[k].setMap(null));

    storeKeys.forEach(key => {
      const s = stores[key];
      const lat = Number(s.lat);
      const lng = Number(s.lng);
      if (Number.isNaN(lat) || Number.isNaN(lng)) return;

      const pos = new kakao.maps.LatLng(lat, lng);

      const marker = new kakao.maps.Marker({ map: map, position: pos });
      markers[key] = marker;

      const content =
        "<div style='padding:10px; font-size:13px; line-height:1.4;'>" +
        "  <div style='font-weight:800; margin-bottom:6px;'>" + (s.storeName || "") + "</div>" +
        "  <div style='color:#6c757d;'>" + (s.address || "") + "</div>" +
        "</div>";

      const infowindow = new kakao.maps.InfoWindow({ content: content });
      infows[key] = infowindow;

      kakao.maps.event.addListener(marker, "click", function() {
        setActiveTab(key);
        moveToStore(key);
      });
    });
  }

  // 탭 클릭
  document.addEventListener("click", function(e) {
    const btn = e.target.closest(".store-btn");
    if (!btn) return;

    const key = btn.getAttribute("data-store");
    setActiveTab(key);
    moveToStore(key);
  });

  // 주소 복사
  btnCopyAddr.addEventListener("click", async function(){
    const s = stores[currentKey];
    const addr = (s && s.address) ? String(s.address) : "";
    if (!addr) return;

    try {
      await navigator.clipboard.writeText(addr);
      btnCopyAddr.innerHTML = "<i class='fa-solid fa-check mr-1'></i> 복사됨";
      setTimeout(() => {
        btnCopyAddr.innerHTML = "<i class='fa-regular fa-copy mr-1'></i> 주소 복사";
      }, 1200);
    } catch (e) {
      const ta = document.createElement("textarea");
      ta.value = addr;
      document.body.appendChild(ta);
      ta.select();
      document.execCommand("copy");
      document.body.removeChild(ta);

      btnCopyAddr.innerHTML = "<i class='fa-solid fa-check mr-1'></i> 복사됨";
      setTimeout(() => {
        btnCopyAddr.innerHTML = "<i class='fa-regular fa-copy mr-1'></i> 주소 복사";
      }, 1200);
    }
  });

  // ✅ 지도 보기: kakao_url 있으면 그걸 열고, 없으면 좌표 링크 생성
  btnOpenKakao.addEventListener("click", function(){
    const s = stores[currentKey];
    if (!s) return;

    const url = (s.kakaoUrl) ? String(s.kakaoUrl).trim() : "";

    // kakao_url이 정상 링크면 그대로 오픈
    if (url) {
      window.open(url, "_blank");
      return;
    }

    // 없으면 좌표 기반 링크 생성
    const lat = Number(s.lat);
    const lng = Number(s.lng);
    if (!Number.isNaN(lat) && !Number.isNaN(lng)) {
      const name = encodeURIComponent(s.storeName || "매장");
      const mapUrl = "https://map.kakao.com/link/map/" + name + "," + lat + "," + lng;
      window.open(mapUrl, "_blank");
      return;
    }

    window.open("https://map.kakao.com/", "_blank");
  });

  // ✅ DB에서 매장 목록 가져오기
  fetch(ctxPath + "/map/storeListJSON.hp", {
    method: "GET",
    headers: { "X-Requested-With": "XMLHttpRequest" }
  })
  .then(res => {
    if (!res.ok) throw new Error("HTTP " + res.status);
    return res.json();
  })
  .then(list => {
    if (!Array.isArray(list) || list.length === 0) {
      stores = {};
      storeKeys = [];
      buildTabs();
      return;
    }

    stores = {};
    list.forEach(s => {
      // data-store용 key는 storeCode 사용
      const key = s.storeCode;
      if (!key) return;
      stores[key] = s;
    });

    storeKeys = Object.keys(stores);

    buildTabs();
    buildMarkers();

    // 최초 선택: sort_no 정렬이 DB에서 이미 됐으니 첫 번째가 디폴트
    const firstKey = storeKeys[0];
    if (firstKey) {
      setActiveTab(firstKey);
      moveToStore(firstKey);
    }
  })
  .catch(err => {
    console.error(err);
    storeTabsEl.innerHTML = "<div class='text-muted' style='font-size:13px;'>매장 정보를 불러오지 못했습니다.</div>";
  });

})();
</script>

<jsp:include page="/WEB-INF/footer.jsp" />
