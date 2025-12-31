   // 로그인 상태 관리
   let isLoggedIn = false;
   let currentUser = null;
   let editingInquiryId = null;

   // 샘플 데이터
   let inquiries = [
       {
           id: 1,
           type: '서비스 문의',
           title: '서비스 이용 관련 문의',
           content: '서비스를 이용하려고 하는데 회원가입은 어떻게 하나요?',
           status: '답변완료',
           date: '2024-12-28',
           author: 'user1',
           adminReply: '안녕하세요. 회원가입은 상단 메뉴의 회원가입 버튼을 클릭하시면 됩니다. 추가 문의사항이 있으시면 언제든지 연락 주세요.'
       },
       {
           id: 2,
           type: '기술 지원',
           title: '로그인이 안됩니다',
           content: '비밀번호를 입력해도 로그인이 되지 않습니다. 확인 부탁드립니다.',
           status: '접수',
           date: '2024-12-29',
           author: 'user2',
           adminReply: null
       },
       {
           id: 3,
           type: '결제 문의',
           title: '환불 요청',
           content: '결제한 상품에 대해 환불을 요청합니다.',
           status: '보류',
           date: '2024-12-30',
           author: 'user1',
           adminReply: null
       }
   ];

   // 상태별 뱃지 색상
   function getStatusBadgeClass(status) {
       switch(status) {
           case '보류': return 'badge-secondary';
           case '접수': return 'badge-info';
           case '답변완료': return 'badge-success';
           default: return 'badge-secondary';
       }
   }

   // 문의 목록 렌더링
   function renderInquiryList() {
       const listHtml = inquiries.map(inquiry => `
           <div class="inquiry-item p-3 border-bottom" data-id="${inquiry.id}">
               <div class="d-flex justify-content-between align-items-center mb-2">
                   <span class="badge badge-primary">${inquiry.type}</span>
                   <span class="badge status-badge ${getStatusBadgeClass(inquiry.status)}">${inquiry.status}</span>
               </div>
               <h6 class="mb-1">${inquiry.title}</h6>
               <small class="text-muted">${inquiry.date}</small>
           </div>
       `).join('');
       
       $('#inquiryList').html(listHtml);
   }

   // 문의 상세 렌더링
   function renderInquiryDetail(inquiryId) {
       const inquiry = inquiries.find(i => i.id === inquiryId);
       if (!inquiry) return;

       const canEdit = isLoggedIn && currentUser === inquiry.author;
       
       const detailHtml = `
           <div class="inquiry-detail">
               <div class="d-flex justify-content-between align-items-start mb-3">
                   <div>
                       <h4>${inquiry.title}</h4>
                       <span class="badge badge-primary mr-2">${inquiry.type}</span>
                       <span class="badge ${getStatusBadgeClass(inquiry.status)}">${inquiry.status}</span>
                   </div>
                   ${canEdit ? `
                   <div>
                       <button class="btn btn-sm btn-outline-primary mr-1" onclick="editInquiry(${inquiry.id})">수정</button>
                       <button class="btn btn-sm btn-outline-danger" onclick="deleteInquiry(${inquiry.id})">삭제</button>
                   </div>
                   ` : ''}
               </div>
               
               <div class="message-box">
                   <div class="d-flex justify-content-between mb-2">
                       <strong>작성자: ${inquiry.author}</strong>
                       <small class="text-muted">${inquiry.date}</small>
                   </div>
                   <p class="mb-0">${inquiry.content}</p>
               </div>
               
               ${inquiry.adminReply ? `
               <div class="message-box admin-message">
                   <div class="mb-2">
                       <strong>관리자 답변</strong>
                   </div>
                   <p class="mb-0">${inquiry.adminReply}</p>
               </div>
               ` : '<p class="text-muted">아직 관리자 답변이 없습니다.</p>'}
           </div>
       `;
       
       $('#inquiryDetail').html(detailHtml).show();
       $('#inquiryDetailPlaceholder').hide();
   }

   // 문의 항목 클릭 이벤트
   $(document).on('click', '.inquiry-item', function() {
       $('.inquiry-item').removeClass('active');
       $(this).addClass('active');
       const inquiryId = parseInt($(this).data('id'));
       renderInquiryDetail(inquiryId);
   });

   // 로그인 버튼
   $('#loginBtn').click(function() {
       isLoggedIn = true;
       currentUser = 'user1';
       $(this).hide();
       $('#logoutBtn').show();
       alert('로그인되었습니다. (사용자: user1)');
   });

   // 로그아웃 버튼
   $('#logoutBtn').click(function() {
       isLoggedIn = false;
       currentUser = null;
       $(this).hide();
       $('#loginBtn').show();
       $('#inquiryDetail').hide();
       $('#inquiryDetailPlaceholder').show();
       $('.inquiry-item').removeClass('active');
       alert('로그아웃되었습니다.');
   });

   // 문의 등록 버튼
   $('#addInquiryBtn').click(function() {
       if (!isLoggedIn) {
           alert('로그인이 필요합니다.');
           // 실제로는 로그인 페이지로 이동
           // window.location.href = '/login';
           return;
       }
       
       editingInquiryId = null;
       $('#modalTitle').text('문의 등록');
       $('#inquiryForm')[0].reset();
       $('#inquiryModal').modal('show');
   });

   // 문의 등록/수정 제출
   $('#submitInquiry').click(function() {
       const type = $('#inquiryType').val();
       const title = $('#inquiryTitle').val();
       const content = $('#inquiryContent').val();
       
       if (!type || !title || !content) {
           alert('모든 항목을 입력해주세요.');
           return;
       }
       
       if (editingInquiryId) {
           // 수정
           const inquiry = inquiries.find(i => i.id === editingInquiryId);
           inquiry.type = type;
           inquiry.title = title;
           inquiry.content = content;
           alert('문의가 수정되었습니다.');
           renderInquiryDetail(editingInquiryId);
       } else {
           // 등록
           const newInquiry = {
               id: inquiries.length + 1,
               type: type,
               title: title,
               content: content,
               status: '접수',
               date: new Date().toISOString().split('T')[0],
               author: currentUser,
               adminReply: null
           };
           inquiries.unshift(newInquiry);
           alert('문의가 등록되었습니다.');
       }
       
       renderInquiryList();
       $('#inquiryModal').modal('hide');
   });

   // 문의 수정
   window.editInquiry = function(inquiryId) {
       const inquiry = inquiries.find(i => i.id === inquiryId);
       if (!inquiry) return;
       
       editingInquiryId = inquiryId;
       $('#modalTitle').text('문의 수정');
       $('#inquiryType').val(inquiry.type);
       $('#inquiryTitle').val(inquiry.title);
       $('#inquiryContent').val(inquiry.content);
       $('#inquiryModal').modal('show');
   };

   // 문의 삭제
   window.deleteInquiry = function(inquiryId) {
       if (!confirm('정말 삭제하시겠습니까?')) return;
       
       inquiries = inquiries.filter(i => i.id !== inquiryId);
       renderInquiryList();
       $('#inquiryDetail').hide();
       $('#inquiryDetailPlaceholder').show();
       alert('문의가 삭제되었습니다.');
   };

   // 초기 렌더링
   $(document).ready(function() {
       renderInquiryList();
   });
