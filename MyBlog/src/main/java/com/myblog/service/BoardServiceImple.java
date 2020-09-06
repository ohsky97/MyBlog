package com.myblog.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.myblog.common.Search;
import com.myblog.domain.Board;
import com.myblog.mapper.BoardMapper;

@Service
public class BoardServiceImple implements BoardService {
	
	private final Logger logger = LoggerFactory.getLogger(BoardServiceImple.class);
	
	@Autowired
	private BoardMapper boardMapper;

	@Override
	public List<Board> getBoardList(Search search) throws Exception {
		
		logger.info("getBoardList() 호출");
		
		return boardMapper.getBoardList(search);
	}
	
	@Override
	public int getBoardListCnt(Search search) {
		
		logger.info("getBoardListCnt() 호출");
		
		return boardMapper.getBoardListCnt(search);
	}

	@Override
	public int registBoard(Board board) {
		logger.info("registBoard() 호출");
		return boardMapper.registBoard(board);
	}

	@Override
	public Board getBoardContent(int bno) {

		
		return boardMapper.getBoardContent(bno);
	}
	
	@Override
	public int updateViewCnt(int bno) {
		
		return boardMapper.updateViewCnt(bno);
	}

	@Override
	public int updateBoard(Board board) {
		logger.info("updateBoard() 호출");
		
		return boardMapper.updateBoard(board);
	}

	@Override
	public int deleteBoard(int bno) {
		logger.info("deleteBoard() 호출");
		
		return boardMapper.deleteBoard(bno);
	}


}














