


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

	
    // 네비게이션 메뉴 클릭
    $('.navbar-nav .nav-link').click(function() {
        alert("네이게이션 메뉴를 클릭하셨습니다.")
    });


    // 로그인 버튼
    $('#loginBtn').click(function() {
		alert("로그인페이지로 이동합니다.");
		console.log('이동: login.hp');
		// window.location.href = 'login.hp';
    });

    // 회원가입 버튼
    $('#signupBtn').click(function() {
        alert("회원가입페이지로 이동합니다.");
		console.log('이동: memberRegister.hp');
		// window.location.href = 'memberRegister.hp';
    });

    // 상품 카드 호버(마우스 올렸을 때) 효과
    $('.product-card').hover(
        function() {
            $(this).find('.product-image-wrapper img').css('transform', 'scale(1.1)');
        },
        function() {
            $(this).find('.product-image-wrapper img').css('transform', 'scale(1)');
        }
    );
});



// 상품 상세 페이지로 이동
function goToProductDetail(productId) {
    alert('상품 상세 페이지로 이동합니다.\n상품 ID: ' + productId);
    console.log('이동: productDetail.hp?id=' + productId);
    // 실제로는 아래 코드 사용
    // window.location.href = 'productDetail.hp?id=' + productId;
}


// 스크롤 시 네비게이션 그림자 효과
$(window).scroll(function() {
    if ($(this).scrollTop() > 50) {
        $('.navbar-custom').css('box-shadow', '0 4px 12px rgba(0,0,0,0.15)');
    } else {
        $('.navbar-custom').css('box-shadow', '0 2px 8px rgba(0,0,0,0.1)');
    }
});



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

	
    // 네비게이션 메뉴 클릭
    $('.navbar-nav .nav-link').click(function() {
        alert("네이게이션 메뉴를 클릭하셨습니다.")
    });


	// 로그인 버튼
	$('#loginBtn').click(function() {
	  /*alert("로그인페이지로 이동합니다.");*/
	  $('#loginModal').modal('show');
	  console.log('이동: login.hp');
	  // window.location.href = 'login.hp';
	});

    // 회원가입 버튼
    $('#signupBtn').click(function() {
		window.location.href = ctxPath + "/member/memberRegister.hp";
		//console.log('이동: memberRegister.hp');
		// window.location.href = 'memberRegister.hp';
    });

    // 상품 카드 호버(마우스 올렸을 때) 효과
    $('.product-card').hover(
        function() {
            $(this).find('.product-image-wrapper img').css('transform', 'scale(1.1)');
        },
        function() {
            $(this).find('.product-image-wrapper img').css('transform', 'scale(1)');
        }
    );
});



// 상품 상세 페이지로 이동
function goToProductDetail(productId) {
    alert('상품 상세 페이지로 이동합니다.\n상품 ID: ' + productId);
    console.log('이동: productDetail.hp?id=' + productId);
    // 실제로는 아래 코드 사용
    // window.location.href = 'productDetail.hp?id=' + productId;
}


// 스크롤 시 네비게이션 그림자 효과
$(window).scroll(function() {
    if ($(this).scrollTop() > 50) {
        $('.navbar-custom').css('box-shadow', '0 4px 12px rgba(0,0,0,0.15)');
    } else {
        $('.navbar-custom').css('box-shadow', '0 2px 8px rgba(0,0,0,0.1)');
    }
});