package admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import admin.model.AdminMemberDAO;
import admin.model.AdminMemberDAO_imple;
import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import member.domain.MemberDTO;



public class Members extends AbstractController {
	
	private AdminMemberDAO mdao = new AdminMemberDAO_imple();

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 관리자(admin) 로 로그인 했을때만 접속 가능하도록 한다
		
//		HttpSession session = request.getSession();
		
//		MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
		
//		if(loginuser != null && "admin".equals(loginuser.getUserid())) {
			// 관리자로 로그인 했을 경우
			
		
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
		String sizePerPage = request.getParameter("sizePerPage");
		String currentShowPageNo = request.getParameter("currentShowPageNo");
		
		if(searchType == null || 
		   (!"name".equals(searchType) &&  
		    !"userid".equals(searchType) &&
		    !"email".equals(searchType)) ) {
		    searchType = "";	
		}
		
		if(searchWord == null || searchWord.isBlank()) {
		   searchWord = "";	
		}
		
		if(sizePerPage == null || 
		   (!"10".equals(sizePerPage) &&  
		    !"5".equals(sizePerPage) &&
		    !"3".equals(sizePerPage)) ) {
			sizePerPage = "10";	
		}
		
		if(currentShowPageNo == null) {
			currentShowPageNo = "1";	
		}
		
	//	System.out.println("~~~ 확인용 searchType : " + searchType);
	//	System.out.println("~~~ 확인용 searchWord : " + searchWord);
	//	System.out.println("~~~ 확인용 sizePerPage : " + sizePerPage);
	//	System.out.println("~~~ 확인용 currentShowPageNo : " + currentShowPageNo);
		/*
		   ~~~ 확인용 searchType : 
           ~~~ 확인용 searchWord : 
           ~~~ 확인용 currentShowPageNo : 1
           
           ~~~ 확인용 searchType : name
           ~~~ 확인용 searchWord : 유
           ~~~ 확인용 currentShowPageNo : 1
           
           ~~~ 확인용 searchType : userid
           ~~~ 확인용 searchWord : 3
           ~~~ 확인용 currentShowPageNo : 1
           
           ~~~ 확인용 searchType : email
           ~~~ 확인용 searchWord : eomjh@gmail.com
           ~~~ 확인용 currentShowPageNo : 1
		*/
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		
		// **** 페이징 처리를 안한 모든 회원 또는 검색한 회원 목록 보여주기 **** //
	//	List<MemberDTO> memberList = mdao.selectMemberNopaging(paraMap);
		
		
		// **** 페이징 처리를 한 모든 회원 또는 검색한 회원 목록 보여주기 **** //
		paraMap.put("sizePerPage", sizePerPage);
		paraMap.put("currentShowPageNo", currentShowPageNo);
		
		
		// 페이징 처리를 위한 검색이 있는 또는 검색이 없는 회원에 대한 총페이지수 알아오기 //
		int totalPage = mdao.getTotalPage(paraMap);
		System.out.println("~~~~ 확인용 totalPage => " + totalPage);
		
		
		// === GET 방식이므로 사용자가 웹브라우저 주소창에서 currentShowPageNo 에 totalPage 값 보다 더 큰값을 입력하여 장난친 경우
		// === GET 방식이므로 사용자가 웹브라우저 주소창에서 currentShowPageNo 에 0 또는 음수를 입력하여 장난친 경우
		// === GET 방식이므로 사용자가 웹브라우저 주소창에서 currentShowPageNo 에 숫자가 아닌 문자열을 입력하여 장난친 경우 
		// 아래처럼 막아주도록 하겠다.
		try {
			 if( Integer.parseInt(currentShowPageNo) > totalPage || 
				 Integer.parseInt(currentShowPageNo) <= 0 ) {
				 currentShowPageNo = "1";
				 paraMap.put("currentShowPageNo", currentShowPageNo);
			 }
		} catch(NumberFormatException e) {
			currentShowPageNo = "1";
			paraMap.put("currentShowPageNo", currentShowPageNo);
		}
		
		
		// *** ======= 페이지바 만들기 시작 ======= *** //
		/*
          1개 블럭당 10개씩 잘라서 페이지를 만든다.
          1개 페이지당 3개행 또는 5개행 또는 10개행을 보여주는데
              만약에 1개 페이지당 5개행을 보여준다라면 
              총 몇개 블럭이 나와야 할까? 
              총 회원수가 207명 이고, 1개 페이지당 보여줄 회원수가 5 이라면
          207/5 = 41.4 ==> 42(totalPage)        
              
          1블럭       [맨처음]  1  2  3  4  5  6  7  8  9  10 [다음][마지막]
	      2블럭   [맨처음][이전] 11 12 13 14 15 16 17 18 19 20 [다음][마지막]
	      3블럭   [맨처음][이전] 21 22 23 24 25 26 27 28 29 30 [다음][마지막]
	      4블럭   [맨처음][이전] 31 32 33 34 35 36 37 38 39 40 [다음][마지막]
	      5블럭   [맨처음][이전] 41 42 [마지막] 
       */
	      
