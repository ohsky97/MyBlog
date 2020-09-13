package com.myblog.controller;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.myblog.domain.UserEntity;
import com.myblog.service.UserService;

@Controller
@RequestMapping(value = "/myblog")
public class MyPageController {
	
	private final Logger logger = LoggerFactory.getLogger(MyPageController.class);
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private BCryptPasswordEncoder passEncoder;
	
	@RequestMapping(value = "/myPage")
	public void moveMyPage(HttpSession session) {
		
		logger.info("MyPage 호출");
		session.getAttribute("userInfo");
		
	}
	
	// 개인정보 수정
	@RequestMapping(value = "/updateUserInfo", method = RequestMethod.PUT)
	public ResponseEntity<Integer> updateUserInfo(@RequestBody UserEntity user) {
		
		System.out.println("userInfo: " + user);
		UserEntity userInfo = UserEntity.builder()
				.username(user.getUsername())
				.userid(user.getUserid())
				.userpwd(passEncoder.encode(user.getUserpwd()))
				.userpn(user.getUserpn())
				.role("USER")
				.build();
		
		int result = userService.updateUserInfo(userInfo);
		
		ResponseEntity<Integer> entity = null;
		
		if (result == 1) {
			entity = new ResponseEntity<Integer>(result, HttpStatus.OK);
		} else {
			entity = new ResponseEntity<Integer>(result, HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}
	
	
	// 회원 탈퇴
	@RequestMapping(value = "/deleteUser", method = RequestMethod.DELETE)
	public ResponseEntity<Integer> deleteUser(@RequestBody UserEntity user) {
		
		System.out.println(user);
		
		int result = userService.deleteUser(user.getUserid());
		
		ResponseEntity<Integer> entity = null;
		
		if (result == 1) {
			entity = new ResponseEntity<Integer>(result, HttpStatus.OK);
		} else {
			entity = new ResponseEntity<Integer>(result, HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}

}

























