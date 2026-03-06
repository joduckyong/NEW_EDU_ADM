<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">

$(function(){
	var loadingSt = 0;
	// ckEditor Height 설정
	CKEDITOR.replace('mailBody',{height : 200});
	CKEDITOR.config.fullPage = true;
	CKEDITOR.config.allowedContent = true;
	
	var baseInfo = {
			insertKey : "${common.baseType[0].key() }",
            updateKey : "${common.baseType[1].key() }",
            deleteKey : "${common.baseType[2].key() }",
            lUrl : "/ncts/mngr/mail/mngrMailRequestList.do",
            fUrl : "/ncts/mngr/mail/mngrMemberMailForm.do",
	}	
	if($("input[name='procType']").val() == baseInfo.updateKey) CKEDITOR.config.readOnly = true;
	
	$.setValidation = function(){
        validator = $("#iForm").validate({
            ignore : "",
            rules: {
            		requestSubject       : {required       : ['글 제목']},
            		mailSenderAddress       : {required       : ['발송자 메일 주소']},
                    mailSenderName         : {required       : ['발송자 이름']},
                    mailTitle          : {required       : ['메일 제목']},
            }
        });
    }
	
	$.listAction = function(){
		var no = 1;
        if(typeof(arguments[0]) != "undefined") no = arguments[0].pageNo;
        with(document.sForm){
            currentPageNo.value = no;
            action = baseInfo.lUrl;
            target = '';
            submit();
        }
	}
	
	$.saveProc = function(){
		if($("input[name='procType']").val() == baseInfo.insertKey) {
			if(CKEDITOR.instances['mailBody'].getData().length == 0) {
				alert("메일 내용을(를) 입력해주세요.");
				return false;
			}
			if($("#userNoArr").val().length == 0 && $("#listAllCheck").val() != "Y") {
				alert("수신자를 선택해주세요.");
				return false;
			}
			
			if(!confirm("메일 발송하시겠습니까? \n발송 후 취소가 불가능합니다.")) return;
			
			$.pageLoadingBarStart();
			makeSnapshot(document.iForm, "mailBody");
			
			$("#iForm").ajaxForm({
				type: 'POST',
				url: "/ncts/mngr/mail/mngrSendEmail.do",
				dataType: "json",
				success: function(result) {
					alert(result.msg);
					if(result.success == "success") location.replace(baseInfo.lUrl);	
					$.pageLoadingBarClose();
				}
	        });
	
	        $("#iForm").submit();
		}
		else if($("input[name='procType']").val() == baseInfo.updateKey) {
			if(!confirm("수정하시겠습니까?")) return false;
			
			$.ajax({
		        type: 'POST',
		        url: "/ncts/mngr/mail/updateMailRequest.do",
		        data: {
					"requestId" : $("#requestId").val(),
					"requestSubject" : $("#requestSubject").val(),
					"procType" : $("input[name='procType']").val(),
					"${_csrf.parameterName}" : "${_csrf.token}"
				},
		        dataType: "json",
		        success: function(data) {
	            	if(data.success == "success") {
	            		alert(data.msg);
	            		location.replace(baseInfo.lUrl);
	            	}
	            	else alert(data.msg);
		        }
	    	})
		}
	}
	
 	$.searchAction = function(){
		with(document.sForm){
			action = baseInfo.lUrl;
			target='';
			submit();
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
	
	$.fn.memberListPopupBtnOnClickEvt = function(){
		$(this).on("click", function(){
			$.popAction.width = 1200;
			$.popAction.height = 600;
			$.popAction.target = "memberListPopup";
			$.popAction.url = "/ncts/mngr/mail/memberListPopup.do";
			$.popAction.form = document.sForm;
			$.popAction.init();
		})
	}
	
	$.choiceUserList = function(obj){
		$.pageLoadingBarStart();
		if(obj != undefined) {
			$("input[name='lastUserNo']").val(obj.lastUserNo);
			$("input[name='userNoArr']").val(obj.userNoArr);
			$("input[name='userNoNotInArr']").val(obj.userNoNotInArr);
			$("input[name='listAllCheck']").val(obj.listAllCheck);
			$("input[name='choiceCnt']").val(obj.choiceCnt);
			$(".choiceCnt").html(obj.choiceCnt+"명");
			
		} else {
			obj = {};
			obj.lastUserNo = $("input[name='lastUserNo']").val();
			obj.userNoArr = $("input[name='userNoArr']").val();
			obj.userNoNotInArr = $("input[name='userNoNotInArr']").val();
			obj.listAllCheck = $("input[name='listAllCheck']").val();
		}
		
		var pageNo = $("#currentPageNo").val();
		obj.currentPageNo = typeof pageNo == "undefined" ? 1 : pageNo;
		obj._csrf = $("input[name='_csrf']").val();
		
		$.ajax({
	        type: 'GET',
	        url: "/ncts/mngr/mail/selectChoiceMemberList.do",
	        data: {
				"lastUserNo" : obj.lastUserNo,
				"userNoArr" : obj.userNoArr,
				"userNoNotInArr" : obj.userNoNotInArr,
				"listAllCheck" : obj.listAllCheck,
				"currentPageNo" : pageNo,
				"${_csrf.parameterName}" : "${_csrf.token}"
			},
	        dataType: "html",
	        contentType: "text/html;charset=UTF-8",
	        success: function(data) {
            	var substring = data.substring(data.indexOf('<form'), data.indexOf('</body>'));
				$(".targetDiv").html(substring);
				$.pageLoadingBarClose();
	        }
    	})
	}
	
	$.extend({
		linkPage2 : function(no){
			$("#currentPageNo").val(no);
		}
	})
	
	$.fn.targetPagingBtnOnClickEvt = function(){
		$(this).on("click", ".targetDiv .pagination a", function(){
			var $this = $(this);
			if($("input[name='procType']").val() == baseInfo.insertKey) $.choiceUserList();
			else $.updateSendList();
		})
	}	
	
	$.updateSendList = function(){
		var pageNo = $("#currentPageNo").val();
		if(pageNo == undefined) pageNo = "1";
		
		$.ajax({
			type : "GET",
			url: "/ncts/mngr/mail/selectMngrMailStatusList.do",
			data: {
				"requestId" : $("#requestId").val(),
				"currentPageNo" : pageNo,
				"${_csrf.parameterName}" : "${_csrf.token}"
			},
			dataType : "html",
			contentType: "text/html;charset=UTF-8",
			success: function(result) {
				var substring = result.substring(result.indexOf('<form'), result.indexOf('</body>'));
				$(".targetDiv").html(substring);
			},
		})
	}		
	
	$.initView = function(){
		$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
		$("#listBtn").goBackList($.listAction);
		$.setValidation();
		$("#saveBtn").saveBtnOnClickEvt();
		$("#memberListPopupBtn").memberListPopupBtnOnClickEvt();
		$("body").targetPagingBtnOnClickEvt();
		$("body").on("keydown", function(e){
	        $.pageLoadingBarKeyDown(e, loadingSt);
        })
        if($("input[name='procType']").val() == baseInfo.updateKey) $.updateSendList();
		
	}
	
	$.initView(); 
	
})
</script>

		
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/ribbon.jsp" flush="false" />

<!-- MAIN CONTENT -->
<div id="content">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/menuTitle.jsp" flush="false" />
	
	<!-- widget grid start -->
	<section id="widget-grid" class="">
	
		
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
				<input type="hidden" id="requestId" name="requestId" value="${param.requestId }">
				<input type="hidden" name="lastUserNo" value="${param.lastUserNo }">
				<input type="hidden" name="userNoArr" value="${param.userNoArr }">
				<input type="hidden" name="userNoNotInArr" value="${param.userNoNotInArr }">
				<input type="hidden" name="choiceCnt" value="${param.choiceCnt }">
				<input type="hidden" name="listAllCheck" value="${param.listAllCheck }">
				
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
					<jsp:param value="form"     name="formType"/>
					<jsp:param value="1,2"     name="buttonYn"/>
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
					<form name="iForm" id="iForm" method="post" class="smart-form" enctype="multipart/form-data">
					    <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						<input type="hidden" name="pageType" value="MEMBER">
						<input type="hidden" id="mailTmpSeq" name="mailTmpSeq" value="${mailTmpSeq }">
						<input type="hidden" id="lastUserNo" name="lastUserNo" value="${param.lastUserNo }">
						<input type="hidden" id="userNoArr" name="userNoArr" value="${param.userNoArr }">
						<input type="hidden" id="userNoNotInArr" name="userNoNotInArr" value="${param.userNoNotInArr }">
						<input type="hidden" id="choiceCnt" name="choiceCnt" value="${param.choiceCnt }">
						<input type="hidden" id="listAllCheck" name="listAllCheck" value="${param.listAllCheck }">
						<input type="hidden" id="centerCd" name="centerCd" value="<sec:authentication property="principal.centerId"/>" >
						<input type="hidden" id="mailBodySnapshot" name="mailBodySnapshot">
						<input type="hidden" name="atchFileId" value="">
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="15%">
								<col width="30%">
								<col width="15%">
								<col width="*">
								<col width="15%">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th>글 제목*</th>
									<td colspan="6">
                                        <label class="input w500 col">
                                            <input type="text" id="requestSubject" name="requestSubject" value="${result.REQUEST_SUBJECT }" maxlength="250">
                                        </label>									
									</td>
								</tr>
								<tr>
									<th>발송자 메일 주소*</th>
									<td colspan="6">
                                        <label class="input w500 col">
                                            <input type="text" id="mailSenderAddress" name="mailSenderAddress" value="${not empty result ? result.MAIL_SENDER_ADDRESS : 'eduadm.nct@gmail.com'}" maxlength="100" ${not empty result ? 'readonly' : '' }>
                                        </label>									
									</td>
								</tr>
								<tr>
									<th>발송자 이름*</th>
									<td colspan="6">
                                        <label class="input w500 col">
                                            <input type="text" id="mailSenderName" name="mailSenderName" value="${not empty result ? result.MAIL_SENDER_NAME : '재난 정신건강 교육관리시스템'}" maxlength="100" ${not empty result ? 'readonly' : '' }>
                                        </label>									
									</td>
								</tr>
								<tr>
									<th>메일 제목*</th>
									<td colspan="6">
                                        <label class="input w500 col">
                                            <input type="text" id="mailTitle" name="mailTitle" value="${result.MAIL_TITLE }" maxlength="100" ${not empty result ? 'readonly' : '' }>
                                        </label>									
									</td>
								</tr>
								<tr>
									<th>메일 내용*</th>
									<td colspan="6" class="board_contents">
										<textarea id="mailBody" name="mailBody" class="part_long board_contents" style="width: 100%; min-width: 100%;" }>${result.MAIL_BODY }</textarea>
									</td>
								</tr>
								<tr>
									<th>수신자 목록*</th>
									<td colspan="6">
										<span class="choiceCnt">${not empty result ? result.MAIL_SENDER_CNT : '0' }명</span>
										<button class="btn btn-primary ml2" type="button" id="memberListPopupBtn" ${not empty result ? 'disabled' : '' }><i class="fa fa-edit" title="가져오기"></i> 가져오기</button>
									</td>
								</tr>
								<tr>
									<th scope="row">첨부파일 </th>
									<td colspan="6">${not empty result ? result.fileView : markup }</td>
								</tr>
							</tbody>
						</table>
					</form>
					
					<div class="targetDiv">
					</div>
				</article>
				
			</div>
			<!-- row 메뉴조회 끝 -->
		</div>
	</section>
	<!-- widget grid end -->

</div>
<!-- END MAIN CONTENT -->
