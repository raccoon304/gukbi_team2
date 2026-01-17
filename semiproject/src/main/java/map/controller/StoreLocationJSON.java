package map.controller;

import java.util.List;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import map.domain.StoreDTO;
import map.model.StoreDAO;
import map.model.StoreDAO_imple;

public class StoreLocationJSON extends AbstractController {

    private StoreDAO sdao = new StoreDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        response.setContentType("application/json; charset=UTF-8");

        List<StoreDTO> list = sdao.selectActiveStores();

        // JSON 직접 만들기(외부 라이브러리 없이)
        StringBuilder sb = new StringBuilder();
        sb.append("[");

        for (int i = 0; i < list.size(); i++) {
            StoreDTO s = list.get(i);

            if (i > 0) sb.append(",");

            sb.append("{");
            sb.append("\"storeId\":").append(s.getStoreId()).append(",");
            sb.append("\"storeCode\":\"").append(escapeJson(s.getStoreCode())).append("\",");
            sb.append("\"storeName\":\"").append(escapeJson(s.getStoreName())).append("\",");
            sb.append("\"address\":\"").append(escapeJson(s.getAddress())).append("\",");
            sb.append("\"lat\":").append(s.getLat()).append(",");
            sb.append("\"lng\":").append(s.getLng()).append(",");
            sb.append("\"description\":\"").append(escapeJson(s.getDescription())).append("\",");
            sb.append("\"kakaoUrl\":\"").append(escapeJson(s.getKakaoUrl())).append("\",");
            sb.append("\"phone\":\"").append(escapeJson(s.getPhone())).append("\",");
            sb.append("\"businessHours\":\"").append(escapeJson(s.getBusinessHours())).append("\",");
            sb.append("\"sortNo\":").append(s.getSortNo());
            sb.append("}");
        }

        sb.append("]");

        response.getWriter().write(sb.toString());
    }

    // 최소 이스케이프(따옴표/개행/역슬래시)
    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "")
                .replace("\n", "\\n");
    }
}
