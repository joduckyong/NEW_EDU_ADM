<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">
$(function(){
	// ckEditor Height 설정
	CKEDITOR.replace('eduCn',{height : 200});
	
	var baseInfo = {
			lUrl : "${pageInfo.READ_AT eq 'Y' ? pageInfo.MENU_URL : pageInfo.MENU_DETAIL_URL   }",
			fUrl : "${pageInfo.MENU_DETAIL_URL }",
			appliPopup : "/ncts/mngr/eduReqstMngr/mngrEduAppliAddPopup.do",
			instrctrPopup : "/ncts/mngr/eduReqstMngr/mngrEduInstrctrAppliListPopup.do",
			excel : "/ncts/mngr/eduReqstMngr/mngrDtyEduApplicantDownload.do",
	}	
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				lectureId               	: {required       : ['패키지명']},
				eduNm               		: {required       : ['교육명'], maxlength :['200']},
				eduDe                     	: {required       : ['교육시작일자']},
				eduBeginTimeHour    		: {required       : ['교육시작시간(시)']},
				eduBeginTimeMin           	: {required       : ['교육시작시간(분)']},
				eduEndDe                    : {required       : ['교육종료일자']},
				eduEndTimeHour            	: {required       : ['교육종료시간(시)']},
				eduEndTimeMin       		: {required       : ['교육종료시간(분)']},
				eduPlace                  	: {required       : ['교육장소'], maxlength :['100']},
				eduPlaceDetail            	: {required       : ['교육장소상세']},
				eduNmpr                   	: {required       : ['교육인원'], maxlength :['10']},
				eduSubjectvity            	: {required       : ['교육주관']},
				 /*eduInstNo                 	: {required       : ['교육강사']},
				eduInstDept         		: {required       : ['교육강사 소속']}, */
				eduTargetType           	: {required       : ['교육대상'], maxlength :['100']},
				centerCd			        : {required       : ['센터명']},
				startDe          			: {required       : ['모집 시작일자']},
				startHH    					: {required       : ['모집 시작시간(시)']},
				startMM			          	: {required       : ['모집 시작시간(분)']},
				endDe	          			: {required       : ['모집 종료일자']},
				endHH    					: {required       : ['모집 종료시간(시)']},
				endMM			          	: {required       : ['모집 종료시간(분)']},
			}
		});
	}
	
	$.beforeInstrctrDeChk = function(){
		var chk = true;
		$(".instrctrDe").each(function(){
			var $this = $(this);
			if($this.val() == '') {
				var title = $this.data("title");
				alert(title+"을(를) 입력해주세요.");
				chk = false;
				return false;
			}
		})
		
		return chk;
	}
	
	
	
	$.saveProc = function(){
		var chk = true;
		if($("#instrctrOthbcYn:checked").size() == '1') chk = $.beforeInstrctrDeChk();
		if(chk) {
			if($("#lectureId option:selected").val() == "") {
				alert("패키지명을 선택해주세요.");
				return false;
			}
			
			if(!confirm("저장하시겠습니까?")) return;
			
			makeSnapshot(document.iForm, "eduCn");
			$("#iForm input[name='eduDivision']").val($("#lectureId option:selected").data("gubun"));
			
			$("#iForm").ajaxForm({
				type: 'POST',
				url: "/ncts/mngr/eduReqstMngr/mngrDtyEduProcess.do",
				dataType: "json",
				success: function(result) {
					alert(result.msg);
//					if(result.success == "success") location.replace(baseInfo.lUrl);	
					if(result.success == "success") history.back();	
				}
	        });
	
	        $("#iForm").submit();
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
	
	$.fn.comboOnChangeEvt = function(depth){
		var _this = $(this);
		_this.on("change", function(){
			if(depth==1){
				$("#deptCd").makecombo(depth+1,$(this).val());
			}else if(depth==2){
				$("#teamCd").makecombo(depth+1,$(this).val());
			}
		})
	}

	$.fn.makecombo = function(depth,value){
		var _this = $(this);
		var parentCd = "";
		if(depth != 1) parentCd = value;
		$.ajax({
			type			: "POST",
			url				: "/ncts/cmm/sys/dept/selectDeptOptionList.do",
			data			: {
								deptDepth : depth,
								parentCd  : parentCd,
								"${_csrf.parameterName}" : "${_csrf.token}"
			},
			dataType		: 'json',
			success			: function(result) {
				 _this.find("option").each(function(index) { if(index > 0) $(this).remove(); });
				$.each(result, function(index) {
					var _self = this;
					_this.append("<option value='"+_self.DEPT_CD+"'>"+_self.DEPT_NM+"</option>");
				});
			}
		});
		
	}
	
	$.fn.approveBtnOnClickEvt = function(){
		var _this = $(this);
		_this.on("click", function(){
			if(!confirm("승인하시겠습니까?")) return;
			var $this = $(this);
			$.ajax({
				type			: "POST",
				url				: "/ncts/mngr/eduReqstMngr/mngrEduApplicantUpdateProcess.do",
				data			: {
									"appliSeq" : $this.parent().parent().parent().find("input[name='appliSeq']").val(),
									"applStat" : "Y", 
									"eduDivision" : $("#eduDivision").val(),
									"procType" : "${common.baseType[1].key() }",
									"${_csrf.parameterName}" : "${_csrf.token}",
				},
				dataType		: 'json',
				success			: function(result) {
					location.reload();
					//$.applicantChange();
				}
			});
		})
	}
	
	$.fn.rejecteBtnOnClickEvt = function(){
		var _this = $(this);
		_this.on("click", function(){
			if(!confirm("반려하시겠습니까?")) return;
			var $this = $(this);
			$.ajax({
				type			: "POST",
				url				: "/ncts/mngr/eduReqstMngr/mngrEduApplicantUpdateProcess.do",
				data			: $("#popForm").serialize(),
				dataType		: 'json',
				success			: function(result) {
					location.reload();
					/* $.applicantChange();
					$.closePopLayer('dtyApplStatPop'); */
				}
			});
		})
	}
	
	$.popupOpen = function(url, target){
		$.popAction.width = 1200;
		$.popAction.height = 600;
		$.popAction.target = target;
		$.popAction.url = url;
		$.popAction.form = document.sForm;
		$.popAction.init();
	}
	
	$.fn.appliAddOnClickEvt = function(){
		var _this = $(this);
		_this.on("click", function(){
			$.popupOpen(baseInfo.appliPopup, "dtyAppliPopup");
		})
	}
	
	$.fn.instrctrListBtnOnClickEvt = function(){
		var _this = $(this);
		_this.on("click", function(){
			var $this = $(this);
			var division = "";
			if($this.prop("id") == "instrctrListBtn") division = "I";
			else division = "S";
			
			if($("#lectureId").val() == "") {
				alert("패키지명을 선택해주세요.");
				return false;
			}
			document.sForm.instrctrDivision.value = division;
			document.sForm.sGubun2.value = division;
			document.sForm.certCd.value = document.sForm.certCd.value.split("|")[0];
			document.sForm.lectureId.value = $("#lectureId").val();
			$.popupOpen(baseInfo.instrctrPopup,"dtyInstrctrPopup");
		})
	}
	
	$.selectInstrctr = function(nm, no, division, type, tempKey){
		var oldTxt = "";
		var oldNo = "";
		var pos = "";
		var posNo = "";
		
		if(tempKey != "") {
			$(".tempSeq").val(tempKey);
			$("input[name='boardType']").val(tempKey);
		}
		if(division == "I") {
			pos = "#eduInstNm";
			posNo = "#eduInstNo";
		}
		else {
			pos = "#eduAssistInstNm";
			posNo = "#eduAssistInstNo";
		}
		
		if($(pos).val() != ""){
		    oldTxt = $(pos).val();
		    
			if(type == "del") {
				var indexOf = oldTxt.indexOf(nm);
				if(oldTxt.substr(indexOf-1,1) == ",") oldTxt = oldTxt.replace(oldTxt.substr(indexOf-1,nm.length+1),'');
				else oldTxt = oldTxt.replace(oldTxt.substr(indexOf, nm.length+1), '');
			} 
			else {
				oldTxt += ',' + nm;
			}
		    $(pos).val(oldTxt);
	    }
		else {
			$(pos).val(nm);
		}
		
		$(posNo).val(no);
	}
	
	$.fn.showManual = function(){	
		var _this = $(this);
		_this.on("click", function(){
			var $this = $(this);
			var appliSeq = $this.parent().parent().parent().find("input[name='appliSeq']").val();
			var applStatDetail = $this.parent().parent().parent().find("input[name='applStatDetail']").val();
			$("#applStatDetail").val(applStatDetail);
			$("#popForm input[name='appliSeq']").val(appliSeq);
			
			$.showPopLayer('dtyApplStatPop');
			$('#cancelBtn').click(function() {
				$.closePopLayer('dtyApplStatPop');
			});
		})
	}
	
	$.showPopLayer = function(id){
		var obj = $('#'+id);
		var W = $(window).width();
		var H = $(window).height();
		var w = $(obj).width();
		var h = $(obj).height();
		$(obj).css({left:(W-w)/2, top:(H-h)/2});

		$('#'+id).parent().addClass("page_ing_wrap");
		obj.show();
	}


	$.closePopLayer = function(id) {
		var obj = $('#'+id);
		$('#'+id).parent().removeClass("page_ing_wrap");
		obj.hide(); 	
	}
	
	$.applicantChange = function(){
		$.ajax({
			type			: "POST",
			url				: "/ncts/mngr/eduReqstMngr/selectMngrDtyEduApplicantList.do",
			data			: {
								"eduSeq" : $("#eduSeq").val(),
								"${_csrf.parameterName}" : "${_csrf.token}"
			},
			dataType		: 'json',
			success			: function(data) {
				if(data.success == "success"){
					$("#applicantBody").handlerbarsCompile($("#applicant-template"), data.rsList);
					$(".approveBtn").approveBtnOnClickEvt();
					//$(".rejecteBtn").rejecteBtnOnClickEvt();
					$(".rejecteBtn").showManual();
					$(".rejecteDetailBtn").showManual();
					$(".userDetailTd").userDetailTdOnClickEvt();
				}
			}
		});
	}
	
	$.datepickerOnSettings = function(){
		var eduDe = $("#eduDe").datepicker("getDate");  
		if(eduDe != null) eduDe.setDate(eduDe.getDate() - 1);
		
		$("#eduDe").datepicker("option", "maxDate", $("#eduEndDe").val());
		$("#eduEndDe").datepicker("option", "minDate", $("#eduDe").val());
		$("#startDe").datepicker("option", "maxDate", eduDe);
		$("#endDe").datepicker("option", "maxDate", eduDe);
		$("#instrctrStartDe").datepicker("option", "maxDate", $("#instrctrEndDe").val());
		$("#instrctrEndDe").datepicker("option", "min", $("#instrctrStartDe").val());
		
		$("#eduDe").datepicker("option", "onClose", function ( selectedDate ){
			eduDe = $("#eduDe").datepicker("getDate");
			if(eduDe != null) eduDe.setDate(eduDe.getDate() - 1);
			$("#eduEndDe").datepicker( "option", "minDate", selectedDate);
			$("#startDe").datepicker( "option", "maxDate", eduDe);
			$("#endDe").datepicker( "option", "maxDate", eduDe);
		});
		
		$("#startDe").datepicker("option", "onClose", function ( selectedDate ){$("#endDe").datepicker( "option", "minDate", selectedDate );});
		$("#eduEndDe").datepicker("option", "onClose", function ( selectedDate ){$("#eduDe").datepicker( "option", "maxDate", selectedDate );});
		$("#instrctrStartDe").datepicker("option", "onClose", function ( selectedDate ){$("#instrctrEndDe").datepicker( "option", "minDate", selectedDate );});
		$("#instrctrEndDe").datepicker("option", "onClose", function ( selectedDate ){$("#instrctrStartDe").datepicker( "option", "maxDate", selectedDate );});
	}
	
	$.instrctrOthbcYnOnChangeEvt = function(){
		var is = true;
		if($("#instrctrOthbcYn:checked").size() == '1') is = false;
		
		$(".instrctrDe").prop("disabled", is);
		$(".instrctrDe").next("input[type='hidden']").prop("disabled", is);
	}
	
	$.fn.userDetailTdOnClickEvt = function(){
		$(this).on("click", function(){
			var $this = $(this);
			var userNo = $this.data("no");
			if(userNo == "") {
				alert("데이터가 없습니다.");
				return false;
			}
			document.userForm.userNo.value = userNo;
			$.popAction.width = 1200;
			$.popAction.height = 600;
			$.popAction.target = "selectDtyEduMemberDetailPopup1";
			$.popAction.url = "/ncts/mngr/common/selectEduMemberDetailPopup.do";
			$.popAction.form = document.userForm;
			$.popAction.init();
		})
	}
	
	$.fn.lectureIdOnChangeEvt = function(){
		$(this).on("change", function(){
			if($("#eduDivision").val() == "") $("input[name='eduDivision']").val($(this).data("gubun"));
			$(".instrctrInfo").val("");
		})
	}
	
	$.initView = function(){
		$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
		$.datepickerOnSettings();
		$(".inputcal").on("change", function(){$.datepickerOnSettings();})
		$("#listBtn").goBackList($.searchAction);
		$.setValidation();
		$("#saveBtn").saveBtnOnClickEvt();
		$("#appliAddBtn").appliAddOnClickEvt();
		
		$(".instrctrListBtn").instrctrListBtnOnClickEvt();
		
		$("#statUpdBtn").rejecteBtnOnClickEvt();
		$("#lectureId").lectureIdOnChangeEvt();
		
		$.applicantChange();
		
		/* if($("#centerCd").size() == 0){
			$("#deptCd").comboOnChangeEvt(2);
			$("#deptCd").makecombo(2,'<sec:authentication property="principal.centerId"/>');
		}else{
			$("#centerCd").comboOnChangeEvt(1);
			$("#deptCd").comboOnChangeEvt(2);
		} */
		
		$(".onlyNum").onlyNumber(2);
		$(".onlyNum10").onlyNumber(10);
		
		$("#instrctrOthbcYn").on("change", function(){$.instrctrOthbcYnOnChangeEvt();})
		$.instrctrOthbcYnOnChangeEvt();
		
		$(".excelDown").on("click", function(){
			var $this = $(this);
			var pageNm = "";
			if($this.is(".excelDownInfo")) pageNm = "mngrEdcApplicantInfoList";
			else pageNm = "mngrEdcApplicantList";
			
			$("[name='excelFileNm']").val($this.find("i").data("title")+ "_" + $.toDay());
			$("[name='excelPageNm']").val(pageNm);
			with(document.sForm){
				target = "";
				action = baseInfo.excel;
				submit();
			}
		});
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
				<input type="hidden" name="excelFileNm">
				<input type="hidden" name="excelPageNm">
				<input type="hidden" name="eduSeq" value="${result.EDU_SEQ}">
				<input type="hidden" id="eduDivision" name="eduDivision" value="${result.PACKAGE_GUBUN }"> <!-- eduDivision -->
				<input type="hidden" name="sGubun2" value=""> <!-- instrctrDivision -->
				<input type="hidden" name="boardType" value='<c:out value="${param.tempSeq}"/>'>
				<input type="hidden" id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'>
				<input type="hidden" name="eduInstNm" value="" />
				<input type="hidden" class="tempSeq" name="tempSeq" value='<c:out value="${param.tempSeq}"/>'>
				<input type="hidden" class="instrctrDivision" name="instrctrDivision" />
				<input type="hidden" name="pageType" value="dtyEdu"/>
				<input type="hidden" name="certCd" value="${result.LECTURE_ID}"/>
				<input type="hidden" name="lectureId" value=""/>
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
				<article class="col-md-6 col-lg-6">
					<form name="iForm" id="iForm" method="post" class="smart-form" enctype="multipart/form-data">
						<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						<input type="hidden" id="eduCnSnapshot" name="eduCnSnapshot">
						<input type="hidden" id="eduCnHtml" name="eduCnHtml">
						<input type="hidden" id="eduSeq" name="eduSeq" value='<c:out value="${result.EDU_SEQ }"/>'>
						<input type="hidden" name="atchFileId" value='<c:out value="${result.ATCH_FILE_ID }"/>'>
						<input type="hidden" class="tempSeq" name="tempSeq" value="" />
						<input type="hidden" name="eduDivision" value="${result.PACKAGE_GUBUN }">
						<input type="hidden" name="oriEduDivision" value="${result.PACKAGE_GUBUN }">
						
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="10%">
								<col width="15%">
								<col width="12.5%">
								<col width="15%">
								<col width="10%">
								<col width="14%">
								<col width="11.5%">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">패키지명</th>
									<td colspan="7">
									   <label class="select col w200 mr5">
                                            <select id="lectureId" name="lectureId" ${result.ISUE_NMPR gt 0 ? 'disabled':''}>
                                                <option value="">선택</option>
                                                    <c:forEach var="lecList" items="${eduResult}" varStatus="idx">
                                                    	<c:if test="${lecList.USE_AT eq 'Y' }">
                                                    		<option value="${lecList.PACKAGE_NO}" ${result.PACKAGE_NO eq lecList.PACKAGE_NO ? 'selected="selected"' : ''} data-gubun="${lecList.PACKAGE_GUBUN }"> ${lecList.PACKAGE_NM}</option>
                                                    	</c:if>	
                                                    </c:forEach>
                                            </select> <i></i>
                                       </label>
									</td>
								</tr>
								<tr>
                                    <th scope="row">교육명 </th>
                                    <td colspan="7">
                                       <label class="input w300">
                                            <input type="text" id="eduNm" name="eduNm"  value="${result.EDU_NM }" />
                                        </label>
                                    </td>
                                </tr>
								<tr>
									<th scope="row">교육날짜</th>
									<td colspan="7">
										<label class="input w120 col"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="eduDe" name="eduDe" value="${result.EDU_DE }" class="date inputcal tt">
										</label>
										<label class="label col">~</label>
										<label class="input w120 col ml5"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="eduEndDe" name="eduEndDe"     value="${result.EDU_END_DE }" class="date inputcal tt">
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">교육시간</th>
									<td colspan="4">
										<label class="input w40 col mr5">
											<input type="text" class="onlyNum hh" id="eduBeginTimeHour" name="eduBeginTimeHour" value="${result.EDU_BEGIN_TIME_HOUR }" class="part_time" maxlength="2">
										</label>
										<label class="label col">:</label>
										<label class="input w40 col ml5 mr5"> 
											<input type="text" class="onlyNum mm" id="eduBeginTimeMin" name="eduBeginTimeMin"   value="${result.EDU_BEGIN_TIME_MIN }" class="part_time" maxlength="2">
										</label>
										<label class="label col">-</label>
										<label class="input w40 col ml5 mr5">
											<input type="text" class="onlyNum hh" id="eduEndTimeHour" name="eduEndTimeHour"     value="${result.EDU_END_TIME_HOUR }" class="part_time" maxlength="2">
										</label> 
										<label class="label col">:</label>
										<label class="input w40 col ml5 mr5">
											<input type="text" class="onlyNum mm" id="eduEndTimeMin" name="eduEndTimeMin"       value="${result.EDU_END_TIME_MIN }" class="part_time" maxlength="2">
										</label>
									</td>
									<th scope="row">캘린더 노출<br>여부</th>
									<td colspan="2">
										<label class="checkbox checkboxCenter col"><input type="checkbox" id="calendarYn" name="calendarYn" value="Y" ${result.CALENDAR_YN eq 'Y' ? 'checked="checked"':''}><i></i></label><span class="col mt7 ml30 mr5">노출</span>
									</td>									
								</tr>
								<tr>
									<th scope="row">모집날짜</th>
									<td colspan="7">
										<label class="input w120 col"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="startDe" name="startDe" value="${result.START_DE }" class="date inputcal tt">
										</label>
										<label class="label col">~</label>
										<label class="input w120 col ml5"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="endDe" name="endDe"     value="${result.END_DE }" class="date inputcal tt">
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">모집시간</th>
									<td colspan="7">
										<label class="input w40 col mr5">
											<input type="text" class="onlyNum hh" id="startHH" name="startHH" value="${result.START_HH }" class="part_time" maxlength="2">
										</label>
										<label class="label col">:</label>
										<label class="input w40 col ml5 mr5"> 
											<input type="text" class="onlyNum mm" id="startMM" name="startMM"   value="${result.START_MM }" class="part_time" maxlength="2">
										</label>
										<label class="label col">-</label>
										<label class="input w40 col ml5 mr5">
											<input type="text" class="onlyNum hh" id="endHH" name="endHH"     value="${result.END_HH }" class="part_time" maxlength="2">
										</label> 
										<label class="label col">:</label>
										<label class="input w40 col ml5 mr5">
											<input type="text" class="onlyNum mm" id="endMM" name="endMM"       value="${result.END_MM }" class="part_time" maxlength="2">
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">강사모집<br>날짜</th>
									<td colspan="7">
										<label class="input w120 col"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="instrctrStartDe" name="instrctrStartDe" value="${result.INSTRCTR_START_DE }" class="date inputcal tt instrctrDe" data-title="강사모집 시작일">
										</label>
										<label class="label col">~</label>
										<label class="input w120 col ml5"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="instrctrEndDe" name="instrctrEndDe"     value="${result.INSTRCTR_END_DE }" class="date inputcal tt instrctrDe" data-title="강사모집 종료일">
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">강사모집<br>시간</th>
									<td colspan="7">
										<label class="input w40 col mr5">
											<input type="text" class="onlyNum hh instrctrDe" id="instrctrStartHH" name="instrctrStartHH" value="${result.INSTRCTR_START_HH }" class="part_time " maxlength="2" data-title="강사모집 시작시간">
										</label>
										<label class="label col">:</label>
										<label class="input w40 col ml5 mr5"> 
											<input type="text" class="onlyNum mm instrctrDe" id="instrctrStartMM" name="instrctrStartMM"   value="${result.INSTRCTR_START_MM }" class="part_time" maxlength="2" data-title="강사모집 시작분">
										</label>
										<label class="label col">-</label>
										<label class="input w40 col ml5 mr5">
											<input type="text" class="onlyNum hh instrctrDe" id="instrctrEndHH" name="instrctrEndHH"     value="${result.INSTRCTR_END_HH }" class="part_time" maxlength="2" data-title="강사모집 종료시간">
										</label> 
										<label class="label col">:</label>
										<label class="input w40 col ml5 mr5">
											<input type="text" class="onlyNum mm instrctrDe" id="instrctrEndMM" name="instrctrEndMM"       value="${result.INSTRCTR_END_MM }" class="part_time" maxlength="2" data-title="강사모집 종료분">
										</label>
									</td>
								</tr>
								<tr>
									<input type="hidden" value="1" name="eduSubjectvity">
									<%-- <th scope="row">교육주관</th>
									<td colspan="5">
										<div class="inline-group col">  
											<c:forEach var="list" items="${codeMap.NCTS50 }" varStatus="idx">
												<label class="radio">
													<input type="radio" value="${list.CODE }" name="eduSubjectvity" ${result.EDU_SUBJECTVITY eq list.CODE ? 'checked="checked"' :'' }><i></i>${list.CODE_NM }
												</label>
											</c:forEach>                                                                               
										</div>
									</td> --%>
									<th scope="row">별도접수</th>
									<td colspan="1">
										<label class="checkbox checkboxCenter col"><input type="checkbox" id="weAcceptAt" name="weAcceptAt" value="Y" ${result.WE_ACCEPT_AT eq 'Y' ? 'checked="checked"':''}><i></i></label>
									</td>
									<th scope="row">홈페이지<br>게시여부</th>
									<td colspan="2">
										<label class="checkbox checkboxCenter col"><input type="checkbox" id="homepageAt" name="homepageAt" value="Y" ${result.HOMEPAGE_AT eq 'Y' ? 'checked="checked"':''}><i></i></label><span class="col mt7 ml30 mr5">게시</span>
									</td>
									<th scope="row">강사모집<br>여부</th>
									<td colspan="2">
										<label class="checkbox checkboxCenter col"><input type="checkbox" id="instrctrOthbcYn" name="instrctrOthbcYn" value="Y" ${result.INSTRCTR_OTHBC_YN eq 'Y' ? 'checked="checked"':''}><i></i></label><span class="col mt7 ml30 mr5">게시</span>
									</td>
								</tr>
								<tr>
									<th scope="row">교육장소</th>
									<td colspan="2">
										<label class="input">
											<input type="text" id="eduPlace" name="eduPlace" value="${result.EDU_PLACE }" />
										</label>
									</td>
									<th scope="row">교육강사</th>
									<td colspan="4">
										<label class="input w200">
											<input type="hidden" id="eduInstNo" name="eduInstNo" class="instrctrInfo" value="${result.INSTRCTR_NO_I }">
											주강사
											<div class="fL wp5">
											<input type="text" id="eduInstNm" class="instrctrInfo" value="${result.INSTRCTR_NM_I }" readonly/>
											</div>
										</label>	
										<button class="btn btn-primary ml2 instrctrListBtn" type="button" id="instrctrListBtn"><i class="fa fa-edit" title="주강사"></i>주강사 배정</button>
											<label class="input w200">
											<input type="hidden" id="eduAssistInstNo" name="eduAssistInstNo" class="instrctrInfo" value="${result.INSTRCTR_NO_S }">
											준강사
											<div class="fL wp5"><input type="text" id="eduAssistInstNm" class="instrctrInfo" value="${result.INSTRCTR_NM_S }" readonly/></div>
											</label>
										<button class="btn btn-primary ml2 instrctrListBtn" type="button" id="copInstrctrListBtn"><i class="fa fa-edit" title="준강사"></i>준강사 배정</button>
										
									</td>
									<%-- <th scope="row">교육강사소속</th>
									<td>
										<label class="input w80">
											<input type="text" id="eduInstDept" name="eduInstDept"  value="${result.EDU_INST_DEPT }" />
										</label>
									</td> --%>
								</tr>
								<tr>
									<th scope="row">센터 </th>
									<td colspan="7">
										<c:choose>
											<c:when test="${common.baseType[1].key() eq common.procType }">
												<input type="hidden" id="centerCd" name="centerCd" value="${result.CENTER_CD }" >
												<c:out value="${result.CENTER_NM }" />
											</c:when>
											<c:otherwise>
												<sec:authorize access="hasRole('ROLE_MASTER')">
													<label class="select col w150 mr5">
														<select id="centerCd" name="centerCd">
															<option value="">선택</option>
															<c:forEach var="center" items="${centerList }" varStatus="idx">
																<option value="${center.DEPT_CD }" data-groupId="${center.GROUP_ID }" ${center.DEPT_CD eq result.CENTER_CD ? 'selected="selected"':'' } >${center.DEPT_NM }</option>
															</c:forEach>
														</select> <i></i>
													</label>
												</sec:authorize>
												<sec:authorize access="hasRole('ROLE_SYSTEM') or hasRole('ROLE_ADMIN') or hasRole('ROLE_USER')">
													<input type="hidden" name="centerCd" value="<sec:authentication property="principal.centerId"/>" >
													<sec:authentication property="principal.centerNm"/>
												</sec:authorize>	
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								<tr>
									<th>교육대상</th>
									<td colspan="3">
										<label class="input">
											<input type="text" id="eduTargetType" name="eduTargetType" value="${result.EDU_TARGET_TYPE }">
										</label>
									</td>
									<th scope="row">교육인원</th>
									<td colspan="3">
										<label class="input w150 col">
											<input type="text" id="eduNmpr" name="eduNmpr" value="${result.EDU_NMPR }" class="onlyNum10">
										</label>
									</td>
								</tr>
								<tr>
								</tr>
								<tr>
									<th scope="row">첨부파일 </th>
									<td colspan="7">
										${markup }
									</td>
								</tr>
								<tr>
									<th scope="row">교육내용 </th>
									<td colspan="7"  class="board_contents">
										<textarea id="eduCn" name="eduCn" class="part_long board_contents" style="width: 100%; min-width: 100%;">${result.EDU_CN }</textarea>
									</td>
								</tr>
							</tbody>
						</table>
					</form>
				</article>
				<c:if test="${common.procType eq common.baseType[1].key()}">
					<article class="col-md-6 col-lg-6">
						<div class="fL mt15">
							승인됨: ${result.APPL_STAT_Y_CNT }명 / 승인대기: ${result.APPL_STAT_NULL_CNT }명 / 취소: ${result.APPL_STAT_N_CNT }명 / 반려: ${result.APPL_STAT_F_CNT }명
						</div>						
						<div class="fR mt5 mb5">	
							<c:if test="${pageInfo.EXCEL_AT eq 'Y'}">
								<button class="btn btn-default ml2 excelDown excelDownInfo" type="button" >
									<i class="fa fa-print" title="엑셀다운로드" data-title="연락처 정보"></i> 연락처 정보
								</button>
								<button class="btn btn-default ml2 excelDown" type="button" >
									<i class="fa fa-print" title="엑셀다운로드" data-title="교육 신청자 리스트"></i> 엑셀다운로드
								</button>
							</c:if>
							<input type="hidden" name="deptAllAuthorAt" value="<sec:authentication property="principal.deptAllAuthorAt"/>">
							<button class="btn btn-primary ml2" id="appliAddBtn" type="button">
							    <i class="fa fa-edit" title="신청자추가"></i>신청자추가
							</button>
						</div>                                
	                             
						 <table class="table table-bordered table-hover tb_type01">
							<colgroup>
								<col width="5%">
								<col width="10%">
								<col width="10%">
								<col width="17%">
								<col width="17%">
								<col width="17%">
								<col width="12%">
								<col width="12%">
							</colgroup>
							<thead>
								<tr>
									<th>연번</th>
									<th>이름</th>
									<th>생년월일</th>
									<th>소속</th>
									<th>직급</th>
									<th>자격</th>
									<th>세부등급</th>
									<th>승인</th>
									<th>반려</th>
								</tr>
							</thead>
							<tbody id="applicantBody">							
								
							</tbody>
						</table>
					</article>
					<form name="userForm" id="userForm" method="post" class="smart-form">
						<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						<input type="hidden" name="userNo" value="">
					</form>					
				</c:if>
				
			</div>
			<!-- row 메뉴조회 끝 -->
		</div>
	</section>
	<!-- widget grid end -->

</div>
<!-- END MAIN CONTENT -->

<div>
	<div class="popLayer" id="dtyApplStatPop">
		<div class="popWrap">
			<form name="popForm" id="popForm" method="post" class="smart-form" >
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
				<input type="hidden" name="appliSeq">
				<input type="hidden" name="applStat" value="F">
				<input type="hidden" name="eduDivision" value="${result.PACKAGE_GUBUN }">
				<table class="table table-bordered tb_type03">
					<colgroup>
						<col width="30%">
						<col width="70%">
					</colgroup>
					<tbody>
						<tr>
							<th>반려사유</th>
							<td>
								<label class="input w150 col">
									<input type="text" id="applStatDetail" name="applStatDetail">
								</label>
							</td>
						</tr>
					</tbody>
				</table>
			</form>
			<div class="fR mt5 mb5">
				<button class="btn btn-primary ml2" id="statUpdBtn" type="button">
				    <i class="fa fa-edit" title="반려"></i>반려
				</button>
				<button class="btn btn-primary ml2" id="cancelBtn" type="button">
				    <i class="fa fa-edit" title="닫기"></i>닫기
				</button>
			</div>
		</div>
	</div>
</div>

<!--
	 www.disaster-edu.kr -  <Y(승인), N(취소,반려)>
	  현재                                  -  <Y(승인), N(취소), F(반려)> 
-->
<script id="applicant-template" type="text/x-handlebars-template">
{{#if .}}
{{#each .}}
	<tr>
		<td>{{inc @key}}</td>
		<td class="userDetailTd" data-no={{USER_NO}}>{{NM}}</td>
		<td>{{BIRTHDAY}}</td>
		<td>{{ORGANIZATION}}</td>
		<td>{{POSITION}}</td>
		<td>{{EDU_QUALIFICATION_DETAIL}}{{#notempty EDU_QUALIFICATION_18_DETAIL}}({{EDU_QUALIFICATION_18_DETAIL}}){{/notempty}}</td>	
		{{!--<td>{{EDU_QUALIFICATION_DETAIL}}{{#notempty EDU_QUALIFICATION_18_DETAIL}}({{EDU_QUALIFICATION_18_DETAIL}}){{/notempty}}</td>--}}
		<td>
			{{DETAIL_GRADE_CD}}
		</td>
		<td>
			<input type="hidden" name="appliSeq" value="{{APPLI_SEQ}}">
			{{#ifeq APPL_STAT "Y"}}승인됨{{/ifeq}}
			{{#ifnoteq APPL_STAT "Y"}}
				{{#ifeq APPL_STAT "N"}}취소{{#notempty CANCEL_DATE}}({{CANCEL_DATE}}){{/notempty}}
				{{else}}
				<label class="input col">
					<button class="btn btn-primary ml2 approveBtn" type="button">
						<i class="fa fa-edit" title="초기화"></i> 승인
					</button>
				</label>
				{{/ifeq}}
			{{/ifnoteq}}
		</td>
		<td>
			{{#ifeq APPL_STAT "F"}}
			<input type="hidden" name="applStatDetail" value="{{APPL_STAT_DETAIL}}">
			<label class="input col">
				<button class="btn btn-default ml2 rejecteDetailBtn" type="button">
					<i class="fa fa-edit" title="초기화"></i> 반려됨
				</button>
			</label>
			{{/ifeq}}
			{{#ifnoteq APPL_STAT "F"}}
				{{#ifeq APPL_STAT "N"}}취소{{#notempty CANCEL_DATE}}({{CANCEL_DATE}}){{/notempty}}
				{{else}}
				<label class="input col">
					<button class="btn btn-danger ml2 rejecteBtn" type="button">
						<i class="fa fa-edit" title="초기화"></i> 반려
					</button>
				</label>
				{{/ifeq}}
			{{/ifnoteq}}
		</td>
	</tr>
{{/each}}
{{else}}
	<tr class="noData">                           
		<td colspan="8">신청자가 없습니다.</td>             
	</tr>
{{/if}}
</script>