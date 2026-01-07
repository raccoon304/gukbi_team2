


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
        //alert("네이게이션 메뉴를 클릭하셨습니다.")
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
    //alert('상품 상세 페이지로 이동합니다.\n상품 ID: ' + productId);
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


	// 상품 카드 호버(마우스 올렸을 때) 효과
	$('.product-card').hover(
	    function() {
	        $(this).find('.product-image-wrapper img').css('transform', 'scale(1.1)');
	    },
	    function() {
	        $(this).find('.product-image-wrapper img').css('transform', 'scale(1)');
	    }
	);

    // 네비게이션 메뉴 클릭
	$('.nav-cart').click(function(e) {
	    e.preventDefault(); // href 막을 때만
	    location.href = '/semiproject/cart/zangCart.hp';
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
    });
	
	
	// 로그아웃 버튼
	$(document).on("click", "#logoutBtn", function () {
		if (!confirm("로그아웃 하시겠습니까?")) return;
		
		location.href = ctxPath + "/member/logout.hp";
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


// ====== 로그인 처리 함수 ======= //
function login() {
	const loginId = $('#loginId').val().trim();
  	const loginPw = $('#loginPw').val().trim();

  	$('#loginError').hide().text('');

  	if (!loginId) {
    	$('#loginError').show().text('아이디를 입력하세요.');
    	$('#loginId').focus();
    return;
 	}
  	if (!loginPw) {
    	$('#loginError').show().text('비밀번호를 입력하세요.');
    	$('#loginPw').focus();
    	return;
  	}

  	$.ajax({
    	url: ctxPath + '/member/login.hp',
    	type: 'post',
    	dataType: 'json',
    	data: { loginId, loginPw },
    	success: function (json) {
	      	if (json.success) {
	        	$('#loginModal').modal('hide');
	
	        	// 성공 시 인덱스 페이지로 이동.
	        	// location.reload();
	        	location.href = json.redirect || (ctxPath + '/index.hp');
	      	} else {
	        $('#loginError').show().text(json.message || '로그인에 실패했습니다.');
	      	}
    	},
		error: function (xhr, status, err) {
		  console.log("statusCode:", xhr.status);
		  console.log("status:", status, "err:", err);
		  console.log("responseText:", xhr.responseText); // 여기 보면 HTML인지 에러메시지인지 나옴
		  $('#loginError').show().text('로그인에 오류가 발생하였습니다.');
		}
  	});
}

// 엔터로 로그인 처리 (아이디/비번 입력 중 Enter 누르면)
$(document).on('keydown', '#loginId, #loginPw', function (e) {
  	if (e.keyCode === 13) {
    	e.preventDefault();
    	login();
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




