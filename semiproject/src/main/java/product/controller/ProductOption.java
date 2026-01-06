package product.controller;


import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import product.domain.ProductDTO;
import product.domain.ProductOptionDTO;
import product.model.ProductDAO;
import product.model.ProductDAO_imple;

//상품상세페이지
public class ProductOption extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String productCode = request.getParameter("productCode");
		//위의 받아온 productCode는 상품테이블의 상품코드임!!
		
		//로그인을 한 세션정보 가져오기(MemberLogin.java / myPage.java 참고)
		HttpSession session = request.getSession();
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
		
		System.out.println(loginUser.getName());
		
		request.setAttribute("loginUser", loginUser);
		
		try {
			//제품정보 가져오기(제품테이블)
			ProductDTO proDto = proDao.selectOne(productCode);

			ProductOptionDTO proOptionDto = proDao.selectOptionOne(productCode);
			//System.out.println(proOptionDto.getTotalPrice());
			
			request.setAttribute("proDto", proDto);
			//request.setAttribute("proOptionList", proOptionList);
			request.setAttribute("proOptionDto", proOptionDto);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/product_TH/productOption.jsp");
	}

}
