package com.myblog.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.myblog.domain.Reply;
import com.myblog.service.ReplyService;

@RestController
@RequestMapping(value = "/myblog/reply")
public class ReplyController {
	
	private final Logger logger = LoggerFactory.getLogger(ReplyController.class);
	
	@Autowired
	private ReplyService replyService;
	
	// 댓글 리스트 출력
	@RequestMapping(value = "/getReplyList")
	public List<Reply> getReplyList(@RequestParam("replybno") int replybno) {
		
		logger.info("replyList 호출");
		
		return replyService.getReplyList(replybno);
	}
	
	// 댓글 등록
	@RequestMapping(value = "/registReply", method = RequestMethod.POST)
	public ResponseEntity<Integer> registReply(@RequestBody Reply reply) {
		
		
		System.out.println(reply);
		
		SimpleDateFormat simple = new SimpleDateFormat("yyyy-MM-dd hh:mm");
		
		reply.setRegdate(simple.format(new Date()));
		reply.setEditdate(simple.format(new Date()));
		
		System.out.println("댓글 시간: " + reply.getRegdate());
		
		int result = replyService.registReply(reply);
		
		ResponseEntity<Integer> entity = null;
		
		if (result == 1) {
			entity = new ResponseEntity<Integer>(result, HttpStatus.OK);
		} else {
			entity = new ResponseEntity<Integer>(result, HttpStatus.BAD_REQUEST);
		}
			
		
		return entity;
	}
	
	// 댓글 수정
	@RequestMapping(value = "/updateReply", method = RequestMethod.PUT)
	public ResponseEntity<Integer> updateReply(@RequestBody Reply reply) {
		
		
		System.out.println(reply);
		
		SimpleDateFormat simple = new SimpleDateFormat("yyyy-MM-dd hh:mm");
		
		reply.setEditdate(simple.format(new Date()));
		
		int result = replyService.updateReply(reply);
		
		ResponseEntity<Integer> entity = null;
		
		if (result == 1) {
			entity = new ResponseEntity<Integer>(result, HttpStatus.OK);
		} else {
			entity = new ResponseEntity<Integer>(result, HttpStatus.BAD_REQUEST);
		}
			
		
		return entity;
	}
	
	// 댓글 삭제
	@RequestMapping(value = "/deleteReply", method = RequestMethod.DELETE)
	public ResponseEntity<Integer> deleteReply(@RequestBody Reply reply) {
		
		System.out.println(reply);
		
		int result = replyService.deleteReply(reply.getRno());
		
		ResponseEntity<Integer> entity = null;
		
		if (result == 1) {
			entity = new ResponseEntity<Integer>(result, HttpStatus.OK);
		} else {
			entity = new ResponseEntity<Integer>(result, HttpStatus.BAD_REQUEST);
		}
			
		
		return entity;
	}
	

}






















