<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!doctype html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Unauthorized IP Access</title>

	<!-- font -->
	<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100;300;400;500;700;900&display=swap">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/moonspam/NanumBarunGothic@latest/nanumbarungothicsubset.css">

    <style>
        *{margin: 0;padding: 0;border: 0;font-size: 100%;word-break: keep-all;box-sizing: border-box;}
        body{font-family: 'Noto Sans KR', 'NanumBarunGothic', sans-serif;background-color: #dee0e3;}
		img{display: block;max-width: 100%;height: auto;image-rendering: -webkit-optimize-contrast;transform: translateZ(0);backface-visibility: hidden;}
        .ip{
			position: fixed;left: 50%;top: 50%;transform: translate(-50%, -50%);padding: 190px 5% 130px;width: 800px;height: auto;text-align: center;letter-spacing: -0.065em;border: 1px solid #003668;
			background-color: #fff;background-image: url("/images/img_icon.png"), url("/images/img_logo.png");background-position: center top 30px, center bottom 20px;background-repeat: no-repeat;
		}
		.ip strong{display: inline-block;position: relative;line-height: 50px;font-size: 42px;color: #303030;}
		/* .ip strong::before{display: block;content: "";position: absolute;left: -30px;top: -10px;width: 20px;height: 20px;border-radius: 50%;background-color: #303030;} */
		.ip p{margin-top: 18px;line-height: 30px;font-size: 28px;color: #686868;}
		.mb{display: none;}

		@media only screen and (max-width: 820px){
			.mb{display: block;}
			.ip{padding-top: 19vw;padding-bottom: 12vw;width: calc(100% - 20px);background-size: 17vw, 24vw;}
			.ip strong{margin-top: 30px;line-height: 7vw;font-size: 5vw;}
			.ip strong::before{left: -3.5vw;top: -1.2vw;width: 2.5vw;height: 2.5vw;border-radius: 50%;background-color: #303030;}
			.ip p{margin-top: 8px;margin-bottom: 30px;line-height: 5vw;font-size: 3.5vw;}
		}
    </style>
</head>
<body>
	<div class="ip">
		<strong>비인가 IP에서 접속하였습니다.</strong>
		<p>문의사항 전산담당 변현정(02-2204-0120) 선생님에게 연락 부탁합니다.</p>
	</div>
</body>
</html>
