package com.myblog.domain;

import lombok.Data;

@Data
public class Board {
	
	private int bno;
	private Long boarduno;
	private String category;
	private String boardtitle;
	private String boardcontent;
	private String tag;
	private int cnt;
	private String regid;
	private String regdate;
	private String editdate;
	
	// view에서 받아온 파일이름을 임시저장 - 삭제하기 위해
	private String filename;

}



















