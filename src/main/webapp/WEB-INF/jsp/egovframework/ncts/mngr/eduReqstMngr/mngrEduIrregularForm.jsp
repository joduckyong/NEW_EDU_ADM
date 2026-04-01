<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">
$(function(){
	// ckEditor Height 설정
	CKEDITOR.replace('eduCn',{height : 200});
	
	var baseInfo = {
			lUrl : '${pageInfo.READ_AT eq 'Y' ? pageInfo.MENU_URL : pageInfo.MENU_DETAIL_URL   }',
			fUrl : '<c:out value="${pageInfo.MENU_DETAIL_URL }"/>',
			excel : "/ncts/stat/common/statExcelDownload.do",
	}	
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				eduNm               		: {required       : ['교육명']},
				eduDe                     	: {required       : ['교육일']},
				eduBeginTimeHour    		: {required       : ['시작시간']},
				eduBeginTimeMin           	: {required       : ['시작분']},
				eduEndTimeHour            	: {required       : ['종료시간']},
				eduEndTimeMin       		: {required       : ['종료분']},
				eduPlace                  	: {required       : ['교육장소']},
				eduPlaceDetail            	: {required       : ['교육장소상세']},
				eduNmpr                   	: {required       : ['교육인원']},
				eduProcess          		: {required       : ['교육과정']},
				eduSubjectvity            	: {required       : ['교육주관']},
				eduInstNm                 	: {required       : ['교육강사']},
				eduInstDept         		: {required       : ['교육강사 소속']},
				eduTargetType           	: {required       : ['교육대상 분류']},
				startDe          			: {required       : ['모집 시작일']},
				startHH    					: {required       : ['모집 시작시간']},
				startMM			          	: {required       : ['모집 시작분']},
				endDe	          			: {required       : ['모집 종료일']},
				endHH    					: {required       : ['모집 종료시간']},
				endMM			          	: {required       : ['모집 종료분']},
			}
		});
	}
	
	$.saveProc = function(){
		if(!confirm("저장하시겠습니까?")) return;
		
		makeSnapshot(document.iForm, "eduCn");
		
		$("#iForm").ajaxForm({
			type: 'POST',
			url: "/ncts/mngr/eduReqstMngr/mngrEduIrregularProcess.do",
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
								'<c:out value="${_csrf.parameterName}"/>' : '<c:out value="${_csrf.token}"/>'
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
				url				: "/ncts/mngr/eduReqstMngr/mngrEduIrregularApplicantUpdateProcess.do",
				data			: {
									"appliSeq" : $this.parent().parent().parent().find("input[name='appliSeq']").val(),
									"applStat" : "Y", 
									"procType" : '<c:out value="${common.baseType[1].key() }"/>',
									'<c:out value="${_csrf.parameterName}"/>' : '<c:out value="${_csrf.token}"/>'
				},
				dataType		: 'json',
				success			: function(result) {
					$.applicantChange();
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
				url				: "/ncts/mngr/eduReqstMngr/mngrEduIrregularApplicantUpdateProcess.do",
				data			: $("#popForm").serialize(),
				dataType		: 'json',
				success			: function(result) {
					$.applicantChange();
					$.closePopLayer('applStatPop');
				}
			});
		})
	}
	
	$.fn.appliAddOnClickEvt = function(){
		var _this = $(this);
		_this.on("click", function(){
			_this=$(this);
 			$.popAction.width = 1200;
			$.popAction.height = 600;
			$.popAction.target = "popup01";
			$.popAction.url = '/ncts/mngr/eduReqstMngr/mngrAppliAddPopup2.do';
			$.popAction.form = document.sForm;
			$.popAction.init();
		})
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
	
	$.applicantChange = function(){
		$.ajax({
			type			: "POST",
			url				: "/ncts/mngr/eduReqstMngr/selectMngrEduIrregularApplicantList.do",
			data			: {
								"eduSeq" : $("#eduSeq").val(),
								'<c:out value="${_csrf.parameterName}"/>' : '<c:out value="${_csrf.token}"/>'
			},
			dataType		: 'json',
			success			: function(data) {
				if(data.success == "success"){
					$("#applicantBody").handlerbarsCompile($("#applicant-template"), data.rsList);
					$(".approveBtn").approveBtnOnClickEvt();
					//$(".rejecteBtn").rejecteBtnOnClickEvt();
					$(".rejecteBtn").showManual();
					$(".rejecteDetailBtn").showManual();
				}
			}
		});
	}
	
	$.initView = function(){
		$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
		$("#listBtn").goBackList($.searchAction);
		$.setValidation();
		$("#saveBtn").saveBtnOnClickEvt();
		
		$("#appliAddBtn").appliAddOnClickEvt();
		
		$("#statUpdBtn").rejecteBtnOnClickEvt();
		
		$.applicantChange();
		
		if($("#centerCd").size() == 0){
			$("#deptCd").comboOnChangeEvt(2);
			$("#deptCd").makecombo(2,'<sec:authentication property="principal.centerId"/>');
		}else{
			$("#centerCd").comboOnChangeEvt(1);
			$("#deptCd").comboOnChangeEvt(2);
		}
		
		$(".onlyNum").onlyNumber(2);
		
		$(".excelDown").on("click", function(){
			$("[name='excelFileNm']").val("교육 신청자 리스트 "+$.toDay());
			$("[name='excelPageNm']").val("eduAppliList");
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
				<input type="hidden" name="eduSeq" value='<c:out value="${result.EDU_SEQ}"/>'>
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
						<input type="hidden" id="eduCnSnapshot" name="eduCnSnapshot">
						<input type="hidden" id="eduCnHtml" name="eduCnHtml">
						<input type="hidden" id="eduSeq" name="eduSeq" value='<c:out value="${result.EDU_SEQ }"/>'>
						<input type="hidden" name="atchFileId" value='<c:out value="${result.ATCH_FILE_ID }"/>'>
						
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
									   <label class="select col w150 mr5">
                                            <select id="lectureId" name="lectureId">
                                                <option value="">선택</option>
                                                    <c:forEach var="test" items="${eduResult }" varStatus="idx">
                                                        <option value='<c:out value="${test.LECTURE_ID }"/>' <c:out value="${result.LECTURE_ID eq test.LECTURE_ID ? 'selected=selected' : ''}"/>> <c:out value="${test.LECTURE_ID }"/></option>
                                                    </c:forEach>
                                            </select> <i></i>
                                       </label>
									</td>
								</tr>
								<tr>
                                    <th scope="row">교육명 </th>
                                    <td colspan="7">
                                       <label class="input w300">
                                            <input type="text" id="eduNm" name="eduNm"  value='<c:out value="${result.EDU_NM }"/>' />
                                        </label>
                                    </td>
                                </tr>
								<tr>
									<th>교육과정</th>
									<td colspan="7">
										<div class="inline-group col">
											<c:forEach var="list" items="${codeMap.DMH14 }" varStatus="idx">
												<label class="radio">
													<input type="radio" value='<c:out value="${list.CODE }"/>' name="eduProcess" <c:out value="${result.EDU_PROCESS eq list.CODE ? 'checked=checked' :'' }"/>><i></i><c:out value="${list.CODE_NM }"/>
												</label>
											</c:forEach>
										</div>                                                                                                          
									</td>                                                                                                               
								</tr>
								<tr>
									<th scope="row">교육날짜</th>
									<td colspan="7">
										<label class="input w120 col"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="eduDe" name="eduDe"     value='<c:out value="${result.EDU_DE }"/>' class="date inputcal tt">
										</label>
										<label class="label col">~</label>
										<label class="input w120 col ml5"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="eduEndDe" name="eduEndDe"     value='<c:out value="${result.EDU_END_DE }"/>' class="date inputcal tt">
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">교육시간</th>
									<td colspan="7">
										<label class="input w40 col mr5">
											<input type="text" class="onlyNum hh" id="eduBeginTimeHour" name="eduBeginTimeHour" value='<c:out value="${result.EDU_BEGIN_TIME_HOUR }"/>' class="part_time" maxlength="2">
										</label>
										<label class="label col">:</label>
										<label class="input w40 col ml5 mr5"> 
											<input type="text" class="onlyNum mm" id="eduBeginTimeMin" name="eduBeginTimeMin"   value='<c:out value="${result.EDU_BEGIN_TIME_MIN }"/>' class="part_time" maxlength="2">
										</label>
										<label class="label col">-</label>
										<label class="input w40 col ml5 mr5">
											<input type="text" class="onlyNum hh" id="eduEndTimeHour" name="eduEndTimeHour"     value='<c:out value="${result.EDU_END_TIME_HOUR }"/>' class="part_time" maxlength="2">
										</label> 
										<label class="label col">:</label>
										<label class="input w40 col ml5 mr5">
											<input type="text" class="onlyNum mm" id="eduEndTimeMin" name="eduEndTimeMin"       value='<c:out value="${result.EDU_END_TIME_MIN }"/>' class="part_time" maxlength="2">
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">모집 기간</th>
									<td colspan="5">
										<label class="input w120 col"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="startDe" name="startDe"     value='<c:out value="${result.START_DE }"/>' class="date inputcal tt">
										</label>
										<label class="input w40 col mr5 ml5">
											<input type="text" class="onlyNum hh" id="startHH" name="startHH" value='<c:out value="${result.START_HH }"/>' class="part_time" maxlength="2">
										</label>
										<label class="label col">:</label>
										<label class="input w40 col ml5"> 
											<input type="text" class="onlyNum mm" id="startMM" name="startMM"   value='<c:out value="${result.START_MM }"/>' class="part_time" maxlength="2">
										</label>
										
										<span class="mt7 ml5 mr5 col">~</span>
										
										<label class="input w120 col"><i class="icon-append fa fa-calendar"></i>
											<input type="text" id="endDe" name="endDe"     value='<c:out value="${result.END_DE }"/>' class="date inputcal tt">
										</label>
										<label class="input w40 col mr5 ml5">
											<input type="text" class="onlyNum hh" id="endHH" name="endHH" value='<c:out value="${result.END_HH }"/>' class="part_time" maxlength="2">
										</label>
										<label class="label col">:</label>
										<label class="input w40 col ml5 mr5"> 
											<input type="text" class="onlyNum mm" id="endMM" name="endMM"   value='<c:out value="${result.END_MM }"/>' class="part_time" maxlength="2">
										</label>
									</td>
									<th>홈페이지<br>게시여부</th>
									<td>
										<label class="checkbox checkboxCenter col"><input type="checkbox" id="homepageAt" name="homepageAt" value="Y" <c:out value="${result.HOMEPAGE_AT eq 'Y' ? 'checked=checked':''}"/>><i></i></label><span class="col mt7 ml30 mr5">게시</span>
									</td>
								</tr>
								<tr>
									<input type="hidden" value="2" name="eduSubjectvity">
									<%-- <th scope="row">교육주관</th>
									<td colspan="5">
										<div class="inline-group col">  
											<c:forEach var="list" items="${codeMap.NCTS50 }" varStatus="idx">
												<label class="radio">
													<c:if test="${list.CODE eq 3}">
														<input type="radio" value="${list.CODE }" name="eduSubjectvity" ${result.EDU_SUBJECTVITY eq list.CODE ? 'checked="checked"' :'' }><i></i>${list.CODE_NM }
													</c:if>
												</label>
											</c:forEach>                                                                               
										</div>
									</td> --%>
									<th>별도접수</th>
									<td>
										<label class="checkbox checkboxCenter col"><input type="checkbox" id="weAcceptAt" name="weAcceptAt" value="Y" <c:out value="${result.WE_ACCEPT_AT eq 'Y' ? 'checked=checked':''}"/>><i></i></label>
									</td>
								</tr>
								<tr>
									<th scope="row">교육장소</th>
									<td colspan="3">
										<label class="input w150">
											<input type="text" id="eduPlace" name="eduPlace"  value='<c:out value="${result.EDU_PLACE }"/>' />
										</label>
									</td>
									<th scope="row">교육강사</th>
									<td>
										<label class="input w80">
											<input type="text" id="eduInstNm" name="eduInstNm"  value='<c:out value="${result.EDU_INST_NM }"/>' />
										</label>
									</td>
									<th scope="row">교육강사소속</th>
									<td>
										<label class="input w80">
											<input type="text" id="eduInstDept" name="eduInstDept"  value='<c:out value="${result.EDU_INST_DEPT }"/>' />
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">센터 </th>
									<td>
										<c:choose>
											<c:when test="${common.baseType[1].key() eq common.procType }">
												<input type="hidden" id="centerCd" name="centerCd" value='<c:out value="${result.CENTER_CD }"/>' >
												<c:out value="${result.CENTER_NM }" />
											</c:when>
											<c:otherwise>
												<sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')">
													<label class="select col w70 mr5">
														<select id="centerCd" name="centerCd">
															<option value="">선택</option>
															<c:forEach var="center" items="${centerList }" varStatus="idx">
																<option value='<c:out value="${center.DEPT_CD }"/>' data-groupId='<c:out value="${center.GROUP_ID }"/>' <c:out value="${center.DEPT_CD eq result.CENTER_CD ? 'selected=selected':'' }"/>><c:out value="${center.DEPT_NM }"/></option>
															</c:forEach>
														</select> <i></i>
													</label>
												</sec:authorize>
												<sec:authorize access="hasRole('ROLE_ADMIN') or hasRole('ROLE_USER')">
													<input type="hidden" name="centerCd" value="<sec:authentication property="principal.centerId"/>" >
													<sec:authentication property="principal.centerNm"/>
												</sec:authorize>	
											</c:otherwise>
										</c:choose>
									</td>
									<th scope="row">부서 </th>
									<td>
										<c:choose>
											<c:when test="${common.baseType[1].key() eq common.procType }">
												<input type="hidden" name="deptCd" value='<c:out value="${result.DEPT_CD }"/>' >
												<c:out value="${result.DEPT_NM }" />
											</c:when>
											<c:otherwise>
												<label class="select w70">
													<select id="deptCd" name="deptCd" class="form-control">
														<option value="">선택</option>
													</select> <i></i>
												</label>
											</c:otherwise>
										</c:choose>
									</td>
									<th scope="row">팀 </th>
									<td colspan="3">
										<c:choose>
											<c:when test="${common.baseType[1].key() eq common.procType }">
												<input type="hidden" name="teamCd" value='<c:out value="${result.TEAM_CD }"/>' >
												<c:out value="${result.TEAM_NM }" />
											</c:when>
											<c:otherwise>
												<label class="select w70">
													<select id="teamCd" name="teamCd" class="form-control">
														<option value="">없음</option>
													</select> <i></i>
												</label>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								<tr>
									<th>교육대상</th>
									<td colspan="3">
										<label class="input w150 col">
											<input type="text" id="eduTargetType" name="eduTargetType" value='<c:out value="${result.EDU_TARGET_TYPE }"/>'>
										</label>
									</td>
									<th scope="row">교육인원</th>
									<td colspan="3">
										<label class="input w150 col">
											<input type="text" id="eduNmpr" name="eduNmpr" value='<c:out value="${result.EDU_NMPR }"/>' class="onlyNum">
										</label>
									</td>
								</tr>
								<tr>
								</tr>
								<tr>
									<th scope="row">첨부파일 </th>
									<td colspan="7">
										<c:out value="${markup}" escapeXml="false"/>
									</td>
								</tr>
								<tr>
									<th scope="row">교육내용 </th>
									<td colspan="7"  class="board_contents">
										<textarea id="eduCn" name="eduCn" class="part_long board_contents" style="width: 100%; min-width: 100%;"><c:out value="${result.EDU_CN }"/></textarea>
									</td>
								</tr>
							</tbody>
						</table>
					</form>
				</article>
				<c:if test="${common.procType eq common.baseType[1].key()}">
				<article class="col-md-6 col-lg-6">
					<div class="fR mt5 mb5">	
						<button class="btn btn-default ml2 excelDown" type="button" >
							<i class="fa fa-print" title="엑셀다운로드"></i> 엑셀다운로드
						</button>								
						<button class="btn btn-primary ml2" id="appliAddBtn" type="button">
						    <i class="fa fa-edit" title="신청자추가"></i>신청자추가
						</button>
					</div>                                
                             
					 <table class="table table-bordered table-hover tb_type01">
						<colgroup>
							<col width="15%">
							<col width="16%">
							<col width="15%">
							<col width="15%">
							<col width="15%">
							<col width="12%">
							<col width="12%">
						</colgroup>
						<thead>
							<tr>
								<th>이름</th>
								<th>생년월일</th>
								<th>소속</th>
								<th>직급</th>
								<th>재난심리지원지역</th>
								<th>승인</th>
								<th>반려</th>
							</tr>
						</thead>
						<tbody id="applicantBody">							
							
						</tbody>
					</table>
				</article>
				</c:if>
				
			</div>
			<!-- row 메뉴조회 끝 -->
		</div>
	</section>
	<!-- widget grid end -->

</div>
<!-- END MAIN CONTENT -->

<div>
	<div class="popLayer" id="applStatPop">
		<div class="popWrap">
			<form name="popForm" id="popForm" method="post" class="smart-form" >
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
				<input type="hidden" name="appliSeq">
				<input type="hidden" name="applStat" value="N">
				<input type="hidden" name="">
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

<script id="applicant-template" type="text/x-handlebars-template">
{{#if .}}
{{#each .}}
	<tr>
		<td>{{NM}}</td>
		<td>{{BIRTHDAY}}</td>
		<td>{{ORGANIZATION}}</td>
		<td>{{POSITION}}</td>
		<td>
			{{EDU_SUPORT_AREAS}}
		</td>
		<td>
			<input type="hidden" name="appliSeq" value="{{APPLI_SEQ}}">
			{{#ifeq APPL_STAT "Y"}}승인됨{{/ifeq}}
			{{#ifnoteq APPL_STAT "Y"}}
			<label class="input col">
				<button class="btn btn-primary ml2 approveBtn" type="button">
					<i class="fa fa-edit" title="초기화"></i> 승인
				</button>
			</label>
			{{/ifnoteq}}
		</td>
		<td>
			{{#ifeq APPL_STAT "N"}}
			<input type="hidden" name="applStatDetail" value="{{APPL_STAT_DETAIL}}">
			<label class="input col">
				<button class="btn btn-default ml2 rejecteDetailBtn" type="button">
					<i class="fa fa-edit" title="초기화"></i> 반려됨
				</button>
			</label>
			{{/ifeq}}
			{{#ifnoteq APPL_STAT "N"}}
			<label class="input col">
				<button class="btn btn-danger ml2 rejecteBtn" type="button">
					<i class="fa fa-edit" title="초기화"></i> 반려
				</button>
			</label>
			{{/ifnoteq}}
		</td>
	</tr>
{{/each}}
{{else}}
	<tr class="noData">                           
		<td colspan="7">신청자가 없습니다.</td>             
	</tr>
{{/if}}
</script>