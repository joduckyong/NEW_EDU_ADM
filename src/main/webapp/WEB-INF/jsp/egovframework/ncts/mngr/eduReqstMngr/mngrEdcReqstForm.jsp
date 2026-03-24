<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">
$(function(){
	var baseInfo = {
			lUrl : "<c:out value='${pageInfo.READ_AT eq "Y" ? pageInfo.MENU_URL : pageInfo.MENU_DETAIL_URL   }'/>",
			fUrl : "<c:out value='${pageInfo.MENU_DETAIL_URL }'/>",
			updateKey : "<c:out value='${common.baseType[1].key() }'/>",
	}	
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				reqstNmpr        		:{required	:['인원'], maxlength :['10']},
				reqstEducation    		:{required	:['요청교육']},
				reqstPhoneNo    		:{required	:['연락처(기관)'], maxlength :['13']},
				reqstHpNo      			:{required	:['연락처(핸드폰)'], maxlength :['13']},
				reqstEmail      		:{required	:['이메일']},
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
			if(!confirm("저장하시겠습니까?")) return;
			
			var updateData = new FormData($('#iForm')[0]);
			$.ajax({
				type: 'POST',
				data: new FormData($('#iForm')[0]),
				url: "/ncts/mngr/eduReqstMngr/mngrEduReqstProcess.do",
				processData: false,
				contentType: false,
				dataType: "json",
				success: function(result) {
					alert(result.msg);
//					if(result.success == "success") location.replace(baseInfo.lUrl);	
					if(result.success == "success") history.back();	
				}
	        });
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
	
	$.fn.phoneNumCheck = function(){
		var _this = $(this);
		_this.on("change keyup keypress", function(){
			_this = $(this);
	        _this.val(_this.val().replace("-",""));
	        
	        var phoneNum = _this.val().replace(/[^0-9]/g, "");
	        _this.val(phoneNum);
	        
	        var length = phoneNum.length;
	        var rs = "";
	        
	        if(9 <= length){
	        	if(phoneNum.substring(0,2) == '02') _this.prop("maxlength","12"); 
	        	else _this.prop("maxlength","13"); 
	            if(10 == length){
	                if(2 != Number(phoneNum.substr(0,2))){
	                    _this.val(phoneNum.substr(0, 3) + '-' + phoneNum.substr(3, 3) + '-' + phoneNum.substr(6));
	                }else{
	                    _this.val(phoneNum.substr(0, 2) + '-' + phoneNum.substr(2, 4) + '-' + phoneNum.substr(6));
	                }
	            }else{
	                if(2 != Number(phoneNum.substr(0,2))){
	                    _this.val(phoneNum.substr(0, 3) + '-' + phoneNum.substr(3, 4) + '-' + phoneNum.substr(7));
	                }else{
	                    _this.val(phoneNum.substr(0, 2) + '-' + phoneNum.substr(2, 3) + '-' + phoneNum.substr(5));
	                }
	            }
	        }
			
		})
    }
	
	$.datepickerOnSettings = function(){
		$("#startDate").datepicker("option", "maxDate", $("#endDate").val());
		$("#endDate").datepicker("option", "min", $("#startDate").val());
		$("#instrctrStartDe").datepicker("option", "maxDate", $("#instrctrEndDe").val());
		$("#instrctrEndDe").datepicker("option", "min", $("#instrctrStartDe").val());
		
		$("#startDate").datepicker("option", "onClose", function ( selectedDate ){$("#endDate").datepicker( "option", "minDate", selectedDate );});
		$("#endDate").datepicker("option", "onClose", function ( selectedDate ){$("#startDate").datepicker( "option", "maxDate", selectedDate );});
		$("#instrctrStartDe").datepicker("option", "onClose", function ( selectedDate ){$("#instrctrEndDe").datepicker( "option", "minDate", selectedDate );});
		$("#instrctrEndDe").datepicker("option", "onClose", function ( selectedDate ){$("#instrctrStartDe").datepicker( "option", "maxDate", selectedDate );});
	}
	
	$.instrctrOthbcYnOnChangeEvt = function(){
		var is = true;
		if($("#instrctrOthbcYn:checked").size() == '1') is = false;
		
		$(".instrctrDe").prop("disabled", is);
		$(".instrctrDe").next("input[type='hidden']").prop("disabled", is);
	}
	
	$.initView = function(){
		$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
		$("#listBtn").goBackList($.searchAction);
		$.datepickerOnSettings();
		$.setValidation();
		$("#saveBtn").saveBtnOnClickEvt();
		$(".onlyNum").onlyNumber(5);
		$("input[name='procType']").val(baseInfo.updateKey);
		$(".phone").phoneNumCheck();
		$("#instrctrOthbcYn").on("change", function(){$.instrctrOthbcYnOnChangeEvt();})
		$.instrctrOthbcYnOnChangeEvt();
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
				<input type="hidden" name="reqstSeq" value="<c:out value='${result.REQST_SEQ}'/>">
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
				<article class="col-md-6 col-lg-6">
					<form name="iForm" id="iForm" method="post" class="smart-form" enctype="multipart/form-data">
						<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						<input type="hidden" id="reqstSeq" name="reqstSeq" value='<c:out value="${result.REQST_SEQ }"/>'>
						<input type="hidden" name="lastUpdusrId" value="<sec:authentication property="principal.userId"/>" >
						<input type="hidden" name="referMatterFile" value='<c:out value="${result.REFER_MATTER_FILE }"/>'>
						
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="15%">
								<col width="15%">
								<col width="12.5%">
								<col width="15%">
								<col width="18%">
								<col width="14%">
								<col width="11.5%">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">요청기관 </th>
									<td colspan="4">
									   <label class="select col w150 mr5">
									   		<c:out value="${result.REQST_INSTT }"/>
                                       </label>
									</td>
									<th scope="row">요청지역 </th>
									<td colspan="3">
									   <label class="select col w150 mr5">
									   		<c:out value="${result.REQST_ADDRESS_NM }"/>
                                       </label>
									</td>
								</tr>
								<tr>
									<th scope="row">대상 </th>
									<td colspan="4">
									   <label class="select col w150 mr5">
									   		<c:out value="${result.REQST_TARGET }"/>
                                       </label>
									</td>
									<th scope="row">인원 </th>
									<td colspan="3">
										<label class="input w150 col">
											<input type="text" id="reqstNmpr" name="reqstNmpr" value="<c:out value='${result.REQST_NMPR }'/>" class="onlyNum10">
										</label>
									</td>
								</tr>
								<tr>
                                    <th scope="row">요청교육 </th>
                                    <td colspan="8">
                                       <label class="input w300">
                                       		<select id="reqstEducation" name="reqstEducation" class="form-control w200" >
                                                <option value="">선택</option>
                                                <c:forEach var="test" items="${codeList }" varStatus="idx">
                                                	<c:if test="${test.VIDEO_AT ne 'Y' }">
                                                		<option value="<c:out value='${test.LECTURE_ID }'/>" <c:out value="${result.REQST_EDUCATION eq test.LECTURE_ID ? 'selected=selected' : ''}"/>> <c:out value="${test.LECTURE_NM }"/></option>
                                                	</c:if>
                                                </c:forEach>
                                            </select> <i></i>
                                        </label>
                                    
                                    </td>
                                </tr>
                                <tr>
									<th scope="row">교육날짜</th>
									<td colspan="8">
										<label class="input w120 col"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="startDate" name="startDate" value="<c:out value='${result.START_DATE }'/>" class="date inputcal tt">
										</label>
										<label class="label col">~</label>
										<label class="input w120 col ml5"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="endDate" name="endDate" value="<c:out value='${result.END_DATE }'/>" class="date inputcal tt">
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">교육시간</th>
									<td colspan="3">
										<label class="input w40 col mr5">
											<input type="text" class="onlyNum hh" id="startHour" name="startHour" value="<c:out value='${result.START_HOUR }'/>" class="part_time" maxlength="2">
										</label>
										<label class="label col">:</label>
										<label class="input w40 col ml5 mr5"> 
											<input type="text" class="onlyNum mm" id="startMin" name="startMin" value="<c:out value='${result.START_MIN }'/>" class="part_time" maxlength="2">
										</label>
										<label class="label col">-</label>
										<label class="input w40 col ml5 mr5">
											<input type="text" class="onlyNum hh" id="endHour" name="endHour" value="<c:out value='${result.END_HOUR }'/>" class="part_time" maxlength="2">
										</label> 
										<label class="label col">:</label>
										<label class="input w40 col ml5 mr5">
											<input type="text" class="onlyNum mm" id="endMin" name="endMin" value="<c:out value='${result.END_MIN }'/>" class="part_time" maxlength="2">
										</label>
									</td>
									<th scope="row">캘린더 노출<br>여부</th>
									<td colspan="4">
										<label class="checkbox checkboxCenter col"><input type="checkbox" id="calendarYn" name="calendarYn" value="Y" <c:out value="${result.CALENDAR_YN eq 'Y' ? 'checked=checked':''}"/>><i></i></label><span class="col mt7 ml30 mr5">노출</span>
									</td>										
								</tr>
								<tr>
									<th scope="row">강사모집<br>날짜</th>
									<td colspan="8">
										<label class="input w120 col"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="instrctrStartDe" name="instrctrStartDe" value="<c:out value='${result.INSTRCTR_START_DE }'/>" class="date inputcal tt instrctrDe" data-title="강사모집 시작일">
										</label>
										<label class="label col">~</label>
										<label class="input w120 col ml5"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="instrctrEndDe" name="instrctrEndDe"     value="<c:out value='${result.INSTRCTR_END_DE }'/>" class="date inputcal tt instrctrDe" data-title="강사모집 종료일">
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">강사모집<br>시간</th>
									<td colspan="3">
										<label class="input w40 col mr5">
											<input type="text" class="onlyNum hh instrctrDe" id="instrctrStartHH" name="instrctrStartHH" value="<c:out value='${result.INSTRCTR_START_HH }'/>" class="part_time" maxlength="2" data-title="강사모집 시작시간">
										</label>
										<label class="label col">:</label>
										<label class="input w40 col ml5 mr5"> 
											<input type="text" class="onlyNum mm instrctrDe" id="instrctrStartMM" name="instrctrStartMM"   value="<c:out value='${result.INSTRCTR_START_MM }'/>" class="part_time" maxlength="2" data-title="강사모집 시작분">
										</label>
										<label class="label col">-</label>
										<label class="input w40 col ml5 mr5">
											<input type="text" class="onlyNum hh instrctrDe" id="instrctrEndHH" name="instrctrEndHH"     value="<c:out value='${result.INSTRCTR_END_HH }'/>" class="part_time" maxlength="2" data-title="강사모집 종료시간">
										</label> 
										<label class="label col">:</label>
										<label class="input w40 col ml5 mr5">
											<input type="text" class="onlyNum mm instrctrDe" id="instrctrEndMM" name="instrctrEndMM"       value="<c:out value='${result.INSTRCTR_END_MM }'/>" class="part_time" maxlength="2" data-title="강사모집 종료분">
										</label>
									</td>
									
									<th scope="row">강사모집<br>여부</th>
									<td colspan="4">
										<label class="checkbox checkboxCenter col"><input type="checkbox" id="instrctrOthbcYn" name="instrctrOthbcYn" value="Y" <c:out value="${result.INSTRCTR_OTHBC_YN eq 'Y' ? 'checked=checked':''}"/>><i></i></label><span class="col mt7 ml30 mr5">게시</span>
									</td>
								</tr>
								<tr>
									<th scope="row">담당자</th>
									<td colspan="3">
										<label class="label">
											<c:out value="${result.REQST_CHARGER }"/>
										</label>
									</td>
									<th scope="row">강사명</th>
									<td colspan="4">
										<label class="label">
											<c:out value="${result.REGST_INSTRCTR_NM }"/>
										</label>
									</td>
									<%-- <th scope="row">교육강사소속</th>
									<td>
										<label class="input w80">
											<input type="text" id="eduInstDept" name="eduInstDept"  value="${result.EDU_INST_DEPT }" />
										</label>
									</td> --%>
								</tr>
								<tr>
									<th scope="row">연락처(기관)</th>
									<td colspan="3">
										<label class="input w200">
											<input type="text" id="reqstPhoneNo" name="reqstPhoneNo" class="phone" value="<c:out value='${result.REQST_PHONE_NO }'/>" maxlength="13">
										</label>
									</td>
									<th scope="row">연락처(휴대전화)</th>
									<td colspan="4">
										<label class="input w200">
											<input type="text" id="reqstHpNo" name="reqstHpNo" class="phone" value="<c:out value='${result.REQST_HP_NO }'/>" maxlength="13">
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">이메일</th>
									<td colspan="8">
										<label class="input w200">
											<input type="text" id="reqstEmail" name="reqstEmail" value="<c:out value='${result.REQST_EMAIL }'/>">
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">기타 </th>
									<td colspan="8">
										<textarea cols="30" rows="10" name="reqstEtc" style="width: 100%; height: 100px; border: 1px solid #d2d2d2;" readonly><c:out value="${result.REQST_ETC }"/></textarea>
									</td>
								</tr>
								<tr>
									<th scope="row">센터</th>
									<td colspan="8">
										<sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')">
											<input type="hidden" name="oriCenterCd" value="<c:out value='${result.CENTER_CD }'/>">
											<label class="select col w150 mr5">
												<select id="centerCd" name="centerCd">
													<option value="">선택</option>
													<c:forEach var="center" items="${centerList }" varStatus="idx">
														<c:if test="${center.DEPT_CD ne '20000000' }">
															<option value="<c:out value='${center.DEPT_CD }'/>" data-groupId="<c:out value='${center.GROUP_ID }'/>" <c:out value="${center.DEPT_CD eq result.CENTER_CD ? 'selected=selected':'' }"/> ><c:out value="${center.DEPT_NM }"/></option>
														</c:if>
													</c:forEach>
												</select> <i></i>
											</label>
										</sec:authorize>
										<sec:authorize access="hasRole('ROLE_ADMIN') or hasRole('ROLE_USER')">
											<input type="hidden" name="centerCd" value="<c:out value='${result.CENTER_CD }'/>" >
											<c:out value="${result.CENTER_NM }"/>
										</sec:authorize>											
									</td>
								</tr>
								<sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')">
								<tr>
									<th scope="row">참고사항 </th>
									<td colspan="8">
										<c:out value="${markup }"/>
										<textarea cols="30" rows="10" name="referMatterMemo" wrap=on style="width: 100%; height: 100px; border: 1px solid #d2d2d2;"><c:out value="${result.REFER_MATTER_MEMO }"/></textarea>
									</td>
								</tr>
								</sec:authorize>	
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