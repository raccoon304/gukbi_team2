<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/header.jsp" />
<%
    String ctxPath = request.getContextPath();
%>

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
    height: 520px;          /* 지도 높이랑 맞춤 */
    overflow: hidden;       /* 헤더/바디 분리 */
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
</style>

<div id="map_container" class="container">
  <div class="row">

    <!-- 왼쪽 네비게이션(지점 리스트) -->
    <div class="col-md-2 mb-4">
      <div class="card shadow-sm position-sticky" style="top: 100px;">
        <div class="card-body text-center">
          <h5 class="font-weight-bold mb-1">매장 위치</h5>
          <small class="text-muted"></small>
        </div>

        <div class="store-tabs">
          <button type="button" class="store-btn active" data-store="gangnam">강남점</button>
          <button type="button" class="store-btn" data-store="hongdae">홍대점</button>
          <button type="button" class="store-btn" data-store="anseong">안성점</button>
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
                <div>매장 방문 전, 재고/상담 가능 여부를 확인하면 더 편합니다.</div>
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

<!-- ✅ 카카오 지도 SDK: appkey 1개만! -->
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=fdd26aed348276cbc1ee6c0ef42c2d5e"></script>

<script>
(function () {
  const mapEl = document.getElementById("map");

  // ✅ 우측 상세 패널 요소
  const sdName = document.getElementById("sdName");
  const sdAddr = document.getElementById("sdAddr");
  const sdDesc = document.getElementById("sdDesc");

  // ✅ 하단 버튼
  const btnCopyAddr = document.getElementById("btnCopyAddr");
  const btnOpenKakao = document.getElementById("btnOpenKakao");

  // ✅ 지점 데이터 (나중에 DB로 바꾸면 이 부분만 JSON으로 채우면 됨)
  const stores = {
    gangnam: {
      name: "강남점",
      lat: 37.4979, lng: 127.0276,
      address: "서울 강남구 (예시 주소)",
      desc: "강남역 인근 매장입니다.\n대중교통 접근성이 좋고, 방문 상담이 가능합니다.",
      kakaoUrl: "https://map.kakao.com/"  // 실제 링크 있으면 교체
    },
    hongdae: {
      name: "홍대점",
      lat: 37.5563, lng: 126.9220,
      address: "서울 마포구 (예시 주소)",
      desc: "홍대입구역 근처 매장입니다.\n주말 방문 고객이 많아 예약 후 방문을 권장합니다.",
      kakaoUrl: "https://map.kakao.com/"
    },
    anseong: {
      name: "안성점",
      lat: 37.0081, lng: 127.2798,
      address: "경기 안성시 (예시 주소)",
      desc: "안성 지역 매장입니다.\n주차가 비교적 편리하며 가족 단위 방문이 많습니다.",
      kakaoUrl: "https://map.kakao.com/"
    }
  };

  // 현재 선택된 매장 key
  let currentKey = "gangnam";

  // 1) 지도 생성
  const map = new kakao.maps.Map(mapEl, {
    center: new kakao.maps.LatLng(stores.gangnam.lat, stores.gangnam.lng),
    level: 4
  });

  // 2) 마커/인포윈도우 생성
  const markers = {};
  const infows = {};

  Object.keys(stores).forEach(key => {
    const s = stores[key];
    const pos = new kakao.maps.LatLng(s.lat, s.lng);

    const marker = new kakao.maps.Marker({ map, position: pos });
    markers[key] = marker;

    const content =
      "<div style='padding:10px; font-size:13px; line-height:1.4;'>" +
      "  <div style='font-weight:800; margin-bottom:6px;'>" + s.name + "</div>" +
      "  <div style='color:#6c757d;'>" + (s.address || "") + "</div>" +
      "</div>";

    const infowindow = new kakao.maps.InfoWindow({ content });
    infows[key] = infowindow;

    // 마커 클릭 시도 해당 매장으로 이동/표시
    kakao.maps.event.addListener(marker, 'click', function() {
      setActiveTab(key);
      moveToStore(key);
    });
  });

  function closeAllInfo() {
    Object.keys(infows).forEach(k => infows[k].close());
  }

  function renderDetail(key) {
    const s = stores[key];
    if (!s) return;

    currentKey = key;
    sdName.textContent = s.name || "-";
    sdAddr.textContent = s.address || "-";
    sdDesc.textContent = s.desc || "-";
  }

  function moveToStore(key) {
    const s = stores[key];
    if (!s) return;

    const pos = new kakao.maps.LatLng(s.lat, s.lng);

    map.panTo(pos);

    closeAllInfo();
    infows[key].open(map, markers[key]);

    renderDetail(key);
  }

  function setActiveTab(key){
    document.querySelectorAll(".store-btn").forEach(b => b.classList.remove("active"));
    const t = document.querySelector('.store-btn[data-store="'+key+'"]');
    if (t) t.classList.add("active");
  }

  // 3) 탭 클릭 이벤트
  document.addEventListener("click", function(e){
    const btn = e.target.closest(".store-btn");
    if (!btn) return;

    const key = btn.getAttribute("data-store");
    setActiveTab(key);
    moveToStore(key);
  });

  // 4) 주소 복사
  btnCopyAddr.addEventListener("click", async function(){
    const s = stores[currentKey];
    const addr = (s && s.address) ? s.address : "";
    if (!addr) return;

    try {
      await navigator.clipboard.writeText(addr);
      btnCopyAddr.innerHTML = "<i class='fa-solid fa-check mr-1'></i> 복사됨";
      setTimeout(() => {
        btnCopyAddr.innerHTML = "<i class='fa-regular fa-copy mr-1'></i> 주소 복사";
      }, 1200);
    } catch (e) {
      // clipboard 권한 막히면 fallback
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

  // 5) 카카오 지도 링크 열기
  btnOpenKakao.addEventListener("click", function(){
    const s = stores[currentKey];
    const url = (s && s.kakaoUrl) ? s.kakaoUrl : "https://map.kakao.com/";
    window.open(url, "_blank");
  });

  // ✅ 최초: 리스트 최상단(강남점) active + 상세 자동 표시
  setActiveTab("gangnam");
  moveToStore("gangnam");

})();
</script>

<jsp:include page="/WEB-INF/footer.jsp" />
