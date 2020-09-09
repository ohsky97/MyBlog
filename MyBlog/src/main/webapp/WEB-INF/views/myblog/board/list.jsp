<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board</title>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/assets/css/board/list.css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>

</head>
<body>

	<!-- 세션만료 팝업창 -->
	<div class="sessionPopup">
		<span class="countMin"></span><span class="countSec"></span>후 자동 로그아웃됩니다.<br/>
		<button class="reset" type="button">연장하기</button>
		<button class="out" type="button" onclick="location.href='/logout'">로그아웃</button>
	</div>

	<header>
		<img class="logo" src="/assets/images/logo.png" onclick="location.href='/myblog'">
		<img class="myPage" src="/assets/images/myPage_white.png" onclick="location.href='/myblog/myPage'">
	</header>

	<main class="table-responsive">
		<table class="table table-sm">
			<colgroup>
				<col style="width: 5%;" />
				<col style="width: 10%;" />
				<col style="width: 15%;" />
				<col style="width: 10%;" />
				<col style="width: 10%;" />
			</colgroup>
			
			<thead>
				<tr>
					<td>No.</td>
					<td>제목</td>
					<td>작성자</td>
					<td>조회수</td>
					<td>작성일</td>
				</tr>
			</thead>
			
			<tbody>
				<c:choose>
					<c:when test="${empty boardList}">
						<tr>
							<td colspan="5" align="center">
								데이터가 없습니다.
							</td>
						</tr>
					</c:when>
					<c:when test="${!empty boardList}">
						<c:forEach var="list" items="${boardList}">
							<tr>
								<td><c:out value="${list.bno}"></c:out></td>
								<td>
									<a href="/myblog/board/detail?bno=${list.bno}">
										<c:out value="${list.boardtitle}"></c:out>
									</a>
								</td>
								<td><c:out value="${list.regid}"></c:out></td>
								<td><c:out value="${list.cnt}"></c:out></td>
								<td><c:out value="${list.regdate}"></c:out></td>
							</tr>
						</c:forEach>
					</c:when>
				</c:choose>
			</tbody>
		</table>
	</main>
	
	<div class="btnGroup">
		<button type="button" class="btn btn-sm" id="writeBtn"
				onclick="location.href='/myblog/board/write'">글쓰기</button>
	</div>
	
	<!-- 페이징 처리 -->
	<div class="paginationBox">
		<ul id="paging" class="pagination">
			<c:if test="${pagination.start}">
				<li class="page-item">
					<a class="page-link" href="#"
						onclick="btnStart('${pagination.page}', '${pagination.range}', '${pagination.rangeSize}', '${pagination.searchType}', '${pagination.keyword}')">&#171;</a>
				</li>
			</c:if>
			<c:if test="${pagination.prev}">
				<li class="page-item">
					<a class="page-link" href="#"
						onclick="btnPrev('${pagination.page}', '${pagination.range}', '${pagination.rangeSize}', '${pagination.searchType}', '${pagination.keyword}')">&#60;</a>
				</li>
			</c:if>
			
			<c:forEach begin="${pagination.startPage}" end="${pagination.endPage}" var="bno">
				<li class="page-item <c:out value="${pagination.page == bno ? 'active' : ''}"/>">
					<a class="page-link" href="#"
						onclick="btnPageNum('${bno}', '${pagination.range}', '${pagination.rangeSize}', '${pagination.searchType}', '${pagination.keyword}')"> ${bno} </a>
				</li>
			</c:forEach>
			
			<c:if test="${pagination.next}">
				<li class="page-item">
					<a class="page-link" href="#"
						onclick="btnNext('${pagination.next}', '${pagination.range}', '${pagination.rangeSize}', '${pagination.searchType}', '${pagination.keyword}')">&#62;</a>
				</li>
			</c:if>
			
			<c:if test="${pagination.end}">
				<li class="page-item">
					<a class="page-link" href="#"
						onclick="btnEnd('${pagination.page}', '${pagination.totalRange}', '${pagination.pageCnt}', '${pagination.searchType}', '${pagination.keyword}')">&#187;</a>
				</li>
			</c:if>
		</ul>
	</div>
	
	<!-- 검색 -->
	<div id="search" class="form-group row justify-content-center">
		<div class="w100 dropDownOp">
			<select id="searchType" class="form-control form-control-sm" name="searchType">
				<option class="op1" value="boardtitle">제목</option>
				<option class="op2" value="boardcontent">내용</option>
				<option class="op3" value="regid">작성자</option>
			</select>
		</div>
		<div class="w300 searchCon">
			<input id="keyword" type="text" class="form-control form-control-sm" name="keyword" value="${pagination.keyword}" />
		</div>
		<div>
			<button id="btnSearch" type="button" class="btn btn-sm">검색</button>
		</div>
	</div>

