package com.myblog.service;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class MailServiceImple implements MailService {
	
	@Autowired
	private JavaMailSender javaMailSender;
	
	public void setJavaMailSender(JavaMailSender javaMailSender) {
        this.javaMailSender = javaMailSender;
    }

	public boolean send(String subject, String text, String from, String to) {
		
		 MimeMessage message = javaMailSender.createMimeMessage();
		 
	        try {
	            // org.springframework.mail.javamail.MimeMessageHelper
	            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
	            helper.setSubject(subject);
	            helper.setText(text, true);
	            helper.setFrom(from);
	            helper.setTo(to);
	 
	            javaMailSender.send(message);
	            return true;
	        } catch (MessagingException e) {
	            e.printStackTrace();
	        }
	        return false;
	}

}
