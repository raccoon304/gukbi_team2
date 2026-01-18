package map.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import map.domain.StoreDTO;
import map.model.StoreDAO;
import map.model.StoreDAO_imple;
import member.domain.MemberDTO;

public class StoreAdd extends AbstractController {

    private StoreDAO sdao = new StoreDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        // admin만 접근할 수 있도록 컨트롤러에서 검사
        if (loginUser == null || !"admin".equals(loginUser.getMemberid())) {
            request.setAttribute("message", "접근 권한이 없습니다.");
            request.setAttribute("loc", request.getContextPath() + "/map/mapView.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String method = request.getMethod();

        if ("GET".equalsIgnoreCase(method)) {
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/map_YD/StoreAdd.jsp");
            return;
        }

        String storeCode      = nvl(request.getParameter("store_code"));
        String storeName      = nvl(request.getParameter("store_name"));
        String address        = nvl(request.getParameter("address"));
        String latStr         = nvl(request.getParameter("lat"));
        String lngStr         = nvl(request.getParameter("lng"));
        String description    = nvl(request.getParameter("description"));
        String kakaoUrl       = nvl(request.getParameter("kakao_url"));
        String phone          = nvl(request.getParameter("phone"));
        String businessHours  = nvl(request.getParameter("business_hours"));
        String isActiveStr    = nvl(request.getParameter("is_active"));
        String sortNoStr      = nvl(request.getParameter("sort_no"));

        // 필수값 체크
        if (storeCode.isEmpty() || storeName.isEmpty() || address.isEmpty()
                || latStr.isEmpty() || lngStr.isEmpty()
                || isActiveStr.isEmpty() || sortNoStr.isEmpty()) {

            fail(request, "필수 입력값이 누락되었습니다.", request.getContextPath() + "/map/storeAdd.hp");
            return;
        }

        // store_code 형식 체크 (data-store로 쓰므로 소문자/숫자/언더바만)
        if (!isValidStoreCode(storeCode)) {
            fail(request, "매장 코드는 영문 소문자/숫자/_(언더바)만 가능하며 2~30자여야 합니다.",
                 request.getContextPath() + "/map/storeAdd.hp");
            return;
        }

        // 길이 체크(DB 컬럼 길이에 맞게 조절)
        if (storeName.length() > 50) {
            fail(request, "매장명은 50자 이하여야 합니다.", request.getContextPath() + "/map/storeAdd.hp");
            return;
        }
        if (address.length() > 200) {
            fail(request, "주소는 200자 이하여야 합니다.", request.getContextPath() + "/map/storeAdd.hp");
            return;
        }
        if (description.length() > 1000) { // description varchar2 길이 정책에 맞춰 조절
            fail(request, "매장 안내(description)는 1000자 이하여야 합니다.", request.getContextPath() + "/map/storeAdd.hp");
            return;
        }
        if (kakaoUrl.length() > 300) {
            fail(request, "카카오 URL은 300자 이하여야 합니다.", request.getContextPath() + "/map/storeAdd.hp");
            return;
        }
        if (phone.length() > 50) {
            fail(request, "전화번호는 50자 이하여야 합니다.", request.getContextPath() + "/map/storeAdd.hp");
            return;
        }
        if (businessHours.length() > 100) {
            fail(request, "영업시간은 100자 이하여야 합니다.", request.getContextPath() + "/map/storeAdd.hp");
            return;
        }

        // 숫자 파싱
        double lat, lng;
        int isActive, sortNo;

        try {
            lat = Double.parseDouble(latStr);
            lng = Double.parseDouble(lngStr);
            isActive = Integer.parseInt(isActiveStr);
            sortNo = Integer.parseInt(sortNoStr);
        } catch (NumberFormatException e) {
            fail(request, "위도/경도/정렬순서/활성여부 값이 올바르지 않습니다.", request.getContextPath() + "/map/storeAdd.hp");
            return;
        }

        // 위도/경도 범위 체크
        if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
            fail(request, "위도/경도 범위가 올바르지 않습니다. (lat:-90~90, lng:-180~180)",
                 request.getContextPath() + "/map/storeAdd.hp");
            return;
        }

        // is_active 체크 (0 또는 1)
        if (!(isActive == 0 || isActive == 1)) {
            fail(request, "활성여부(is_active)는 0 또는 1만 가능합니다.", request.getContextPath() + "/map/storeAdd.hp");
            return;
        }

        // sort_no 체크
        if (sortNo < 1) {
            fail(request, "정렬순서(sort_no)는 1 이상이어야 합니다.", request.getContextPath() + "/map/storeAdd.hp");
            return;
        }

        // DB 중복 체크
        if (sdao.existsStoreCode(storeCode)) {
            fail(request, "이미 존재하는 매장 코드입니다. 다른 코드를 입력하세요.", request.getContextPath() + "/map/storeAdd.hp");
            return;
        }

        // 정책상 sort_no 중복 불허하게 해놔서 막아야댐.
        if (sdao.existsSortNo(sortNo)) {
            fail(request, "이미 사용 중인 정렬순서(sort_no)입니다. 다른 숫자를 입력하세요.", request.getContextPath() + "/map/storeAdd.hp");
            return;
        }

        // URL 형식 간단 체크
        if (!kakaoUrl.isEmpty() && !isValidUrl(kakaoUrl)) {
            fail(request, "카카오 URL 형식이 올바르지 않습니다. (http/https로 시작해야 함)", request.getContextPath() + "/map/storeAdd.hp");
            return;
        }

        // insert
        StoreDTO dto = new StoreDTO();
        dto.setStoreCode(storeCode);
        dto.setStoreName(storeName);
        dto.setAddress(address);
        dto.setLat(lat);
        dto.setLng(lng);
        dto.setDescription(description);
        dto.setKakaoUrl(kakaoUrl);
        dto.setPhone(phone);
        dto.setBusinessHours(businessHours);
        dto.setIsActive(isActive);
        dto.setSortNo(sortNo);

        int n = sdao.insertStore(dto);

        if (n == 1) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/map/mapView.hp");
        } else {
            fail(request, "매장 등록에 실패했습니다.", request.getContextPath() + "/map/storeAdd.hp");
        }
    }

    private String nvl(String s) {
        return (s == null) ? "" : s.trim();
    }

    // data-store key로 쓰기 좋게
    private boolean isValidStoreCode(String code) {
        return code != null && code.matches("^[a-z0-9_]{2,30}$");
    }

    private boolean isValidUrl(String url) {
        // 최소 검증 http/https 시작
        return url.startsWith("http://") || url.startsWith("https://");
    }

    private void fail(HttpServletRequest request, String message, String loc) {
        request.setAttribute("message", message);
        request.setAttribute("loc", loc);
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/msg.jsp");
    }
}
