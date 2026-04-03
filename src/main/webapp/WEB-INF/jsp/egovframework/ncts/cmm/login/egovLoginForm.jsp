<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta http-equiv="Expires" content="-1" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Cache-Control" content="no-cache" />

<%
    String dummynow = new java.text.SimpleDateFormat("yyyyMMddHHmmssSSS").format(new java.util.Date());
%>

<link rel="stylesheet" type="text/css" href="/gpkisecureweb/css/style.css" />
<link rel="stylesheet" type="text/css" href="/gpkisecureweb/client/jquery-ui.min.css"/>
<link rel="stylesheet" type="text/css" href="/gpkisecureweb/client/dialog_css/gsw-jquery-ui.min.css"/>
<link rel="stylesheet" href="/css/egovframework/edu/common.css?v=<%=dummynow%>">

<c:if test="${operYn eq 'Y' }">
	<script type="text/javascript" src="/gpkisecureweb/client/GPKIWeb/js/ext/jquery-ui.min.js"></script>
	<script type="text/javascript" src="/gpkisecureweb/client/GPKIWeb/js/ext/jquery.blockUI.js"></script>
	<script type="text/javascript" src="/gpkisecureweb/client/GPKIWeb/js/ext/json2.js"></script>
	
	<!-- GPKIWeb JS -->
	<script type="text/javascript" src="/gpkisecureweb/client/GPKIWeb/js/GPKIWeb_Config.js?v=<%=dummynow%>"></script>
	<script type="text/javascript" src="/gpkisecureweb/client/GPKIWeb/js/ext/GPKI_Config.js"></script>
	
	<script type="text/javascript" src="/gpkisecureweb/client/gpkijs_1.2.1.3.min.js" id="DSgpkijs"></script>
	<script type="text/javascript" src="/gpkisecureweb/client/GenerateContent.js" id="DSGenInterface"></script>
	<script type="text/javascript" src="/gpkisecureweb/client/GPKISecureWebJS.js"></script>
	<script type="text/javascript" src="/gpkisecureweb/client/GPKIJS_Crypto.js" id="DSGPKIJS_Crypto"></script>
	
	<script type="text/javascript" src="/gpkisecureweb/client/GPKIErrorText.js" ></script>
	<script type="text/javascript" src="/gpkisecureweb/client/var.js?v=<%=dummynow%>"></script>
	<script type="text/javascript" src="/gpkisecureweb/client/GPKISecureWebNP2.js?v=<%=dummynow%>"></script>
</c:if>

