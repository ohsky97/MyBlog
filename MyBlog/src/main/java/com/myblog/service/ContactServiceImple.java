package com.myblog.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.myblog.domain.Contact;
import com.myblog.mapper.ContactMapper;

@Service
public class ContactServiceImple implements ContactService {

	private final Logger logger = LoggerFactory.getLogger(ContactServiceImple.class);
	
	@Autowired private ContactMapper contactMapper;

	public int contactCon(Contact contact) {
		
		logger.info("contactCon() 호출");
		
		return contactMapper.contactCon(contact);
	}
	
}










