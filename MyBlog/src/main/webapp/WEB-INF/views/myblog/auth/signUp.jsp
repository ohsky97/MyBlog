<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
	<title>회원가입</title>
	
<link rel="stylesheet" type="text/css" href="/assets/css/signUp.css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>


</head>
<body>

<div class="web">
	<header>
		<img class="logo" src="/assets/images/logo.png" onclick="location.href='/'">
		<label class="lock" onclick="location.href='/myblog/auth/logIn'">LOG IN</label>
	</header>
	
	<div class="title">
		<h2>회원가입</h2>
	</div>
	<div class="main">
		<section class="signInfo">
			<div class="name">
				<span>NAME.</span>
				<input id="userName" type="text" name="username" placeholder="성함을 적어주세요." required />
			</div>	
			
			<div class="id">
				<span>EMAIL.</span>
				<input id="userId" type="email" name="userid" placeholder="이메일" required />
				<label class="warning"></label>
				<button id="idCheck" type="button">중복체크</button>
			</div>
			<div class="inspectionOn">
				<button class="inspectionBtn">인증번호 발송</button>
			</div>
			<div class="inspection">
				<input id="keyForm" type="text" placeholder="인증번호를 입력해주세요." />
				<button class="EMCheck" type="submit">확인</button>
			</div>
			
			<div class="pwd">
				<span>PSWD.</span>
				<input id="userPwd" type="password" name="userpwd" placeholder="암호키" required />
			</div>
			<div class="PN">
				<span>PHONE.</span>
				<input id="userPN" type="tel" name="userpn" placeholder="전화번호(-빼고 입력해주세요.)" required />
				<button class="certification" type="button">인증번호</button>
			</div>
			
			<div class="certificationCon">
				<input id="key" type="text" name="key" placeholder="" />
				<button class="sub" type="submit">확인</button>
			</div>	
				
			<div class="privacyInfo">
				<input id="privacyPolicy" type="checkbox" name="privacyPolicy" required />
				<label for="privacyPolicy"></label>
				<span class="privacyT1">개인정보처리방침</span><span class="privacyT2">에 동의합니다.</span>
			</div>
				
			<div class="underBar">
				<button id="ok" type="submit">발급</button>
			</div>
		</section>
	</div>

</div>
</body>

<script>

