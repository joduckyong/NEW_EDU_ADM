<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%
    String dummynow = new java.text.SimpleDateFormat("yyyyMMddHHmmssSSS").format(new java.util.Date());
%>
<link href="/css/egovframework/common.css?v=<%=dummynow%>" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="/gpkisecureweb/css/style.css" />
<link rel="stylesheet" type="text/css" href="/gpkisecureweb/client/jquery-ui.min.css"/>
<link rel="stylesheet" type="text/css" href="/gpkisecureweb/client/dialog_css/gsw-jquery-ui.min.css"/>

<script type="text/javascript" src="/gpkisecureweb/client/GPKIWeb/js/ext/jquery-ui.min.js"></script>
<script type="text/javascript" src="/gpkisecureweb/client/GPKIWeb/js/ext/jquery.blockUI.js"></script>
<script type="text/javascript" src="/gpkisecureweb/client/GPKIWeb/js/ext/json2.js"></script>
<script type="text/javascript" src="/gpkisecureweb/client/GPKIWeb/js/GPKIWeb_Config.js?v=<%=dummynow%>"></script>
<script type="text/javascript" src="/gpkisecureweb/client/GPKIWeb/js/ext/GPKI_Config.js"></script>
<script type="text/javascript" src="/gpkisecureweb/client/gpkijs_1.2.1.3.min.js" id="DSgpkijs"></script>
<script type="text/javascript" src="/gpkisecureweb/client/GenerateContent.js" id="DSGenInterface"></script>
<script type="text/javascript" src="/gpkisecureweb/client/GPKISecureWebJS.js"></script>
<script type="text/javascript" src="/gpkisecureweb/client/GPKIJS_Crypto.js" id="DSGPKIJS_Crypto"></script>
<script type="text/javascript" src="/gpkisecureweb/client/GPKIErrorText.js" ></script>
<script type="text/javascript" src="/gpkisecureweb/client/var.js?v=<%=dummynow%>"></script>
<script type="text/javascript" src="/gpkisecureweb/client/GPKISecureWebNP2.js?v=<%=dummynow%>"></script>

<script type="text/javascript">
	$(function() {

		$.setValidation = function() {
			validator = $("#iForm").validate({
				ignore : "",
				rules : {
					userId : {
						required : [ '아이디' ]
					},
					userPw : {
						required : [ '비밀번호' ]
					}

				}
			});
		}

		$.loginBtnOnClickHandler = function() {
			$("#loginBtn").on("click", function() {
				if (!$("#iForm").valid()) {
					validator.focusInvalid();
					return false;
				}

				$.loginProc();
			})
		}

		$.loginProc = function() {
			$.ajax({
				type: 'POST',
				url: "/ncts/gpik/selectCheckedDN.do",
				data : $("#iForm").serialize(),
				dataType: "json",
				success: function(data) {
					if(data.success == "success"){
						
						var input = document.createElement("input");
						input.type = "hidden";
						input.name = "userId";
						input.value = $.trim($("#userId").val());
						document.gpkiForm.appendChild(input);
						Login(this,document.gForm,false);
						/* if(GPKISecureWeb.InitCheck() == 0){
							GPKISecureWebUi.Init();
							return Login(this,document.gForm,false);
						}else{
							//window.location.href="../install.html";
							return false;
						} */
					}else{
						alert(data.msg);
						return false;
					}
				}
			});

		}

		$.initView = function() {
			$.setValidation();
			$.loginBtnOnClickHandler();
			
			$(".blockUI.blockMsg.blockPage img").css("width", "75px");
			//아이디로 로그인 
			$("#loginBtn2").click(function(){
				location.href = "/ncts/login/egovLoginForm.do";
			});
			
			$('button[name=pwView]').off('click').on('click', function(e){
				if($(this).hasClass('pw_show')) {
					$(this).removeClass('pw_show').addClass('pw_off');
					$(this).parent().find('input').attr('type', 'password');
				} else {
					$(this).removeClass('pw_off').addClass('pw_show');
					$(this).parent().find('input').attr('type', 'text');
				}
				                                     
			   
			});
			
		}

		$.initView();
	})
</script>
<form id="iForm" name="iForm" class="smart-form client-form" method="post" action="/ncts/gpik/selectCheckedDN.do">
	<input type="hidden" name="<c:out value='${_csrf.parameterName}'/>" value="<c:out value='${_csrf.token}'/>" />
	<div id="wrap"> 
		<div class="login login2">
			<div class="inner_login">
				<h1><strong>Disaster Mental health Education Admin</strong> 공인인증 등록</h1>
				<div class="login_box fClr">
					<div class="fLeft">
						<div class="first">
							<h2>아이디 로그인</h2>
							<div class="icon"></div>
							<button type="button" id="loginBtn2" class="loginBtn">아이디 로그인</button>
						</div>
					</div><!--//ft_l-->
					<div class="fRight" style="padding-right:5px;">
						<h2 style="width: 85%;">공인인증서 등록</h2>
						<div style="text-align: left;">
							<input type="text" id="userId" name="userId" class="item" placeholder="USER ID" style="width: 85%;">
						</div>
						<div>
							<input type="password" id="userPw" name="userPw" class="item" placeholder="PASSWORD" style="margin-top:15px;float: left;width: 85%;">
							<button type="button" name="pwView" style="float:left;margin-top:20px;" class="pw_off"></button>
						</div>
						<div style="text-align: left;width:85%;">
							<button type="button" id="loginBtn" class="loginBtn">로그인</button>
						</div>
						
						<!-- <input type="text" id="userId" name="userId" class="item" placeholder="USER ID">
						<input type="password" id="userPw" name="userPw" class="item" placeholder="PASSWORD">
						<button type="button" id="loginBtn" class="loginBtn">로그인</button> -->
						<div class="box_find" style="width: 85%;">
							공인인증서 등록을 하기 위해서는 <br>로그인을 먼저 하셔야 합니다.
						</div><!--box_find-->
					</div><!--// ft_r-->
				</div><!--//set_ft-->
				<!-- p class="logo"><img src="/images/logo_login.png" alt="DMHIS"></p--><!--// logo-->
			</div><!--// inner_login-->
		</div>
	</div>
</form>

<form action="/ncts/gpik/registerDNProcess.do" method="post" name="gForm">
	<input type="hidden" name="challenge" value="<c:out value='${challenge }'/>" />
	<input type="hidden" name="sessionid"  value="<c:out value='${sessionid }'/>" />
</form>
