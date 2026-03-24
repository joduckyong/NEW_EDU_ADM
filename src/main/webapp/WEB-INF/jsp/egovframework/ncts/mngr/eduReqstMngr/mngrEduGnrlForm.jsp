<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">
$(function(){
	// ckEditor Height 설정
	CKEDITOR.replace('gnrlEduCn',{height : 200});
	
	var baseInfo = {
			lUrl : "<c:out value='${pageInfo.READ_AT eq "Y" ? pageInfo.MENU_URL : pageInfo.MENU_DETAIL_URL   }'/>",
			fUrl : "<c:out value='${pageInfo.MENU_DETAIL_URL }'/>",
			instrctrPopup : "/ncts/mngr/eduReqstMngr/mngrEduInstrctrAppliListPopup.do",
	}	
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				gnrlLectureId               	: {required       : ['기준강의코드']},
				gnrlEduNm               		: {required       : ['교육명'], maxlength :['200']},
				gnrlEduDe                     	: {required       : ['교육시작일자']},
				gnrlEduBeginTimeHour    		: {required       : ['교육시작시간(시)']},
				gnrlEduBeginTimeMin           	: {required       : ['교육시작시간(분)']},
				gnrlEduEndDe           			: {required       : ['교육종료일자']},
				gnrlEduEndTimeHour            	: {required       : ['교육종료시간(시)']},
				gnrlEduEndTimeMin       		: {required       : ['교육종료시간(분)']},
				gnrlEduPlace                  	: {required       : ['교육장소'], maxlength :['100']},
				gnrlEduPlaceDetail            	: {required       : ['교육장소상세']},
				gnrlEduNmpr                   	: {required       : ['교육인원'], maxlength :['10']},
				gnrlEduProcess          		: {required       : ['교육과정']},
				gnrlEduSubjectvity            	: {required       : ['교육주관']},
				 /*eduInstNo                 	: {required       : ['교육강사']},
				eduInstDept         		: {required       : ['교육강사 소속']}, */
				gnrlEduTargetType           	: {required : ['교육대상'], maxlength :['100']},
				gnrlEduReqstInstt           	: {required : ['신청기관'], maxlength :['100']},
				centerCd			        : {required       : ['센터명']},
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
		if($("#gnrlInstrctrOthbcYn:checked").size() == '1') chk = $.beforeInstrctrDeChk();
		if(chk) {
			if(!confirm("저장하시겠습니까?")) return;
			makeSnapshot(document.iForm, "gnrlEduCn");
			
			$("#iForm").ajaxForm({
				type: 'POST',
				url: "/ncts/mngr/eduReqstMngr/mngrEduGnrlProcess.do",
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
								"<c:out value='${_csrf.parameterName}'/>" : "<c:out value='${_csrf.token}'/>"
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
	
	$.popupOpen = function(url, target){
		$.popAction.width = 1200;
		$.popAction.height = 600;
		$.popAction.target = target;
		$.popAction.url = url;
		$.popAction.form = document.sForm;
		$.popAction.init();
	}
	
	$.fn.instrctrListBtnOnClickEvt = function(){
		var _this = $(this);
		_this.on("click", function(){
			var $this = $(this);
			var division = "";
			if($this.prop("id") == "instrctrListBtn") division = "I";
			else division = "S";
			document.sForm.instrctrDivision.value = division;
			document.sForm.sGubun2.value = division;
			$.popupOpen(baseInfo.instrctrPopup,"instrctrPopup");
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
			
			$.showPopLayer('applStatPop');
			$('#cancelBtn').click(function() {
				$.closePopLayer('applStatPop');
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
	
	$.datepickerOnSettings = function(){
		$("#gnrlEduDe").datepicker("option", "maxDate", $("#gnrlEduEndDe").val());
		$("#gnrlEduEndDe").datepicker("option", "minDate", $("#gnrlEduDe").val());
		$("#gnrlInstrctrStartDe").datepicker("option", "maxDate", $("#gnrlInstrctrEndDe").val());
		$("#gnrlInstrctrEndDe").datepicker("option", "minDate", $("#gnrlInstrctrStartDe").val());
		
		$("#gnrlEduDe").datepicker("option", "onClose", function ( selectedDate ){$("#gnrlEduEndDe").datepicker( "option", "minDate", selectedDate);});
		$("#gnrlEduEndDe").datepicker("option", "onClose", function ( selectedDate ){$("#gnrlEduDe").datepicker( "option", "maxDate", selectedDate );});
		$("#gnrlInstrctrStartDe").datepicker("option", "onClose", function ( selectedDate ){$("#gnrlInstrctrEndDe").datepicker( "option", "minDate", selectedDate);});
		$("#gnrlInstrctrEndDe").datepicker("option", "onClose", function ( selectedDate ){$("#gnrlInstrctrStartDe").datepicker( "option", "maxDate", selectedDate );});
	}
	
	$.instrctrOthbcYnOnChangeEvt = function(){
		var is = true;
		if($("#gnrlInstrctrOthbcYn:checked").size() == '1') is = false;
		
		$(".instrctrDe").prop("disabled", is);
		$(".instrctrDe").next("input[type='hidden']").prop("disabled", is);
	}
	
	
	$.initView = function(){
		$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
		$.datepickerOnSettings();
		$("#listBtn").goBackList($.searchAction);
		$.setValidation();
		$("#saveBtn").saveBtnOnClickEvt();
		
		$(".instrctrListBtn").instrctrListBtnOnClickEvt();
		
		/* if($("#centerCd").size() == 0){
			$("#deptCd").comboOnChangeEvt(2);
			$("#deptCd").makecombo(2,'<sec:authentication property="principal.centerId"/>');
		}else{
			$("#centerCd").comboOnChangeEvt(1);
			$("#deptCd").comboOnChangeEvt(2);
		} */
		
		$("#gnrlInstrctrOthbcYn").on("change", function(){$.instrctrOthbcYnOnChangeEvt();})
		$.instrctrOthbcYnOnChangeEvt();
		
		$(".onlyNum").onlyNumber(2);
		$(".onlyNum10").onlyNumber(10);
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
				<input type="hidden" name="gnrlEduSeq" value='<c:out value="${result.GNRL_EDU_SEQ}"/>'>
				<input type="hidden" name="eduSeq" value='<c:out value="${result.GNRL_EDU_SEQ}"/>'>
				<input type="hidden" name="reqstSeq" value='<c:out value="${result.GNRL_EDU_SEQ}"/>'>
				<input type="hidden" name="eduDivision" value="03"> <!-- eduDivision -->
				<input type="hidden" name="sGubun2" value=""> <!-- instrctrDivision -->
				<input type="hidden" name="boardType" value='<c:out value="${param.tempSeq}"/>'>
				<input type="hidden" id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'>
				<input type="hidden" name="gnrlEduInstNm" value="" />
				<input type="hidden" class="tempSeq" name="tempSeq" value='<c:out value="${param.tempSeq}"/>' />
				<input type="hidden" class="instrctrDivision" name="instrctrDivision" />
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
						<input type="hidden" id="gnrlEduCnSnapshot" name="gnrlEduCnSnapshot">
						<input type="hidden" id="eduCnHtml" name="eduCnHtml">
						<input type="hidden" id="gnrlEduSeq" name="gnrlEduSeq" value="<c:out value='${result.GNRL_EDU_SEQ }'/>">
						<input type="hidden" name="atchFileId" value="<c:out value='${result.ATCH_FILE_ID }'/>">
						<input type="hidden" class="tempSeq" name="tempSeq" value="" />
						<input type="hidden" name="eduDivision" value="03" />
						
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
									<th scope="row">기준강의코드 </th>
									<td colspan="7">
									   <label class="select col w200 mr5">
                                            <select id="gnrlLectureId" name="gnrlLectureId">
                                                <option value="">선택</option>
                                                    <c:forEach var="lecList" items="${eduResult}" varStatus="idx">
                                                        <c:if test="${lecList.LECTURE_ID ne '일반' and lecList.VIDEO_AT ne 'Y'}">
                                                            <option value="<c:out value='${lecList.LECTURE_ID}'/>" <c:out value="${result.GNRL_LECTURE_ID eq lecList.LECTURE_ID ? 'selected=selected' : ''}"/>> <c:out value="${lecList.LECTURE_NM}"/></option>
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
                                            <input type="text" id="gnrlEduNm" name="gnrlEduNm"  value="<c:out value='${result.GNRL_EDU_NM }'/>" />
                                        </label>
                                    </td>
                                </tr>
								<tr>
									<th>교육과정</th>
									<td colspan="7">
										<div class="inline-group col">
											<c:forEach var="list" items="${codeMap.DMH14 }" varStatus="idx">
												<c:if test="${list.CODE eq '00'}">
													<label class="radio">
														<%-- <input type="radio" value="${list.CODE }" name="gnrlEduProcess" ${result.GNRL_EDU_PROCESS eq list.CODE ? 'checked="checked"' :'' }><i></i>${list.CODE_NM } --%>
														<input type="radio" value="<c:out value='${list.CODE }'/>" name="gnrlEduProcess" checked><i></i><c:out value="${list.CODE_NM }"/>
													</label>
												</c:if>
											</c:forEach>
										</div>                                                                                                          
									</td>                                                                                                               
								</tr>
								<tr>
									<th scope="row">교육날짜</th>
									<td colspan="7">
										<label class="input w120 col"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="gnrlEduDe" name="gnrlEduDe" value="<c:out value='${result.GNRL_EDU_DE }'/>" class="date inputcal tt">
										</label>
										<label class="label col">~</label>
										<label class="input w120 col ml5"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="gnrlEduEndDe" name="gnrlEduEndDe"     value="<c:out value='${result.GNRL_EDU_END_DE }'/>" class="date inputcal tt">
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">교육시간</th>
									<td colspan="7">
										<label class="input w40 col mr5">
											<input type="text" class="onlyNum hh" id="gnrlEduBeginTimeHour" name="gnrlEduBeginTimeHour" value="<c:out value='${result.GNRL_EDU_BEGIN_TIME_HOUR }'/>" class="part_time" maxlength="2">
										</label>
										<label class="label col">:</label>
										<label class="input w40 col ml5 mr5"> 
											<input type="text" class="onlyNum mm" id="gnrlEduBeginTimeMin" name="gnrlEduBeginTimeMin"   value="<c:out value='${result.GNRL_EDU_BEGIN_TIME_MIN }'/>" class="part_time" maxlength="2">
										</label>
										<label class="label col">-</label>
										<label class="input w40 col ml5 mr5">
											<input type="text" class="onlyNum hh" id="gnrlEduEndTimeHour" name="gnrlEduEndTimeHour"     value="<c:out value='${result.GNRL_EDU_END_TIME_HOUR }'/>" class="part_time" maxlength="2">
										</label> 
										<label class="label col">:</label>
										<label class="input w40 col ml5 mr5">
											<input type="text" class="onlyNum mm" id="gnrlEduEndTimeMin" name="gnrlEduEndTimeMin"       value="<c:out value='${result.GNRL_EDU_END_TIME_MIN }'/>" class="part_time" maxlength="2">
										</label>
									</td>
								</tr>
								<%-- <tr>
									<th scope="row">강사모집<br>날짜</th>
									<td colspan="7">
										<label class="input w120 col"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="gnrlInstrctrStartDe" name="gnrlInstrctrStartDe" value="${result.GNRL_INSTRCTR_START_DE }" class="date inputcal tt instrctrDe" data-title="강사모집 시작일">
										</label>
										<label class="label col">~</label>
										<label class="input w120 col ml5"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="gnrlInstrctrEndDe" name="gnrlInstrctrEndDe"     value="${result.GNRL_INSTRCTR_END_DE }" class="date inputcal tt instrctrDe" data-title="강사모집 종료일">
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">강사모집<br>시간</th>
									<td colspan="7">
										<label class="input w40 col mr5">
											<input type="text" class="onlyNum hh instrctrDe" id="gnrlInstrctrStartHH" name="gnrlInstrctrStartHH" value="${result.GNRL_INSTRCTR_START_HH }" class="part_time " maxlength="2" data-title="강사모집 시작시간">
										</label>
										<label class="label col">:</label>
										<label class="input w40 col ml5 mr5"> 
											<input type="text" class="onlyNum mm instrctrDe" id="gnrlInstrctrStartMM" name="gnrlInstrctrStartMM"   value="${result.GNRL_INSTRCTR_START_MM }" class="part_time" maxlength="2" data-title="강사모집 시작분">
										</label>
										<label class="label col">-</label>
										<label class="input w40 col ml5 mr5">
											<input type="text" class="onlyNum hh instrctrDe" id="gnrlInstrctrEndHH" name="gnrlInstrctrEndHH"     value="${result.GNRL_INSTRCTR_END_HH }" class="part_time" maxlength="2" data-title="강사모집 종료시간">
										</label> 
										<label class="label col">:</label>
										<label class="input w40 col ml5 mr5">
											<input type="text" class="onlyNum mm instrctrDe" id="gnrlInstrctrEndMM" name="gnrlInstrctrEndMM"       value="${result.GNRL_INSTRCTR_END_MM }" class="part_time" maxlength="2" data-title="강사모집 종료분">
										</label>
									</td>
								</tr> --%>
								<tr>
									<input type="hidden" value="1" name="gnrlEduSubjectvity">
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
									<%-- <th scope="row">별도접수</th>
									<td colspan="3">
										<label class="checkbox checkboxCenter col"><input type="checkbox" id="gnrlWeAcceptAt" name="gnrlWeAcceptAt" value="Y" ${result.GNRL_WE_ACCEPT_AT eq 'Y' ? 'checked="checked"':''}><i></i></label>
									</td>
									<th scope="row">홈페이지<br>게시여부</th>
									<td colspan="3">
										<label class="checkbox checkboxCenter col"><input type="checkbox" id="gnrlHomepageAt" name="gnrlHomepageAt" value="Y" ${result.GNRL_HOMEPAGE_AT eq 'Y' ? 'checked="checked"':''}><i></i></label><span class="col mt7 ml30 mr5">게시</span>
									</td> --%>
									<%-- <th scope="row">강사모집<br>여부</th>
									<td colspan="2">
										<label class="checkbox checkboxCenter col"><input type="checkbox" id="gnrlInstrctrOthbcYn" name="gnrlInstrctrOthbcYn" value="Y" ${result.GNRL_INSTRCTR_OTHBC_YN eq 'Y' ? 'checked="checked"':''}><i></i></label><span class="col mt7 ml30 mr5">게시</span>
									</td> --%>
								</tr>
								<tr>
									<th scope="row">교육장소</th>
									<td colspan="2">
										<label class="input">
											<input type="text" id="gnrlEduPlace" name="gnrlEduPlace" value="<c:out value='${result.GNRL_EDU_PLACE }'/>" />
										</label>
									</td>
									<th scope="row">교육강사</th>
									<input type="hidden" name="deptAllAuthorAt" value="<sec:authentication property="principal.deptAllAuthorAt"/>">	
									<td colspan="4">
										<label class="input w200">
											<input type="hidden" id="eduInstNo" name="eduInstNo" value="<c:out value='${result.INSTRCTR_NO_I }'/>">
											주강사
											<div class="fL wp5">
											<input type="text" id="eduInstNm" value="<c:out value='${result.INSTRCTR_NM_I }'/>" readonly/>
											</div>
										</label>
										<button class="btn btn-primary ml2 instrctrListBtn dstrctHide" type="button" id="instrctrListBtn" ><i class="fa fa-edit" title="주강사"></i>주강사 배정</button>
											<label class="input w200">
											<input type="hidden" id="eduAssistInstNo" name="eduAssistInstNo" value="<c:out value='${result.INSTRCTR_NO_S }'/>">
											준강사
											<div class="fL wp5"><input type="text" id="eduAssistInstNm" value="<c:out value='${result.INSTRCTR_NM_S }'/>" readonly/></div>
											</label>
										<button class="btn btn-primary ml2 instrctrListBtn dstrctHide" type="button" id="copInstrctrListBtn" ><i class="fa fa-edit" title="준강사"></i>준강사 배정</button>
										
									</td>
									<%-- <th scope="row">교육강사소속</th>
									<td>
										<label class="input w80">
											<input type="text" id="eduInstDept" name="eduInstDept"  value="${result.EDU_INST_DEPT }" />
										</label>
									</td> --%>
								</tr>
								<tr>
								<th scope="row">신청기관</th>
									<td colspan="3">
										<label class="input w200 col">
											<input type="text" id="gnrlEduReqstInstt" name="gnrlEduReqstInstt" value="<c:out value='${result.GNRL_EDU_REQST_INSTT }'/>">
										</label>
									</td>
									<th scope="row">센터 </th>
									<td colspan="7">
										<c:choose>
											<c:when test="${common.baseType[1].key() eq common.procType }">
												<input type="hidden" id="centerCd" name="centerCd" value="<c:out value='${result.CENTER_CD }'/>" >
												<c:out value="${result.CENTER_NM }" />
											</c:when>
											<c:otherwise>
												<sec:authorize access="hasRole('ROLE_MASTER')">
													<label class="select col w150 mr5">
														<select id="centerCd" name="centerCd">
															<option value="">선택</option>
															<c:forEach var="center" items="${centerList }" varStatus="idx">
																<option value="<c:out value='${center.DEPT_CD }'/>" data-groupId="<c:out value='${center.GROUP_ID }'/>" <c:out value="${center.DEPT_CD eq result.CENTER_CD ? 'selected=selected':'' }"/> ><c:out value="${center.DEPT_NM }"/></option>
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
										<label class="input w200 col">
											<input type="text" id="gnrlEduTargetType" name="gnrlEduTargetType" value="<c:out value='${result.GNRL_EDU_TARGET_TYPE }'/>">
										</label>
									</td>
									<th scope="row">교육인원</th>
									<td colspan="3">
										<label class="input w150 col">
											<input type="text" id="gnrlEduNmpr" name="gnrlEduNmpr" value="<c:out value='${result.GNRL_EDU_NMPR }'/>" class="onlyNum10">
										</label>
									</td>
								</tr>
								<tr>
								</tr>
								<tr>
									<th scope="row">첨부파일 </th>
									<td colspan="7">
										<c:out value="${markup }"/>
									</td>
								</tr>
								<tr>
									<th scope="row">교육내용 </th>
									<td colspan="7"  class="board_contents">
										<textarea id="gnrlEduCn" name="gnrlEduCn" class="part_long board_contents" style="width: 100%; min-width: 100%;"><c:out value="${result.GNRL_EDU_CN }"/></textarea>
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
<!-- END MAIN CONTENT -->