<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="msg" value="${errMsg}" />

<style>
  /* ====== Admin modal fragment styles  ====== */
  .yd-section-title{ font-weight:700; font-size:16px; margin-bottom:.75rem; }
  .yd-box{
    background:#f8f9fa;
    border:1px solid #e9ecef;
    border-radius:.5rem;
    padding:1rem;
  }
  .yd-kv{
    display:grid;
    grid-template-columns:140px 1fr;
    gap:.35rem .75rem;
    font-size:14px;
  }
  .yd-kv .k{ color:#6c757d; }
  .yd-item{
    padding:.9rem 0;
    border-bottom:1px solid #e9ecef;
    display:grid;
    grid-template-columns:1fr auto;
    gap:.5rem;
    align-items:start;
    font-size:14px;
  }
  .yd-item:last-child{ border-bottom:0; }
  .yd-item-name{ font-weight:700; }
  .yd-item-opt{ color:#6c757d; font-size:13px; line-height:1.35; }
  .yd-item-price{ font-weight:700; white-space:nowrap; padding-left:16px; }
  .yd-item-link{ font-weight:700; text-decoration:none; }
  .yd-item-link:hover{ text-decoration:underline; }
  .yd-pill{
    display:inline-block;
    padding:.25rem .6rem;
    border-radius:999px;
    font-size:12px;
    font-weight:700;
    border:1px solid transparent;
  }
  .yd-pill-info{ background:rgba(23,162,184,.12); color:#117a8b; border-color:rgba(23,162,184,.18); }
  .yd-pill-warn{ background:rgba(255,193,7,.18); color:#856404; border-color:rgba(255,193,7,.28); }
  .yd-pill-gray{ background:rgba(108,117,125,.12); color:#495057; border-color:rgba(108,117,125,.18); }
  .yd-pill-danger{ background:rgba(220,53,69,.12); color:#a71d2a; border-color:rgba(220,53,69,.18); }
  .text-muted-sm{ color:#6c757d; font-size:13px; }
</style>

<c:if test="${not empty msg}">
  <div class="text-center text-muted py-3">
    <c:out value="${msg}" />
  </div>
</c:if>

<c:if test="${empty msg}">

  <c:if test="${empty orderHeader}">
    <div class="text-center text-muted py-3">주문 정보를 찾을 수 없습니다.</div>
  </c:if>

  <c:if test="${not empty orderHeader}">
    <c:set var="ds" value="${orderHeader['delivery_status']}" />

    <!-- ===== 주문 요약 ===== -->
    <div class="mb-4">
      <div class="yd-section-title">주문 정보</div>
      <div class="yd-box">
        <div class="yd-kv">
          <div class="k">주문 번호</div>
          <div class="v"><c:out value="${orderHeader['order_id']}" /></div>

          <div class="k">주문 일시</div>
          <div class="v"><c:out value="${orderHeader['order_date']}" /></div>

          <div class="k">총 금액</div>
          <div class="v"><fmt:formatNumber value="${orderHeader['total_amount']}" pattern="#,###" /> 원</div>

          <div class="k">할인 금액</div>
          <div class="v"><fmt:formatNumber value="${orderHeader['discount_amount']}" pattern="#,###" /> 원</div>

          <div class="k">결제 금액</div>
          <div class="v"><fmt:formatNumber value="${orderHeader['final_amount']}" pattern="#,###" /> 원</div>

          <div class="k">배송 상태</div>
          <div class="v">
            <c:choose>
              <c:when test="${ds eq '0'}"><span class="yd-pill yd-pill-info">배송준비중</span></c:when>
              <c:when test="${ds eq '1'}"><span class="yd-pill yd-pill-warn">배송중</span></c:when>
              <c:when test="${ds eq '2'}"><span class="yd-pill yd-pill-gray">배송완료</span></c:when>
              <c:otherwise><span class="yd-pill yd-pill-danger">주문실패</span></c:otherwise>
            </c:choose>
          </div>

          <div class="k">주문 상태</div>
          <div class="v"><c:out value="${orderHeader['order_status']}" /></div>
        </div>
      </div>
    </div>

    <!-- ===== 상품 정보 ===== -->
    <div class="mb-4">
      <div class="yd-section-title">상품 정보</div>
      <div class="yd-box">

        <c:if test="${empty items}">
          <div class="text-muted-sm">상품 정보가 없습니다.</div>
        </c:if>

        <c:if test="${not empty items}">
          <c:forEach var="it" items="${items}">
            <div class="yd-item">
              <div>
                <div class="yd-item-name">
                  <c:out value="${it['product_name']}" />
                </div>

                <div class="yd-item-opt">
                  브랜드: <c:out value="${it['brand_name']}" /><br/>

                  색상:
                  <c:choose>
                    <c:when test="${empty it['color']}">-</c:when>
                    <c:otherwise><c:out value="${it['color']}" /></c:otherwise>
                  </c:choose>

                  / 용량:
                  <c:choose>
                    <c:when test="${empty it['storage']}">-</c:when>
                    <c:otherwise><c:out value="${it['storage']}" /></c:otherwise>
                  </c:choose>
                  <br/>

                  수량: <c:out value="${it['quantity']}" />
                </div>
              </div>

              <div class="yd-item-price">
                <fmt:formatNumber value="${it['unit_price']}" pattern="#,###" /> 원
              </div>
            </div>
          </c:forEach>
        </c:if>

      </div>
    </div>

    <!-- ===== 배송 정보 ===== -->
    <div class="mb-2">
      <div class="yd-section-title">배송 정보</div>
      <div class="yd-box">
        <div class="yd-kv">
          <div class="k">수령인</div>
          <div class="v"><c:out value="${orderHeader['recipient_name']}" /></div>

          <div class="k">휴대폰</div>
          <div class="v"><c:out value="${orderHeader['recipient_phone']}" /></div>

          <div class="k">주소</div>
          <div class="v"><c:out value="${orderHeader['delivery_address']}" /></div>

          <div class="k">배송번호</div>
          <div class="v">
            <c:choose>
              <c:when test="${empty orderHeader['delivery_number']}">-</c:when>
              <c:otherwise><c:out value="${orderHeader['delivery_number']}" /></c:otherwise>
            </c:choose>
          </div>

          <div class="k">배송시작일</div>
          <div class="v">
            <c:choose>
              <c:when test="${empty orderHeader['delivery_startdate']}">-</c:when>
              <c:otherwise><c:out value="${orderHeader['delivery_startdate']}" /></c:otherwise>
            </c:choose>
          </div>

          <div class="k">배송완료일</div>
          <div class="v">
            <c:choose>
              <c:when test="${empty orderHeader['delivery_enddate']}">-</c:when>
              <c:otherwise><c:out value="${orderHeader['delivery_enddate']}" /></c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
    </div>

  </c:if>
</c:if>
