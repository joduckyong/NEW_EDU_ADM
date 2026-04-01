<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">

$(function(){
	// ckEditor Height 설정
	CKEDITOR.replace('cmptReqstContents',{height : 400});
	
	var baseInfo = {
			insertKey : "<c:out value='${common.baseType[0].key() }'/>",
            updateKey : "<c:out value='${common.baseType[1].key() }'/>",
            deleteKey : "<c:out value='${common.baseType[2].key() }'/>",
            lUrl : "/ncts/mngr/cmptMngr/mngrCmptReqstList.do",
            fUrl : "/ncts/mngr/cmptMngr/mngrCmptReqstForm.do",
            dUrl : "/ncts/mngr/cmptMngr/mngrDeleteCmptReqst.do",
	}	
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				cmptReqstTitle               : {required       : ['제목']},
				/* cmptReqstYmd         		 : {required       : ['요청일자']}, */
				cmptReqstHH    				 : {required       : ['요청시간(시)']},
				cmptReqstMM			         : {required       : ['요청시간(분)']},
				
			}
		});
	}
	
	$.reflctFormCheck = function(){
		var isChk = true;
		$(".reflct").each(function(){
			var $this = $(this);
			if($this.val().length == 0) {
				alert($this.data("title")+"을(를) 입력해주세요.");
				$this.focus();
				isChk = false;
				return false;
			}
		})
		return isChk;
	}
	
	$.saveProc = function(){
		if(!confirm("저장하시겠습니까?")) return;
		if(!$('input[name=cmptSeq]').val())$('input[name=cmptSeq]').val(0);
		
		makeSnapshot(document.iForm, "cmptReqstContents");
		
		$("#iForm").ajaxForm({
			type: 'POST',
			url: "/ncts/mngr/cmptMngr/mngrProgressCmptReqst.do",
			dataType: "json",
			success: function(result) {
				alert(result.msg);
				if(result.success == "success") location.replace(baseInfo.lUrl);	
			}
        });

        $("#iForm").submit();
		
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
			if($.reflctFormCheck()) $.saveProc();	
		})
	}
			
	$.initView = function(){
		$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
		$("#listBtn").goBackList($.searchAction);
		$.setValidation();
		$(".onlyNum").onlyNumber(2);
		$("#saveBtn").saveBtnOnClickEvt();
	}
	
	$.initView(); 
	
})
</script>

		
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/ribbon.jsp" flush="false" />

<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />
<!-- MAIN CONTENT -->
<div id="content">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/menuTitle.jsp" flush="false" />
	
	<!-- widget grid start -->
	<section id="widget-grid" class="">
	
		
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
				<input type="hidden" id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'>
				<div class="fL wp50">
					<ul class="searchAreaBox">
					</ul>
				</div>
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
						<input type="hidden" id="cmptSeq" name="cmptSeq" value='<c:out value="${result.CMPT_SEQ}"/>'>
						<input type="hidden" name="atchFileId" value='<c:out value="${result.ATCH_FILE_ID}"/>'>
						<input type="hidden" name="cmptReqstContentsSnapshot" value="">
						<input type="hidden" name="centerCd" value="<sec:authentication property="principal.centerId"/>">
						
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="15%">
								<col width="85%">
							</colgroup>
							<tbody>
                               <%--  <tr>
									<th scope="row">요청일자</th>
									<td colspan="7">
										<label class="input w120 col"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="cmptReqstYmd" name="cmptReqstYmd" value="${result.CMPT_REQST_YMD }" class="date inputcal tt">
										</label>
										
										<label class="input w40 col mr5">
											<input type="text" class="onlyNum hh" id="cmptReqstHH" name="cmptReqstHH" value="${result.CMPT_REQST_HH }" class="part_time" maxlength="2">
										</label>
										<label class="label col">:</label>
										<label class="input w40 col ml5 mr5"> 
											<input type="text" class="onlyNum mm" id="cmptReqstMM" name="cmptReqstMM"   value="${result.CMPT_REQST_MM }" class="part_time" maxlength="2">
										</label>
									</td>
								</tr> --%>
								<tr>
									<th scope="row">제목</th>
									<td>
										<label class="input w500 col">
											<input type="text" id="cmptReqstTitle" name="cmptReqstTitle" value="<c:out value='${result.CMPT_REQST_TITLE}'/>">
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">내용 </th>
									<td class="board_contents">
										<textarea id="cmptReqstContents" name="cmptReqstContents" class="part_long board_contents" style="width: 100%; min-width: 100%;"><c:out value="${result.CMPT_REQST_CONTENTS}"/></textarea>
									</td>
								</tr>
								<tr>
                                    <th scope="row">첨부파일 </th>
                                    <td>
										<c:out value="${markup}" escapeXml="false"/>
                                    </td>
                                </tr>
                                <tr>
									<th scope="row">작성자</th>
									<td colspan="5">
										<label class="input w150">
											<input type="text" id="frstRegisterId" name="frstRegisterId" value="<c:out value='${result.FRST_REGISTER_ID }'/><c:if test="${empty result.FRST_REGISTER_ID }"><sec:authentication property="principal.userNm"/></c:if>" readonly/>
										</label>
									</td>
								</tr>
								<c:if test="${not empty result.CMPT_SEQ and result.REFLCT_YN eq 'Y'}">
	                                <tr>
										<th scope="row">반영일자</th>
										<td colspan="7">
											<label class="input w120 col"><i class="icon-append fa fa-calendar"></i>
												<input type="text" id="reflctYmd" name="reflctYmd" value="<c:out value='${result.REFLCT_YMD}'/>" class="date inputcal tt reflct" data-title="반영일자">
											</label>
											
											<label class="input w40 col mr5">
												<input type="text" class="onlyNum hh reflct" id="reflctHH" name="reflctHH" value="<c:out value='${result.REFLCT_HH}'/>" class="part_time" maxlength="2" data-title="반영시간(시)">
											</label>
											<label class="label col">:</label>
											<label class="input w40 col ml5 mr5"> 
												<input type="text" class="onlyNum mm reflct" id="reflctMM" name="reflctMM"   value="<c:out value='${result.REFLCT_MM}'/>" class="part_time" maxlength="2" data-title="반영시간(분)">
											</label>
										</td>
									</tr>
								</c:if>
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
<!-- END MAIN CONTENT -->