	      // ==== !!! pageNo 구하는 공식 !!! ==== // 
	   /*
	       1  2  3  4  5  6  7  8  9  10  -- 첫번째 블럭의 페이지번호 시작값(pageNo)은  1 이다.
	       11 12 13 14 15 16 17 18 19 20  -- 두번째 블럭의 페이지번호 시작값(pageNo)은 11 이다.   
	       21 22 23 24 25 26 27 28 29 30  -- 세번째 블럭의 페이지번호 시작값(pageNo)은 21 이다.
	       
	        currentShowPageNo        pageNo  ==> ( (currentShowPageNo - 1)/blockSize ) * blockSize + 1 
	       ---------------------------------------------------------------------------------------------
	              1                   1 = ( (1 - 1)/10 ) * 10 + 1 
	              2                   1 = ( (2 - 1)/10 ) * 10 + 1 
	              3                   1 = ( (3 - 1)/10 ) * 10 + 1 
	              4                   1 = ( (4 - 1)/10 ) * 10 + 1  
	              5                   1 = ( (5 - 1)/10 ) * 10 + 1 
	              6                   1 = ( (6 - 1)/10 ) * 10 + 1 
	              7                   1 = ( (7 - 1)/10 ) * 10 + 1 
	              8                   1 = ( (8 - 1)/10 ) * 10 + 1 
	              9                   1 = ( (9 - 1)/10 ) * 10 + 1 
	             10                   1 = ( (10 - 1)/10 ) * 10 + 1 
	              
	             11                  11 = ( (11 - 1)/10 ) * 10 + 1 
	             12                  11 = ( (12 - 1)/10 ) * 10 + 1
	             13                  11 = ( (13 - 1)/10 ) * 10 + 1
	             14                  11 = ( (14 - 1)/10 ) * 10 + 1
	             15                  11 = ( (15 - 1)/10 ) * 10 + 1
	             16                  11 = ( (16 - 1)/10 ) * 10 + 1
	             17                  11 = ( (17 - 1)/10 ) * 10 + 1
	             18                  11 = ( (18 - 1)/10 ) * 10 + 1 
	             19                  11 = ( (19 - 1)/10 ) * 10 + 1
	             20                  11 = ( (20 - 1)/10 ) * 10 + 1
	              
	             21                  21 = ( (21 - 1)/10 ) * 10 + 1 
	             22                  21 = ( (22 - 1)/10 ) * 10 + 1
	             23                  21 = ( (23 - 1)/10 ) * 10 + 1
	             24                  21 = ( (24 - 1)/10 ) * 10 + 1
	             25                  21 = ( (25 - 1)/10 ) * 10 + 1
	             26                  21 = ( (26 - 1)/10 ) * 10 + 1
	             27                  21 = ( (27 - 1)/10 ) * 10 + 1
	             28                  21 = ( (28 - 1)/10 ) * 10 + 1 
	             29                  21 = ( (29 - 1)/10 ) * 10 + 1
	             30                  21 = ( (30 - 1)/10 ) * 10 + 1                    

	    */
		String pageBar = "";
		
		int blockSize = 10;
		// blockSize 는 블럭(토막)당 보여지는 페이지 번호의 개수 이다.
		
