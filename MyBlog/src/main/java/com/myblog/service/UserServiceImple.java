package com.myblog.service;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.myblog.domain.UserEntity;
import com.myblog.mapper.UserMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class UserServiceImple implements UserService {
	
	private final Logger logger = LoggerFactory.getLogger(UserServiceImple.class);

	
	@Autowired private UserMapper userMapper;
	
	
	// 회원가입
	public int insert(UserEntity user) {
		logger.info("UserServiceImple insert()");
		
		return userMapper.registUser(user);
	}
	
	// 아이디(이메일) 중복검사
	public int checkId(UserEntity user) {
		logger.info("checkId()", user);
		
		int result = userMapper.checkId(user);
		
		return result;
	}

	
	// 로그인 체크
	public UserEntity logInCheck(String userid) {
		logger.info("logInCheck()", userid);

		
		return userMapper.logInCheck(userid);
	}


	// 이름과 전화번호 체크
	public int findUser(UserEntity user) {
		logger.info("findUser() 호출");
		
		int result = userMapper.findUser(user);
		
		return result;
	}

	// 임시 비밀번호 변경
	public int updatePwd(UserEntity user) {
		logger.info("updatePwd() 호출");
		
		
		return userMapper.updatePwd(user);
	}

	// 회원번호로 정보찾기
	public UserEntity checkUno(Long uno) {
		logger.info("checkUno() 호출");
		
		return userMapper.findUserByUno(uno);
	}

	// 개인정보 수정
	@Override
	public int updateUserInfo(UserEntity user) {
		
		logger.info("updateUserInfo() 호출");
		
		return userMapper.updateUserInfo(user);
	}

	@Override
	public int deleteUser(String userId) {

		logger.info("deleteUser() 호출");
		
		return userMapper.deleteUser(userId);
	}


}
