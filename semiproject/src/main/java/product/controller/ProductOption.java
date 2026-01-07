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
		//로그인을 한 세션정보 가져오기(MemberLogin.java / myPage.java 참고)
		HttpSession session = request.getSession();
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
		request.setAttribute("loginUser", loginUser);

		String productCode = request.getParameter("productCode");
		//위의 받아온 productCode는 상품테이블의 상품코드임!!
		
		try {
			//제품정보 가져오기(제품테이블)
			ProductDTO proDto = proDao.selectOne(productCode);

			//제품코드에 대한 제품상세정보 가져오기(제품상세테이블)
			ProductOptionDTO proOptionDto = proDao.selectOptionOne(productCode);
			//System.out.println(proOptionDto.getTotalPrice());
			
			//제품코드에 따른 옵션 중 추가금을 Map<>으로 전부 가져오기(256GB, 512GB)
			//Map<String, String> paraMap = proDao.selectOptionPlusPrice();
			
			//제품코드에 따른 추가금을 가져오기(512GB만 추가금이 있으므로 그것만 가져오기
			int plusPrice = proDao.selectOptionPlusPrice(productCode);
				
			request.setAttribute("proDto", proDto);
			//request.setAttribute("proOptionList", proOptionList);
			request.setAttribute("proOptionDto", proOptionDto);
			
			//request.setAttribute("paraMap", paraMap);
			//System.out.println(paraMap.get(productCode));
			
			request.setAttribute("plusPrice", plusPrice);
			//System.out.println(plusPrice);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/product_TH/productOption.jsp");
	}

}
