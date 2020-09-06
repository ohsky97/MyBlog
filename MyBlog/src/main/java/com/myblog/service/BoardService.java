package com.myblog.service;

import java.util.List;

import com.myblog.common.Search;
import com.myblog.domain.Board;

public interface BoardService {
	
	// 게시판 리스트 출력
	public List<Board> getBoardList(Search search) throws Exception;
	
	// 총 게시글 개수
	public int getBoardListCnt(Search search);
	
	// 게시판 상세 출력
	public Board getBoardContent(int bno);

	// 게시글 등록
	public int registBoard(Board board);
	
	// 게시글 수정
	public int updateBoard(Board board);
	
	// 게시글 수정
	public int updateViewCnt(int bno);
	
	
	// 게시글 삭제
	public int deleteBoard(int bno);

}










