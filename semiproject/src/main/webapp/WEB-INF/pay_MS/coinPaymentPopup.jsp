<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>결제 진행</title>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
</head>

<body>

<script>
$(function () {

    const IMP = window.IMP;
    IMP.init("imp11367665");

    const userid = "${userid}";
    const userName = "${sessionScope.loginUser.name}";  // ✅ 로그인한 사용자 이름
    const finalPrice = Number("${finalPrice}") || 0;

    console.log("=== 결제 시작 ===");
    console.log("userid:", userid);
    console.log("userName:", userName);
    console.log("finalPrice:", finalPrice);
    console.log("readyOrderId:", "${sessionScope.readyOrderId}");

    if (!finalPrice || finalPrice <= 0) {
        alert("결제 금액 오류");
        window.close();
        return;
    }

    // 세션 체크 인터벌 시작
    let sessionCheckInterval = setInterval(function() {
        $.ajax({
            url: '<%= request.getContextPath() %>/member/checkSession.hp',
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                if (!data.isLoggedIn) {
                    clearInterval(sessionCheckInterval);
                    alert('세션이 만료되었습니다.\n결제를 계속하려면 다시 로그인해주세요.');

                    if (window.opener && !window.opener.closed) {
                        window.opener.location.href = '<%= request.getContextPath() %>/member/login.hp';
                    }

                    window.close();
                }
            },
            error: function() {
                clearInterval(sessionCheckInterval);
            }
        });
    }, 5000);

    $(window).on('beforeunload', function() {
        clearInterval(sessionCheckInterval);
    });

    const merchantUid = "order_" + new Date().getTime();

    IMP.request_pay({
        pg: "html5_inicis",
        pay_method: "card",
        merchant_uid: merchantUid,
        name: "ShopMall 상품 결제",  // ✅ 상품명
        amount: 100,  // 테스트용 100원
        buyer_name: userName  // ✅ 로그인한 사용자 이름
    }, function (rsp) {

        console.log("=== 결제 콜백 시작 ===");
        console.log("rsp.success:", rsp.success);
        console.log("rsp.imp_uid:", rsp.imp_uid);
        console.log("rsp.merchant_uid:", rsp.merchant_uid);

        clearInterval(sessionCheckInterval);

        if (rsp.success) {
            console.log(" 결제 성공");

            const payForm = opener.document.getElementById("payForm");

            if (!payForm) {
                console.error("❌ payForm을 찾을 수 없음!");
                alert("결제 처리 중 오류가 발생했습니다.");
                window.close();
                return;
            }

            //  필수 파라미터: paymentStatus
            const paymentStatus = opener.document.createElement("input");
            paymentStatus.type = "hidden";
            paymentStatus.name = "paymentStatus";
            paymentStatus.value = "success";
            payForm.appendChild(paymentStatus);

            //  필수 파라미터: pgTid (PG 거래번호)
            const pgTid = opener.document.createElement("input");
            pgTid.type = "hidden";
            pgTid.name = "pgTid";
            pgTid.value = rsp.imp_uid;
            payForm.appendChild(pgTid);

            // 결제 검증용 값
            const impUid = opener.document.createElement("input");
            impUid.type = "hidden";
            impUid.name = "imp_uid";
            impUid.value = rsp.imp_uid;
            payForm.appendChild(impUid);

            const merchantUidInput = opener.document.createElement("input");
            merchantUidInput.type = "hidden";
            merchantUidInput.name = "merchant_uid";
            merchantUidInput.value = rsp.merchant_uid;
            payForm.appendChild(merchantUidInput);

            console.log(" payForm submit 실행");
            console.log("  - paymentStatus: success");
            console.log("  - pgTid:", rsp.imp_uid);
            
            payForm.submit();

            window.close();

        } else {
            console.log(" 결제 실패: " + rsp.error_msg);

            // PG 즉시 실패 → 서버에 FAIL 통보
            $.post(
                "<%= request.getContextPath() %>/payment/paymentFail.hp",
                {
                    orderId: "${sessionScope.readyOrderId}",
                    pgTid: rsp.imp_uid || "",
                    errorMessage: rsp.error_msg
                },
                function() {
                    console.log("paymentFail.hp 호출 완료");
                    alert("결제 실패: " + rsp.error_msg);

                    if (opener && !opener.closed) {
                        opener.location.href = "<%= request.getContextPath() %>/pay/payMent.hp";
                    }

                    window.close();
                }
            );
        }
    });

});
</script>

</body>
</html>