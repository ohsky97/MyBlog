package com.myblog.config;

import org.springframework.boot.web.servlet.ServletListenerRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.session.HttpSessionEventPublisher;

import com.myblog.security.LoginFailHandler;
import com.myblog.security.LoginSuccessHandler;


@Configuration
@EnableWebSecurity
public class WebSecurityConfiguration extends WebSecurityConfigurerAdapter {
	
	// security에 대한 인증을 무시하고 사용 가능한 경로
	@Override
	public void configure(WebSecurity web) throws Exception {
		web.ignoring()
			.antMatchers("/assets/**", "/uploads/**");
	}
	
	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http
			.csrf().disable() // 추후 csrf 처리 진행
			.authorizeRequests() // 인증 요청시 .permitAll()을 제외한 나머지 모든 요청은 권한이 필요
				.antMatchers("/", "/myblog/auth/**", "/myblog/contact").permitAll()
			.anyRequest().authenticated()
			.and()
			.formLogin() // 로그인 인증을 하여 권한 부여
				.loginPage("/myblog/auth/logIn")
				.loginProcessingUrl("/logInCheck")
				.usernameParameter("userid") // input 태그의 name 값과 동일하게 설정
				.passwordParameter("userpwd") // input 태그의 name 값과 동일하게 설정
				.successHandler(loginSuccessHandler())
				.failureHandler(loginFailHandler())
			.and()
			.logout()
				.logoutUrl("/logout")
				.logoutSuccessUrl("/myblog/auth/logIn")
				.invalidateHttpSession(true) // 세션제거
				.deleteCookies("JSESSIONID") // 쿠키제거
				.clearAuthentication(true) // 권한 제거
				.permitAll()
			.and()
			.sessionManagement()
				.maximumSessions(1) // session 허용갯수
				.maxSessionsPreventsLogin(true)  // 동일한 사용자 로그인 시 거절
				.expiredUrl("/myblog/auth/logIn") // 중복로그인이 일어날 경우 이동할 페이지
			.and()
			.sessionFixation()  // 고정세션공격 보호 - 공격자가 JSESSIONID를 가로채서 Session을 공유하여 공격하는 방법
			.changeSessionId(); // 새로운 세션아이디가 발급되고, 이전 세션으로 설정되었던 것을 그대로 사용할 수 있음.

				
	}
	
	// 로그인 성공 시, 처리 핸들러
	@Bean
	public AuthenticationSuccessHandler loginSuccessHandler() {
		return new LoginSuccessHandler();
	}
	
	// 로그인 실패 시, 처리 핸들러
	@Bean
	public AuthenticationFailureHandler loginFailHandler() {
		return new LoginFailHandler();
	}
	
	// 비밀번호 암호화
	@Bean
	public BCryptPasswordEncoder bcyBCryptPasswordEncoder() {
		return new BCryptPasswordEncoder();
	}
	
	// invalidateHttpSession(true)가 정상작동하지 않아서 세션이 삭제되지 않는다.
	// 이를 해결하기 위해 이 메소드를 추가하고 @Bean등록을 해준다.
	@Bean
	public ServletListenerRegistrationBean<HttpSessionEventPublisher> httpSessionEventPublisher() {
		return new ServletListenerRegistrationBean<HttpSessionEventPublisher>(
				new HttpSessionEventPublisher());
	}
	
}



























