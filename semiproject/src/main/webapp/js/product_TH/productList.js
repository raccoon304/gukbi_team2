/*
// form 테이블을 이용해 데이터값을 java 파일로 보내주기
// 아래 코드에선 jsp의 <span>태그에 있는 productCode를 가져와 productDetail.hp로 보냄
$(function(){
	//테이블의 행을 클릭하면 클릭한 정보의대표값(productCode)을 제품상세페이지에 보내주기
	$("tbody > tr").click((e) => {
		const productCode = $(e.target).parent().find("span").text();
		console.log(productCode);
		
		const frm = document.productCodeFrm;
		frm.productCode.value = productCode;
		frm.action = "productDetail.hp";
		frm.submit();
	});
});//and of $(function(){})-----*/

$(function() {
	const $searchInput = $("#searchInput");
	const $searchBtn = $("#searchBtn");
	const $brandBtns = $(".brand-btn");
	const $sortSelect = $("#sortSelect");
	const $products = $(".product-item");
	const $totalCount = $("#totalCount");
	const $productRow = $(".product-item").parent();
	
	let selectedBrand = "all";
	
	applyFilterAndSort();
/* =====================
      필터 + 정렬 핵심 함수
   ====================== */
	function applyFilterAndSort() {
		const keyword = $searchInput.val().toLowerCase();
		let visibleCount = 0;
		let $visibleItems = $();
		
		// 필터링 해주기
		$products.each(function() {
			const $item = $(this);
			const brand = $item.data("brand");
			const name = $item.data("name").toLowerCase();
			
			let isVisible = true;
			
			// 브랜드 필터
			if(selectedBrand != "all" && brand != selectedBrand) {
				isVisible = false;
			}

			// 검색어 필터
			if(keyword && !name.includes(keyword)) {
				isVisible = false;
			}
			
			$item.toggle(isVisible);
			
			if(isVisible){
				visibleCount++;
				$visibleItems = $visibleItems.add($item);
			}
		});
		
		// 정렬해주기(보이는 상품)
		if($sortSelect.val() == "price_high") {
			$visibleItems.sort((a, b) => 
				$(b).data("price") - $(a).data("price")
			);
		} else if($sortSelect.val() == "price_low") {
			$visibleItems.sort((a, b) => 
				$(a).data("price") - $(b).data("price")
			);
		}
		
		// 재배치 해주기
		$productRow.append($visibleItems);
		
		// 결과 개수 갱신
		$totalCount.text(visibleCount);
	}//end of function applyFilterAndSort()-----
	
	
	/* =====================
	   이벤트 바인딩
	====================== */
	// 검색 버튼
	$searchBtn.on("click", applyFilterAndSort);
	
	// 엔터 검색
	$searchInput.on("keyup", function(e){
		if(e.key == "Enter") {
			applyFilterAndSort();
		}
	});
	
	// 정렬 변경
	$sortSelect.on("change", applyFilterAndSort);
	
	// 브랜드 버튼
	$brandBtns.on("click", function() {
		$brandBtns.removeClass("active");
		$(this).addClass("active");
		selectedBrand = $(this).data("brand");
		applyFilterAndSort();
	});
		
	
});