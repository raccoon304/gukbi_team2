$(document).ready(function() {
    let coupons = [];
    let allMembers = [];
    let couponCategoryNo = null;
    let selectedMembers = [];
    let currentPage = 1;
    let pageSize = 5;
    let searchQuery = '';
    let searchType = 'userId';

 //   loadCoupons();  추후 삭제 예정
    loadMembers();
	
	
	// 쿠폰 리스트 한 행을 클릭하면 회원 목록이 뜨게함
	$('tr.coupon-row').bind('click', function () {

	  couponCategoryNo = $(this).data('coupon-no');     // 쿠폰번호
	  const couponName = $(this).data('coupon-name');   // 쿠폰명

	  // 모달 상단 안내 문구
	  $('#couponInfo').html(`<strong>쿠폰:</strong> ${couponName} (No.${couponCategoryNo})`);

	  // 선택 초기화
	  selectedMembers = [];
	  currentPage = 1;
	  searchQuery = '';
	  $('#memberSearch').val('');
	  $('#selectAllMembers').prop('checked', false);

	  // 회원 목록 그리기 (loadMembers()로 allMembers는 이미 받아온 상태)
	  renderMemberTable();

	  // 모달 열기
	  $('#memberSelectModal').modal('show');
	});
	
	
	
	
	function showTableMsg(tbodySelector, colCount, msg, cssClass) {
	  $(tbodySelector).html(`
	    <tr>
	      <td colspan="${colCount}" class="text-center py-4 ${cssClass || ''}">
	        ${msg}
	      </td>
	    </tr>
	  `);
	}

/*	
    // Load coupons             추후 삭제 예정
    function loadCoupons() {
        $.ajax({
			url: ctxPath + '/admin/couponList.hp',
		    method: 'GET',
		    dataType: 'json',
		    success: function(json) {
		     coupons = Array.isArray(json) ? json : [];

		     if (coupons.length === 0) {
		       showTableMsg('#couponTableBody', 4, '등록된 쿠폰이 없습니다.', 'text-muted');
		       return;
		     }

		     renderCouponTable();
		   },
		    error: function() {
		     coupons = [];
		     showTableMsg('#couponTableBody', 4, '쿠폰 목록 조회에 실패했습니다.', 'text-danger');
		   }
        });
    }
*/

    // Load members
    function loadMembers() {
        $.ajax({
			url: ctxPath + '/admin/memberList.hp',
		    method: 'GET',
		    dataType: 'json',
		    success: function(data) {
		      allMembers = Array.isArray(data) ? data : [];

		      if (allMembers.length === 0) {
		        showTableMsg('#memberSelectTableBody', 6, '회원이 없습니다.', 'text-muted');
		      }
		    },
		    error: function() {
		      allMembers = [];
		      showTableMsg('#memberSelectTableBody', 6, '회원 목록 조회에 실패했습니다.', 'text-danger');
		    }
        });
    }

/*
    // Render coupon table
    function renderCouponTable() {
        let html = '';
        coupons.forEach(coupon => {
            const unusedCount = (coupon.issuedMembers || []).filter(m => !m.used).length;

            html += `
                <tr data-coupon-id="${coupon.id}" style="cursor: pointer;">
                    <td>${coupon.code}</td>
                    <td>${coupon.name}</td>
                    <td>${coupon.discountType === 'percentage' ? '비율 할인' : '금액 할인'}</td>
                    <td>${coupon.discountType === 'percentage' ? coupon.discountValue + '%' : '₩' + Number(coupon.discountValue).toLocaleString()}</td>
                    <td>${coupon.expiryDate || '-'}</td>
                    <td class="text-right">${unusedCount}명</td>
                </tr>
            `;
        });

        $('#couponTableBody').html(html);

        // Add click event
        $('#couponTableBody tr').click(function() {
            const couponId = $(this).data('coupon-id');
            showIssuedMembers(couponId);
        });
    }
*/


    // Show issued members modal
    function showIssuedMembers(couponId) {
        const coupon = coupons.find(c => c.id == couponId);
        if (!coupon) return;

        couponCategoryNo = couponId;

        const issuedMembers = coupon.issuedMembers || [];

        $('#issuedCouponInfo').html(`
            <strong>쿠폰:</strong> ${coupon.name} (${coupon.code})<br>
            <strong>미사용:</strong> ${issuedMembers.filter(m => !m.used).length}명 /
            <strong>전체:</strong> ${issuedMembers.length}명
        `);

        let html = '';
        issuedMembers.forEach(member => {
            const statusBadge = member.used
                ? '<span class="badge badge-secondary">사용완료</span>'
                : '<span class="badge badge-success">미사용</span>';

            html += `
                <tr>
                    <td>${member.memberUserId}</td>
                    <td>${member.memberName}</td>
                    <td>${member.issuedDate}</td>
                    <td>${statusBadge}</td>
                </tr>
            `;
        });

        $('#issuedMembersTableBody').html(html);
        $('#issuedMembersModal').modal('show');
    }

    // 쿠폰 생성 Create coupon
    $('#submitCoupon').click(function() {
        const couponName = $('#couponName').val();
        const discountType = $('#discountType').val();
        const discountValue = $('#discountValue').val();

		
		console.log('len', $('#couponName').length, $('#discountType').length, $('#discountValue').length);
		console.log('vals', $('#couponName').val(), $('#discountType').val(), $('#discountValue').val());
		
        if (!couponName || !discountValue) {
            alert('모든 값을 입력해주세요.');
            return;
        }

        $.ajax({
            url: ctxPath + '/admin/couponCreate.hp',
            method: 'POST',
            dataType: 'json',
            data: {
                couponName: couponName,
                discountType: discountType,
                discountValue: discountValue,
            },
            success: function(json) {
				alert(json.message);
				location.href = json.loc;
           //     $('#createCouponModal').modal('hide');   추후 삭제
            //    $('#createCouponForm')[0].reset();	   추후 삭제
           //     loadCoupons();						   추후 삭제
            },
            error: function() {
                alert('쿠폰 생성에 실패했습니다.');
            }
        });
    });

    // 쿠폰 전송 버튼 클릭
    $('#sendMoreCoupons').click(function() {
        if (!couponCategoryNo) return;

        const coupon = coupons.find(c => c.id == couponCategoryNo);
        if (!coupon) return;

        $('#issuedMembersModal').modal('hide');
        $('#couponInfo').html(`<strong>쿠폰:</strong> ${coupon.name} (${coupon.code})`);
        $('#memberSelectModal').modal('show');

        selectedMembers = [];
        currentPage = 1;
        searchQuery = '';
        renderMemberTable();
    });

    // Render member table
    function renderMemberTable() {
        let filtered = allMembers;

        if (searchQuery) {
            filtered = allMembers.filter(m => {
                if (searchType === 'userId') return (m.userId || '').toLowerCase().includes(searchQuery.toLowerCase());
                if (searchType === 'name') return (m.name || '').toLowerCase().includes(searchQuery.toLowerCase());
                if (searchType === 'email') return (m.email || '').toLowerCase().includes(searchQuery.toLowerCase());
                return true;
            });
        }

        const start = (currentPage - 1) * pageSize;
        const paginatedMembers = filtered.slice(start, start + pageSize);

        let html = '';
        paginatedMembers.forEach(member => {
            const memberIdStr = String(member.id);
            const checked = selectedMembers.includes(memberIdStr) ? 'checked' : '';

            html += `
                <tr>
                    <td><input type="checkbox" class="member-checkbox" data-member-id="${member.id}" ${checked}></td>
                    <td>${member.userId}</td>
                    <td>${member.name}</td>
                    <td>${member.orderCount}건</td>
                    <td>₩${Number(member.totalSpent).toLocaleString()}</td>
                    <td>${member.joinDate}</td>
                </tr>
            `;
        });

        $('#memberSelectTableBody').html(html);
        $('#selectedCount').text(selectedMembers.length);

        renderPagination(filtered.length);
    }

    // Render pagination
    function renderPagination(totalCount) {
        const totalPages = Math.ceil(totalCount / pageSize);
        let html = '';

        for (let i = 1; i <= totalPages; i++) {
            html += `<li class="page-item ${i === currentPage ? 'active' : ''}">
                        <a class="page-link" href="#" data-page="${i}">${i}</a>
                     </li>`;
        }

        $('#pagination').html(html);

        $('.page-link').click(function(e) {
            e.preventDefault();
            currentPage = parseInt($(this).data('page'));
            renderMemberTable();
        });
    }

    // Member checkbox change
    $(document).on('change', '.member-checkbox', function() {
        const memberId = $(this).data('member-id').toString();

        if ($(this).is(':checked')) {
            if (!selectedMembers.includes(memberId)) selectedMembers.push(memberId);
        } else {
            selectedMembers = selectedMembers.filter(id => id !== memberId);
        }

        $('#selectedCount').text(selectedMembers.length);
    });

    // Select all
    $('#selectAllMembers').change(function() {
        const isChecked = $(this).is(':checked');
        $('.member-checkbox').prop('checked', isChecked);

        if (isChecked) {
            $('.member-checkbox').each(function() {
                const memberId = $(this).data('member-id').toString();
                if (!selectedMembers.includes(memberId)) selectedMembers.push(memberId);
            });
        } else {
            selectedMembers = [];
        }

        $('#selectedCount').text(selectedMembers.length);
    });

    // Page size change
    $('#pageSize').change(function() {
        pageSize = parseInt($(this).val());
        currentPage = 1;
        renderMemberTable();
    });

    // Search
    $('#searchBtn').click(function() {
        searchQuery = $('#memberSearch').val();
        searchType = $('#searchType').val();
        currentPage = 1;
        renderMemberTable();
    });

    // Send coupon
    $('#sendCoupon').click(function() {
        if (selectedMembers.length === 0) {
            alert('최소 한 명의 회원을 선택해주세요.');
            return;
        }

        if (!couponCategoryNo) {
            alert('쿠폰을 선택해주세요.');
            return;
        }

        $.ajax({
            url: ctxPath + '/admin/couponSend.hp',
            method: 'POST',
            dataType: 'json',
            data: {
                couponCategoryNo: couponCategoryNo,
                memberIds: selectedMembers.join(',')
            },
            success: function(data) {
                alert('쿠폰이 전송되었습니다.');
                $('#memberSelectModal').modal('hide');
                loadCoupons();
                selectedMembers = [];
                couponCategoryNo = null;
            },
            error: function() {
                alert('쿠폰 전송에 실패했습니다.');
            }
        });
    });
});