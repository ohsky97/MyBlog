package com.myblog.controller;

import java.util.Random;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.myblog.domain.UserEntity;
import com.myblog.repository.UserRepository;
import com.myblog.service.MailService;
import com.myblog.service.SmsService;
import com.myblog.service.UserService;


@Controller
@RequestMapping("/myblog/auth")
public class UserController {

	private final Logger logger = LoggerFactory.getLogger(UserController.class);

	@Autowired
	private UserService userService;
	
	@Autowired
	private UserRepository userRepository;
	
	
	@Autowired
	private MailService mailService;

	@Autowired
	private SmsService smsService;

	@Autowired
	private BCryptPasswordEncoder passEncoder;

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	public void setMailService(MailService mailService) {
		this.mailService = mailService;
	}

	// 회원가입 이동
	@RequestMapping(value = "/signUp")
	public void signUp() {
		logger.info("signUp() 이동");
	}

	// 아이디(이메일) 중복검사
	@RequestMapping(value = "/checkId", method = RequestMethod.POST)
	@ResponseBody
	public String checkId(@RequestBody UserEntity user) throws Exception {

		int result = userService.checkId(user);

		return Integer.toString(result);
	}

	// 문자 인증번호 발송 - 회원가입
	@ResponseBody
	@RequestMapping(value = "/checkPhone", method = RequestMethod.POST)
	public String checkPhone(@RequestBody UserEntity user) {
		String userpn = user.getUserpn();
		Random rand = new Random();

		String numStr = "";
		for (int i = 0; i < 6; i++) {
			String ran = Integer.toString(rand.nextInt(10));
			numStr += ran;
		}

		System.out.println("수신자 번호 : " + userpn);
		System.out.println("인증번호 : " + numStr);
		smsService.certifiedPhoneNumber(userpn, numStr);
		
		return numStr;
	}

	// 문자 인증번호 발송 & 비밀번호 변경
	@ResponseBody
	@RequestMapping(value = "/checkPN", method = RequestMethod.POST)
	public String checkPN(@RequestBody UserEntity user) {

		String userpn = user.getUserpn();
		Random rand = new Random();
		String numStr = "";
		for (int i = 0; i < 6; i++) {
			String ran = Integer.toString(rand.nextInt(10));
			numStr += ran;
		}
		

		String transPwd = passEncoder.encode(numStr);
		System.out.println(userpn);

		// 비밀번호 변경
		user.setUserpn(userpn);
		user.setUserpwd(transPwd);

		userService.updatePwd(user);

		System.out.println("수신자 번호 : " + userpn);
		System.out.println("인증번호 : " + numStr);
		smsService.certifiedPhoneNumber(userpn, numStr);
		return numStr;
	}

	// 회원가입
	@RequestMapping(value = "/signUp", method = RequestMethod.POST)
	public String signUp(@RequestBody UserEntity user) {

		System.out.println(user.toString());
		UserEntity userInfo = UserEntity.builder()
				.username(user.getUsername())
				.userid(user.getUserid())
				.userpwd(passEncoder.encode(user.getUserpwd()))
				.userpn(user.getUserpn())
				.role("USER")
				.build();
		
		userRepository.save(userInfo);
		logger.info("signUp post 호출");


		return "redirect:/myblog/auth/logIn";
	}
	
	// 로그인 페이지 이동
	// LoginFailHandler 예외처리 클래스에서 로그인에 실패할 경우
	// 해당하는 exception에 메시지를 포워딩하는데
	// 로그인 form RequestMethod가 POST방식이기 때문에
	// 로그인 페이지로 이동할 메소드 get, 로그인 실패 후 메시지 포워딩을 위한 post 둘이 필요하다.
	@RequestMapping(value = "/logIn", method = {RequestMethod.GET, RequestMethod.POST})
	public void userlogIn() {
		logger.info("logIn 이동");
	}

	// 이름과 전화번호체크 - 비밀번호 변경
	@ResponseBody
	@RequestMapping(value = "/userCheck", method = RequestMethod.POST)
	public String userCheck(@RequestBody UserEntity user, HttpSession session) throws Exception {

		logger.info("userCheck() 호출");
		int result = userService.findUser(user);
		System.out.println(result);

		session.setAttribute("userPN", user.getUserpn());

		return Integer.toString(result);
	}

	// close
	@RequestMapping(value = "/close")
	public String close(HttpSession session) {
		session.invalidate();

		return "redirect:/logIn";
	}

	// 이메일 전송 - 회원가입
	@ResponseBody
	@RequestMapping(value = "/checkMail", method = RequestMethod.POST)
	public boolean checkMail(@RequestBody UserEntity user) {

		int ran = user.getRan();
		System.out.println(ran);
		String subject = "이메일 인증번호입니다.";
		StringBuilder sb = new StringBuilder();
		sb.append("인증번호: " + ran);

		String email = user.getUserid();
		System.out.println(email);

		boolean result = mailService.send(subject, sb.toString(), "pre'am", email);

		return result;
	}

}
