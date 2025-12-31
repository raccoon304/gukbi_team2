$(document).ready(function() {
    let allMembers = [];
    let currentPage = 1;
    let sizePerPage = 5;
    let searchWord = '';
    let searchType = 'userId';
    
    // Load members
    loadMembers();
    
    function loadMembers() {
        $.ajax({
            url: '/api/members/',
            method: 'GET',
            data: {
                searchType: searchType,
                searchWord: searchWord,
                page: currentPage,
                sizePerPage: 100  // Get all for client-side pagination
            },
            success: function(data) {
                allMembers = data;
                renderMemberTable();
            }
        });
    }
    
    function renderMemberTable() {
        let filtered = allMembers;
        
        // Filter
        if (searchWord) {
            filtered = allMembers.filter(m => {
                if (searchType === 'userId') return m.userId.toLowerCase().includes(searchWord.toLowerCase());
                if (searchType === 'name') return m.name.toLowerCase().includes(searchWord.toLowerCase());
                if (searchType === 'email') return m.email.toLowerCase().includes(searchWord.toLowerCase());
                return true;
            });
        }
        
        // Paginate
        const start = (currentPage - 1) * sizePerPage;
        const paginatedMembers = filtered.slice(start, start + sizePerPage);
        
        let html = '';
        paginatedMembers.forEach(member => {
            html += `
                <tr>
                    <td>${member.userId}</td>
                    <td>${member.name}</td>
                    <td>${member.email}</td>
                    <td>${member.phone}</td>
                    <td>${member.joinDate}</td>
                    <td>${member.orderCount}건</td>
                    <td>₩${member.totalSpent.toLocaleString()}</td>
                </tr>
            `;
        });
        $('#memberTableBody').html(html);
        
        // Render pagination
        renderPagination(filtered.length);
    }
    
    function renderPagination(totalCount) {
        const totalPages = Math.ceil(totalCount / sizePerPage);
        let html = '';
        
        // Previous button
        html += `<li class="page-item ${currentPage === 1 ? 'disabled' : ''}">
                    <a class="page-link" href="#" data-page="${currentPage - 1}">이전</a>
                 </li>`;
        
        // Page numbers
        for (let i = 1; i <= totalPages; i++) {
            if (i === 1 || i === totalPages || (i >= currentPage - 2 && i <= currentPage + 2)) {
                html += `<li class="page-item ${i === currentPage ? 'active' : ''}">
                            <a class="page-link" href="#" data-page="${i}">${i}</a>
                         </li>`;
            } else if (i === currentPage - 3 || i === currentPage + 3) {
                html += `<li class="page-item disabled"><span class="page-link">...</span></li>`;
            }
        }
        
        // Next button
        html += `<li class="page-item ${currentPage === totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="#" data-page="${currentPage + 1}">다음</a>
                 </li>`;
        
        $('#pagination').html(html);
        
        // Page click event
        $('.page-link').click(function(e) {
            e.preventDefault();
            const page = parseInt($(this).data('page'));
            if (page >= 1 && page <= totalPages) {
                currentPage = page;
                renderMemberTable();
            }
        });
    }
    
    // Page size change
    $('#sizePerPage').change(function() {
        sizePerPage = parseInt($(this).val());
        currentPage = 1;
        renderMemberTable();
    });
    
    // Search button click
    $('#searchBtn').click(function() {
        searchWord = $('#searchWord').val();
        searchType = $('#searchType').val();
        currentPage = 1;
        renderMemberTable();
    });
    
    // Enter key on search input
    $('#searchWord').keypress(function(e) {
        if (e.which === 13) {
            $('#searchBtn').click();
        }
    });
});
