/* 해당 파일은 사용하지 않는 파일로 다음과 같은 이유. 
 
=====!!!기존 로직!!!=====
[인증코드 입력]
   ↓ (VerifyCertification.hp, form submit)
[세션에 verified=true 저장]
   ↓
[PwdUpdateEnd.hp 이동]
   ↓
[임시비밀번호 생성 + 메일 발송 + msg.jsp]

==> 기존 로직으로 사용했을때 메일 발송시 2~4초 정도 해당 페이지가 보여지면서 넘어갔음. 
	그래서 로직 수정하고 카드형식으로 바꿈. 

=====!!!수정로직!!!=====
[인증코드 입력]
   ↓ AJAX (/verifyCertificationAjax.hp)
[인증코드 검증 + 임시비밀번호 생성 + 메일/SMS 발송]
   ↓
[JSON 응답 → alert → index.hp 이동]








*/
/*
 * package auth.controller;
 * 
 * import java.security.SecureRandom;
 * 
 * import common.controller.AbstractController; import
 * jakarta.servlet.http.HttpServletRequest; import
 * jakarta.servlet.http.HttpServletResponse; import
 * jakarta.servlet.http.HttpSession; import mail.controller.GoogleMail; import
 * member.model.MemberDAO; import member.model.MemberDAO_imple; import
 * util.security.Sha256;
 * 
 * public class PwdUpdateEnd extends AbstractController {
 * 
 * private MemberDAO mdao = new MemberDAO_imple();
 * 
 * @Override public void execute(HttpServletRequest request, HttpServletResponse
 * response) throws Exception {
 * 
 * String userid = request.getParameter("userid"); userid = (userid == null) ?
 * "" : userid.trim();
 * 
 * HttpSession session = request.getSession();
 * 
 * String email = (String) session.getAttribute("pwdfind_email");
 * 
 * // VerifyCertification 성공했는지 체크 VerifyCertification.java 에서 작성 해놨음 검증 플래그를
 * 넣은거임. Boolean verified = (Boolean) session.getAttribute("pwdfind_verified");
 * String verifiedUserid = (String)
 * session.getAttribute("pwdfind_verified_userid");
 * 
 * String message = ""; String loc = request.getContextPath() + "/index.hp";
 * 
 * // 기본 검증 if (userid.isEmpty() || email == null || email.trim().isEmpty()) {
 * message = "비정상적인 접근입니다. 다시 시도해주세요."; loc = request.getContextPath() +
 * "/member/accountFind.hp"; goMsg(request, message, loc); return; }
 * 
 * // 인증 성공 검증 및 userid 매칭 검증 if (verified == null || !verified.booleanValue()
 * || verifiedUserid == null || !userid.equals(verifiedUserid)) { message =
 * "인증이 완료되지 않았습니다. 인증코드를 먼저 확인해주세요."; loc = request.getContextPath() +
 * "/member/accountFind.hp"; cleanup(session); goMsg(request, message, loc);
 * return; }
 * 
 * // 임시비번 생성(영문+숫자 10자리) String tempPwd = makeTempPassword(10);
 * 
 * // DB 저장 String hashedPwd = Sha256.encrypt(tempPwd);
 * 
 * // 검증 완료시 비밀번호 변경 메서드 int n = mdao.updatePasswordByUserid(userid, hashedPwd);
 * 
 * if (n == 1) { try { GoogleMail mail = new GoogleMail();
 * mail.send_temp_password(email, tempPwd); message =
 * "임시비밀번호가 이메일로 발급되었습니다. 로그인 후 비밀번호를 변경하세요."; } catch (Exception e) {
 * //e.printStackTrace(); message =
 * "임시비밀번호 발급은 되었으나, 메일 전송에 실패했습니다. 관리자에게 문의하세요."; } } else { message =
 * "임시비밀번호 발급에 실패했습니다. 다시 시도해주세요."; loc = request.getContextPath() +
 * "/member/accountFind.hp"; }
 * 
 * // 세션을 정리해서 재호출 막음 . cleanup(session);
 * 
 * goMsg(request, message, loc); }
 * 
 * private void goMsg(HttpServletRequest request, String message, String loc)
 * throws Exception { request.setAttribute("message", message);
 * request.setAttribute("loc", loc); super.setRedirect(false);
 * super.setViewPage("/WEB-INF/msg.jsp"); }
 * 
 * // 세션정리 private void cleanup(HttpSession session) {
 * session.removeAttribute("pwdfind_email");
 * session.removeAttribute("pwdfind_verified");
 * session.removeAttribute("pwdfind_verified_userid");
 * session.removeAttribute("certication_code"); }
 * 
 * // 패스워드 만들기 private String makeTempPassword(int len) { final String chars =
 * "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
 * SecureRandom rnd = new SecureRandom(); StringBuilder sb = new
 * StringBuilder(); for (int i = 0; i < len; i++) {
 * sb.append(chars.charAt(rnd.nextInt(chars.length()))); } return sb.toString();
 * } }
 */