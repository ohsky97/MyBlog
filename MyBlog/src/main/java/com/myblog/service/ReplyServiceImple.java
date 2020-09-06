package com.myblog.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.myblog.domain.Reply;
import com.myblog.mapper.ReplyMapper;

@Service
public class ReplyServiceImple implements ReplyService {
	
	private final Logger logger = LoggerFactory.getLogger(ReplyServiceImple.class);

	@Autowired
	private ReplyMapper replyMapper;
	
	@Override
	public List<Reply> getReplyList(int replybno) {
		
		logger.info("getReplyList() 호출");
		
		return replyMapper.getReplyList(replybno);
	}

	@Override
	public int registReply(Reply reply) {

		logger.info("registReply() 호출");
		
		return replyMapper.registReply(reply);
	}

	@Override
	public int updateReply(Reply reply) {
		
		logger.info("updateReply() 호출");
		
		return replyMapper.updateReply(reply);
	}

	@Override
	public int deleteReply(int rno) {
		
		logger.info("deleteReply() 호출");
		
		return replyMapper.deleteReply(rno);
	}


}
