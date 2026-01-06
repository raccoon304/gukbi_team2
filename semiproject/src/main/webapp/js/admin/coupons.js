$(document).ready(function() {

    let couponCategoryNo = null;
	let couponName = "";
	let globalSelectAll = false;                 // 전체선택 모드
	let selectedSet = new Set();                 // (전체선택 모드 아닐 때) 선택된 회원들
	let deselectedSet = new Set();               // (전체선택 모드일 때) 예외로 해제한 회원들
	let totalCount = 0;


	// 쿠폰 발급 받을 회원 리스트
	function loadCouponMemberSelect(pageNo) {

		const searchType = $("#searchType").val();
	    const searchWord = $("#searchWord").val();

	    $.ajax({
	      url: ctxPath + "/admin/couponMemberSelect.hp",
	      method: "GET",
	      dataType: "html",
	      data: {
	        sizePerPage: $("#pageSize").val(),
	        currentShowPageNo: pageNo,
	        searchType: searchType,
	        searchWord: searchWord
	      },
	      success: function (html) {
	        const tmp = $("<div>").html(html);

	        // rows/pagebar
	        $("#memberSelectTableBody").html(tmp.find("#memberRows").html() || "");
	        $("#pagination").html(tmp.find("#modalPageBarHtml").html() || "");

	        // totalCount 받기
	        totalCount = parseInt(tmp.find("#totalCountHtml").text() || "0", 10);

	        // 복원/전체선택 반영
	        applySelectionStateToCurrentPage();
	      },
	      error: function () {
	        $("#memberSelectTableBody").html("<tr><td colspan='6' class='text-center text-danger py-4'>회원 목록 조회 실패</td></tr>");
	        $("#pagination").html("");
	      }
	    });
	}
	
	
	
	// 모달 페이지바 클릭 시 해당 페이지 로드
	$(document).on("click", "a.modal-page", function(e){
	  e.preventDefault();
	  loadCouponMemberSelect($(this).data("page"));
	});
	
	
	// 검색버튼 클릭하면 1페이지부터 다시 로드
	$('#searchBtn').click(function(e){
	  e.preventDefault();
	  loadCouponMemberSelect(1);
	});
	
	// 엔터로 검색
	$('#searchWord').on('keydown', function(e){
	  if(e.key === 'Enter'){
	    e.preventDefault();
	    loadCouponMemberSelect(1);
	  }
	});
	
	



    // 쿠폰 생성 Create coupon
    $('#submitCoupon').click(function() {
        const couponName = $('#couponName').val().trim();;
        const discountType = $('#discountType').val();
        const discountValue = $('#discountValue').val().trim();

		
		console.log('len', $('#couponName').length, $('#discountType').length, $('#discountValue').length);
		console.log('vals', $('#couponName').val(), $('#discountType').val(), $('#discountValue').val());
		
        if (!couponName || !discountValue) {
            alert('모든 값을 입력해주세요.');
            return;
        }

	
		const discountValueNum = parseInt(discountValue, 10);

		  if (discountType === "percentage") {
		    // 정률: 1~100
		    if (discountValueNum < 1 || discountValueNum > 100) {
		      alert("비율 할인은 1~100 사이만 입력 가능합니다.");
		      return;
		    }
		  } else { 
		    // 정액: 5000 이상 + 5000 단위
		    if (discountValueNum < 5000) {
		      alert("금액 할인은 최소 5,000원 이상 입력하세요.");
		      return;
		    }
		    if (discountValueNum % 5000 !== 0) {
		      alert("금액 할인은 5,000원 단위로만 입력 가능합니다.");
		      return;
		    }
		  }
		  
        $.ajax({
            url: ctxPath + '/admin/couponCreate.hp',
            method: 'POST',
            dataType: 'json',
            data: {
                couponName: couponName,
                discountType: discountType,
                discountValue: discountValueNum,
            },
            success: function(json) {
				alert(json.message);
				location.href = json.loc;
        
            },
            error: function() {
                alert('쿠폰 생성에 실패했습니다.');
            }
        });
    });
	
	
	// 쿠폰 생성시 할인값 설정(마우스 클릭)
	function applyDiscountValueConstraints() {
	  const type = $("#discountType").val();
	  
	//  $("#discountValue").attr({ min: 1, step: 1 });

	  if (type === "percentage") {// 정률일때
		
	    $("#discountValue")
	      .attr({ min: 1, max: 100, step: 1 })
	      .prop("placeholder", "1~100")
	      .val(function(_, v){
	        const n = parseInt(v, 10);
	        if (isNaN(n)) return v;
	        return Math.min(n, 100);
	      });
		  
	  } else { // 정액일때
	    $("#discountValue")
		  .attr({ min: 5000, step: 5000 }) 
	      .removeAttr("max")
	      .prop("placeholder", "단위 : 5,000 (원)")
	  }
	}

	// 타입 변경 시 적용
	$(document).on("change", "#discountType", function () {
	  applyDiscountValueConstraints();
	});

	// 쿠폰 생성 모달 열릴 때도 초기 적용(기본값 percentage)
	$("#createCouponModal").on("shown.bs.modal", function () {
	  applyDiscountValueConstraints();
	});
	
	
	// 할인값 키보드 입력 설정(즉시)
	$(document).on("input", "#discountValue", function () {
		
		this.value = this.value.replace(/[^\d]/g, "");

		  const type = $("#discountType").val();
		  if (type === "percentage" && this.value !== "") {
		    let n = parseInt(this.value, 10);
		    if (n > 100) this.value = "100"; // 정률은 100 초과만 컷 (입력 방해 최소화)
		  }
		
	});
	
	// 할인값 키보드 입력 설정(포커스 잃었을때)
	$(document).on("blur", "#discountValue", function () {
	  if (this.value == "") return;

	  let n = parseInt(this.value, 10);
	  const type = $("#discountType").val();

	  if (type == "percentage") {
	    if (n < 1) n = 1;
	    if (n > 100) n = 100;
	  } else {
	    if (n < 5000) n = 0;
	    n = Math.floor(n / 5000) * 5000; // 5000 단위 버림
	  }

	  this.value = n;
	});
	
	
	// 쿠폰 생성 모달 닫힐 때 입력값 초기화(취소 버튼 포함)
	$("#createCouponModal").on("hidden.bs.modal", function () {
		
	  // form 값 초기화
	  document.getElementById("createCouponForm").reset();

	  // 남아있는 값/속성 초기화
	  $("#couponName").val("");
	  $("#discountValue").val("");

	  // 할인타입 기본값
	  $("#discountType").val("percentage");

	  // min/max/step 다시 적용
	  applyDiscountValueConstraints();
	});
	
	
	
	// 쿠폰 리스트에서 필터 바뀌면 submit
	$(document).on("change", "#filterType, #filterSort", function () {
	  $("#couponFilterFrm").submit();
	});
	
	

    // 쿠폰 전송 버튼 클릭
    $('#sendMoreCoupons').click(function() {
		if (!couponCategoryNo) return;

	    $('#issuedMembersModal').modal('hide');

	    // 안내문구
	    $('#couponInfo').html(`<strong>쿠폰:</strong> ${couponName} (No.${couponCategoryNo})`);

	    // 만료일 초기화
	    $('#expireDate').val("");

	    // 회원 선택 모달 오픈 + 1페이지 로드
		$("#issuedMembersModal").one("hidden.bs.modal", function () {
		    $("#memberSelectModal").modal("show");
		    loadCouponMemberSelect(1);
		  });
    });

	
	// 회원 선택 모달 닫힐 때 선택 초기화
	function resetMemberSelectModalState() {

	  // UI 해제
	  $("#selectAllMembers").prop("checked", false);
	  $("#memberSelectTableBody .member-checkbox").prop("checked", false);
	  $("#selectedCount").text("0");

	  // 입력값 초기화
	  $("#expireDate").val("");
	  $("#searchWord").val("");
	  $("#searchType").val("member_id");
	  $("#pageSize").val("5");

	  // 전송버튼 복구
	  $("#sendCoupon").prop("disabled", false);

	  // 선택상태 변수 초기화
	  globalSelectAll = false;
	  selectedSet.clear();
	  deselectedSet.clear();
	  totalCount = 0;

	  // hidden 값 정리
	  $("#hiddenAllSelected").val("0");
	  $("#hiddenDeselectedIds").val("");
	  $("#hiddenMemberIds").val("");
	  $("#hiddenExpireDate").val("");
	}

	// document에 위임
	$(document).on("hidden.bs.modal", "#memberSelectModal", function () {
	  console.log("memberSelectModal hidden fired");
	  resetMemberSelectModalState();
	});
	
	
	

	
    // 개별 체크
    $(document).on('change', '.member-checkbox', function() {
		const id = String($(this).data("member-id"));
	    const checked = $(this).is(":checked");

	    if (globalSelectAll) {
	      // 전체선택 모드에서는 해제한 것만 예외로 기억
	      if (!checked) deselectedSet.add(id);
	      else deselectedSet.delete(id);
		  
	    } else {
	      // 일반 모드에서는 선택된 것만 기억
	      if (checked) selectedSet.add(id);
	      else selectedSet.delete(id);
	    }

	    syncSelectAllState();
	    updateSelectedCount();
    });

	
    // 전체 체크
    $('#selectAllMembers').change(function() {
		const isChecked = $(this).is(":checked");

	    if (isChecked) {
	      // 전체선택 ON
	      globalSelectAll = true;
	      selectedSet.clear();
	      deselectedSet.clear();

	      // 현재 페이지 즉시 전부 체크
	      $("#memberSelectTableBody .member-checkbox").prop("checked", true);
	    } else {
	      // 전체 해제(OFF)
	      globalSelectAll = false;
	      selectedSet.clear();
	      deselectedSet.clear();

	      $("#memberSelectTableBody .member-checkbox").prop("checked", false);
	    }

	    syncSelectAllState();
		updateSelectedCount();
    });
	
	
	function updateSelectedCount() {
		let cnt = 0;

	    if (globalSelectAll) {
	     
	      cnt = Math.max(0, totalCount - deselectedSet.size);
	    } else {
	      cnt = selectedSet.size;
	    }

	    $("#selectedCount").text(cnt);
	 }

	 
	 
    // Page size change
    $('#pageSize').change(function() {
        loadCouponMemberSelect(1);
    });



	// 쿠폰 전송
	$("#issueCouponForm").on("submit", function(e){
	
		const expireDate = $("#expireDate").val();
	    if (!expireDate) {
	      alert("만료일을 선택하세요.");
	      e.preventDefault();
	      return;
	    }

	    $("#hiddenCouponCategoryNo").val(couponCategoryNo);
	    $("#hiddenExpireDate").val(expireDate);

	    if (globalSelectAll) {
	      // 전체선택 모드 제출: ALL + 예외 + 현재 검색조건도 같이 보내기
	      $("#hiddenAllSelected").val("1");
	      $("#hiddenDeselectedIds").val(Array.from(deselectedSet).join(","));
	      $("#hiddenSearchType").val($("#searchType").val());
	      $("#hiddenSearchWord").val($("#searchWord").val());

	    
	      $("#hiddenMemberIds").val("");
		  
	    } else {
	      // 일반 제출: 선택된 id들만
	      if (selectedSet.size === 0) {
	        alert("최소 1명 선택하세요.");
	        e.preventDefault();
	        return;
	      }
	      $("#hiddenAllSelected").val("0");
	      $("#hiddenDeselectedIds").val("");
	      $("#hiddenMemberIds").val(Array.from(selectedSet).join(","));
	    }

	    // 더블클릭 방지
	    $("#sendCoupon").prop("disabled", true);
	  
	});
	
	
	// 페이지바 이동 후에도 전체 선택 상태 유지
	function syncSelectAllState() {
	  const boxes = $("#memberSelectTableBody .member-checkbox");
	  const total = boxes.length;

	  if (total === 0) {
	    $("#selectAllMembers").prop("checked", false);
	    return;
	  }

	  const checked = boxes.filter(":checked").length;
	  $("#selectAllMembers").prop("checked", total === checked);
	  
	  
	  
	}

	
	// 현재 페이지의 체크박스들 상태 유지
	function applySelectionStateToCurrentPage() {
	    
	    $("#memberSelectTableBody .member-checkbox").each(function () {
	      const id = String($(this).data("member-id"));

	      if (globalSelectAll) {
	        $(this).prop("checked", !deselectedSet.has(id));
	      } else {
	        $(this).prop("checked", selectedSet.has(id));
	      }
	    });

	    syncSelectAllState();
	    updateSelectedCount();
	}
	
	
	// 쿠폰 리스트 한 행을 누르면 발급 받은 회원 목록이 뜨게함
	function loadIssuedMembers(pageNo){
		$.ajax({
		    url: ctxPath + "/admin/couponIssuedMembers.hp",
		    method: "GET",
		    dataType: "html",
		    data: {
		      couponCategoryNo: couponCategoryNo,
		      sizePerPage: 10,
		      currentShowPageNo: pageNo,
			  filter: $("#issuedFilter").val()
		    },
		    success: function(html){
				const tmp = $("<div>").html(html);

				  console.log("issuedRows:", tmp.find("#issuedRows").length);
				  console.log("issuedPageBarHtml:", tmp.find("#issuedPageBarHtml").length);
				  console.log("issuedPageBarHtml inner:", tmp.find("#issuedPageBarHtml").html());

				  $("#issuedMembersTableBody").html(tmp.find("#issuedRows").html() || "");
				  $("#issuedPagination").html(tmp.find("#issuedPageBarHtml").html() || "");

				  $("#issuedMembersModal").modal("show");
		    },
		    error: function(){
		      $("#issuedMembersTableBody").html("<tr><td colspan='6' class='text-center text-danger py-4'>조회 실패</td></tr>");
		      $("#issuedPagination").html("");
		      $("#issuedMembersModal").modal("show");
		    }
		  });
	}

	// 쿠폰 행 클릭 시 -> 1페이지 로드
	$(document).on("click", "tr.coupon-row", function(e){
		
		
	  if ($(e.target).closest(".coupon-action, form[action*='couponDisable'], form[action*='couponEnable'], button, a").length > 0) {
		  return;
	  }	
		
      const usable = parseInt($(this).data("usable"), 10);
      if (usable === 0) {
		  // 사용안함 쿠폰은 모달 안 뜨게
		  alert("사용안함 처리된 쿠폰은 발급 내역을 조회할 수 없습니다.");
		  return;
	  }
		
	  
	  couponCategoryNo = $(this).data("coupon-no");
	  couponName = $(this).data("coupon-name");

	  $("#issuedCouponInfo").html(`<strong>쿠폰:</strong> ${couponName} (No.${couponCategoryNo})`);

	  loadIssuedMembers(1);
	});
	
	
	// 전체/미사용 필터 바꾸면 1페이지부터 다시 보여줌
	$(document).on("change", "#issuedFilter", function(){
	  if(!couponCategoryNo) return;
	  loadIssuedMembers(1);
	});

	// issued 페이지바 클릭
	$(document).on("click", "a.issued-page", function(e){
		e.preventDefault();
		  loadIssuedMembers($(this).data("page"));
	});

	// issued 페이지사이즈 변경
	$("#issuedPageSize").change(function(){
	  if(!couponCategoryNo) return;
	  loadIssuedMembers(1);
	});
	
	
	// 쿠폰 사용 안함 처리
	$(document).on("click", ".btn-disable-coupon", function(e){
	  e.stopPropagation(); // 혹시 몰라서 한번 더
	  if(!confirm("미사용(만료 전) 발급건이 0명일 때만 사용안함 처리됩니다.")){
	    e.preventDefault(); // submit 취소
	  }
	});
	
	// tr 클릭 이벤트랑 버튼 사용안함 클릭 충돌 방지
	$(document).on("click", "form[action*='couponDisable'], form[action*='couponEnable'], .coupon-action", function(e){
	  e.stopPropagation(); // tr 클릭 이벤트 방지
	});
	
	  
});