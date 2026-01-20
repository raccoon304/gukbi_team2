<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>   
<%String ctxPath = request.getContextPath();%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 헤더부분 가져오기 -->
<jsp:include page="header.jsp"/>



<!-- 슬라이드 -->
<section class="hero-section">
    <div class="container">
        <div id="productCarousel" class="carousel slide" data-ride="carousel" data-interval="3000">

            <div class="carousel-inner">

                <!-- 슬라이드 1 -->
                <div class="carousel-item active">
                    <div class="slide-content" style="background-image:url('<%=ctxPath%>//image/product_TH/centerAP.jpg');">
                        <div class="slide-overlay"></div>
                        <div class="slide-info">
                            <h2>아이폰 17 Pro Max</h2>
                            <p>티타늄 디자인과 강력한 성능</p>
                            <button class="btn btn-view-product" onclick="goToProductOption('1200AP')">
                                <i class="fa-solid fa-arrow-right mr-2"></i>상품 보기
                            </button>
                        </div>
                    </div>
                </div>

                <!-- 슬라이드 2 -->
                <div class="carousel-item">
                    <div class="slide-content" style="background-image:url('<%=ctxPath%>/image/product_TH/centerGX.jpg');">
                        <div class="slide-overlay"></div>
                        <div class="slide-info">
                            <h2>갤럭시 S25 Ultra</h2>
                            <p>차세대 모바일 경험의 시작</p>
                            <button class="btn btn-view-product" onclick="goToProductOption('1200GX')">
                                <i class="fa-solid fa-arrow-right mr-2"></i>상품 보기
                            </button>
                        </div>
                    </div>
                </div>

				<!-- 슬라이드 3 -->
                <div class="carousel-item">
                    <div class="slide-content" style="background-image:url('<%=ctxPath%>/image/product_TH/centerAP.jpg');">
                        <div class="slide-overlay"></div>
                        <div class="slide-info">
                            <h2>아이폰 17</h2>
                            <p>완벽한 균형의 스마트폰</p>
                            <button class="btn btn-view-product" onclick="goToProductOption('1000AP')">
                                <i class="fa-solid fa-arrow-right mr-2"></i>상품 보기
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- 슬라이드 4 -->
                <div class="carousel-item">
                    <div class="slide-content" style="background-image:url('<%=ctxPath%>/image/product_TH/centerGX.jpg');">
                        <div class="slide-overlay"></div>
                        <div class="slide-info">
                            <h2>갤럭시 Z 플립</h2>
                            <p>접히는 혁신, 펼쳐지는 가능성</p>
                            <button class="btn btn-view-product" onclick="goToProductOption('1100GX')">
                                <i class="fa-solid fa-arrow-right mr-2"></i>상품 보기
                            </button>
                        </div>
                    </div>
                </div>

            </div>

            <!-- 이전 / 다음 버튼 -->
            <a class="carousel-control-prev" href="#productCarousel" role="button" data-slide="prev">
                <span class="carousel-control-prev-icon"></span>
            </a>
            <a class="carousel-control-next" href="#productCarousel" role="button" data-slide="next">
                <span class="carousel-control-next-icon"></span>
            </a>

        </div>
    </div>
</section>


<!-- 베스트 상품 -->
<section class="best-products-section">
    <div class="container">
        <div class="section-title text-center">
            <h2><i class="fa-solid fa-trophy mr-3"></i>베스트 상품</h2>
            <p>가장 인기 있는 상품</p>
        </div>
        
        <div class="row">
            <div class="col-lg-3 col-md-6">
                <div class="product-card" data-id="1100GX" data-name="갤럭시 Z 플립">
                    <div class="product-image-wrapper">
                        <div class="best-badge">
                            <i class="fa-solid fa-crown mr-1"></i>BEST 1
                        </div>
                        <img src="<%=ctxPath%>/image/product_TH/Main_galaxy_z_flip7.jpg" alt="">
                    </div>
                    <div class="product-info">
                        <div class="product-brand">Samsung</div>
                            <h3 class="product-name">갤럭시 Z 플립7</h3>
                            <div class="product-specs">256GB / 라벤더</div>
                        <div class="product-sales">
                            <i class="fa-solid fa-fire mr-1"></i>판매량 431개
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-3 col-md-6">
                <div class="product-card" data-id="1100AP" data-name="아이폰17 Pro">
                    <div class="product-image-wrapper">
                        <div class="best-badge">
                            <i class="fa-solid fa-crown mr-1"></i>BEST 2
                        </div>
                        <img src="<%=ctxPath%>/image/product_TH/Main_iphone17Pro.jpg" alt="">
                    </div>
                    <div class="product-info">
                        <div class="product-brand">Apple</div>
                        <h3 class="product-name">아이폰16 Pro</h3>
                        <div class="product-specs">256GB / 티타늄 그레이</div>
                        <div class="product-sales">
                            <i class="fa-solid fa-fire mr-1"></i>판매량 388개
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-3 col-md-6">
                <div class="product-card" data-id="1200GX" data-name="갤럭시 S25 Ultra">
                    <div class="product-image-wrapper">
                        <div class="best-badge">
                            <i class="fa-solid fa-crown mr-1"></i>BEST 3
                        </div>
                        <img src="<%=ctxPath%>/image/product_TH/Main_galaxy_s25_ultra.jpg" alt="">
                    </div>
                    <div class="product-info">
                        <div class="product-brand">Samsung</div>
                        <h3 class="product-name">갤럭시 S25 Ultra</h3>
                        <div class="product-specs">512GB / 티타늄 그레이</div>
                        <div class="product-sales">
                            <i class="fa-solid fa-fire mr-1"></i>판매량 75개
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6">
                <div class="product-card" data-id="2200AP" data-name="아이폰16 Pro Max">
                    <div class="product-image-wrapper">
                        <div class="best-badge">
                            <i class="fa-solid fa-crown mr-1"></i>BEST 4
                        </div>
                        <img src="<%=ctxPath%>/image/product_TH/Main_iphone16ProMax.jpg" alt="">
                    </div>
                    <div class="product-info">
                        <div class="product-brand">Apple</div>
                        <h3 class="product-name">아이폰16 Pro Max</h3>
                        <div class="product-specs">512GB / 티타늄 그레이</div>
                        <div class="product-sales">
                            <i class="fa-solid fa-fire mr-1"></i>판매량 219개
                        </div>
                    </div>
                </div>
            </div>
            
        </div>
    </div>
</section>




<!-- 푸터부분 가져오기 -->
<jsp:include page="footer.jsp"/>