(function($){
	var	$ok = $('#ok'),
		$idCheck = $('#idCheck'),
		su = false;
	
	var inspectionOn = $('.inspectionOn'),
		inspection = $('.inspection');
	
	$ok.click(function() {
		
		var userName = $('#userName').val(),
			userId = $('#userId').val(),
			userPwd = $('#userPwd').val(),
			userPN = $('#userPN').val(),
			checkBox = $('#privacyPolicy'),
		
		NameCheck = /^[가-힣]{2,4}|[a-zA-Z]{2,10}\s[a-zA-Z]{2,10}$/,
		EmailCheck = RegExp(/^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/),
		PNCheck = /^(?:(010\d{4})|(01[1|6|7|8|9]\d{3,4}))(\d{4})$/,
		RedundancyCheck = $('#idCheck');
		console.log(userName);
		console.log(userId);
		console.log(userPwd);
		console.log(userPN);
		
		
		/* 유효성 검사 
			userName == ""과 !userName은 같은 의미 - 변수에 .val()을 주었기때문 
		*/
		// userName 검사
		if(!userName) {
			alert('이름을 입력해 주세요!');
			
		} else if(!NameCheck.test(userName)) {
			alert('잘못된 표기의 이름입니다.');
				
		// userId = email 검사	
		} else if(!userId) {
			alert('이메일을 입력해주세요!');
			
		} else if(!EmailCheck.test(userId)) {
			alert('이메일 형식이 잘못되었습니다.');
			
			return false;
		
		// 아이디(이메일) 중복검사
		} else if(su == false) {
			alert('이메일 중복체크를 해주세요.');
	
			return;
	
		// 이메일 인증 체크
		} else if(inspectionOn.css('display') != 'none' || inspection.css('display') != 'none') {
			alert('이메일 인증을 완료해주세요.');
			
		// userPwd 검사
		} else if(userPwd == "") {
			alert('암호키를 입력해주세요!');
			
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
			
		// 인증번호 검사
		}  else if(certification.css('display') != 'none') { 
			alert('핸드폰 번호를 인증해주세요.');
			
			
		// checkBox 검사	
		} else if(!checkBox.is(":checked")) {
			alert('개인정보처리방침에 동의해주세요.');
			
		} else {
			$.ajax({
				type: 'post',
				url: '/myblog/auth/signUp',
				headers: {
					'Content-Type': 'application/json',
					'X-HTTP-Method-Override': 'post'
				},
				data: JSON.stringify({
					'username': userName,
					'userid': userId,
					'userpwd': userPwd,
					'userpn': userPN
				}),
				success: function(result) {
					alert('회원이 되신걸 환영합니다.');
					location.href='/myblog/auth/logIn'
				}
			}); 
		}
	});
	
	// userId = email 중복 검사 함수
		$idCheck.click(function() {
			
			var warning = $('.warning'),
			registId = $('#userId').val(),
			EmailCheck = RegExp(/^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/);
			
			var inspectionOn = $('.inspectionOn'),
				inspection = $('.inspection'),
				inspectionBtn = $('.inspectionBtn'),
				EMCheck = $('.EMCheck');
			if (!EmailCheck.test(registId) || !registId) {
				alert('이메일 형식이 잘못되었습니다.');
				
			} else {
				
				$.ajax({
					type: 'post',
					url: '/myblog/auth/checkId',
					headers: {
						'Content-Type': 'application/json',
						'X-HTTP-Method-Override': 'post'
					},
					data: JSON.stringify({
						'userid' : registId
					}),
					success: function(data) {
						if (data == 1) {
							warning.html('중복된 이메일이 있습니다.');

						} else if (data == 0){
							if (!EmailCheck.test(registId) || !registId) {
								alert('이메일 형식이 잘못되었습니다.');
								inspectionOn.hide();
								
							} else {
								alert('사용가능한 이메일입니다.');
								su = true;
								warning.hide();
								inspectionOn.show();
								
								inspectionBtn.click(function() {
									inspection.show();
									inspectionOn.hide();
									
									var ran = Math.floor(Math.random() * 1000000)+100000;
									
									if(ran > 1000000){
									   ran = ran - 100000;
									}
									
									console.log(ran);
									
									$.ajax({
										type: 'post',
										url: '/myblog/auth/checkMail',
										headers: {
											'Content-Type': 'application/json',
											'X-HTTP-Method-Override': 'post'
										},
										data: JSON.stringify({
											'userid' : registId,
											'ran': ran
										}),
										success: function(result) {
											if (result == true) {
												alert('이메일을 발송했습니다.');
												
												EMCheck.click(function() {
													var keyForm = $('#keyForm').val(),
														recevieKey = ran;
													
													if (keyForm == recevieKey) {
														alert('인증이 완료되었습니다.');
														inspection.hide();
														$idCheck.hide();
													} else {
														alert('인증에 실패했습니다.');
													}
												});
											}
										}
									});
								});
								
							}
							
						}
					}
				});
				
			}
			
			
		});
	
	var certification = $('.certification'), // 인증번호 버튼
		content = $('.certificationCon'),
		submit = $('.sub'); 
	
	// 인증번호 발송
	certification.click(function() {
		
		var userPN = $('#userPN').val();
		
		var PNCheck = /^(?:(010\d{4})|(01[1|6|7|8|9]\d{3,4}))(\d{4})$/;
		console.log(userPN);
		
		if (!PNCheck.test(userPN) || !userPN) {
			alert('알맞는 전화번호를 입력해주세요.');
			
		} else {
			$.ajax({
				type: 'post',
				url: '/myblog/auth/checkPhone',
				headers: {
					'Content-Type': 'application/json',
					'X-HTTP-Method-Override': 'post'
				},
				data: JSON.stringify({
					'userpn' : userPN
				}),
				success: function(data) {
					alert('문자전송 완료!');
					content.show();
					
					submit.click(function() {
						var key = $('#key').val();
						console.log(key);
						console.log(data);
						
						if ($.trim(data) == key) {
							alert('인증이 완료되었습니다.');
							certification.hide();
							content.hide();
							
						} else {
							alert('인증에 실패했습니다, 다시 시도해주세요.');
						}
					});
					
				}
			});
			
		}
		
	});
	
})(jQuery);
	
</script>

</html>






