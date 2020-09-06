package com.myblog.service;

public interface MailService {
	
	// 이메일 내용
	public boolean send(String subject, String text, String from, String to);
}
