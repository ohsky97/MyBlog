<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home</title>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/assets/css/home.css?ver=1.1">

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
		<a href="/myblog/board/myPage" style="color: #fff;">마이페이지</a>
		<a href="/myblog/board/list" style="color: #fff;">게시판</a>
		<a href="/logout" style="color: #fff;">로그아웃</a>
		<img class="logo" src="/assets/images/logo.png" onclick="location.href='/'">
		<label class="lock" onclick="location.href='/myblog/auth/logIn'">Login</label>
		<img class="myPage" src="/assets/images/myPage_white.png"
			onclick="location.href='/myblog/myPage'">
	</header>
	
	<nav class="contact">
		<img class="contactOn" src="/assets/images/contact.png">
		
		<div class="on">
			<label class="title">CONTACT</label>
			<button id="close">&times;</button><br/>
			<input type="text" id="userName" name="contactname" placeholder="이름" /><br/>
			<input type="text" id="userEmail" name="contactemail" placeholder="이메일" /><br/>
			<input type="text" id="contactType" name="contacttype" placeholder="문의유형" readonly /><br/>
			<textarea id="contactCon" name="contactcon" placeholder="문의내용"></textarea>
			<button id="send" type="submit">전송</button>
		</div>
		<div class="contactTypeOn">
				<div class="a"><label>게시판 이용</label></div>
				<div class="b"><label>bb</label></div>
				<div class="c"><label>cc</label></div>
				<div class="d">
					<input type="text" placeholder="기타" />
					<button class="d_click" type="button">확인</button>
				</div>
		</div>
	</nav>
</body>

<script>
	(function($) {
		
		var contactOn = $('.contactOn'),
			close = $('#close'),
			userName = $('#userName'),
			userEmail = $('#userEmail'),
			contactType = $('#contactType'),
			contactCon = $('#contactCon'),
			contactTypeOn = $('.contactTypeOn'),
			a = $('.a'),
			b = $('.b'),
			c = $('.c'),
			d = $('.d');
		
		
		contactOn.click(function() {
			$('.on').show();
			$(this).hide();
		});
		
		close.click(function() {
			$('.on').hide();
			contactOn.show();
			if (!userName.attr('readonly') && !userEmail.attr('readonly')) {
				userName.val('');
				userEmail.val('');
			
			} 
			contactType.val('');
			contactCon.val('');
			contactTypeOn.hide();
		});
		
		contactType.click(function() {
			contactTypeOn.toggle();
		});
		
		a.click(function() {
			var aText = a.find('label');
			
			contactType.val(aText.text());
			contactTypeOn.hide();
		});
		
		b.click(function() {
			var bText = b.find('label');
			
			contactType.val(bText.text());
			contactTypeOn.hide();
		});
		
		c.click(function() {
			var cText = c.find('label');
			
			contactType.val(cText.text());
			contactTypeOn.hide();
		});
		
		$('.d_click').click(function() {
			var dText = d.find('input');
			
			contactType.val(dText.val());
			dText.val('');
			contactTypeOn.hide();
		});
		
		// 문의내용 전송
		var send = $('#send');
		
		send.click(function() {
			var userName = $('#userName'),
				userEmail = $('#userEmail'),
				contactType = $('#contactType'),
				contactCon = $('#contactCon'),
				uno = '${userInfo.uno}',
				
				NameCheck = /^[가-힣]{2,4}|[a-zA-Z]{2,10}\s[a-zA-Z]{2,10}$/,
				EmailCheck = RegExp(/^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/);
				
			console.log(userName.val(), userEmail.val(), contactType.val(), contactCon.val(), uno);
			
			if (!userName.val()) {
				alert('이름을 입력해 주세요!');
				
			} else if (!NameCheck.test(userName.val())) {
				alert('잘못된 표기의 이름입니다.');
				
			} else if (!userEmail.val()) {
				alert('이메일을 입력해 주세요!');
				
			} else if (!EmailCheck.test(userEmail.val())) {
				alert('잘못된 이메일 형식입니다.');
				
			} else if (!contactType.val()) {
				alert('문의유형을 입력해 주세요!');
				
			} else if (!contactCon.val()) {
				alert('문의내용을 입력해 주세요!');
				
			} else {
				if (uno == '') {
					uno = 0;
				}
				
				$.ajax({
					type: 'post',
					url: '/myblog/contact',
					headers: {
						'Content-Type': 'application/json',
						'X-HTTP-Method-Override': 'post'
					},
					data: JSON.stringify({
						'contact_uno': '${userInfo.uno}',
						'contactname': userName.val(),
						'contactemail': userEmail.val(),
						'contacttype': contactType.val(),
						'contactcon': contactCon.val()
					}),
					success: function(result) {
						if (result == 1) {
							alert('문의내용이 접수되었습니다.');
							userName.val('');
							userEmail.val('');
							contactType.val('');
							contactCon.val('');
							$('.on').hide();
							contactOn.show();
						} 
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
			 $('.myPage').show();
			 $('.lock').hide();
			 
			 // 로그인 정보 확인되면 카운트 실행
			 countDown();
			 
			// 로그인을 했다면 문의 할 시 자동으로 이름과 이메일 적용
			var userName = $('#userName'),
				userEmail = $('#userEmail');
			
			userName.val('${userInfo.username}');
			userName.attr('readonly', 'readonly');
			userEmail.val('${userInfo.userid}');
			userEmail.attr('readonly', 'readonly');
			
		 } else {
			 $('.myPage').hide();
			 $('.lock').show();
		 }
		
	})(jQuery);
</script>

</html>















