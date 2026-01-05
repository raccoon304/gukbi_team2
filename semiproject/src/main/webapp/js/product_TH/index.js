

$(document).ready(function() {
    // 슬라이드 자동 재생 시작
    $('#productCarousel').carousel({
        interval: 3000,
        pause: 'hover'
    });

	//=================화면줄일때 이벤트================//
    // 화면을 줄인 상태에서 토글 시 애니메이션
    $('.navbar-toggler').click(function() {
        if ($('.navbar-collapse').hasClass('show')) {
            $('.navbar-collapse').slideUp(300);
        } else {
            $('.navbar-collapse').slideDown(300);
        }
    });
    // 줄인 화면에서 메뉴 클릭 시 자동으로 메뉴 닫기
    $('.navbar-nav .nav-link').click(function() {
        if ($(window).width() < 992) {
            $('.navbar-collapse').collapse('hide');
        }
    });
	//=================화면줄일때 이벤트================//


	// 상품 카드 호버(마우스 올렸을 때) 효과
	$('.product-card').hover(
	    function() {
	        $(this).find('.product-image-wrapper img').css('transform', 'scale(1.1)');
	    },
	    function() {
	        $(this).find('.product-image-wrapper img').css('transform', 'scale(1)');
	    }
	);
	

    // 로그인 버튼
    $('#loginBtn').click(function() {
		/*alert("로그인페이지로 이동합니다.");*/
		$('#loginModal').modal('show');
		console.log('이동: login.hp');
		// window.location.href = 'login.hp';
    });
	

    // 회원가입 버튼
    $('#signupBtn').click(function() {
        alert("회원가입페이지로 이동합니다.");
		console.log('이동: memberRegister.hp');
		// window.location.href = 'memberRegister.hp';
    });

	
	
	//카드 클릭에 대한 이벤트
	const cards = document.querySelectorAll(".product-card");
	cards.forEach(card => {
		card.addEventListener("click", function() {
			const id = card.dataset.id;
			
			//alert(`상품ID: ${id}`);
			
			//카드에 data-id를 통해 제품ID(상품테이블의 상품코드값)를 GET 방식으로 넘겨주기
			window.location.href = 'product/productOption.hp?productCode=' + id;
		});
	});
	
	
});//end of $(document).ready(function(){})-----



// 스크롤 시 네비게이션 그림자 효과
$(window).scroll(function() {
    if ($(this).scrollTop() > 50) {
        $('.navbar-custom').css('box-shadow', '0 4px 12px rgba(0,0,0,0.15)');
    } else {
        $('.navbar-custom').css('box-shadow', '0 2px 8px rgba(0,0,0,0.1)');
    }
});



//==========Function Decalaration==========//
// 상품 상세 페이지로 이동
function goToProductOption(productCode) {
    //alert('상품 상세 페이지로 이동합니다.\n상품 ID: ' + productCode);
    //console.log('이동: productOption.hp?id=' + productCode);
    
	//상품상세 페이지에 체품아이디값(상품테이블의 상품코드 값)을 GET 방식으로 보내주기
    window.location.href = 'product/productOption.hp?productCode=' + productCode;
}