</body>

<script>

	var paging = document.getElementById('paging');
	
	console.log(paging.clientWidth);
	
	console.log(${pagination.rangeSize});
	
/* 	if (paging.clientWidth == 562) {
		paging.style.marginLeft = '-281px';
		
	}  */
	console.log($('#paging').find('a').length);
	
	if ($('#paging').find('a').length == 14) {
		paging.style.marginLeft = '-281px';
	}
	
	// 처음 버튼
	function btnStart(page, range, rangeSize, searchType, keyword) {
		
		var page = 1
			range = 1;

		var url = "/myblog/board/list";
		
		url = url + "?page=" + page;
		url = url + "&range=" + range;
		url = url + "&searchType=" + $('#searchType').val();
		url = url + "&keyword=" + keyword;
		
		location.href = url;
	}
	
	// 이전 버튼 클릭
	function btnPrev(page, range, rangeSize, searchType, keyword) {
		var page = ((range - 2) * rangeSize) + 10,
			range = range - 1;
		
		var url = "/myblog/board/list";
		
		url = url + "?page=" + page;
		url = url + "&range=" + range;
		url = url + "&searchType=" + $('#searchType').val();
		url = url + "&keyword=" + keyword;
		
		location.href=url;
		
	}
	
	// 다음 버튼 클릭
	function btnNext(page, range, rangeSize, searchType, keyword) {
		var page = parseInt((range * rangeSize)) + 1;
			range = parseInt(range) + 1;
			
		var url = "/myblog/board/list";
		
		url = url + "?page=" + page;
		url = url + "&range=" + range;
		url = url + "&searchType=" + $('#searchType').val();
		url = url + "&keyword=" + keyword;
		
		location.href=url;
		

	}
	
	// 페이지 번호 클릭
	function btnPageNum(page, range, rangeSize, searchType, keyword) {
		var url = "/myblog/board/list";
		
		url = url + "?page=" + page;
		url = url + "&range=" + range;
		url = url + "&searchType=" + $('#searchType').val();
		url = url + "&keyword=" + keyword;

		location.href=url;
	}
	
	// 끝 버튼
	function btnEnd(page, totalRange, pageCnt, searchType, keyword) {
		
		var page = parseInt(pageCnt),
			range = totalRange;
		

		var url = "/myblog/board/list";
		
		url = url + "?page=" + page;
		url = url + "&range=" + range;
		url = url + "&searchType=" + $('#searchType').val();
		url = url + "&keyword=" + keyword;
		
		location.href = url;
	}
	
	
	(function($) {
		
		// 검색 이벤트
		$('#btnSearch').click(function() {
			var url = '/myblog/board/list';
			
			url = url + '?searchType=' + $('#searchType').val();
			url = url + '&keyword=' + $('#keyword').val();
			
			location.href = url;
		});
		
		
		// 검색 후 searchType 처리
		var option = $('option'),
				op1 = $('.op1'),
				op2 = $('.op2'),
				op3 = $('.op3');
			
		if ('${pagination.searchType}' == 'boardtitle') {
			op1.prop('selected', true);
			
		} else if ('${pagination.searchType}' == 'boardcontent') {
			op2.prop('selected', true);
			
		} else if ('${pagination.searchType}' == 'regid') {
			op3.prop('selected', true);
			
		}
		
		// 카운트 설정
		function countDown() {
			// 초기값
			var minute = 19, second = 59;

			timer = setInterval(function() {
				// 설정
				$('.countMin').html(minute + ':');
				$('.countSec').html(second);

				second--;

				if (second < 10) {
					$('.countSec').html('0' + second);
				}

				if (second == 0 && minute != 0) {
					minute--;
					second = 59;

				} else if (second == 21 && minute == 0) {
					$('.sessionPopup').show();

					var reset = $('.reset');

					reset.click(function() {
						location.href = '/myblog/board/list';
						clearInterval(timer);
						$('.sessionPopup').hide();
					});

				} else if (second == 0 && minute == 0) {
					alert('로그인 세션이 만료되어, 자동로그아웃 되었습니다.');
					clearInterval(timer);
					location.href = '/logout';

				}

			}, 1000); /* millisecond 단위별 인터별 */
		}
		
		// 로그인 정보를 검사해서 세션 타이머 실행
		if ('${userInfo.uno}' != '') {
			countDown();
		}
	})(jQuery);
	

</script>

</html>

















