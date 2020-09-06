package com.myblog.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.myblog.domain.Contact;
import com.myblog.service.ContactService;

@Controller
@RequestMapping("/myblog/*")
public class ContactController {
	
	private final Logger logger = LoggerFactory.getLogger(ContactController.class);
	
	@Autowired ContactService contactService;
	
	@ResponseBody
	@RequestMapping(value = "/contact", method = RequestMethod.POST)
	public ResponseEntity<Integer> contact(@RequestBody Contact contact) {
		
		logger.info("ContactController() 호출");
		
		int result = contactService.contactCon(contact);
		
		ResponseEntity<Integer> entity = null;
		if (result == 1) {
			entity = new ResponseEntity<Integer>(result, HttpStatus.OK);
		} else {
			entity = new ResponseEntity<Integer>(result, HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}
	
}














