package com.myblog.service;

import com.myblog.domain.UserEntity;

public interface UserService {
	
	// 회원가입
	public int insert(UserEntity user);
	
	// 아이디(이메일) 중복 검사
	public int checkId(UserEntity user);
	
	// 로그인 체크
	public UserEntity logInCheck(String userid);
	
	// 회원정보
	public int findUser(UserEntity user);
	
	// 임시 비밀번호 변경
	public int updatePwd(UserEntity user);
	
	// 회원번호로 정보찾기
	public UserEntity checkUno(Long uno);
	
	// 개인정보 수정
	public int updateUserInfo(UserEntity user);
	
	// 회원 탈퇴
	public int deleteUser(String userId);

}
