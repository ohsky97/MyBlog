<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>detail</title>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/assets/css/board/detail.css">

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
	
	<main class="container" role="main">
		<div class="bg-white rounded shadow-sm">
			<div class="boardTitle"><label>${detail.boardtitle}</label></div>
			<div class="boardInfoBox">
				<span class="boardAuthor"><label>${detail.regid}</label></span>
				<span class="boardDate"><label>${detail.regdate}</label></span>
			</div>
			<div class="boardContent">${detail.boardcontent}</div><br/>
			<div class="tag">TAG: <label>${detail.tag}</label></div>
			<div class="fileDownload">
				<label>첨부파일</label><br/>
				<a href="/myblog/board/fileDown/${files.filebno}">${files.fileoriname}</a>
				<c:if test="${userInfo.userid == detail.regid && files.fno != null}">
					<button class="btnDeleteFile btn btn-sm btn-danger" type="button">삭제</button>
				</c:if>
			</div>
		</div>
		
		<div class="btnGroup">
			<button type="button" id="btnList" class="btn btn-sm btn-primary"
					onclick="goList('${current.page}', '${current.range}', '${current.searchType}', '${current.keyword}')">목록</button>
			<button type="button" id="btnUpdate" class="btn btn-sm btn-primary"
					data-toggle="modal" data-target="#updateBoard">수정</button>
			<button type="button" id="btnDelete" class="btn btn-sm btn-danger"
					data-toggle="modal" data-target="#deleteBoard">삭제</button>
		</div>
	</main>
	
	<!-- 수정 모달창 -->
	<div class="modal fade" id="updateBoard" data-backdrop="static">
		<div class="modal-dialog">
			<div class="modal-content">
				<!-- Modal Header -->
				<div class="modal-header">
					<h4>게시글 수정</h4>
				</div>
				
				<!-- Modal Body -->
				<form class="modal-body" action="/myblog/board/update" method="post" enctype="multipart/form-data">
					<input type="hidden" name="bno" value="${detail.bno}" />
					<label for="boardTitle">제목</label>
					<input class="form-control" type="text" id="boardTitle" name="boardtitle" value="${detail.boardtitle}" /><br/>
					<label for="boardContent">내용</label>
					<textarea class="form-control" id="boardContent" name="boardcontent" rows="5">${detail.boardcontent}</textarea><br/>
					<label for="modalTag">태그</label>
					<input class="form-control" type="text" id="modalTag" name="tag" value="${detail.tag}" /><br/>
					<c:if test="${files.fno == null}">
						<label>첨부파일</label><br/>
						<input type="file" id="file" class="form-control" name="files" placeholder="파일선택" /><br/>
					</c:if>
					
					<!-- form 태그에서 method는 get, post 밖에 지원되지 않아서 이런 방법을 이용 -->
					<input type="hidden" name="_method" value="put" /> 
				</form>
				
				<!-- Modal footer -->
				<div class="modal-footer">
					<button id="updateOk" class="btn btn-sm btn-primary" type="button">확인</button>
					<button class="btn btn-sm btn-primary" type="button" data-dismiss="modal">취소</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 삭제 모달창 -->
	<div class="modal fade" id="deleteBoard" data-backdrop="static">
		<div class="modal-dialog">
			<div class="modal-content">
				<!-- Modal Header -->
				<div class="modal-header">
					<h4>정말로 삭제 하시겠습니까?</h4>
				</div>
				
				<!-- Modal footer -->
				<div class="modal-footer">
					<button id="delete" class="btn btn-sm btn-danger" type="button">삭제</button>
					<button class="btn btn-sm btn-primary" type="button" data-dismiss="modal">취소</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 댓글 영역 -->
	<div id="replyArea" class="container my-3 p-3 bg-white rounded shadow-sm">
		<form:form id="replyForm" name="form" role="form" modelAttribute="reply">
			
			<form:hidden id="bno" path="replybno" />
			
			<div class="row">
				<div class="col-sm-10">
					<form:textarea id="replyContent" class="form-control" path="replycontent" rows="3" placeholder="댓글을 입력해주세요."></form:textarea>
				</div>
				<div class="col-sm-2">
					<form:input path="regid" class="form-control" id="regId" value="${userInfo.userid}" readonly="true"></form:input>
					<button id="btnRegistReply" class="btn btn-sm btn-primary" type="button">저장</button>
				</div>
			</div>
		</form:form>
	</div>
	
	<div id="replyListForm" class="container my-3 p-3 bg-white rounded shadow-sm">
		<h6 class="border-bottom pb-2 mb-0">Reply List</h6>
		
		<div id="replyList"></div>
	</div>
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
						location.href = '/myblog/board/detail?bno=${detail.bno}';
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
		
		// 로그인 유저와 게시글 작성자 일치 유무
		// 수정, 삭제 버튼
		if ('${userInfo.userid}' != '${detail.regid}') {
			$('#btnUpdate').hide();
			$('#btnDelete').hide();
			$('#btnList').css('margin-left', '120px');
			
			
		}
		
		// 파일 업로드 삭제
		$('.btnDeleteFile').click(function() {
			var fno = '${files.fno}',
				fileName = '${files.filename}';
			
			$.ajax({
				type: 'delete',
				url: '/myblog/board/fileDelete',
				headers: {
					'Content-Type': 'application/json',
					'X-HTTP-Method-Override': 'delete'
				},
				data: JSON.stringify({
					'fno': fno,
					'filename': fileName 
				}),
				success: function(result) {
					if (result == 1) {
						alert('삭제 완료되었습니다.');
						location.href='/myblog/board/detail?bno=${detail.bno}';
				
					} else {
						alert('삭제 도중 오류가 발생했습니다.');
					}
					
				}
			});
		});
		
		// 게시글 수정
		$('#updateOk').click(function() {
			
			var boardTitle = $('#boardTitle').val(),
				boardContent = $('#boardContent').val(),
				modalTag = $('#modalTag').val();
			
			var formData = new FormData($('.modal-body')[0]);
			
			if (boardTitle == '') {
				alert('제목을 입력해주세요');
				
			} else if (boardContent == '') {
				alert('내용을 입력해주세요.');
				
			} else {
				$.ajax({
					type: 'put',
					url: '/myblog/board/update',
					processData: false,
                    contentType: false,
					data: formData,
					success: function(result) {
						if (result == 1) {
							alert('수정이 완료되었습니다.');
							location.href='/myblog/board/detail?bno=${detail.bno}';
							
						} else {
							alert('오류가 발생했습니다.');
							
						}
						
					}
				});
				
			}
				
		});
		
		// 게시글 삭제
		$('#delete').click(function() {
			var bno = ${detail.bno},
				fileName = '${files.filename}';
			
			console.log(bno);
			
			$.ajax({
				type: 'delete',
				url: '/myblog/board/delete',
				headers: {
					'Content-Type': 'application/json',
					'X-HTTP-Method-Override': 'delete'
				},
				data: JSON.stringify({
					'bno': bno,
					'filename': fileName
				}),
				success: function(result) {
					if (result == 1) {
						alert('삭제 완료되었습니다.');
						location.href='/myblog/board/list?page=${current.page}&range=${current.range}';
						
					} else {
						alert('오류가 발생했습니다.');
					}
					
				}
			});
		});
		
		// 댓글 등록
		$('#btnRegistReply').click(function() {
			var replyContent = $('#replyContent').val(),
				regId = $('#regId').val(),
				bno = ${detail.bno};
			
			console.log(replyContent);
			if (replyContent == '') {
				alert('댓글을 입력해주세요.');
			} else {
				$.ajax({
					type: 'post',
					url: '/myblog/reply/registReply',
					headers: {
						'Content-Type': 'application/json',
						'X-HTTP-Method-Override': 'post'
					},
					data: JSON.stringify({
						'replybno': bno,
						'replycontent': replyContent,
						'regid': regId
					}),
					success: function(result) {
						
						if (result == 1) {
							alert('등록 완료되었습니다.');
							showReplyList();
							
							$('#replyContent').val('');
							
						} else {
							alert('댓글 등록에 오류가 발생했습니다.');
						}
						
						
					}
				});
				
			}
			
		});
		
	})(jQuery);
	
	
	// 댓글 수정 폼
	function editReply(rno, regid, replycontent, editdate){

		var htmls = "";

		htmls += '<div class="media text-muted pt-3" id="rno' + rno + '">';

			htmls += '<svg class="bd-placeholder-img mr-2 rounded" width="32" height="32" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid slice" focusable="false" role="img" aria-label="Placeholder:32x32">';
	
				htmls += '<title>Placeholder</title>';
		
				htmls += '<rect width="100%" height="100%" fill="#007bff"></rect>';
		
				htmls += '<text x="50%" fill="#007bff" dy=".3em">32x32</text>';
	
			htmls += '</svg>';
	
			htmls += '<p class="media-body pb-3 mb-0 small lh-125 border-bottom horder-gray">';
		
				htmls += '<span class="d-block">';
		
					htmls += '<strong class="text-gray-dark">' + regid + '</strong>';
			
					htmls += '<span style="padding-left: 7px; font-size: 9pt">';
			
						htmls += '<a href="#" onclick="updateReply(' + rno + ', \'' + regid + '\')" style="padding-right:5px">저장</a>';
				
						htmls += '<a href="#" onClick="showReplyList()">취소<a> </br>';
						
						htmls += '<span class="text-grey-dark">';
							
							htmls += editdate;
							
						htmls += '</span>';
						
					htmls += '</span>';
		
				htmls += '</span>';		
		
				htmls += '<textarea name="editContent" id="editContent" class="form-control" rows="3">';
		
					htmls += replycontent;
		
				htmls += '</textarea>';
	
			
	
			htmls += '</p>';

		htmls += '</div>';

		

		$('#rno' + rno).replaceWith(htmls);

		$('#rno' + rno + ' #editContent').focus();

	}
	
	// 댓글 수정
	function updateReply(rno, regid) {
		var replyContent = $('#editContent').val();
		
		if (replyContent == '') {
			alert('내용을 입력해주세요.');
			
		} else {
			$.ajax({
				type: 'put',
				url: '/myblog/reply/updateReply',
				headers: {
					'Content-Type': 'application/json',
					'X-HTTP-Method-Override': 'put'
				},
				data: JSON.stringify({
					'rno': rno,
					'replycontent': replyContent,
				}),
				success: function(result) {
					if (result == 1) {
						alert('수정 완료되었습니다.');
						showReplyList();
						
						$('#editContent').val('');
						
					} else {
						alert('댓글 수정에 오류가 발생했습니다.');
					}
					
					
				}
			});
			
		}
		
	}
	
	// 댓글 삭제
	function deleteReply(rno) {
		
		console.log(rno);
		
		$.ajax({
			type: 'delete',
			url: '/myblog/reply/deleteReply',
			headers: {
				'Content-Type': 'application/json',
				'X-HTTP-Method-Override': 'delete'
			},
			data: JSON.stringify({
				'rno': rno,
			}),
			success: function(result) {
				if (result == 1) {
					alert('삭제 완료되었습니다.');
					showReplyList();
					
				} else {
					alert('댓글 삭제에 오류가 발생했습니다.');
				}
				
				
			}
		});
	}
	
	
	// 댓글 리스트 출력
	function showReplyList() {
		var url = '/myblog/reply/getReplyList';
		
		var paramData = {'replybno' : '${detail.bno}'};
		
		$.ajax({
			type: 'post',
			url: url,
			data: paramData,
			dataType: 'json',
			success: function(result) {
				var htmls = '';
				
				if (result.length < 1) {
					htmls = '등록된 댓글이 없습니다.';
					
				} else {
					$(result).each(function() {
						htmls += '<div class="media text-muted pt-3" id="rno' + this.rno + '">';
							htmls += '<svg class="bd-placeholder-img mr-2 rounded" width="32" height="32" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid slice" focusable="false" role="img" aria-label="Placeholder:32x32">';

	                    		htmls += '<title>Placeholder</title>';

	                    		htmls += '<rect width="100%" height="100%" fill="#007bff"></rect>';

	                    		htmls += '<text x="50%" fill="#007bff" dy=".3em">32x32</text>';

	                    	htmls += '</svg>';

	                    	htmls += '<p style="position: relative; width: 100%;" class="media-body pb-3 mb-0 small lh-125 border-bottom horder-gray">';

	                    		htmls += '<span class="d-block">';
	                    		
		                    		htmls += '<strong class="text-gray-dark">' + this.regid + '</strong>';
				
		                    		if ('${userInfo.userid}' == this.regid) {
		                    			
		                    			htmls += '<span style="padding-left: 7px; font-size: 9pt">';
	
			                    			htmls += '<a href="#" onclick="editReply(' + this.rno + ', \'' + this.regid + '\', \'' + this.replycontent + '\', \'' + this.editdate + '\')" style="padding-right:5px">수정</a>';
			
				                    		htmls += '<a href="#" onclick="deleteReply(' + this.rno + ')" >삭제</a>';
										
		                    			htmls += '</span>';
		                    		
		                    		}
		                    		
		                    		htmls += '<span style="position: absolute; right: 0; font-size: 9pt;">'
			                    		
		                    			htmls += this.editdate;
		                    		
		                    		htmls += '</span> </br>';

	                    		htmls += '</span>';
	                    		
	                    		htmls += this.replycontent;
	                    		
	                    	htmls += '</p>';

	                     htmls += '</div>';
					});
				}
				$('#replyList').html(htmls);
			}
		});
			
	}
	
	showReplyList();

</script>

</html>
















