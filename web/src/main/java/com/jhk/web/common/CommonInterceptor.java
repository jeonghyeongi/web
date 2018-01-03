package com.jhk.web.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import jdk.internal.jline.internal.Log;

@Component
public class CommonInterceptor extends HandlerInterceptorAdapter{
	private static final Logger log = LoggerFactory.getLogger(CommonInterceptor.class);
	
	@Override    
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response,  Object handler) throws Exception{
		
		String loginYn = null;
		
		HandlerMethod handlerMethod = (HandlerMethod)handler;
		Class<?> clazz= handlerMethod.getBeanType();
		
		if(handlerMethod != null) {
			CommonCheck commMethodChk = handlerMethod.getMethodAnnotation(CommonCheck.class);
			if(commMethodChk != null){
				loginYn = commMethodChk.isLogin();
			}
		}
		
		CommonCheck commClassChk = (CommonCheck)clazz.getAnnotation(CommonCheck.class);
		if(commClassChk != null){
			if(loginYn == null || "".equals(loginYn)){
				loginYn = commClassChk.isLogin();
			}
		}
		
		
		if("Y".equalsIgnoreCase(loginYn)){
			HttpSession session = request.getSession();
			String id = (String) session.getAttribute("id");
			if(id == null) {
				log.info("세션아이디 없음");
				response.sendRedirect("/login");
				return false;
			}
		}
		
		log.info("인터셉터 종료");
		
        return true;
    }
	
	@Override
	public void postHandle(HttpServletRequest request, 
			HttpServletResponse response, Object handler, ModelAndView mav) throws Exception {
		
		super.postHandle(request, response, handler, mav); //- jsp 파싱전.
	}
	 
	@Override
	public void afterCompletion(HttpServletRequest request, 
			HttpServletResponse response, Object handler, Exception ex) throws Exception {
		super.afterCompletion(request, response, handler, ex); //- jsp 파싱후에
	}

}
