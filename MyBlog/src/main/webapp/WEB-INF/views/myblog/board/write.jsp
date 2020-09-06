<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>write</title>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/assets/css/board/write.css">

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
		<img class="categoryBarBtn" src="/assets/images/category_brown.png">
	</header>
	
	<main>
		<form id="boardWrite" action="/myblog/board/write" method="post" enctype="multipart/form-data">
			<div class="mb-3">
				<label for="board_uno">USER</label>
				<input type="text" id="uno" class="form-control" name="boarduno" value="${userInfo.uno}" readonly />
			</div>
			
			<div class="mb-3">
				<label for="reg_id">작성자</label>
				<input type="text" id="reg_id" class="form-control" name="regid" value="${userInfo.userid}" readonly />
			</div>
			
			<div class="mb-3">
				<label for="boardTitle">제목</label>
				<input type="text" id="boardTitle" class="form-control" name="boardtitle" placeholder="제목을 입력해주세요."/>
			</div>
			
			<div class="mb-3">
				<label for="boardContent">내용</label>
				<textarea id="boardContent" class="form-control" rows="5" name="boardcontent" placeholder="내용을 입력해주세요."></textarea>
			</div>
			
			<div class="mb-3">
				<label for="tag">TAG</label>
				<input type="text" id="tag" class="form-control" name="tag" placeholder="태그를 입력해주세요." />
			</div>
			
			<div class="mb-3">
				<label for="file">파일첨부</label>
				<input type="file" id="file" class="form-control" name="files" placeholder="파일선택" />
			</div>
			
			<div class="btnGroup">
				<button type="button" id="registBtn" class="btn btn-sm btn-primary">등록</button>
				<button type="button" id="listBtn" class="btn btn-sm btn-primary"
						onclick="goList('${current.page}', '${current.range}', '${current.searchType}', '${current.keyword}')">목록</button>
			</div>
		</form>
	</main>

</body>

<script>

function goList(page, range, searchType, keyword) {
	var url = '/myblog/board/list';
	
	url = url + "?page=" + page;
	url = url + "&range=" + range;
	url = url + "&searchType=" + searchType;
	url = url + "&keyword=" + keyword;
	
	location.href = url;
}

(function($) {
	
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

			} else if (second == 20 && minute == 0) {
				$('.sessionPopup').show();

				var reset = $('.reset');

				reset.click(function() {
					location.href = '/myblog/myPage?uno=${userInfo.uno}';
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
		
	var	registBtn = $('#registBtn');
	
	registBtn.click(function() {
		var uno = $('#uno').val(),
			boardTitle = $('#boardTitle').val(),
			reg_id = $('#reg_id').val(),
			boardContent = $('#boardContent').val(),
			tag = $('#tag').val();
		
		var formData = new FormData($('#boardWrite')[0]);
		
		if (boardTitle == '') {
			alert('제목을 입력해주세요.');
			
		} else if (boardContent == '') {
			alert('내용을 입력해주세요.');
			
		} else {
			
			$.ajax({
				type: 'post',
				url: '/myblog/board/write',
				processData: false,
                contentType: false,
				data: formData,
				success: function(result) {
					if (result == 1) {
						alert('등록 완료되었습니다.');
						location.href='/myblog/board/list';
						
					} else {
						alert('오류가 발생했습니다.');
						
					}
					
				}
			});
			
			
			/* $.ajax({
				type: 'post',
				url: '/myblog/board/write',
				headers: {
					'Content-Type': 'application/json',
					'X-HTTP-Method-Override': 'post'
				},
				processData: false,
				data: JSON.stringify({
					'boarduno': uno,
					'regid': reg_id,
					'boardtitle': boardTitle,
					'boardcontent': boardContent,
					'tag': tag
				}),
				success: function(data) {
					alert('등록이 완료되었습니다.');
					location.href='/myblog/board/list';
				}
			}); */
			
		}
		
	});
		
		
	
})(jQuery);

</script>

</html>















