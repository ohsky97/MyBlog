package com.myblog.security;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

public class LoginFailHandler implements AuthenticationFailureHandler {
	
	private final Logger logger = LoggerFactory.getLogger(LoginFailHandler.class);

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {
		
		
		// 계정 없음
		// InternalAuthenticationServiceException 은 계정이 없는 경우 뿐만 아니라
		// 인증 요청에 대한 처리가 이루어질 때 발생하는 모든 시스템 에러에 대해 발생하는 예외이다.
		if (exception instanceof AuthenticationServiceException) {
			request.setAttribute("errorMsg", "존재하지 않는 계정입니다.");
			
			logger.error("UsernameNotFound - 계정 없음");
		
		// 비밀번호 불일치
		} else if (exception instanceof BadCredentialsException) {
			request.setAttribute("errorMsg", "비밀번호가 일치하지 않습니다. 다시 입력해주세요.");
			
			logger.error("BadCredentialsException - 비밀번호가 틀립니다. 다시입력해주세요.");
		}
		
		
		// 로그인 페이지로 다시 포워딩
		RequestDispatcher dispatcher = request.getRequestDispatcher("/myblog/auth/logIn");
		dispatcher.forward(request, response);
	}
	

}













