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
    const finalPrice = Number("${finalPrice}") || 0;

    if (!finalPrice || finalPrice <= 0) {
        alert("결제 금액 오류");
        window.close();
        return;
    }

    const merchantUid = "order_" + new Date().getTime();

    IMP.request_pay({
        pg: "html5_inicis",
        pay_method: "card",
        merchant_uid: merchantUid,
        name: "ㅇ",
        amount: 100,
        buyer_name: userid
    }, function (rsp) {
    	
    	if (rsp.success) {

    	    const payForm = opener.document.getElementById("payForm");

    	    // 결제 검증용 값만 추가
    	    const impUid = opener.document.createElement("input");
    	    impUid.type = "hidden";
    	    impUid.name = "imp_uid";
    	    impUid.value = rsp.imp_uid;

    	    const merchantUidInput = opener.document.createElement("input");
    	    merchantUidInput.type = "hidden";
    	    merchantUidInput.name = "merchant_uid";
    	    merchantUidInput.value = rsp.merchant_uid;

    	    payForm.appendChild(impUid);
    	    payForm.appendChild(merchantUidInput);

    	    // 기존 payForm submit (모든 주문 데이터 포함)
    	    payForm.submit();

             window.close();

         } else {
             alert("결제 실패: " + rsp.error_msg);
             window.close();
         }
     });

 });
 </script>

 </body>
 </html>