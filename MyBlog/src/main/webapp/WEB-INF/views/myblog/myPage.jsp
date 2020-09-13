<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/assets/css/myPage.css?ver=1.1">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>


</head>
<body>

	<header>
		<img class="logo" src="/assets/images/logo.png" onclick="location.href='/'">
		<label class="logout" onclick="location.href='/logout'">Logout</label>
	</header>
	
		<div class="main">
		<section class="signInfo">
			<div class="name">
				<span>NAME.</span>
				<input id="userName" type="text" name="username" value="${userInfo.username}" placeholder="성함을 적어주세요." required />
			</div>	
			
			<div class="id">
				<span>EMAIL.</span>
				<input id="userId" type="email" name="userid" value="${userInfo.userid}" placeholder="이메일" readonly />
			</div>
			
			<div class="pwd">
				<span>PSWD.</span>
				<input id="userPwd" type="password" name="userpwd" placeholder="비밀번호" required />
			</div>
			<div class="PN">
				<span>PHONE.</span>
				<input id="userPN" type="text" name="userpn" value="${userInfo.userpn}" placeholder="전화번호(-빼고 입력해주세요.)" required />
			</div>
			<div class="underBar">
				<button id="ok" type="submit">수정</button>
				<button id="btnDelete" type="button" data-toggle="modal" data-target="#userCheckModal">삭제</button>
			</div>
		</section>
	</div>
	
				<!-- 아이디  확인창 -->
				<div class="modal fade" id="userCheckModal" data-backdrop="static">
    				<div class="modal-dialog">
     					<div class="modal-content">
      
	       					<!--  Modal Header -->
	       					 <div class="modal-header">
	         					 <h4 class="modal-title">계정 탈퇴</h4><br/>
	        				</div>
	        
	        				<!-- Modal body -->
	       					 <div class="modal-body">
	       					 	<h6>확인을 위해 아이디를 작성해주세요.</h6>
					         	<input id="modalUserId" class="form-control" name="userid" pl />
					         </div>
	        
	       					<!-- Modal footer -->
					        <div class="modal-footer">
					        	<button type="button" id="checkOk" class="btn btn-sm btn-primary">확인</button>
					        	<button class="btn btn-sm btn-primary" type="button" data-dismiss="modal">취소</button>
					        </div>
        
						</div>
					</div>
				</div>

</body>

<script>

	(function($) {
		
		var ok = $('#ok'),
			btnDelete = $('#btnDelete');
		
		ok.click(function() {
			
			var userName = $('#userName').val(),
				userId = $('#userId').val(),
				userPwd = $('#userPwd').val(),
				userPN = $('#userPN').val(),
			
			NameCheck = /^[가-힣]{2,4}|[a-zA-Z]{2,10}\s[a-zA-Z]{2,10}$/,
			PNCheck = /^(?:(010\d{4})|(01[1|6|7|8|9]\d{3,4}))(\d{4})$/;
			
			// userName 검사
			if(!userName) {
				alert('이름을 입력해 주세요!');
				
			} else if(!NameCheck.test(userName)) {
				alert('잘못된 표기의 이름입니다.');

			// userPwd 검사
			} else if(userPwd == "") {
				alert('비밀번호를 입력해주세요!');
				
			} else if(userPwd.length < 6 || userPwd.length > 10) {
				if(userPwd.length > 10) {
					alert('최대 10글자이하로 입력해주세요.');
					
				} else if (userPwd.length < 6) {
					alert('최소 6글자이상으로 입력해주세요.');
					
				}
			
			// userPN 검사
			} else if(userPN == "" && userPN == 0) {
				alert('전화번호를 입력해주세요!');
				
			} else if(!PNCheck.test(userPN)) {
				alert('알맞는 전화번호를 입력해주세요.');
				
			} else {
				$.ajax({
					type: 'put',
					url: '/myblog/updateUserInfo',
					headers: {
						'Content-Type': 'application/json',
						'X-HTTP-Method-Override': 'put'
					},
					data: JSON.stringify({
						'username': userName,
						'userid': userId,
						'userpwd': userPwd,
						'userpn': userPN
					}),
					success: function(result) {
						if (result == 1) {
							alert('수정되었습니다.');
							location.href='/myblog/myPage';
						
						} else {
							alert('오류가 발생했습니다.');
						}
						
					}
				}); 
			}
		});
		
		$('#checkOk').click(function() {
			var userId = $('#modalUserId').val();
			
			if (userId == '') {
				alert('아이디를 입력해 주세요');
				$('#userId').focus();
				return;
				
			} else {
				$.ajax({
					type: 'delete',
					url: '/myblog/deleteUser',
					headers: {
						'Content-Type': 'application/json',
						'X-HTTP-Method-Override': 'delete'
					},
					data: JSON.stringify({
						'userid': userId
					}),
					success: function(result) {
						if (result == 1) {
							alert('그동안 이용해 주셔서 감사합니다.');
							location.href='/';
							
						} 
						
					},
					error: function() {
						alert('아이디가 일치하지 않습니다.');
					}
				});
				
			}
		});
		
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
						location.href = '/myblog/home';
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
		
		
		// 세션에 저장한 정보를 읽어 로그인 체크하여 null일 경우 로그인 페이지 이동
		// 아니면 마이페이지 이동
		var uno = '${userInfo.uno}';
		
		 if (uno != '') {
			 
			 // 로그인 정보 확인되면 카운트 실행
			 countDown();
		 }
		 
	})(jQuery);

</script>

</html>














