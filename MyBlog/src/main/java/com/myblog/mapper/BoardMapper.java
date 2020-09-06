package com.myblog.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.myblog.common.Search;
import com.myblog.domain.Board;
import com.myblog.domain.FileVO;

@Mapper
public interface BoardMapper {
	
	// 게시판 리스트 출력
	List<Board> getBoardList(Search search) throws Exception;
	
	// 총 게시글 개수
	int getBoardListCnt(Search search);
	
	// 게시판 상세 출력
	Board getBoardContent(int bno);
	
	// 게시글 등록
	int registBoard(Board board);
	
	// 파일 등록
	int fileRegist(FileVO file);
	
	// 파일 상세 - 다운로드
	FileVO fileDetail(int filebno);
	
	// 파일 삭제
	int fileDelete(int fno);
	
	// 게시글 수정
	int updateBoard(Board board);
	
	// 조회수 업데이트
	int updateViewCnt(int bno);
	
	// 게시글 삭제
	int deleteBoard(int bno);
	
}















