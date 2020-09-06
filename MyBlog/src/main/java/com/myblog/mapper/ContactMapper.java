package com.myblog.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.myblog.domain.Contact;

@Mapper
public interface ContactMapper {
	
	int contactCon(Contact contact);
}
