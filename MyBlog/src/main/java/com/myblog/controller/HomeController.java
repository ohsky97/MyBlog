package com.myblog.controller;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeController {
	private final Logger logger = LoggerFactory.getLogger(HomeController.class);

	// home
	@RequestMapping(value = "/")
	public String home(HttpSession session) {
		logger.info("myblog main 호출");
		session.getAttribute("userInfo");
		
		
		return "/home";
	}
	
	
}
















