package util.sms;

import java.util.HashMap;

import org.json.simple.JSONObject;

import jakarta.servlet.ServletContext;
import net.nurigo.java_sdk.api.Message;

public class SmsService {

    private final String apiKey;
    private final String apiSecret;
    private final String fromPhone;

    public SmsService(ServletContext app) {
        this.apiKey = app.getInitParameter("COOLSMS_API_KEY");
        this.apiSecret = app.getInitParameter("COOLSMS_API_SECRET");
        this.fromPhone = app.getInitParameter("COOLSMS_FROM_PHONE");
    }

    // ===== 공통: 설정 누락 체크 =====
    private void validateConfig() {
        if (apiKey == null || apiSecret == null || fromPhone == null) {
            throw new IllegalStateException(
                "COOLSMS 설정 누락(web.xml context-param 확인): " +
                "apiKey=" + apiKey + ", apiSecret=" + apiSecret + ", fromPhone=" + fromPhone
            );
        }
    }

    // ===== 공통: send 실행 + 성공판단 =====
    private boolean sendSms(String toMobile, String text) throws Exception {

        validateConfig();

        Message coolsms = new Message(apiKey, apiSecret);

        HashMap<String, String> smsMap = new HashMap<>();
        smsMap.put("to", toMobile);
        smsMap.put("from", fromPhone);
        smsMap.put("type", "SMS");
        smsMap.put("text", text);
        smsMap.put("app_version", "JAVA SDK v2.2");

        JSONObject jsObj = coolsms.send(smsMap);

        // 응답 로그(문제 생기면 여기 보면 됨)
        System.out.println("[SmsService] response=" + jsObj.toString());

        Object successCntObj = jsObj.get("success_count");
        Object errorCntObj   = jsObj.get("error_count");

        long successCount = (successCntObj == null) ? 0 : Long.parseLong(successCntObj.toString());
        long errorCount   = (errorCntObj   == null) ? 0 : Long.parseLong(errorCntObj.toString());

        // 성공 판정 통일
        return (successCount == 1 && errorCount == 0);
    }

    /** 인증코드 SMS 발송 */
    public boolean sendVerificationCode(String toMobile, String code) throws Exception {

        System.out.println("[SmsService] apiKey=" + apiKey + ", apiSecret=" + apiSecret + ", fromPhone=" + fromPhone);

        String text = "[SIST SIX] 인증코드: " + code + " (5분 내 입력)";
        return sendSms(toMobile, text);
    }

    /** 임시비밀번호 발송(SMS) */
    public boolean sendTempPassword(String toMobile, String tempPwd) throws Exception {

        String text = "[SIST SIX] 임시비밀번호: " + tempPwd + "  로그인 후 비밀번호를 변경하세요.";
        return sendSms(toMobile, text);
    }

    /** 일반 메시지 발송(관리자 등 공용) */
    public boolean sendText(String toMobile, String text) throws Exception {

        return sendSms(toMobile, text);
    }
}
