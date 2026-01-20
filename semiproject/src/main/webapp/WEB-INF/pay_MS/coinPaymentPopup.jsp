<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>결제 진행</title>

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<!-- 주문 상세 모달 CSS 파일 -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/order/orderDetail.css">
<!-- 또는 -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/myPage/orderModal.css">

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
    
    let isPaymentCompleted = false;
    let isPaymentProcessing = false; // 추가

    if (!finalPrice || finalPrice <= 0) {
        alert("결제 금액 오류");
        window.close();
        return;
    }

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

    // ===== beforeunload 1번만! =====
    window.addEventListener('beforeunload', function(e) {
        // 결제 처리 중일 때 창 닫기 방지
        if (isPaymentProcessing && !isPaymentCompleted) {
            e.preventDefault();
            e.returnValue = '결제 처리 중입니다. 잠시만 기다려주세요.';
            return e.returnValue;
        }
        
        clearInterval(sessionCheckInterval);
        
        // 결제 완료 안 된 상태로 창 닫을 때 FAIL 처리
        if (!isPaymentCompleted) {
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

    const merchantUid = "order_" + "${sessionScope.readyOrderId}";
    
    isPaymentProcessing = true; // 결제 시작
    
    IMP.request_pay({
        pg: "html5_inicis",
        pay_method: "card",
        merchant_uid: merchantUid,
        name: productName,
        amount: 100,
        buyer_name: userName,
        buyer_email: buyerEmail
    }, function (rsp) {
        isPaymentProcessing = false; // 응답 받음
        clearInterval(sessionCheckInterval);

        if (rsp.success) {
            isPaymentCompleted = true;
           
            if (!opener || opener.closed) {
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

            if (opener.window.paymentInProgress !== undefined) {
                opener.window.paymentInProgress = false;
            }
            
            payForm.submit();
            window.close();

        } else {
            isPaymentCompleted = true;

            if (opener && !opener.closed && opener.window.paymentInProgress !== undefined) {
                opener.window.paymentInProgress = false;
            }

            $.post(
                "<%= request.getContextPath() %>/payment/paymentFail.hp",
                {
                    orderId: "${sessionScope.readyOrderId}",
                    pgTid: rsp.imp_uid || "",
                    errorMessage: rsp.error_msg
                },
                function() {
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