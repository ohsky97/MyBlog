package com.myblog.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.myblog.domain.UserEntity;
import com.myblog.service.UserService;

public class LoginSuccessHandler implements AuthenticationSuccessHandler {
	
	@Autowired
	private UserService userService;
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		
		// 로그인 성공하기 전, 실패 시 발생한 에러가 세션에 저장되어 있는데, 그것을 제거 하기위한 메서드 
		clearAuthenticationAttributes(request);
		
		HttpSession session = request.getSession();
		
		UserEntity user = userService.logInCheck(authentication.getName());
		
		System.out.println("ROLE: " + authentication.getAuthorities());
		
		session.setAttribute("userInfo", user);
//		session.setAttribute("userAuth", authentication.getName());
		
		response.sendRedirect("/");
	}
	
	protected void clearAuthenticationAttributes(HttpServletRequest req) {
		HttpSession session = req.getSession(false);
		
		if (session == null) return;
		session.removeAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
	}

}