		int loop = 1;
		// loop 는 1 부터 증가하여 1개 블럭을 이루는 페이지번호의 개수(지금은 10개)까지만 증가하는 용도이다.
		
		// ==== !!! 다음은 pageNo 구하는 공식이다. !!! ==== // 
		int pageNo = ( (Integer.parseInt(currentShowPageNo) - 1)/blockSize ) * blockSize + 1; 
		// pageNo 는 페이지바에서 보여지는 첫번째 번호이다.
		
		// *** [맨처음][이전] 만들기 *** //
		pageBar += "<li class='page-item'><a class='page-link' href='admin/members.hp?searchType="+searchType+"&searchWord="+searchWord+"&sizePerPage="+sizePerPage+"&currentShowPageNo=1'>[맨처음]</a></li>";  
		
		if(pageNo != 1) {
			pageBar += "<li class='page-item'><a class='page-link' href='admin/members.hp?searchType="+searchType+"&searchWord="+searchWord+"&sizePerPage="+sizePerPage+"&currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>";
		}
		
		while(!(loop > blockSize || pageNo > totalPage)) {
			
			if(pageNo == Integer.parseInt(currentShowPageNo)) {
				pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+"</a></li>";
			}
			else {
				pageBar += "<li class='page-item'><a class='page-link' href='admin/members.hp?searchType="+searchType+"&searchWord="+searchWord+"&sizePerPage="+sizePerPage+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>"; 
			}
			
			loop++;   // 1 2 3 4 5 6 7 8 9 10
			
			pageNo++; //  1  2  3  4  5  6  7  8  9 10
			          // 11 12 13 14 15 16 17 18 19 20
			          // 21 22 23 24 25 26 27 28 29 30
			          // 31 32 33 34 35 36 37 38 39 40
			          // 41 42  
		}// end of while(!(loop > blockSize || pageNo > totalPage))-----------------------
		
		// *** [다음][마지막] 만들기 *** //
		// pageNo ==> 11
		
		if(pageNo <= totalPage) {
			pageBar += "<li class='page-item'><a class='page-link' href='admin/members.hp?searchType="+searchType+"&searchWord="+searchWord+"&sizePerPage="+sizePerPage+"&currentShowPageNo="+pageNo+"'>[다음]</a></li>"; 
		}
		pageBar += "<li class='page-item'><a class='page-link' href='admin/members.hp?searchType="+searchType+"&searchWord="+searchWord+"&sizePerPage="+sizePerPage+"&currentShowPageNo="+totalPage+"'>[마지막]</a></li>";
		
		// *** ======= 페이지바 만들기 끝 ======= *** //
		
		
		List<MemberDTO> memberList = mdao.selectMemberPaging(paraMap);
		
		request.setAttribute("memberList", memberList);
		
		request.setAttribute("searchType", searchType);
		request.setAttribute("searchWord", searchWord);
		request.setAttribute("sizePerPage", sizePerPage);
		
		request.setAttribute("pageBar", pageBar);
		
		
		/* >>> 뷰단(memberList.jsp)에서 "페이징 처리시 보여주는 순번 공식" 에서 사용하기 위해 
	       검색이 있는 또는 검색이 없는 회원의 총개수 알아오기 시작 <<< */
		   int totalMemberCount = mdao.getTotalMemberCount(paraMap);
	   //  System.out.println("~~~~ 확인용 totalMemberCount : " + totalMemberCount);
		   
//		   request.setAttribute("totalMemberCount", totalMemberCount);
//		   request.setAttribute("currentShowPageNo", currentShowPageNo);
		/* >>> 뷰단(memberList.jsp)에서 "페이징 처리시 보여주는 순번 공식" 에서 사용하기 위해 
	       검색이 있는 또는 검색이 없는 회원의 총개수 알아오기 끝 <<< */
		
		
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/admin/admin_members.jsp");
			
//		}
//		else {
			// 관리자로 로그인 하지 않은 경우
//			String message = "관리자만 접근이 가능합니다";
//			String loc = "javascript:history.back()";
			
//			request.setAttribute("message", message);
//			request.setAttribute("loc", loc);
			
//			super.setRedirect(false);
//			super.setViewPage("/WEB-INF/msg.jsp");
			
//		}
		
	}

}
