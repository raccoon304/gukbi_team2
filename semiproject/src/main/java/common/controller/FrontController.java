package common.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.Constructor;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

// ㅎㅇ

@WebServlet(
		description = "사용자가 웹에서 *.hp을 했을 경우 이 서블릿이 응답을 해주도록 한다.", 
		urlPatterns = { "*.hp" },  
		initParams = { 

				@WebInitParam(name = "propertyConfig", value = "C:/Users/sist/git/gukbi_team2/semiproject/src/main/webapp/WEB-INF/Command.properties", description = "*.hp 에 대한 클래스의 매핑파일")


		})
public class FrontController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private Map<String, Object> cmdMap = new HashMap<>();
	
	
	
	public void init(ServletConfig config) throws ServletException {
		/*
        웹브라우저 주소창에서  *.hp 을 하면 FrontController 서블릿이 응대를 해오는데 맨 처음에 자동적으로 실행되어지는 메소드가 init(ServletConfig config) 이다.
        여기서 중요한 것은 init(ServletConfig config) 메소드는 WAS(톰캣)가 구동되어진 후 딱 1번만 init(ServletConfig config) 메소드가 실행되어지고, 그 이후에는 실행이 되지 않는다. 
        그러므로 init(ServletConfig config) 메소드에는 FrontController 서블릿이 동작해야할 환경설정을 잡아주는데 사용된다.
		*/
		// *** 확인용 *** //
		// System.out.println("~~~ 확인용 => 서블릿 FrontController 의 init(ServletConfig config) 메서드가 실행됨.");
	    // ~~~ 확인용 => 서블릿 FrontController 의 init(ServletConfig config) 메서드가 실행됨.
		
		FileInputStream fis = null;
		//특정 파일에 있는 내용을 읽어오기 위한 용도로 쓰이는 객체 		
		
		String props = config.getInitParameter("propertyConfig");
		// System.out.println("확인용 => "+props);
		//확인용 => C:/NCS/workspace_jsp/MyMVC_1/src/main/webapp/WEB-INF/Command.properties
		
		try {
			fis = new FileInputStream(props);
			//fis는 C:/NCS/workspace_jsp/MyMVC_1/src/main/webapp/WEB-INF/Command.properties 파일의 내용을 읽어오기 위한 용도로 쓰이는 객체이다. 
			Properties pr = new Properties();
			// Properties 는 Collection 중 HashMap 계열중의 하나로써
	        // "key","value"으로 이루어져 있는것이다.
	        // 그런데 중요한 것은 Properties 는 key도 String 타입이고, value도 String 타입만 가능하다는 것이다.
	        // key는 중복을 허락하지 않는다. value 값을 얻어오기 위해서는 key값 만 알면 된다.
			
			pr.load(fis);
			// pr.load(fis); 은 fis 객체를 사용하여 C:/NCS/workspace_jsp/MyMVC/src/main/webapp/WEB-INF/Command.properties 파일의 내용을 읽어다가 Properties 클래스의 객체인 pr 에 로드시킨다.
			// 그러면 pr 은 읽어온 파일(Command.properties)의 내용에서 = 을 기준으로 왼쪽은 key로 보고, 오른쪽은 value 로 인식한다.

			Enumeration<Object> en = pr.keys();
	        //pr.keys(); 은 C:/NCS/workspace_jsp/MyMVC/src/main/webapp/WEB-INF/Command.properties 파일의 내용물에서 = 을 기준으로 왼쪽에 있는 모든 key 들만 가져오는 것이다.   
	       
			while(en.hasMoreElements()) {
				String key = (String) en.nextElement();
				//System.out.println("확인용 key =>"+ key);
				// System.out.println("확인용 value =>"+ pr.getProperty(key)+"\n");
				/*
				 * 확인용 key =>/test/test2.up 확인용 value =>test.controller.Test2Controller
				 * 확인용 key =>/test3.up 확인용 value =>test.controller.Test3Controller
				 * 확인용 key =>/test1.up 확인용 value =>test.controller.Test1Controller
				 */			
				String className = pr.getProperty(key);
				if(className != null) {
					className = className.trim();
					Class<?> cls = Class.forName(className);
					// <?> 은 generic 인데 어떤 클래스 타입인지는 모르지만 하여튼 클래스 타입이 들어온다는 뜻이다.
	                // String 타입으로 되어진 className 을 클래스화 시켜주는 것이다.
	                // 주의할 점은 실제로 String 으로 되어져 있는 문자열이 클래스로 존재해야만 한다는 것이다.
			
					Constructor<?> constrt = cls.getDeclaredConstructor();
					// 생성자 만들기.
					
					Object obj = constrt.newInstance();
					//생성자로 부터 실제 객체(인스턴스)를 생성해주는것이다.
					/*
					 * --확인용 Text2Controller 클래스 생성자 호출-- 
					 * --확인용 Text3Controller 클래스 생성자 호출-- 
					 * --확인용 Text1Controller 클래스 생성자 호출--
					*/
					
					cmdMap.put(key, obj);
					// cmdMap 속에 obj를 넣을때 key를 Command.properties 파일에 있는 url주소 (/test1.up)로 함.
					
					
				}// EoP if(className != null) -----
				
				
			}// EoP while(en.hasMoreElements()) -------------------
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			System.out.println(">> 문자열로 명명되어진 클래스가 존재하지 않습니다. ");
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}// EoP public void init(ServletConfig config) throws ServletException ======================================
	// 초기 환경setup 설정
	

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 웹 브라우저의 주소 입력창에서 
		// http://localhost:9090/MyMVC/member/idDuplicateCheck.up?userid=leess 와 같이 입력되었더라면 
		//String url = request.getRequestURL().toString();
		//System.out.println("확인용 url =>"+url);
		//확인용 url =>http://localhost:9090/MyMVC/member/idDuplicateCheck.up
		
		// 웹 브라우저의 주소 입력창에서 
		// http://localhost:9090/MyMVC/member/idDuplicateCheck.up?userid=leess 와 같이 입력되었더라면 
		String uri = request.getRequestURI();
		System.out.println("확인용 uri =>"+uri);
		// 확인용 uri =>/MyMVC/member/idDuplicateCheck.up
		// 확인용 uri =>/MyMVC/test1.up
		// 확인용 uri =>/MyMVC/test/test2.up
		// 확인용 uri =>/MyMVC/test3.up
		
		
		String key = uri.substring(request.getContextPath().length());
		// request.getContextPath() => /MyMVC
		// request.getContextPath().length() ==> 6자리 
		/*
			/member/idDuplicateCheck.up
			/test1.up
			/test/test2.up
			/test3.up
		*/	
		AbstractController action = (AbstractController) cmdMap.get(key);
		// 다형성 
		
		if(action == null) {// 존재하지 않는 uri값을 넣었을 경우 
			System.out.println(""+key+"는 uri 패턴에 맵핑된 클래스는 없습니다.");
		}
		else {// 존재하는 uri 값을 넣어준 경우.
			try {
				action.execute(request, response);
				
				boolean bool = action.isRedirect();
				String viewPage = action.getViewPage();
				if(!bool) {
					// viewPage 에 명기된 view단 페이지로 forward(dispatcher)를 하겠다는 말이다.
	                // forward 되어지면 웹브라우저의 URL주소 변경되지 않고 그대로 이면서 화면에 보여지는 내용은 forward 되어지는 jsp 파일이다.
	                // 또한 forward 방식은 forward 되어지는 페이지로 데이터를 전달할 수 있다는 것이다.
					if(viewPage != null) {
						RequestDispatcher dispatcher = request.getRequestDispatcher(viewPage);
						dispatcher.forward(request, response);
					}
				}
				else {
					// viewPage 에 명기된 주소로 sendRedirect(웹브라우저의 URL주소 변경됨)를 하겠다는 말이다.
	                // 즉, 단순히 페이지이동을 하겠다는 말이다. 
	                // 암기할 내용은 sendRedirect 방식은 sendRedirect 되어지는 페이지로 데이터를 전달할 수가 없다는 것이다.
					if(viewPage != null) {
						response.sendRedirect(viewPage);
					}
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
