

$(function() {
	const $searchInput = $("#searchInput");
	const $searchBtn = $("#searchBtn");
	const $brandBtns = $(".brand-btn");
	const $sortSelect = $("#sortSelect");
	const $products = $(".product-item");
	const $totalCount = $("#totalCount");
	
	
	const $productRow = $(".product-item").parent();
	
	//페이징
	const $pagination = $("#pagination");
	const $currentPage = $("#currentPage");
	const $totalPages = $("#totalPages");
	
	let selectedBrand = "all";
	
	//페이징 상태
	const pageSize = 16; //한 페이지 16개
	let currentPage = 1; //현재 페이지 1부터 시작
	
	applyFilterAndSort();
	
	
/* =====================
      필터 + 정렬 핵심 함수
   ====================== */
	function applyFilterAndSort(page = 1) {
		const keyword = $searchInput.val().toLowerCase();
		
		//let visibleCount = 0;
		let $visibleItems = $();
		
		// 1.필터링 해주기
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
			
			//일단 숨겨놓고 마지막 페이지에 해당하는 것만 보여주기
			$item.hide();
			
			//$item.toggle(isVisible);
			
			if(isVisible){
				//visibleCount++;
				$visibleItems = $visibleItems.add($item);
			}
		});
		
		// 2.정렬해주기(보이는 상품)
		const sortVal = $sortSelect.val();
		
		$visibleItems = $($visibleItems.get().sort((a,b) => {
			const $a = $(a);
			const $b = $(b);

			const pa = Number($a.data("price"));
			const pb = Number($b.data("price"));

			const na = $a.data("name").toLowerCase();
			const nb = $b.data("name").toLowerCase();

			if (sortVal === "price_high") return pb - pa;
			if (sortVal === "price_low") return pa - pb;

			// ✅ 기본 정렬 → 상품명 가나다순
			if (sortVal === "default") return na.localeCompare(nb);

			return 0;
		}));
		
		
		// 3.재배치 해주기
		$productRow.append($visibleItems);
		
		
		// 4.페이징 계산해주기
		const total = $visibleItems.length;
		const pages = Math.max(1, Math.ceil(total/pageSize));
		
		//요청한 페이지가 범위를 벗어나면 보정해주기
		currentPage = Math.min(Math.max(1, page), pages);
		
		
		// 5.현재 페이지에 해당하는 16개의 상품만 보여주기
		const start = (currentPage - 1) * pageSize;
		const end = start + pageSize;
		$visibleItems.slice(start, end).show();
		
		
		// 6.결과 개수/페이지 UI 갱신해주기
		$totalCount.text(total);
		$currentPage.text(currentPage);
		$totalPages.text(pages);
		
		// 결과 개수 갱신
		//$totalCount.text(visibleCount);
		
		// 7.페이지 버튼 렌더링
		renderPagination(pages);
	}//end of function applyFilterAndSort()-----
	
	
	/* =====================
	   페이지 버튼 생성
	====================== */
	function renderPagination(totalPages) {
		$pagination.empty();
		
		//이전버튼
		$pagination.append(makePageItem("«", currentPage-1, currentPage===1));
		
		//번호표시(우선 앞뒤로 두 개씩만)
		const windowSize = 2;
		let start = Math.max(1, currentPage - windowSize);
		let end = Math.min(totalPages, currentPage + windowSize);
		
		//앞에 ... 처리해주기
		if(start > 1){
			$pagination.append(makePageItem("1", 1, false, currentPage === 1));
			if(start > 2) $pagination.append(makeDots());
		}
		
		for(let p = start; p<= end; p++) {
			$pagination.append(makePageItem(String(p), p, false, p === currentPage));
		}
		
		//뒤에 ... 처리해주기
		if(end < totalPages){
			if(end < totalPages-1) $pagination.append(makeDots());
			$pagination.append(makePageItem(String($totalPages), totalPages, false, currentPage === totalPages));
		}
		
		//다음 버튼
		$pagination.append(makePageItem("»", currentPage+1, currentPage===totalPages));
	}//end of function renderPagination(totalPages)-----
	
	
	function makePageItem(label, page, disabled, active) {
		const $li = $("<li>").addClass("page-item");
		if(disabled) $li.addClass("disabled");
		if(active) $li.addClass("active");
		
		const $a = $("<a>")
			.addClass("page-link")
			.attr("href", "#")
			.text(label)
			.on("click", function(e) {
				e.preventDefault();
				if(disabled) return;
				applyFilterAndSort(page);
				//UX: 페이지 이동 시 상단으로 살짝 올리기
				window.scrollTo({top: 0, behavior: "smooth"});
			});
			return $li.append($a);
	}
	
	function makeDots() {
		return $("<li>")
			.addClass("page-item disabled")
			.append($("<span>").addClass("page-link").text("..."));
		
	}
	
	
	
	
	/* =====================
	   이벤트 바인딩
	====================== */
	// 검색 버튼
	$searchBtn.on("click", function() {
		applyFilterAndSort(1); //1페이지부터 검색
	});
	
	// 엔터 검색
	$searchInput.on("keyup", function(e){
		if(e.key == "Enter") {
			applyFilterAndSort(1);
		}
	});
	
	// 정렬 변경
	$sortSelect.on("change", function(e) {
		applyFilterAndSort(1);
	});
	
	// 브랜드 버튼
	$brandBtns.on("click", function() {
		$brandBtns.removeClass("active");
		$(this).addClass("active");
		selectedBrand = $(this).data("brand");
		applyFilterAndSort(1);
	});
		
	
});