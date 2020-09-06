<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/assets/css/logIn.css?ver=1.1">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>

<!-- csrf 토큰 -->
<%-- <meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}" /> --%>


</head>
<body>
	
	<header>
		<img class="logo" src="/assets/images/logo.png" onclick="location.href='/myblog'">
	</header>
	
	<section class="logInForm">
		<div class="logInCon">
			<label class="conTitle">로그인</label>
			<form id="logInFo" action="/logInCheck" method="post">
				<input id="userId" type="email" name="userid" maxlength="30" placeholder="Email"
						onkeypress="enterLogIn()" />
				<input id="userPwd" type="password" name="userpwd" maxlength="10" placeholder="Password"
						onkeypress="enterLogIn()"/>
				<input id="logInButton" type="button" value="입장"/>
				
				<!-- csrf 토큰을 로그인 정보와 같이 보내준다. -->
				<%-- <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/> --%>
				<br/><label class="warning">${requestScope.errorMsg}</label>
			</form>
			<div class="findBtn">	
				<a id="findPwdBtn" class="btn" data-toggle="modal" data-target="#userCheckModal">Password</a><span>를 잃어버리셨습니까?</span>
				<a href="/myblog/auth/signUp">회원가입</a>
			</div>
		</div>
	</section>					
				<!-- 이름, 이메일 체크를 위한 모달창 -->
				<div class="modal fade" id="userCheckModal" data-backdrop="static">
    				<div class="modal-dialog">
     					<div class="modal-content">
      
	       					<!--  Modal Header -->
	       					 <div class="modal-header">
	         					 <h4 class="modal-title">비밀번호 찾기</h4>
	          					<button id="close" type="button" class="close" data-dismiss="modal">&times;</button>
	        				</div>
	        
	        				<!-- Modal body -->
	       					 <div class="modal-body">
					         	<input id="modalUserName" class="form-control" name="username" placeholder="이름" /><br/>
					         	<input id="modalUserPN" class="form-control" name="userpn" placeholder="전화번호" /><br/>
					         	<label class="info" style="display: none;">가입하지 않은 계정입니다.</label>
					         </div>
	        
	       					<!-- Modal footer -->
					        <div class="modal-footer">
					        	<button type="button" id="checkOk" class="btn btn-primary">확인</button>
					        </div>
        
						</div>
					</div>
				</div>
				
				<!-- 정보확인 후 이메일 인증창 -->
				<div class="modal fade" id="findPwdModal" data-backdrop="static">
    				<div class="modal-dialog">
     					<div class="modal-content">
      
	       					<!--  Modal Header -->
	       					 <div class="modal-header">
	         					<h4 class="modal-title">임시비밀번호 발급</h4>
	          					<button id="close2" type="button" class="close" data-dismiss="modal">&times;</button>
	        				</div>
	        
	        				<!-- Modal body -->
	       					 <div class="modal-body">
	       					 	<input id="temporaryPwd" class="btn btn-primary" type="button" value="임시 비밀번호 발급" />
	       					 	<input id="recevieKey" class="form-control" type="text" placeholder="인증번호를 입력해주세요." style="display: none;" />
	       					 	<span class="countMin" style="display: none;"></span><span class="countSec" style="display: none;"></span>
					         </div>
					        
					        <!-- Modal footer -->
					        <div class="modal-footer">
					        	<button class="inspection btn btn-primary" type="submit" style="display: none;">확인</button>
					        </div>
						</div>
					</div>
				</div>
		
	
</body>

<script>
	
