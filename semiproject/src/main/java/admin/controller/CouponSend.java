package admin.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.json.JSONObject;

import common.controller.AbstractController;
import coupon.model.CouponDAO;
import coupon.model.CouponDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CouponSend extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		 // POST만 허용
        if(!"POST".equalsIgnoreCase(request.getMethod())) {
        	
            String message = "잘못된 접근입니다.";
            String loc = request.getContextPath() + "/admin/coupon.hp";
            request.setAttribute("message", message);
            request.setAttribute("loc", loc);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String ctxPath = request.getContextPath();

        try {
            
            String sCouponCategoryNo = request.getParameter("couponCategoryNo");
            String memberIdsStr      = request.getParameter("memberIds");       // "user01,user02,..."
            String expireDateStr     = request.getParameter("expireDate");      // "yyyy-MM-dd"

            String allSelected       = request.getParameter("allSelected");     // "1" or "0"
            String deselectedIdsStr  = request.getParameter("deselectedIds");   // "user03,user07,..."
            String searchType        = request.getParameter("searchType");      // member_id/name/email
            String searchWord        = request.getParameter("searchWord");

            // couponCategoryNo 검증
            int couponCategoryNo = 0;
            try {
                couponCategoryNo = Integer.parseInt(sCouponCategoryNo);
                if (couponCategoryNo <= 0) throw new NumberFormatException();
            } catch (NumberFormatException e) {
                request.setAttribute("message", "쿠폰 번호가 올바르지 않습니다.");
                request.setAttribute("loc", ctxPath + "/admin/coupon.hp");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            // expireDate 검증 (오늘 이전 금지)
            if (expireDateStr == null || expireDateStr.trim().isEmpty()) {
                request.setAttribute("message", "만료일을 선택하세요.");
                request.setAttribute("loc", ctxPath + "/admin/coupon.hp");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            LocalDate expireDate;
            try {
                expireDate = LocalDate.parse(expireDateStr.trim(), DateTimeFormatter.ISO_LOCAL_DATE);
            } catch (Exception e) {
                request.setAttribute("message", "만료일 형식이 올바르지 않습니다. (yyyy-MM-dd)");
                request.setAttribute("loc", ctxPath + "/admin/coupon.hp");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            LocalDate today = LocalDate.now();
            if (expireDate.isBefore(today)) {
                request.setAttribute("message", "만료일은 오늘 이전으로 설정할 수 없습니다.");
                request.setAttribute("loc", ctxPath + "/admin/coupon.hp");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            // 대상 회원 리스트 만들기 (ALL 처리)
            CouponDAO cdao = new CouponDAO_imple();
            List<String> memberIdList = new ArrayList<>();

            boolean isAll = "1".equals(allSelected);

            if (isAll) {
                // searchType 유효성
                if (searchType == null) searchType = "";
                if (!"member_id".equals(searchType) && !"name".equals(searchType) && !"email".equals(searchType)) {
                    searchType = "";
                }
                if (searchWord == null) searchWord = "";

                Map<String, String> paraMap = new HashMap<>();
                paraMap.put("searchType", searchType);
                paraMap.put("searchWord", searchWord);

                // 검색조건에 맞는 전체 회원아이디 조회
                List<String> allMatchedIds = cdao.selectMemberIdsForIssue(paraMap);

                // 전체선택 중 “해제한 회원” 제외
                Set<String> deselectedSet = parseCommaIdsToSet(deselectedIdsStr);

                for (String id : allMatchedIds) {
                    if (!deselectedSet.contains(id)) {
                        memberIdList.add(id);
                    }
                }

            } else {
                // 일반 선택 모드: memberIdsStr로 받은 콤마 문자열 파싱
                Set<String> picked = parseCommaIdsToSet(memberIdsStr); // 중복 제거 + 순서 유지
                memberIdList.addAll(picked);
            }

            if (memberIdList.isEmpty()) {
                request.setAttribute("message", "쿠폰을 발급할 회원이 없습니다.");
                request.setAttribute("loc", ctxPath + "/admin/coupon.hp");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            // 발급 처리 (DAO가 미사용+미만료 존재 시 스킵)
            int issuedCount = cdao.issueCouponToMembers(couponCategoryNo, memberIdList, expireDateStr);

            String msg;
            if (issuedCount > 0) {
                msg = "쿠폰을 " + issuedCount + "명에게 전송했습니다.";
            } else {
                msg = "전송할 대상이 없습니다. (이미 미사용/미만료 쿠폰이 있는 회원은 건너뜁니다.)";
            }

            request.setAttribute("message", msg);
            request.setAttribute("loc", ctxPath + "/admin/coupon.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
        catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "쿠폰 전송 중 오류가 발생했습니다.");
            request.setAttribute("loc", request.getContextPath() + "/admin/coupon.hp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
    }

    // 중복 제거
    private Set<String> parseCommaIdsToSet(String str) {
        Set<String> set = new LinkedHashSet<>();
        if (str == null) return set;

        String[] arr = str.split(",");
        for (int i = 0; i < arr.length; i++) {
            String s = arr[i].trim();
            if (!s.isEmpty()) set.add(s);
        }
        return set;
    }
   
}





