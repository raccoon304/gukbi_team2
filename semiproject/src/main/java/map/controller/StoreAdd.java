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

        // ✅ admin만 접근
        if (loginUser == null || !"admin".equals(loginUser.getMemberid())) {
            request.setAttribute("message", "접근 권한이 없습니다.");
            request.setAttribute("loc", request.getContextPath() + "/map/mapView.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp"); // 너희 프로젝트 메시지 페이지에 맞게
            return;
        }

        String method = request.getMethod();

        // ==========================
        // GET: 폼 보여주기
        // ==========================
        if ("GET".equalsIgnoreCase(method)) {
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/map_YD/StoreAdd.jsp");
            return;
        }

        // ==========================
        // POST: 저장
        // ==========================
        String storeCode = nvl(request.getParameter("store_code"));
        String storeName = nvl(request.getParameter("store_name"));
        String address = nvl(request.getParameter("address"));
        String latStr = nvl(request.getParameter("lat"));
        String lngStr = nvl(request.getParameter("lng"));
        String description = nvl(request.getParameter("description"));
        String kakaoUrl = nvl(request.getParameter("kakao_url"));
        String phone = nvl(request.getParameter("phone"));
        String businessHours = nvl(request.getParameter("business_hours"));
        String isActiveStr = nvl(request.getParameter("is_active"));
        String sortNoStr = nvl(request.getParameter("sort_no"));

        double lat, lng;
        int isActive, sortNo;

        try {
            lat = Double.parseDouble(latStr);
            lng = Double.parseDouble(lngStr);
            isActive = Integer.parseInt(isActiveStr);
            sortNo = Integer.parseInt(sortNoStr);
        } catch (NumberFormatException e) {
            request.setAttribute("message", "위도/경도/정렬순서/활성여부 값이 올바르지 않습니다.");
            request.setAttribute("loc", request.getContextPath() + "/map/storeAdd.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

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
            // 저장 성공 -> 지도 페이지로
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/map/mapView.hp");
        } else {
            request.setAttribute("message", "매장 등록에 실패했습니다.");
            request.setAttribute("loc", request.getContextPath() + "/map/storeAdd.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
    }

    private String nvl(String s) {
        return (s == null) ? "" : s.trim();
    }
}
