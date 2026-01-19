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

    const userName = "${sessionScope.loginUser.name}";
    const productName = "${param.productName}" || "상품";
    const finalPrice = Number("${finalPrice}") || 0;
    const buyerEmail = "${sessionScope.loginUser.email}";
    
    let isPaymentCompleted = false; // 결제 완료 플래그

    console.log("=== 결제 시작 ===");
    console.log("userName:", userName);
//  console.log("userid:", userid);
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
                    isPaymentCompleted = true;
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

    // 브라우저 창 닫기 전 처리
    window.addEventListener('beforeunload', function(e) {
        clearInterval(sessionCheckInterval);
        
        // 결제가 완료되지 않은 상태로 브라우저 창을 닫을 때
        if (!isPaymentCompleted) {
            // FAIL 처리 (동기 방식)
            $.ajax({
                url: "<%= request.getContextPath() %>/payment/paymentFail.hp",
                type: "POST",
                async: false,
                data: {
                    orderId: "${sessionScope.readyOrderId}",
                    pgTid: "",
                    errorMessage: "사용자가 결제창을 닫음"
                }
            });
        }
    });

    const merchantUid = "order_" + new Date().getTime();

    IMP.request_pay({
        pg: "html5_inicis",
        pay_method: "card",
        merchant_uid: merchantUid,
        name: productName,
        amount: 100,
        buyer_name: userName,
        buyer_email: buyerEmail
    }, function (rsp) {

    //    console.log("=== 결제 콜백 시작 ===");
    //   console.log("rsp.success:", rsp.success);
    //   console.log("rsp.imp_uid:", rsp.imp_uid);
    //    console.log("rsp.merchant_uid:", rsp.merchant_uid);

        clearInterval(sessionCheckInterval);

        
        if (rsp.success) {
    //        console.log(" 결제 성공");
            
            isPaymentCompleted = true; // 플래그 설정
           
         // opener 체크 추가!
            if (!opener || opener.closed) {
                alert("부모 창이 닫혔습니다.\n결제는 완료되었으니 마이페이지에서 확인해주세요.");
                
                // 서버에 결제 완료 알림 (AJAX)
                $.ajax({
                    url: "<%= request.getContextPath() %>/payment/paymentSuccess.hp",
                    type: "POST",
                    async: false,
                    data: {
                        orderId: "${sessionScope.readyOrderId}",
                        imp_uid: rsp.imp_uid,
                        merchant_uid: rsp.merchant_uid,
                        pgTid: rsp.imp_uid
                    },
                    success: function() {
                        window.location.href = "<%= request.getContextPath() %>/myPage/orderList.hp";
                    },
                    error: function() {
                        alert("결제 처리 중 오류가 발생했습니다.\n고객센터로 문의해주세요.");
                        window.close();
                    }
                });
                return;
            }
         
            const payForm = opener.document.getElementById("payForm");

            if (!payForm) {
    //            console.error(" payForm을 찾을 수 없음!");
                alert("결제 처리 중 오류가 발생했습니다.");
                window.close();
                return;
            }

            const paymentStatus = opener.document.createElement("input");
            paymentStatus.type = "hidden";
            paymentStatus.name = "paymentStatus";
            paymentStatus.value = "success";
            payForm.appendChild(paymentStatus);

            const pgTid = opener.document.createElement("input");
            pgTid.type = "hidden";
            pgTid.name = "pgTid";
            pgTid.value = rsp.imp_uid;
            payForm.appendChild(pgTid);

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
            
            payForm.submit();
            window.close();

        } else {
  //          console.log(" 결제 실패: " + rsp.error_msg);
            
            isPaymentCompleted = true; // 플래그 설정

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