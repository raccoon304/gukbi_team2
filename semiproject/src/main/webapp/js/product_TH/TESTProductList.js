


$(document).ready(function() {
    // 전체 상품 데이터 (60개)
    const allProducts = [];
    
    // 상품 데이터 생성 (60개)
    const productNames = [
        '아이폰 16 Pro Max', '아이폰 16 Pro', '아이폰 16', '아이폰 15 Pro Max', '아이폰 15 Pro', 
        '아이폰 15', '갤럭시 S25 Ultra', '갤럭시 S25+', '갤럭시 S25', '갤럭시 S24 Ultra',
        '갤럭시 S24+', '갤럭시 S24', '갤럭시 Z 플립6', '갤럭시 Z 플립5', '갤럭시 Z 폴드6'
    ];
    
    const brands = ['Apple', 'Samsung'];
    const storages = ['256GB', '512GB', '1TB'];
    const colors = ['블루', '화이트', '블랙', '레드', '그린'];
    const images = [
        'https://images.unsplash.com/photo-1592286927505-2c1f6c3c3186?w=500',
        'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=500',
        'https://images.unsplash.com/photo-1580910051074-3eb694886505?w=500',
        'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=500'
    ];
    
    for (let i = 0; i < 60; i++) {
        const nameIndex = i % productNames.length;
        const brandIndex = productNames[nameIndex].includes('아이폰') ? 0 : 1;
        
        allProducts.push({
            id: i + 1,
            name: productNames[nameIndex],
            brand: brands[brandIndex],
            storage: storages[Math.floor(Math.random() * storages.length)],
            color: colors[Math.floor(Math.random() * colors.length)],
            price: Math.floor(Math.random() * 1000000) + 800000,
            reviews: Math.floor(Math.random() * 300) + 50,
            image: images[Math.floor(Math.random() * images.length)]
        });
    }

    let currentPage = 1;
    let itemsPerPage = 12; // 행3개 x 열4개
    let filteredProducts = [...allProducts];
    let currentBrand = 'all';
    let currentSort = 'latest';
    let searchKeyword = '';

    // 상품 렌더링
    function renderProducts() {
        const start = (currentPage - 1) * itemsPerPage;
        const end = start + itemsPerPage;
        const pageProducts = filteredProducts.slice(start, end);
        
        const grid = $('#productsGrid');
        grid.empty();
        
        pageProducts.forEach(product => {
            const stars = Math.floor(product.rating);
            let starsHtml = '';
            for (let i = 0; i < 5; i++) {
                if (i < stars) {
                    starsHtml += '<i class="fas fa-star"></i>';
                } else if (i === stars && product.rating % 1 >= 0.5) {
                    starsHtml += '<i class="fas fa-star-half-alt"></i>';
                } else {
                    starsHtml += '<i class="far fa-star"></i>';
                }
            }
            
            const card = `
                <div class="product-card" onclick="goToDetail(${product.id})">
                    <div class="product-image-wrapper">
                        <img src="${product.image}" alt="${product.name}">
                    </div>
                    <div class="product-info">
                        <div class="product-brand">${product.brand}</div>
                        <h3 class="product-name">${product.name}</h3>
                        <div class="product-specs">${product.storage} / ${product.color}</div>
						<div class="product-rating">리뷰 (${product.reviews})</span></div>
                        <div class="product-price">${product.price.toLocaleString()}원</div>
                    </div>
                </div>
            `;
            grid.append(card);
        });
        
        updateResultInfo();
    }

    // 필터링 및 정렬
    function applyFilters() {
        filteredProducts = [...allProducts];
        
        // 브랜드 필터
        if (currentBrand !== 'all') {
            filteredProducts = filteredProducts.filter(p => p.brand === currentBrand);
        }
        
        // 검색 필터
        if (searchKeyword) {
            filteredProducts = filteredProducts.filter(p => 
                p.name.toLowerCase().includes(searchKeyword.toLowerCase())
            );
        }
        
        // 정렬
        switch(currentSort) {
            case 'price_high':
                filteredProducts.sort((a, b) => b.price - a.price);
                break;
            case 'price_low':
                filteredProducts.sort((a, b) => a.price - b.price);
                break;
            default: // latest
                filteredProducts.sort((a, b) => b.id - a.id);
        }
        
        currentPage = 1;
        renderProducts();
        updatePagination();
    }

    // 결과 정보 업데이트
    function updateResultInfo() {
        $('#totalCount').text(filteredProducts.length);
        $('#currentPage').text(currentPage);
    }

    // 페이지네이션 업데이트
    function updatePagination() {
        const totalPages = Math.ceil(filteredProducts.length / itemsPerPage);
        const pagination = $('#pagination');
        pagination.empty();
        
        // 이전 버튼
        pagination.append(`
            <li class="page-item ${currentPage === 1 ? 'disabled' : ''}">
                <a class="page-link" href="#" data-page="prev">
                    <i class="fas fa-chevron-left"></i>
                </a>
            </li>
        `);
        
        // 페이지 번호 (최대 5개만 표시)
        for (let i = 1; i <= Math.min(totalPages, 5); i++) {
            pagination.append(`
                <li class="page-item ${i === currentPage ? 'active' : ''}">
                    <a class="page-link" href="#" data-page="${i}">${i}</a>
                </li>
            `);
        }
        
        // 다음 버튼
        pagination.append(`
            <li class="page-item ${currentPage === totalPages ? 'disabled' : ''}">
                <a class="page-link" href="#" data-page="next">
                    <i class="fas fa-chevron-right"></i>
                </a>
            </li>
        `);
    }

    // 브랜드 필터 클릭
    $('.brand-btn').click(function() {
        $('.brand-btn').removeClass('active');
        $(this).addClass('active');
        currentBrand = $(this).data('brand');
        applyFilters();
    });

    // 정렬 변경
    $('#sortSelect').change(function() {
        currentSort = $(this).val();
        applyFilters();
    });

    // 검색
    $('#searchBtn').click(function() {
        searchKeyword = $('#searchInput').val();
        applyFilters();
    });

    $('#searchInput').keypress(function(e) {
        if (e.which === 13) {
            searchKeyword = $(this).val();
            applyFilters();
        }
    });

    // 페이지네이션 클릭
    $(document).on('click', '.page-link', function(e) {
        e.preventDefault();
        const page = $(this).data('page');
        const totalPages = Math.ceil(filteredProducts.length / itemsPerPage);
        
        if (page === 'prev' && currentPage > 1) {
            currentPage--;
        } else if (page === 'next' && currentPage < totalPages) {
            currentPage++;
        } else if (typeof page === 'number') {
            currentPage = page;
        }
        
        renderProducts();
        updatePagination();
        
        // 페이지 상단으로 스크롤
        $('html, body').animate({
            scrollTop: $('.page-header').offset().top - 80
        }, 600);
    });

    // 모바일 메뉴 처리
    $('.navbar-toggler').click(function() {
        if ($('.navbar-collapse').hasClass('show')) {
            $('.navbar-collapse').slideUp(300);
        } else {
            $('.navbar-collapse').slideDown(300);
        }
    });

    $('.navbar-nav .nav-link').click(function() {
        if ($(window).width() < 992) {
            $('.navbar-collapse').collapse('hide');
        }
    });

    // 초기 렌더링
    renderProducts();
    updatePagination();
});//end of $(document).ready(function()-----


//==== Function Dacalaration ====//

// 상품 상세 페이지로 이동
function goToDetail(productId) {
    alert('상품 상세 페이지로 이동합니다.\n상품 ID: ' +productId+'\n이 ID는 상품상세테이블의 option_id입니다.');
    console.log('이동: productOption.hp?productId=' + productId);
    window.location.href = 'productOption.hp';
}
