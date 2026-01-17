package map.controller;

import java.util.List;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import map.domain.StoreDTO;
import map.model.StoreDAO;
import map.model.StoreDAO_imple;



public class StoreListJSON extends AbstractController {

    private StoreDAO sdao = new StoreDAO_imple();

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        response.setContentType("application/json; charset=UTF-8");

        List<StoreDTO> list = sdao.selectActiveStores();

        StringBuilder sb = new StringBuilder();
        sb.append("[");

        for (int i = 0; i < list.size(); i++) {
            StoreDTO s = list.get(i);

            sb.append("{");
            sb.append("\"storeId\":").append(s.getStoreId()).append(",");
            sb.append("\"storeCode\":\"").append(esc(s.getStoreCode())).append("\",");
            sb.append("\"storeName\":\"").append(esc(s.getStoreName())).append("\",");
            sb.append("\"address\":\"").append(esc(s.getAddress())).append("\",");
            sb.append("\"lat\":").append(s.getLat()).append(",");
            sb.append("\"lng\":").append(s.getLng()).append(",");
            sb.append("\"description\":\"").append(esc(s.getDescription())).append("\",");
            sb.append("\"kakaoUrl\":\"").append(esc(s.getKakaoUrl())).append("\",");
            sb.append("\"phone\":\"").append(esc(s.getPhone())).append("\",");
            sb.append("\"businessHours\":\"").append(esc(s.getBusinessHours())).append("\",");
            sb.append("\"sortNo\":").append(s.getSortNo());
            sb.append("}");

            if (i < list.size() - 1) sb.append(",");
        }

        sb.append("]");

        response.getWriter().write(sb.toString());
        super.setRedirect(false);
        super.setViewPage(null);
    }
}
