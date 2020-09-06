package com.myblog.common;

import lombok.Data;

@Data
public class Pagination {
	
	private int listSize = 10;  // 초기 목록개수 10
	private int rangeSize = 10; // 초기 페이지 범위 10
	private int page; // 현재 페이지 정보
	private int range; // 현재 페이지 범위 정보
	private double listCnt; // 총 게시글 개수
	private double pageCnt; // 총 페이지 범위 개수
	private int totalRange; // 총 페이지 범위
	private int startPage; // 각 페이지 범위의 시작 번호 (1, 11, 21,)
	private int startList; // 게시판 시작 번호
	private double endPage; // 각 페이지 범위의 끝 번호 (1, 11, 21,)
	private boolean start; // 처음
	private boolean prev; // 이전
	private boolean next; // 다음
	private boolean end; // 끝
	
	
	public void pageInfo(int page, int range, int listCnt) {
		this.page = page;
		this.range = range;
		this.listCnt = listCnt;
		
		// 전체 페이지 수
		// int로 캐스팅할 경우 정수로만 반환되어 반올림 처리가 되지 않아서
		// 10개 단위가 아니라면 데이터가 누락된다. 
		this.pageCnt = Math.ceil((double)listCnt/listSize);
		
		// 
		this.totalRange = (int) (pageCnt/rangeSize) + 1;
		
		// 시작 페이지
		this.startPage = (range -1) * rangeSize + 1;
		
		// 끝 페이지
		this.endPage = range * rangeSize;
		
		// 게시판 시작번호
		this.startList = (page - 1) * listSize;
		
		// 처음 버튼
		this.start = page == 1 || range == 1 ? false : true;
		
		// 이전 버튼 상태
		this.prev = range == 1 ? false : true;
		
		// 다음 버튼 상태
		this.next = pageCnt > endPage ? true : false;
		if (this.endPage > this.pageCnt) {
			this.endPage = this.pageCnt;
			this.next = false;
		}
		
		// 끝 버튼
		this.end = pageCnt > endPage ? true : false;

	}
	
	
}























