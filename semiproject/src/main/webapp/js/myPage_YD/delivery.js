/*
btnOpenAdd:			배송지 추가 버튼
btnOpenAddEmpty:	첫 배송지 추가하기 버튼(배송지 없을 때)

checkAll:			전체 선택 체크박스
btnDeleteSelected:	선택 삭제 버튼
btnSetDefault:		기본 배송지로 설정 버튼

deleteForm:			선택 삭제 전송 폼
defaultForm:		기본 배송지 설정 전송 폼
defaultDeliveryId:	기본 배송지 설정용 hidden input(선택된 배송지 id 저장)

addressModal:		배송지 추가/수정 모달 전체 영역
addressModalLabel:	모달 제목(h5)

addressForm:		배송지 추가/수정 전송 폼
mode:				추가/수정 모드 hidden input(add/edit)
deliveryAddressId:	수정 대상 배송지 id hidden input

addressName:		배송지명 입력 input
recipientName:		수령인 입력 input
postalCode:			우편번호 입력 input
btnPostcodeSearch:	우편번호 검색 버튼
recipientPhone:		연락처 입력 input
address:			주소 입력 input
addressDetail:		상세주소 입력 input
*/


(function () {

  function resetModalToAdd() {
    document.querySelector('#addressModalLabel').innerText = '배송지 추가';
    document.querySelector('#mode').value = 'add';
    document.querySelector('#deliveryAddressId').value = '';

    document.querySelector('#addressName').value = '';
    document.querySelector('#recipientName').value = '';
    document.querySelector('#postalCode').value = '';
    document.querySelector('#recipientPhone').value = '';
    document.querySelector('#address').value = '';
    document.querySelector('#addressDetail').value = '';
  }

  function fillModalToEdit(btn) {
    document.querySelector('#addressModalLabel').innerText = '배송지 수정';
    document.querySelector('#mode').value = 'edit';

    document.querySelector('#deliveryAddressId').value = btn.dataset.id || '';
    document.querySelector('#addressName').value = btn.dataset.addressname || '';
    document.querySelector('#recipientName').value = btn.dataset.recipientname || '';
    document.querySelector('#postalCode').value = btn.dataset.postalcode || '';
    document.querySelector('#recipientPhone').value = btn.dataset.phone || '';
    document.querySelector('#address').value = btn.dataset.address || '';
    document.querySelector('#addressDetail').value = btn.dataset.addressdetail || '';
  }

  function getCheckedIds() {
    const checked = document.querySelectorAll('.addr-check:checked');
    return Array.from(checked).map(ch => ch.value);
  }

  document.addEventListener('DOMContentLoaded', function () {

    // 추가 버튼들 -> 모달 초기화
    const btnOpenAdd = document.querySelector('#btnOpenAdd');
    if (btnOpenAdd) btnOpenAdd.addEventListener('click', resetModalToAdd);

    const btnOpenAddEmpty = document.querySelector('#btnOpenAddEmpty');
    if (btnOpenAddEmpty) btnOpenAddEmpty.addEventListener('click', resetModalToAdd);

    // 수정 버튼들 -> data-* 기반으로 모달 채우기
    document.querySelectorAll('.btnOpenEdit').forEach(function (btn) {
      btn.addEventListener('click', function () {
        fillModalToEdit(btn);
      });
    });

    // 전체선택
    const checkAll = document.querySelector('#checkAll');
    if (checkAll) {
      checkAll.addEventListener('change', function () {
        document.querySelectorAll('.addr-check').forEach(function (ch) {
          ch.checked = checkAll.checked;
        });
      });
    }

    // 선택 삭제
    const btnDeleteSelected = document.querySelector('#btnDeleteSelected');
    if (btnDeleteSelected) {
      btnDeleteSelected.addEventListener('click', function () {
        const ids = getCheckedIds();
        if (ids.length === 0) {
          alert('삭제할 배송지를 선택하세요.');
          return;
        }
        if (!confirm('선택한 배송지를 삭제하시겠습니까?')) return;

        const form = document.querySelector('#deleteForm');
        form.innerHTML = ''; // hidden 초기화

        ids.forEach(function (id) {
          const input = document.createElement('input');
          input.type = 'hidden';
          input.name = 'deliveryAddressId';
          input.value = id;
          form.appendChild(input);
        });

        form.submit();
      });
    }

    // 기본 배송지 설정 (1개만)
    const btnSetDefault = document.querySelector('#btnSetDefault');
    if (btnSetDefault) {
      btnSetDefault.addEventListener('click', function () {
        const ids = getCheckedIds();

        if (ids.length === 0) {
          alert('기본으로 설정할 배송지를 선택하세요.');
          return;
        }
        if (ids.length > 1) {
          alert('기본 배송지는 1개만 선택할 수 있습니다.');
          return;
        }
        if (!confirm('선택한 배송지를 기본 배송지로 설정하시겠습니까?')) return;

        document.querySelector('#defaultDeliveryId').value = ids[0];
        document.querySelector('#defaultForm').submit();
      });
    }

    // 우편번호 검색(프로젝트 방식에 맞게 연결)
    const btnPostcodeSearch = document.querySelector('#btnPostcodeSearch');
    if (btnPostcodeSearch) {
      btnPostcodeSearch.addEventListener('click', function () {
        alert('우편번호 검색 API(다음주소 등)를 여기에 연결하세요.');
      });
    }
  });

  
})();
