package com.myblog.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.myblog.domain.Reply;

@Mapper
public interface ReplyMapper {
	
	// 전체 댓글
	List<Reply> getReplyList(int replybno);
	
	// 댓글 등록
	int registReply(Reply reply);
	
	// 댓글 수정
	int updateReply(Reply reply);
	
	// 댓글 삭제
	int deleteReply(int rno);

}














