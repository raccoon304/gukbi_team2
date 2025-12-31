document.addEventListener("DOMContentLoaded", () => {

  // ================= 전체 선택 =================
  window.toggleSelectAll = function(allChk) {
    document.querySelectorAll(".item-checkbox").forEach(chk => {
      chk.checked = allChk.checked;
    });
    updateTotal();
  };

  // =============== 전체 선택된 체크 박스 중 1개를 삭제하면 전체 칸에 해제가 되는것 =================
  // === 체크박스 전체선택/전체해제 에서 
      //     하위 체크박스에 체크가 1개라도 체크가 해제되면 체크박스 전체선택/전체해제 체크박스도 체크가 해제되고
      //     하위 체크박스에 체크가 모두 체크가 되어지면 체크박스 전체선택/전체해제 체크박스도 체크가 되어지도록 하는 것 === // 
	  
	  const itemCheckboxList = document.querySelectorAll(".item-checkbox");
	   const allCheck = document.querySelector("thead input[type='checkbox']");
	  
	  // === 개별 체크 클릭 시 ===
	  for (let checkbox of itemCheckboxList) {

	    checkbox.addEventListener("click", () => {

	      // 하나라도 해제되면 전체 해제
	      if (!checkbox.checked) {
	        allCheck.checked = false;
	      }
	      else {
	        // 모두 체크되었는지 검사
	        let is_all_checked = true;

	        for (let chk of itemCheckboxList) {
	          if (!chk.checked) {
	            is_all_checked = false;
	            break;
	          }
	        }

	        allCheck.checked = is_all_checked;
	      }

	    });
	  }
  
  // ================= 개별 삭제 =================
  document.querySelectorAll(".btn.btn-danger").forEach(btn => {
    btn.addEventListener("click", () => {
      if (confirm("정말로 삭제하시겠습니까?")) {
        btn.closest("tr").remove();
      }
    });
  });

  // ================= 선택 삭제 =================
  document.querySelector(".btn.btn-danger.my-3")
    .addEventListener("click", () => {

		
		const checkedItems = document.querySelectorAll(".item-checkbox:checked");
		    if (checkedItems.length === 0) {
		      alert("삭제할 상품을 선택하세요.");
		      return;
		    }

		    if (!confirm("정말로 선택한 상품을 삭제하시겠습니까?")) return;

		    checkedItems.forEach(chk => {
		      chk.closest("tr").remove();
		    });

		    updateTotal();
		  });

  // ================= 금액 계산 =================
  window.updateTotal = function() {
    let total = 0;

    document.querySelectorAll(".item-checkbox:checked").forEach(chk => {
      const row = chk.closest("tr");
      const priceText = row.querySelector("td.price:last-child").innerText;
      const price = Number(priceText.replace(/[^0-9]/g, ""));
      total += price;
    });

    document.getElementById("totalProductPrice").innerText = total.toLocaleString() + "원";
    document.getElementById("totalDiscount").innerText = "0원";
    document.getElementById("finalTotal").innerText = total.toLocaleString() + "원";
  };
  
  
  // ========= 구매하기 버튼을 누르면 구매 및 결제 페이지로 이동 (단 1개의 상품도 없을때 ) ================
  $(function () {

    $(".checkout-btn").on("click", function () {

      const checkedCount = $(".item-checkbox:checked").length;

      if (checkedCount != 0) {
        alert("주문한 상품이 없습니다."); // ㅎㅇ
        return;
      }

      // 주문 / 결제 페이지 이동
      location.href = ctxPath + "/pay/payMent.hp";
    });

  });
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

});