<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
$(function(){
	var baseInfo = {
			insertKey : "${common.baseType[0].key() }",
			updateKey : "${common.baseType[1].key() }",
			deleteKey : "${common.baseType[2].key() }",
			lUrl : "/ncts/cmm/sys/ipauth/ipAuthList.do",
			fUrl : "/ncts/cmm/sys/ipauth/ipAuthForm.do",
			dUrl : "/ncts/cmm/sys/ipauth/ipAuthProcess.do"
	}

	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				ipAdress				:{required	:['IP주소']} ,
				ipUseAgency				:{required	:['IP사용기관'] } ,
				useYn		        	:{required	:['사용여부']}   ,
				ipUseReason		        :{required	:['IP사용사유']} 
			}
		});
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
	
	$.saveProc = function(){
		if(!confirm("저장하시겠습니까?")) return;
		
		$("#iForm").ajaxForm({
			type: 'POST',
			url: '/ncts/cmm/sys/ipauth/authipProcess.do',
			dataType: "json",
			success: function(result) {
				alert(result.msg);
				if(result.success == "success") $.searchAction();
			}
        });
        $("#iForm").submit();
	}
	
    $.searchAction = function(){
		var no = 1;
        if(typeof(arguments[0]) != "undefined") no = arguments[0].pageNo;
        with(document.sForm){
            currentPageNo.value = no;
            action = baseInfo.lUrl;
            target = '';
            submit();
        }
	}

	 $.initView = function(){
		 $("#listBtn").goBackList($.searchAction);
		 $.setValidation();
		 $("#saveBtn").saveBtnOnClickEvt();
    }
    $.initView();
})
</script>

<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/ribbon.jsp" flush="false" />
<div id="content">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/menuTitle.jsp" flush="false" />
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
					<jsp:param value="form"     name="formType"/>
					<jsp:param value="1,2,3,4"     name="buttonYn"/>
				</jsp:include>
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
			</form>
		</div>
		<!-- Search 영역 끝 -->
		
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<form name="iForm" id="iForm" method="post" class="smart-form" enctype="multipart/form-data">
						<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						<input type="hidden" id="ipSeq" name="ipSeq" value="${result.IP_SEQ }" >
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="20%">
								<col width="80%">
							</colgroup>
							<tbody>
								<tr>
									<th>IP주소</th>
									<td>
										<label class="input w180 col">
											<input type="text" id="ipAdress" name="ipAdress" class="ipAdress" value="${result.IP_ADRESS }" placeholder="" maxlength="25" >
										</label>
									</td>
								</tr>
								<tr>
									<th>IP사용기관</th>
									<td>
										<label class="input w180 col">
											<input type="text" id="ipUseAgency" name="ipUseAgency" class="ipUseAgency" value="${result.IP_USE_AGENCY }" placeholder="" maxlength="25">
										</label>
									</td>
								</tr>
								<tr>
									<th>사용여부</th>
									<td>
										<label class="radio mr5 mt5" style="display: inline-block;">
											<input type="radio" name="useYn" value="Y" class="" ${result.USE_YN eq 'Y'? 'checked="checked"':''}><i></i>사용
										</label>
										<label class="radio ml5 mt5" style="display: inline-block;">
											<input type="radio" name="useYn" value="N" class="" ${result.USE_YN eq 'N'? 'checked="checked"':''}><i></i>미사용
										</label>
									</td>                                                                
								</tr>
								<tr>
									<th>IP사용사유</th>
									<td>
										<textarea id="ipUseReason" name="ipUseReason" rows="5" cols="33" style="border-radius: 0;">${result.IP_USE_REASON }</textarea>
									</td>
								</tr>
							</tbody>
						</table>
					</form>
				</article>
			</div>
		</div>
	</section>
</div>