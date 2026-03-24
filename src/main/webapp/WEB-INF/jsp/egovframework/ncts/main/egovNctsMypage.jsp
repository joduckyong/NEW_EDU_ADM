<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
.w300 {
	width: 300px;
}
</style>
    
<script type="text/javascript">

$(function(){
	
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				password       		: {required       : ['기존 암호']},
				newPassword1       	: {required       : ['새 암호']},
				newPassword2       	: {required       : ['암호 확인']},
			}
		});
	}
	
	$.saveProc = function(){
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
		
		
		if(pwChk) {
			if(!confirm("저장하시겠습니까?")) return;
			
			$("#iForm").ajaxForm({
				type: 'POST',
				url: "/ncts/procPasswordChange.do",
				dataType: "json",
				success: function(result) {
					alert(result.msg);
					if(result.success == "success"){
						$("#logoutBtn").click();				
					}
				}
	        });
	
	        $("#iForm").submit();
		}
		
	}
	
	$.fn.saveBtnOnClickEvt = function(){
		var _this = $(this);
		_this.on("click", function(){
			if(!$("#iForm").valid()) {
				validator.focusInvalid();
				return false;
			}
			$.saveProc();	
		})
	}
	
	$.initView = function(){
		$.setValidation();
		$("#saveBtn").saveBtnOnClickEvt();
	}
	
	$.initView();
	
})
</script>

<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/ribbon.jsp" flush="false" />

<div id="content">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/menuTitle.jsp" flush="false" />

	<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
          		<input type="hidden" id="registerNo" name="registerNo"  value="<c:out value='${param.registerNo }'/>">
          		<input type="hidden" id="tmeSeq" name="tmeSeq"  value="<c:out value='${param.tmeSeq }'/>">
				<div class="fL wp50">
					<ul class="searchAreaBox">
						
					</ul>
				</div>
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
					<jsp:param value="form"     name="formType"/>
					<jsp:param value="1"     name="buttonYn"/>
				</jsp:include>
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
                 
			</form>
		</div>
		<!-- Search 영역 끝 -->
	
		<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />
		
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<form name="iForm" id="iForm" method="post" class="smart-form">
						<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="15%">
								<col width="*">
								<col width="15%">
								<col width="*">
								<col width="15%">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">기존 암호 </th>
									<td colspan="5">
										<label class="input w300">
											<input type="password" name="password">
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">새 암호 </th>
									<td colspan="5">
										<label class="input w300">
											<input type="password" name="newPassword1" class="newPw" maxlength="20">
											<p style="color:red; margin-top:10px;">9자이상 (특수, 영어, 숫자 포함)으로 설정해주세요.</span>
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">암호 확인 </th>
									<td colspan="5">
										<label class="input w300">
											<input type="password" name="newPassword2" class="newPw" maxlength="20">
											<p style="color:red; margin-top:10px;">9자이상 (특수, 영어, 숫자 포함)으로 설정해주세요.</span>
										</label>
									</td>
								</tr>
							</tbody>
						</table>
					</form>
					
				</article>
				
			</div>
			<!-- row 메뉴조회 끝 -->
		</div>
	</section>
	<!-- widget grid end -->

</div>