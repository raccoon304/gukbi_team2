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
                    <div class="slide-content" style="background-image:url('https://images.unsplash.com/photo-1699265837122-7636e128b4b0?w=1200');">
                        <div class="slide-overlay"></div>
                        <div class="slide-info">
                            <h2>아이폰 16 Pro Max</h2>
                            <p>티타늄 디자인과 강력한 성능</p>
                            <button class="btn btn-view-product" onclick="goToProductDetail(1)">
                                <i class="fa-solid fa-arrow-right mr-2"></i>상품 보기
                            </button>
                        </div>
                    </div>
                </div>

                <!-- 슬라이드 2 -->
                <div class="carousel-item">
                    <div class="slide-content" style="background-image:url('https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=1200');">
                        <div class="slide-overlay"></div>
                        <div class="slide-info">
                            <h2>갤럭시 S25 Ultra</h2>
                            <p>차세대 모바일 경험의 시작</p>
                            <button class="btn btn-view-product" onclick="goToProductDetail(2)">
                                <i class="fa-solid fa-arrow-right mr-2"></i>상품 보기
                            </button>
                        </div>
                    </div>
                </div>

                <!-- 슬라이드 3 -->
                <div class="carousel-item">
                    <div class="slide-content" style="background-image:url('https://images.unsplash.com/photo-1580910051074-3eb694886505?w=1200');">
                        <div class="slide-overlay"></div>
                        <div class="slide-info">
                            <h2>갤럭시 Z 플립</h2>
                            <p>접히는 혁신, 펼쳐지는 가능성</p>
                            <button class="btn btn-view-product" onclick="goToProductDetail(3)">
                                <i class="fa-solid fa-arrow-right mr-2"></i>상품 보기
                            </button>
                        </div>
                    </div>
                </div>

                <!-- 슬라이드 4 -->
                <div class="carousel-item">
                    <div class="slide-content" style="background-image:url('https://images.unsplash.com/photo-1556656793-08538906a9f8?w=1200');">
                        <div class="slide-overlay"></div>
                        <div class="slide-info">
                            <h2>아이폰 15</h2>
                            <p>완벽한 균형의 스마트폰</p>
                            <button class="btn btn-view-product" onclick="goToProductDetail(4)">
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
                <div class="product-card">
                    <div class="product-image-wrapper">
                        <div class="best-badge">
                            <i class="fa-solid fa-crown mr-1"></i>BEST 1
                        </div>
                        <img src="" alt="">
                    </div>
                    <div class="product-info">
                        <div class="product-brand">Samsung</div>
                            <h3 class="product-name">갤럭시 Z 플립</h3>
                            <div class="product-specs">256GB / 라벤더</div>
                        <div class="product-sales">
                            <i class="fa-solid fa-fire mr-1"></i>판매량 431개
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-3 col-md-6">
                <div class="product-card">
                    <div class="product-image-wrapper">
                        <div class="best-badge">
                            <i class="fa-solid fa-crown mr-1"></i>BEST 2
                        </div>
                        <img src="" alt="">
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
                <div class="product-card">
                    <div class="product-image-wrapper">
                        <div class="best-badge">
                            <i class="fa-solid fa-crown mr-1"></i>BEST 3
                        </div>
                        <img src="" alt="">
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

            <div class="col-lg-3 col-md-6">
                <div class="product-card">
                    <div class="product-image-wrapper">
                        <div class="best-badge">
                            <i class="fa-solid fa-crown mr-1"></i>BEST 4
                        </div>
                        <img src="" alt="">
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
            
        </div>
    </div>
</section>


<!-- 로그인 모달 -->
<div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">

            <!-- 모달 헤더 -->
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fa-solid fa-right-to-bracket mr-2"></i>로그인
                </h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>

            <!-- 모달 바디 -->
            <div class="modal-body">
                <form id="loginForm">

                    <!-- 아이디 -->
                    <div class="form-group">
                        <label for="loginId">아이디</label>
                        <input type="text" class="form-control" id="loginId"
                               placeholder="아이디를 입력하세요">
                    </div>

                    <!-- 비밀번호 -->
                    <div class="form-group">
                        <label for="loginPw">비밀번호</label>
                        <input type="password" class="form-control" id="loginPw"
                               placeholder="비밀번호를 입력하세요">
                    </div>

                    <!-- 아이디 / 비밀번호 찾기 -->
					<div class="text-center mb-3">
					    <a href="#" class="text-secondary small mr-2">
					        <i class="fa-solid fa-user-magnifying-glass mr-1"></i>아이디 찾기
					    </a>
					    <span class="text-muted mx-1">|</span>
					    <a href="#" class="text-secondary small ml-2">
					        <i class="fa-solid fa-key mr-1"></i>비밀번호 찾기
					    </a>
					</div>

                </form>
            </div>

            <!-- 모달 푸터 -->
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">
                    취소
                </button>
                <button type="button" class="btn btn-primary" onclick="login()">
                    <i class="fa-solid fa-right-to-bracket mr-1"></i>로그인
                </button>
            </div>

        </div>
    </div>
</div>


<!-- 푸터부분 가져오기 -->
<jsp:include page="footer.jsp"/>