function enterLogIn() {
	if (event.keyCode == 13) {
		var userId = $('#userId').val(),
		userPwd = $('#userPwd').val();
	
		if ($.trim(userId) == '') {
			alert('아이디를 입력해 주세요');
			$('#userId').focus();
			return;
		} else if ($.trim(userPwd) == '') {
			alert('비밀번호를 입력해주세요.');
			$('#userPwd').focus();
			return;
		} else {
			$('#logInFo').submit();
			
		}
	}
	
}
	
	(function($) {
		
		// 기타 설정
		var close = $('#close'),
			close2 = $('#close2');
		
		close.click(function() {
			$('#modalUserName').val('');
			$('#modalUserPN').val('');
			
		});
		
		
		$('#updateOk').hide();
		
		// 로그인
		var button = $('#logInButton'),
			checkOk = $('#checkOk');
		
		button.click(function() {
			var userId = $('#userId').val(),
				userPwd = $('#userPwd').val();
			
			if ($.trim(userId) == '') {
				alert('아이디를 입력해 주세요');
				$('#userId').focus();
				return;
			} else if ($.trim(userPwd) == '') {
				alert('비밀번호를 입력해주세요.');
				$('#userPwd').focus();
				return;
			} else {
				$('#logInFo').submit();
				
			}
			
		});
		
		// 가입된 이름과 이메일 체크
	 	checkOk.click(function() {
			var userName = $('#modalUserName').val(),
				userPN = $('#modalUserPN').val(),
				NameCheck = /^[가-힣]{2,4}|[a-zA-Z]{2,10}\s[a-zA-Z]{2,10}$/,
				PNCheck = /^(?:(010\d{4})|(01[1|6|7|8|9]\d{3,4}))(\d{4})$/;
			
			if (userName == '') {
				alert('이름을 입력해주세요.');
			} else if (!NameCheck.test(userName)) {
				alert('잘못된 표기의 이름입니다.');
			} else if (userPN == '') {
				alert('전화번호를 입력해주세요.');
			} else if (!PNCheck.test(userPN)) {
				alert('전화번호 형식이 잘못되었습니다.');
			} else {
			
				$.ajax({
					type: 'post',
					url: '/myblog/auth/userCheck',
					headers: {
						'Content-Type': 'application/json',
						'X-HTTP-Method-Override': 'post'
					},
					data: JSON.stringify({
						'username': userName,
						'userpn': userPN
					}),
					success: function(data) {
						if (data == 1) {
							$('#findPwdModal').modal('show');
							$('#userCheckModal').modal('hide');
							
							// 임시비밀번호 발급 버튼 누를 시 문자 보냄
							var temporaryPwd = $('#temporaryPwd'),
								inspection = $('.inspection');
							
							temporaryPwd.click(function() {
								var recevieKey = $('#recevieKey');
								
								recevieKey.show();
								inspection.show();
								$(this).hide();
								countDown();
								
								$.ajax({
									type: 'post',
									url: '/myblog/auth/checkPN',
									headers: {
										'Content-Type': 'application/json',
										'X-HTTP-Method-Override': 'post'
									},
									data: JSON.stringify({
										'userpn' : userPN
									}),
									success: function(data) {
										alert('문자전송 완료!');
										
											inspection.click(function() {
												var recevieKey = $('#recevieKey');
											
												if ($.trim(data) == recevieKey.val()) {
													alert('인증이 완료되었습니다. 인증번호로 로그인해주세요.');
													clearInterval(timer);
													location.href='/myblog/auth/close';

												} else {
													alert('인증에 실패했습니다, 다시 시도해주세요.');
												}
											});
										
									}
								});

							});
						} else {
							$('.info').show();
						}
					}
				});
			}
		});
		
			
		
		close2.click(function() {
			$('#modalUserName').val('');
			$('#modalUserPN').val('');
			location.href='/myblog/auth/close';
		});
	
			
			
			// 카운트 설정
			function countDown() {
				// 초기값
				var minute = 2,
					second = 59;
				
				$('.countMin').show();
				$('.countSec').show();
				

				timer = setInterval(function() {
					// 설정
					$('.countMin').html(minute+':');
					$('.countSec').html(second);
					
					second--;
					
					if (second < 10) {
						$('.countSec').html('0'+second);
					}
						
				
					if (second == 0 && minute != 0) {
						minute--;
						second = 59;
						
					} else if (second == 0 && minute == 0) {
						alert('제한시간이 만료되었습니다.');
						clearInterval(timer);
						location.href='/myblog/auth/logIn';
					}
					

				}, 1000); /* millisecond 단위별 인터별 */
			}
		
		
	})(jQuery);
</script>
</html>










