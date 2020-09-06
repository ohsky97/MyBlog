package com.myblog.service;

import java.util.List;

import com.myblog.domain.Reply;

public interface ReplyService {
	
	// 전체 댓글
	public List<Reply> getReplyList(int replybno);
	
	public int registReply(Reply reply);
	
	public int updateReply(Reply reply);
	
	public int deleteReply(int rno);
	
}
