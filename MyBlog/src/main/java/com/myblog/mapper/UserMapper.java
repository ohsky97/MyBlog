package com.myblog.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.myblog.domain.UserEntity;

@Mapper
public interface UserMapper {
	
	// 회원가입
	int registUser(UserEntity user);
	
	// 아이디(이메일) 중복검사
	int checkId(UserEntity user);
	
	// 로그인 체크
	UserEntity logInCheck(String user);
	
	// 이름, 전화번호체크
	int findUser(UserEntity user);
	
	// 임시 비밀번호 변경
	int updatePwd(UserEntity user);
	
	// 회원번호로 정보 찾기
	UserEntity findUserByUno(Long uno);
	

}








