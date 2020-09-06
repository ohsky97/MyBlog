package com.myblog.security;

import java.util.Arrays;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.myblog.domain.UserEntity;
import com.myblog.repository.UserRepository;

@Service
public class CustomUserDetailsService implements UserDetailsService {
	
	@Autowired
	private UserRepository userRepository;

	@Override
	public UserDetails loadUserByUsername(String userid) throws UsernameNotFoundException {
		
		UserEntity userEntity = userRepository.findByUserid(userid).orElseThrow(null);
		
		
		return new User(userEntity.getUserid(), userEntity.getUserpwd(), Arrays.asList(new
							SimpleGrantedAuthority(userEntity.getRole())));
	}


}