<script type="text/javascript">

	/* if("${ipChk2}" == 0){
		if("${ipChk}" == 0){
		    alert("접속한 아이피는 이용할 수 없습니다.");
		    location.href="https://www.google.com/";
		}	
	}
 */
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
		
		$.macServerCheck = function(userId){
			$("#mForm input[name='userId']").val(userId);
			
			$.ajax({
				type: 'POST',
				url: "/ncts/login/mac/macServerCheck.do",
				data: $("#mForm").serialize(),
				//async: false,
				dataType: "json",
				success: function(data) {
					if(data.result == "N") $.macPopupOpenEvt(userId);
					else if(data.result == "Y") {
						$("#MacPopupFail p").html("현재 로그인 시도중입니다. <br>잠시 후 다시 시도해주시기를 바랍니다.");
						$("#MacPopupFail").show();						
					}
					else {
						$("#MacPopupFail p").html("포트 번호가 등록되지 않았습니다.");
						$("#MacPopupFail").show();
					}
				}
			})
		}
		
		$.macPopupOpenEvt = function(userId){
			$("#progressbar").val(0);
			//$("#macProcBtn").click();
			location.href = "ICMN://";
			setTimeout(function() {
				$("#macPopup").show();
			}, 3000);
		}
		
		$.loginProc = function() {
			$("#iForm").ajaxForm({
				type: 'POST',
				url: "/ncts/login/loginRequest.do",
				dataType: "json",
				success: function(data) {
					/* if(data.result == "success") {
						if('Y' == data.pwChgYn ) {
							$('#changePw_layerPopup').show();
						}else{
							window.location.assign(data.targetUrl);	
						}
					}else {
						alert(data.msg);
						return false;
					} */
					
					if( 'Y' == '${operYn}' ) {
						if(data.result == "success") {
							if('master' == data.userId) { // 사용자ID가 master일 경우 공인인증 pass
								window.location.assign(data.targetUrl);	
							} else {
								if('Y' == data.pwChgYn ) {
									$('#changePw_layerPopup').show();
								} else {
									if($('form[name=gpkiForm]').length > 0 ){
										$('form[name=gpkiForm]').append('<input type="hidden" name="gpkiUserId" value="'+data.userId+'">');
									}
									Login($('#gpkiLogin'),document.gForm,false);	
								}
							}
							
						} else {
							alert(data.msg);
							return false;
						}
					} 
					else {
						if(data.result == "success") {
							if('Y' == data.pwChgYn ) $('#changePw_layerPopup').show();
							else window.location.assign(data.targetUrl);	
						} else if(data.result == "macCheck") {
							$.macServerCheck(data.userId);
						} else {
							alert(data.msg);
							return false;
						}			
					}
				}
				
			});

			$("#iForm").submit();

		}
		
		$.fn.inputEnter = function(){
			var $this = $(this);
			$this.on("keypress", function(e){
				if(e.keyCode == 13) $("#loginBtn").click();
			})
		}
		
		$.gpkiLoginOnClickEvt = function(){
			$("#gpkiLogin").on("click", function(){
				Login(this,document.gForm,false);
			})
		}
	
		$.fn.macProcBtnOnClickEvt = function(){
			$(this).on("click", function(){
				$.ajax({
					type: 'POST',
					url: "/ncts/login/mac/macCheck.do",
					data: $("#mForm").serialize(),
					//async: false,
					dataType: "json",
					beforeSend:function() {
						$("#macProcBtn").prop("disabled", true);
						$("#macProcBtn").css("background", "#777");
						setInterval(function() {
							$("#progressbar").val($("#progressbar").val() + 3.33);
						}, 1000);
					},
					success: function(data) {
						if(data.errorMsg) {
							$("#MacPopupFail p").html(data.errorMsg);
							$("#MacPopupFail").show();
						}
						else {
				        	$("#progressbar").val(100);
							if(data.success == "success") window.location.assign(data.targetUrl);
							else {
								$("#macPopup").hide();
								$("#unauthMacPopup").show();
							}
						}
					}
				})
			})
		};
		
		/*초기 비밀번호 변경 처리*/
		$.setValidationPwChange = function(){
			validator = $("#pForm").validate({
				ignore : "",
				rules: {
					password       		: {required       : ['기존 암호']},
					newPassword1       	: {required       : ['새 암호']},
					newPassword2       	: {required       : ['암호 확인']},
				}
			});
		};
		
		$.savePwChangeProc = function(){
			var pwChk = true;
			var pattern = /^(?=.*[a-zA-Z])(?=.*[~`!@#$%^&*()\-\_+=\[\{}\]\|\\\;:<>.,/?])(?=.*[0-9]).{9,20}$/;
			$(".newPw").each(function(){
				var $this = $(this);
				if(!pattern.test($this.val())) {
					alert("비밀번호는 9자이상 (특수, 영어, 숫자 포함)으로 설정해주세요.");
					$this.focus();
					pwChk = false;
					return false;
				}
			});	
			$('input[name=userId]').val($('#userId').val());
			if(pwChk) {
				if(!confirm("저장하시겠습니까?")) return;
				
				$("#pForm").ajaxForm({
					type: 'POST',
					url: "/ncts/procPasswordChange2.do",
					dataType: "json",
					success: function(result) {
						if(result.success == "success"){
							$('#changePw_layerPopup').hide();
							alert('변경된 비밀번호로 다시 로그인을 진행해 주세요');
							$("#logoutForm").ajaxForm({
								type: 'POST',
								url: "/ncts/login/logoutRequest.do",
								dataType: "json",
								success: function(data) {
									if(data.result == "success") {
									} else {
										alert(data.msg);
										return;
									}
								}
								
							});
							$("#logoutForm").submit();
							
						} else {
							alert(result.msg);
						}
					}
		        });
		
		        $("#pForm").submit();
			}
		};
		
		$.fn.saveBtnOnClickEvt = function(){
			var _this = $(this);
			_this.on("click", function(){
				if(!$("#pForm").valid()) {
					validator.focusInvalid();
					return false;
				}
				$.savePwChangeProc();	
			})
		};
		
		$.initView = function() {
			$.setValidation();
			$.loginBtnOnClickHandler();
			$.gpkiLoginOnClickEvt();
			$("#userPw").inputEnter();
			$("#macProcBtn").macProcBtnOnClickEvt();
			
			$("#downBtn").click(function(){
				location.href = "/downLoad.do?path=file/&fileName=Education_접근권한_신청서.hwp";
			});
			
			$("#reqGpki").click(function(){
				location.href = "/ncts/login/egovGpkiLoginForm.do";
			});
			
			// 인증서 설치 프로그램 다운로드
			$("#gpkiExeDown").click(function(){
				location.href = "/downLoad.do?path=file/&fileName=GPKISecureWebSetup.exe";
			});
			
			$(".unauthMacCloseBtn").click(function(){
				//$(this).closest(".dim-layer").hide();
				location.reload();
			});
			
			$(".blockUI.blockMsg.blockPage img").css("width", "75px");
			
			if("${gpkiMsg}" != "") {
				alert("${gpkiMsg}");
				if('${gpkiErrorCd}' == 'ERROR001') {
					location.href = '/ncts/login/egovGpkiLoginForm.do';
				}
			};
			
			$.setValidationPwChange();
			$("#saveBtn").saveBtnOnClickEvt();
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

<div class="dim-layer" id="macPopup" style="display: none;">
	<div class="dimBg"></div>
	<div id="layer1" class="login-con">
		<div class="inner_box">
			<div class="lock">
				<p>2단계 개인 PC 인증을 진행합니다.</p>
				<progress id="progressbar" value="20" max="100"></progress>
				<form name="mForm" id="mForm" action="/ncts/mac/macCheck.do" method="POST">
					<input type="hidden" name="userId" value="">
					<div class="fClr">
						<button type="button" id="macProcBtn" class="gold">MAC 인증</button>
					</div>
		 		</form> 				
			</div>
		</div>
	</div>
</div>

<div class="dim-layer" id="unauthMacPopup" style="display: none;">
	<div class="dimBg"></div>
	<div id="layer2" class="login-con">
		<div class="inner_box">
			<div class="exclam">
				<p><span class="red">허가되지 않은 PC 입니다.</span><br>담당자에게 연락을 주세요.</p>
				<p class="addr">연락처 변현정 : ( 02-2204-0120 )</p>			
				<button type="button" class="gold unauthMacCloseBtn">확인</button>
			</div>
		</div>
	</div>
</div>

<div class="dim-layer" id="MacPopupFail" style="display: none;">
	<div class="dimBg"></div>
	<div id="layer3" class="login-con">
		<div class="inner_box">
			<div class="exclam">
				<p></p>
				<button type="button" class="gold unauthMacCloseBtn">확인</button>
			</div>
		</div>
	</div>
</div>
<form id="logoutForm" method="post" action="/ncts/login/logoutRequest.do">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
</form>
<div class="dim-layer" id="changePw_layerPopup" style="display: none;">
<div class="dimBg"></div>
	<div class="login-con">
		<div style="text-align: left;padding-bottom: 15px;">
			<span style="font-weight: bold;font-size: 20px;">초기비밀번호 변경 팝업</span>
		</div>
		<form name="pForm" id="pForm" method="post" class="smart-form">
			<input type="hidden" name="userId" value="" />
			<table class="table table-bordered tb_type03">
				<colgroup>
					<col width="30%">
					<col width="*">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">기존 암호 </th>
						<td>
							<label class="input w300 fL">
								<input type="password" name="password" autocomplete="off" style="width: 296px;"/>
							</label>
							<button type="button" name="pwView" style="padding-top: 30px;padding-left: 30px;" class="pw_off"></button>
						</td>
					</tr>
					<tr>
						<th scope="row">새 암호 </th>
						<td>
							<label class="input w300 fL">
								<input type="password" name="newPassword1" autocomplete="off" class="newPw" maxlength="20"/>
								<p style="color:red; margin-top:10px;">9자이상 (특수, 영어, 숫자 포함)으로 설정해주세요.</p>
							</label>
							<button type="button" name="pwView" style="padding-top: 30px;padding-left: 30px;" class="pw_off"></button>
						</td>
					</tr>
					<tr>
						<th scope="row">암호 확인 </th>
						<td>
							<label class="input w300 fL">
								<input type="password" name="newPassword2" autocomplete="off" class="newPw" maxlength="20"/>
								<p style="color:red; margin-top:10px;">9자이상 (특수, 영어, 숫자 포함)으로 설정해주세요.</p>
							</label>
							<button type="button" name="pwView" style="padding-top: 30px;padding-left: 30px;" class="pw_off"></button>
							
						</td>
					</tr>
				</tbody>
			</table>
		</form>
		<div class="fR mt5 mb5">
			<button class="btn btn-primary ml2" id="saveBtn" type="button">
			    <i class="fa fa-edit" title="저장"></i>저장
			</button>
		</div>
	</div>
</div>

<form id="iForm" name="iForm" class="smart-form client-form" method="post" action="/ncts/login/loginRequest.do">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	<input type="hidden" name="macCheckYn">
	<div id="admin_wrap">
        <div class="admin">
            <div class="side mgb25">Disaster Mental health Education Admin</div>
            <div class="title"></div>
            <div class="flex mgt40 mgb40">
                <div class="half hl">
                    <div class="tit_box">로그인</div>
                    <p class="mgt10">회원님의 아이디와 비밀번호를 입력해 주세요.</p>

                    <div class="input_box">
                        <div class="input_row">
                            <label for="identity">아이디</label>
                            <input type="text" name="userId" id="userId">
                        </div>
                        <div class="input_row mgt10">
                            <label for="password">비밀번호</label>
                            <input type="password" name="userPw" id="userPw">
                        </div>
                        <button type="button" id="loginBtn">로그인</button>
                    </div>

                    <p>
                        아이디/비밀번호 유실 시 담당자연락 주세요.<br>
                        ( 연락처 변현정 : 02-2204-0120 )
                    </p>
                </div>
                <div class="half hr">
                    <div class="tit_box">로그인시 유의사항</div>

                    <ul>
                        <li class="arr">원하는 서비스를 이용하신 후 자리를 비우게 될 경우에는 반드시 로그아웃하시기 바랍니다.</li>
                        <li class="arr">사용자의 개인 정보 보호를 위하여 약 10분 동안 화면 이동이 없을 경우 자동 로그아웃 처리됩니다.</li>
                        <li class="arr">사용자 암호는 주기적으로 변경 관리하시고 타인에게 노출되지 않도록 주의하시기 바랍니다.</li>
                    </ul>
                </div>
            </div>
            
            <div class="side">
				<div class="box_down" style="padding:12px;">
					<span style="color:white">신청서 제출은 각 기관 운영자(전산담당자)에게 제출하시기 바랍니다.</span> 
					<!-- <a href="javascript:;">[ 다운로드 ]</a> -->
					<button class="btn btn-danger ml10 mr5" id="downBtn" type="button" style="padding: 0 10px;width: auto;height: 25px;"><i class="fa fa-download" title="다운로드"></i> 다운로드</button>
					<button class="btn btn-primary" id="reqGpki" type="button" style="padding: 0 10px;width: auto;height: 25px;"><i class="fa fa-user-circle-o" title="다운로드"></i> 인증서 등록</button>
					<button class="btn btn-primary" id="gpkiExeDown" type="button" style="padding: 0 10px;width: auto;height: 25px;"><i class="fa fa-download" title="다운로드"></i> 인증서설치프로그램</button>
				</div><!--//box_down-->
            </div>
        </div><!-- //.admin -->
    </div>
	
	
</form>

<form action="/ncts/gpik/loginProcess.do" method="post" name="gForm">
	<input type="hidden" name="challenge" value="${challenge }" />
	<input type="hidden" name="sessionid"  value="${sessionid }" />
	<input type="hidden" name="gpkiUserId"  value="" />
</form>

<%-- <form action="/ncts/gpik/loginProcess.do" method="post" name="gForm">
	<input type="hidden" name="challenge" value="${challenge }" />
	<input type="hidden" name="sessionid"  value="${sessionid }" />
</form>
 --%>

<c:if test="${!empty ErrorMsg}">
	<script>
		alert("${ErrorMsg}");
	</script>	
</c:if>

