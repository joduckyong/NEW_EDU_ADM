 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">
$(function(){
    var baseInfo = {
            insertKey : "${common.baseType[0].key() }",
            updateKey : "${common.baseType[1].key() }",
            deleteKey : "${common.baseType[2].key() }",
            lUrl : "/ncts/mngr/common/selectEduMemberDetailPopup.do",
            pop01 : "/ncts/mngr/userMngr/mngrFileConfirmListPopup.do",
            notePop : "/ncts/mngr/userMngr/mngrMemberNoteListPopup.do",
            pop02 : "/ncts/mngr/instrctrMngr/mngrInstrctrStatusListPopup.do",
    }
    
    $.dataDetail = function(){
    	var pageType = "${result.INSTRCTR_DETAIL_GRADE_CD}" != "99" ? "INSTRCTR" : "";
    	var aUrl = pageType == "INSTRCTR" ? "/ncts/mngr/instrctrMngr/mngrInstrctrDetail.do" : "/ncts/mngr/userMngr/mngrMemberDetail.do";
    	
        $.ajax({
            type: 'POST',
            url: aUrl,
            data: $("#sForm").serialize(),
            dataType: "json",
            success: function(data) {
                if(data.success == "success"){
                	var courses = "";
                	var $template = pageType == "INSTRCTR" ? $("#instrctr-detail-template") : $("#detail-template");
                	
                    if(pageType == "INSTRCTR") {
	                    var modifiedData = {};
	                    data.status.forEach(function(obj, idx){
	                    	modifiedData[obj.INSTRCTR_GUBUN+"_INSTRCTR_RESULT"] = obj.STATUS_GUBUN;
	                    })
	                    for(key in modifiedData) {
	                    	if(data.de.hasOwnProperty(key)) {
	        					data.de[key] = modifiedData[key];
	        				}
	                    }                    	
                    }                   
                    $(".tab-content").show();
                    $("#detailTable").handlerbarsCompile($template, data.de);
                    $("#seTable").handlerbarsCompile($("#se-template"), data.se);
                    $("#seTable").handlerbarsAppendCompile($("#video-se-template"), data.seVideo);
                    
        	        $("#fileConfirmBtn").fileConfirmBtnOnClickEvt();
        	        $("#confirmDetailBtn").confirmDetailBtnOnClickEvt();
        	        $("#changeDetailBtn").changeDetailBtnOnClickEvt();
        	        
                    if($("#courses").val() == '') courses = "#coursesEtc";
                    else courses = "#courses"+$("#courses").val();
                    $(courses).closest("ul").find("li").removeClass("active");
                    $(courses).closest("li").addClass("active");
                    
                    $.noteDataOnSettings(data);
                    $(".instrctrSelect").instrctrSelectOnChangeEvt(baseInfo.updateKey, document.sForm.userNo.value);
                    $(".instrctrInput").instrctrInputOnChangeEvt(baseInfo.updateKey, document.sForm.userNo.value);
                    $.instrctrDetailViewOnSettings($("input[name='loginUserId']").val());
                    $("#packageAuthAt").packageAuthAtOnChangeEvt(baseInfo.updateKey, document.sForm.userNo.value);
                    $.instrctrResultBackgroundOnSettings();
                    $(".notePopBtn").notePopBtnOnClickEvt();
                    $(".instrctrResult").instrctrResultOnChangeEvt(baseInfo.insertKey, document.sForm.userNo.value);
                    
                    if($("input[name='deptAllAuthorAt']").val() == "N" && "${param.excpAt}" != "Y") $("#fileConfirmBtn").prop("disabled", true);
                    
                    $(".inputcal").each(function(){$(this).userDatePicker({yearRange : '1900:'+currentYear});});
                }
            }
        })
    }
    
    $.searchAction = function(){
        var no = 1;
        
        if(typeof(arguments[0]) != "undefined") no = arguments[0].pageNo;
        with(document.sForm){
            currentPageNo.value = no;
            action = baseInfo.lUrl;
            target='';
            submit();
        }
    }
    
    $.fn.liOnClickEvt = function(){
    	var _this = $(this);
    	_this.on("click", function(){
    		var $this = $(this);
    		var id = $this.attr("id").replace("courses", "");
    		var courses = id == "Etc" ? '' : id;   		
    		
    		document.sForm.courses.value = courses;
    		$.dataDetail();
    	})
    }
    
    $.fn.fileConfirmBtnOnClickEvt = function(){
    	$(this).on("click", function(){
    		var $this = $(this);
    		var fileConfirmAt = $this.data("confirmAt");
    		
    		if(fileConfirmAt == "Y") fileConfirmAt = "N";
    		else fileConfirmAt = "Y";
    		
    		document.sForm.fileConfirmAt.value = fileConfirmAt;
    		document.sForm.procType.value = baseInfo.updateKey;
    		
    		$.ajax({
                type: 'POST',
                url: "/ncts/mngr/userMngr/fileConfirmProcess.do",
                data: $("#sForm").serialize(),
                dataType: "json",
                success: function(data) {
                	alert(data.msg);
                    if(data.success == "success"){
                    	$.dataDetail($("#userNo").val());
                    }
                }
            });
    	})
    }
    
    $.fn.confirmDetailBtnOnClickEvt = function(){
    	$(this).on("click", function(){
    		var $this = $(this);
    		
    		$.popAction.width = 1200;
			$.popAction.height = 600;
			$.popAction.target = "selectFileConfirmListPopup";
			$.popAction.url = baseInfo.pop01;
			$.popAction.form = document.sForm;
			$.popAction.init();
    	})
    }
    
    $.fn.notePopBtnOnClickEvt = function(){
    	$(this).on("click", function(){
    		var $this = $(this);
    		
    		$.popAction.width = 1200;
			$.popAction.height = 600;
			$.popAction.target = "selectMemberNoteListPopup";
			$.popAction.url = baseInfo.notePop;
			$.popAction.form = document.sForm;
			$.popAction.init();
    	})
    }	    
    
    $.fn.changeDetailBtnOnClickEvt = function(){
    	$(this).on("click", function(){
    		var $this = $(this);
    		
    		$.popAction.width = 1200;
			$.popAction.height = 600;
			$.popAction.target = "mngrInstrctrStatusListPopup";
			$.popAction.url = baseInfo.pop02;
			$.popAction.form = document.sForm;
			$.popAction.init();
    	})
    }    
    
    $.initView = function(){
    	$.dataDetail();
        $("#searchBtn").searchBtnOnClickEvt($.searchAction);
        $("#isueList li a").liOnClickEvt();
        
        $("input[name='searchKeyword1']").keypress(function(e){if(e.keyCode == 13)  $.searchAction();});
        
        $(document).on("click",".fileDown", function(){
        	var url = $(this).prev(".fileView").find(".file_wrap");
        	
        	if(url.length == 0) alert("업로드 된 파일이 없습니다.");
        	else {
        		url = url.find("a").prop("href");
        		location.href = url;
        	}
        });    
        
        $("body").on("click", ".reportDown", function(){
        	var $this = $(this);
	        document.ubiForm.userNo.value = $this.data("userNo");
	        document.ubiForm.jrf.value = $this.data("jrf");
            popUbiReport();
        });        
    }
    
    $.initView();
})
</script>
		
<form id="ubiForm" name="ubiForm" method="post">
    <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
    <input type="hidden" id="ubi_jrt" name="jrf" value="" />
    <input type="hidden" name="userNo" value="" />
</form>
		
<!-- MAIN CONTENT -->
<div id="content" class="popPage">
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<form name="sForm" id="sForm" method="post">
        	<input type="hidden" name="userNo" id="userNo" value="${param.userNo }">
        	<input type="hidden" name="courses" id="courses" value="${result.INSTRCTR_DETAIL_GRADE_CD eq '99' ? '00' : '04' }">
            <input type="hidden" name="fileConfirmAt" id="fileConfirmAt" value="">
            <input type="hidden" name="searchCondition2" id="searchCondition2" value="${param.searchCondition2 }">
            <input type="hidden" name="loginUserId" value="<sec:authentication property="principal.userId"/>" >
            <input type="hidden" name="deptAllAuthorAt" value="<sec:authentication property="principal.deptAllAuthorAt"/>">
            <input type="hidden" name="excpAt" value="${param.excpAt }">
            <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
        </form>
		<!-- Search 영역 끝 -->
		
		<form method="post" name="nForm" id="nForm">
			<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
			<input type="hidden" name="userNo" value="" >
			<input type="hidden" name="pfatGradeCd" value="" >
			<input type="hidden" name="sprtGradeCd" value="" >
			<input type="hidden" name="pmptGradeCd" value="" >			
			<input type="hidden" name="mpgtGradeCd" value="" >		
			<input type="hidden" name="packageAuthAt" value="" >
			<input type="hidden" name="instrctrGubun" value="" >	
			<input type="hidden" name="orgInstrctrStatus" value="">
			<input type="hidden" name="instrctrStatus" value="" >
			<input type="hidden" name="pfatInstrctrEntrstDe" value="">
			<input type="hidden" name="sprtInstrctrEntrstDe" value="">
			<input type="hidden" name="pmptInstrctrEntrstDe" value="">
			<input type="hidden" name="mpgtInstrctrEntrstDe" value="">
			
			<div class="dim-layer" style="display: none;">
        		<div class="dimBg"></div>			
				<div id="layer2" class="popup-con" style="width:300px;">
					<div class="close_box fClr" style="margin: 0 0 20px 0;"></div>
					<div class="file_box">
						<p class="tit">저장되었습니다.</p>
					</div>
					<button type="button" class="closeBtn" style="margin: 10px 0;">확인</button>
				</div>			
			</div>				
		</form>			
		
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<table class="table table-bordered tb_type03">
						<c:choose>
							<c:when test="${result.INSTRCTR_DETAIL_GRADE_CD eq '99' }">
								<colgroup class="member">
									<col width="10%">
									<col width="23.2%">
									<col width="10.2%">
									<col width="23%">
									<col width="10%">
									<col width="23.2%">
								</colgroup>
							</c:when>
							<c:otherwise>
								<colgroup class="instrctr">
									<col width="10.5%">
									<col width="22%">
									<col width="10.5%">
									<col width="15%">
									<col width="10.5%">
									<col width="8.5%">
									<col width="23%">
								</colgroup>
							</c:otherwise>
						</c:choose>
						<tbody id="detailTable">
							<tr><td colspan="6" class="textAlignCenter">항목을 선택해주세요.</td></tr>
						</tbody>
					</table>
					
					<table class="table table-bordered table-hover tb_type01">
						<div class="wp12">
						  <span class="col mt7 mr5 ml15"><b>P:이수, T:시간부족, F:미이수</b></span>
						</div>
						
						<div class="tab-content" style="display:none;">
							<div class="jarviswidget-sortable active" id="isueList">
								<ul class="nav nav-tabs" style="min-width:100%;">
									<c:choose>
										<c:when test="${result.INSTRCTR_DETAIL_GRADE_CD eq '99' }">
											<li class="active"><a href="javascript:void(0);" id="courses00">일반</a></li>
											<li><a href="javascript:void(0);" id="courses01">초급</a></li>
											<li><a href="javascript:void(0);" id="courses02">중급</a></li>
											<li><a href="javascript:void(0);" id="courses03">고급</a></li>
											<li><a href="javascript:void(0);" id="courses04">강사</a></li>
											<li><a href="javascript:void(0);" id="courses10">직무</a></li>
											<li><a href="javascript:void(0);" id="courses07">기타</a></li>
											<li><a href="javascript:void(0);" id="coursesEtc">미선택</a></li>
										</c:when>
										<c:otherwise>
											<li class="active"><a href="javascript:void(0);" id="courses04">강사</a></li>
											<li><a href="javascript:void(0);" id="courses00">일반</a></li>
											<li><a href="javascript:void(0);" id="courses01">초급</a></li>
											<li><a href="javascript:void(0);" id="courses02">중급</a></li>
											<li><a href="javascript:void(0);" id="courses03">고급</a></li>
											<li><a href="javascript:void(0);" id="courses10">직무</a></li>
											<li><a href="javascript:void(0);" id="courses07">기타</a></li>
											<li><a href="javascript:void(0);" id="coursesEtc">미선택</a></li>										
										</c:otherwise>
									</c:choose>
								</ul>
							</div>
						</div>
						<colgroup>
							<col width="28%">
							<col width="22%">
							<col width="28%">
							<col width="22%">
							<col width="28%">
							<col width="22%">
						</colgroup>
						<tbody id="seTable">
						</tbody>
					</table>
				</article>
			</div>
			<!-- row 메뉴조회 끝 -->
		</div>
		
	</section>
	<!-- widget grid end -->
	
</div>
<!-- END MAIN CONTENT -->

<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/memberNotePopup.jsp" flush="false" />
<script id="detail-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">아이디</th>
	<td>{{USER_ID}}</td>
	<th scope="row">이메일</th>
	<td colspan="3">{{USER_EMAIL}}</td>
</tr>
<tr>
	<th scope="row">회원등급</th>
	<td>{{GRADE_CD_NM}}</td>
	<th scope="row">세부등급 </th>
	<td colspan="3">{{DETAIL_GRADE_CD_NM}}</td>
</tr>
<tr>
	<th scope="row">이름</th>
	<td>{{USER_NM}}</td>
    <th scope="row">생년월일</th>
    <td colspan = "3">{{USER_BIRTH_YMD}}</td>
</tr>
<tr>
	<th scope="row">학위</th>
	<td>{{ACADEMIC_DEGREE_CD_NM}}</td>
    <th scope="row">전화번호</th>
    <td colspan = "3">{{USER_HP_NO}}</td>
</tr>
<tr>
	<th scope="row">학과</th>
	<td>{{DEPARTMENT_NM}}</td>
    <th scope="row">전공</th>
    <td colspan = "3">{{MAJOR_NM}}</td>
</tr>
<tr>
	<th scope="row">졸업여부 </th>
	<td >{{GRADUATION_CD_NM}}</td>
    <th scope="row">졸업(예정)일</th>
    <td colspan = "3">{{GRADUATION_YMD}}</td>
</tr>
<tr>
    <th scope="row">현재소속 </th>
    <td >{{CURRENT_JOB_NM}}</td>
    <th scope="row">
		자격증
		<button type="button" class="btn btn-default ml2 mb5" id="confirmDetailBtn">
    		<i class="fa fa-search" title="변경내역"></i>변경내역
		</button>

	</th>
    <td colspan = "3">
		{{LICENSE_NM}}
		<br>
		<div class="fileView" style="display:none;">
			{{safe fileView}}
		</div>
		<button type="button" class="btn btn-default ml2 mb5 fileDown" id="">
			<i class="fa fa-print" title="첨부파일 down"></i> 첨부파일 down
		</button>
		<button type="button" class="btn ml2 {{#ifeq FILE_CONFIRM_AT 'Y'}}btn-primary{{else}}btn-danger{{/ifeq}}" id="fileConfirmBtn" data-confirm-at="{{FILE_CONFIRM_AT}}" >
			<i title="확인버튼"></i> {{#ifeq FILE_CONFIRM_AT 'Y'}}확인{{else}}미확인{{/ifeq}}
		</button>
		<br>
		{{#notempty FILE_CONFIRM_PNTTM}}({{FILE_CONFIRM_NM}}, {{FILE_CONFIRM_PNTTM}}){{/notempty}}
	</td>
</tr>

<tr>
    <th scope="row">가입일시</th>
    <td >{{FRST_REGIST_PNTTM}}</td>
	<th scope="row">개인정보<br>동의여부</th>
    <td>
		{{PRIVACY_AGREE_AT}}
		{{#ifeq PRIVACY_AGREE_AT 'Y'}}
			<button class="btn btn-default ml2 mb5 reportDown" type="button" data-user-no="{{USER_NO}}" data-jrf="USER_AGREEMENT.jrf" ><i class="fa fa-edit" title="리포트 출력"></i> 동의서</button>
		{{/ifeq}}
	</td>
	<th scope="row">본인인증<br>여부</th>
    <td>{{CRTFC_AT}}{{#ifeq CRTFC_AT 'Y'}}({{DI_INSERT_DE}}){{/ifeq}}</td>
</tr>

<tr>
	<th scope="row">직무자격<br>활성화</th>
	<td colspan="6">
		<label class="select col w150 mr5">
			<select id="packageAuthAt" name="packageAuthAt">
           		<option value="N" {{#ifeq PACKAGE_AUTH_AT 'N'}}selected{{/ifeq}}>N</option>
           		<option value="Y" {{#ifeq PACKAGE_AUTH_AT 'Y'}}selected{{/ifeq}}>Y</option>
			</select> <i></i>
		</label>
	</td>
</tr>
</script>

<script id="instrctr-detail-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">아이디</th>
	<td>{{USER_ID}}</td>
	<th scope="row">이메일</th>
	<td colspan="4">{{USER_EMAIL}}</td>
</tr>
<tr>
	<th scope="row" rowspan="4">회원등급</th>
	<td rowspan="4">{{GRADE_CD_NM}}</td>
	<th scope="row" rowspan="4">세부등급 </th>
	<td rowspan="4">{{DETAIL_GRADE_CD_NM}} <br>/ {{INSTRCTR_DETAIL_GRADE_CD_NM}}</td>
	<th scope="row" rowspan="4">
		강사등급
		<button type="button" class="btn btn-default ml2 mb5" id="changeDetailBtn">
    		<i class="fa fa-search" title="변경내역"></i>변경내역
		</button> 
	</th>
	<th scope="row">PFA</th>
	<td>
		<label class="select col w150 mr5" style="display:inline;">
			<select id="pfatGradeCd" name="pfatGradeCd" class="instrctrSelect">
           		<option value="">해당없음</option>
                	<c:forEach var="list" items="${codeMap.DMH24 }" varStatus="idx">
                    	<option value="${list.CODE }">
	                    	${list.CODE_NM}
                        </option>
               	 	</c:forEach>    
			</select> <i></i>
		</label>
		{{#ifeq PFAT_GRADE_CD '01'}}
			<label class="select col w100 mr5" style="display:inline;">
				<select id="pfatInstrctrResult" class="instrctrResult" data-result="{{PFAT_INSTRCTR_RESULT}}" data-gubun="PFAT" disabled>
                	<c:forEach var="list" items="${codeMap.DMH30 }" varStatus="idx">
						<c:if test="${list.CODE ne '00'}">
							<option value="${list.CODE}" data-change-at="${list.CODE eq '02' or list.CODE eq '03' ? 'Y' : ''}" data-other="${list.CODE eq '99' ? 'Y' : ''}">${list.CODE_NM}</option>
						</c:if>
               	 	</c:forEach> 
				</select>
			</label>
		{{/ifeq}}
		{{#ifeq PFAT_GRADE_CD '00'}}
   		<label class="input col w70" style="line-height: 12px;font-size: 12px; vertical-align: middle;">위촉일자
			{{#notnull PFAT_INSTRCTR_ENTRST_DE}}
     	    	<input type="text" class="inputcal instrctrInput instrctrInput1" value="{{PFAT_INSTRCTR_ENTRST_DE}}" id="pfatInstrctrEntrstDe" name="pfatInstrctrEntrstDe" data-name="pfatInstrctrEntrstDe" placeholder="YYYY-MM-DD" size=10 style="border: none; background: transparent; margin-left: -2px;">
			{{/notnull}}
		</label>
	{{/ifeq}}	
	</td>
</tr>
<tr>
	<th scope="row">SPR</th>
	<td>
		<label class="select col w150 mr5" style="display:inline;">
			<select id="sprtGradeCd" name="sprtGradeCd" class="instrctrSelect">
           		<option value="">해당없음</option>
                	<c:forEach var="list" items="${codeMap.DMH24 }" varStatus="idx">
                    	<option value="${list.CODE }">
	                    	${list.CODE_NM}
                        </option>
               	 	</c:forEach>  
			</select> <i></i>
		</label>
		{{#ifeq SPRT_GRADE_CD '01'}}
			<label class="select col w100 mr5" style="display:inline;">
				<select id="sprtInstrctrResult" class="instrctrResult" data-result="{{SPRT_INSTRCTR_RESULT}}" data-gubun="SPRT" disabled>
                	<c:forEach var="list" items="${codeMap.DMH30 }" varStatus="idx">
						<c:if test="${list.CODE ne '00'}">
							<option value="${list.CODE}" data-change-at="${list.CODE eq '02' or list.CODE eq '03' ? 'Y' : ''}" data-other="${list.CODE eq '99' ? 'Y' : ''}">${list.CODE_NM}</option>
						</c:if>
               	 	</c:forEach> 
				</select>
			</label>
		{{/ifeq}}
		{{#ifeq SPRT_GRADE_CD '00'}}
   			<label class="input col w70" style="line-height: 12px;font-size: 12px; vertical-align: middle;">위촉일자
   				{{#notnull SPRT_INSTRCTR_ENTRST_DE}}
     	    		<input type="text" class="inputcal instrctrInput instrctrInput2" value="{{SPRT_INSTRCTR_ENTRST_DE}}" id="sprtInstrctrEntrstDe" name="sprtInstrctrEntrstDe" data-name="sprtInstrctrEntrstDe" placeholder="YYYY-MM-DD" size=10 style="border: none; background: transparent; margin-left: -2px;">
				{{/notnull}}
			</label>
		{{/ifeq}}
	</td>
</tr>
<tr>
	<th scope="row">PM+</th>
	<td>
		<label class="select col w150 mr5" style="display:inline;">
			<select id="pmptGradeCd" name="pmptGradeCd" class="instrctrSelect">
           		<option value="">해당없음</option>
                	<c:forEach var="list" items="${codeMap.DMH24 }" varStatus="idx">
                    	<option value="${list.CODE }">
	                    	${list.CODE_NM}
                        </option>
               	 	</c:forEach>  
			</select> <i></i>
		</label>
		{{#ifeq PMPT_GRADE_CD '01'}}
			<label class="select col w100 mr5" style="display:inline;">
				<select id="pmptInstrctrResult" class="instrctrResult" data-result="{{PMPT_INSTRCTR_RESULT}}" data-gubun="PMPT" disabled>
                	<c:forEach var="list" items="${codeMap.DMH30 }" varStatus="idx">
						<c:if test="${list.CODE ne '00'}">
							<option value="${list.CODE}" data-change-at="${list.CODE eq '02' or list.CODE eq '03' ? 'Y' : ''}" data-other="${list.CODE eq '99' ? 'Y' : ''}">${list.CODE_NM}</option>
						</c:if>
               	 	</c:forEach> 
				</select>
			</label>
		{{/ifeq}}
		{{#ifeq PMPT_GRADE_CD '00'}}
   			<label class="input col w70" style="line-height: 12px;font-size: 12px; vertical-align: middle;">위촉일자
				{{#notnull PMPT_INSTRCTR_ENTRST_DE}}
     	        	<input type="text" class="inputcal instrctrInput instrctrInput3" value="{{PMPT_INSTRCTR_ENTRST_DE}}" id="pmptInstrctrEntrstDe" name="pmptInstrctrEntrstDe" data-name="pmptInstrctrEntrstDe" placeholder="YYYY-MM-DD" size=10 style="border: none; background: transparent; margin-left: -2px;">
				{{/notnull}}
			</label>
		{{/ifeq}}
	</td>
</tr>
<tr>
	<th scope="row">MPG</th>
	<td>
		<label class="select col w150 mr5" style="display:inline;">
			<select id="mpgtGradeCd" name="mpgtGradeCd" class="instrctrSelect">
           		<option value="">해당없음</option>
                	<c:forEach var="list" items="${codeMap.DMH24 }" varStatus="idx">
                    	<option value="${list.CODE }">
	                    	${list.CODE_NM}
                        </option>
               	 	</c:forEach>  
			</select> <i></i>
		</label>
		{{#ifeq MPGT_GRADE_CD '01'}}
			<label class="select col w100 mr5" style="display:inline;">
				<select id="mpgtInstrctrResult" class="instrctrResult" data-result="{{MPGT_INSTRCTR_RESULT}}" data-gubun="MPGT" disabled>
                	<c:forEach var="list" items="${codeMap.DMH30 }" varStatus="idx">
						<c:if test="${list.CODE ne '00'}">
							<option value="${list.CODE}" data-change-at="${list.CODE eq '02' or list.CODE eq '03' ? 'Y' : ''}" data-other="${list.CODE eq '99' ? 'Y' : ''}">${list.CODE_NM}</option>
						</c:if>
               	 	</c:forEach> 
				</select>
			</label>
		{{/ifeq}}
		{{#ifeq MPGT_GRADE_CD '00'}}
   			<label class="input col w70" style="line-height: 12px;font-size: 12px; vertical-align: middle;">위촉일자
				{{#notnull MPGT_INSTRCTR_ENTRST_DE}}
					<input type="text" class="inputcal instrctrInput instrctrInput4" value="{{MPGT_INSTRCTR_ENTRST_DE}}" id="mpgtInstrctrEntrstDe" name="mpgtInstrctrEntrstDe" data-name="mpgtInstrctrEntrstDe" placeholder="YYYY-MM-DD" size=10 style="border: none; background: transparent; margin-left: -2px;">
				{{/notnull}}
   			</label>
		{{/ifeq}}	
	</td>
</tr>
<tr>
	<th scope="row">이름</th>
	<td>{{USER_NM}}</td>
    <th scope="row">생년월일</th>
    <td>{{USER_BIRTH_YMD}}</td>
	<th scope="row">상태</th>
	<td colspan="2">
		<button type="button" class="btn btn-default ml2 mb5 notePopBtn" {{#iflt 0 NOTE_CNT}}style="background: yellow;"{{/iflt}}>
			<i class="fa fa-sticky-note-o"></i>
		</button>
		<span class="fw ml5">메모 {{NOTE_CNT}}건</span>
	</td>
</tr>
<tr>
	<th scope="row">학위</th>
	<td>{{ACADEMIC_DEGREE_CD_NM}}</td>
    <th scope="row">전화번호</th>
    <td colspan = "4">{{USER_HP_NO}}</td>
</tr>
<tr>
	<th scope="row">학과</th>
	<td>{{DEPARTMENT_NM}}</td>
    <th scope="row">전공</th>
    <td colspan = "4">{{MAJOR_NM}}</td>
</tr>
<tr>
	<th scope="row">졸업여부 </th>
	<td >{{GRADUATION_CD_NM}}</td>
    <th scope="row">졸업(예정)일</th>
    <td colspan = "4">{{GRADUATION_YMD}}</td>
</tr>
<tr>
    <th scope="row">현재소속 </th>
    <td >{{CURRENT_JOB_NM}}</td>
    <th scope="row">
		자격증
		<button type="button" class="btn btn-default ml2 mb5" id="confirmDetailBtn">
    		<i class="fa fa-search" title="변경내역"></i>변경내역
		</button>

	</th>
    <td colspan = "4">
		{{LICENSE_NM}}
		<br>
		<div class="fileView" style="display:none;">
			{{safe fileView}}
		</div>
		<button type="button" class="btn btn-default ml2 mb5 fileDown" id="">
			<i class="fa fa-print" title="첨부파일 down"></i> 첨부파일 down
		</button>
		<button type="button" class="btn ml2 {{#ifeq FILE_CONFIRM_AT 'Y'}}btn-primary{{else}}btn-danger{{/ifeq}}" id="fileConfirmBtn" data-confirm-at="{{FILE_CONFIRM_AT}}">
			<i title="확인버튼"></i> {{#ifeq FILE_CONFIRM_AT 'Y'}}확인{{else}}미확인{{/ifeq}}
		</button>
		<br>
		{{#notempty FILE_CONFIRM_PNTTM}}({{FILE_CONFIRM_NM}}, {{FILE_CONFIRM_PNTTM}}){{/notempty}}
	</td>
</tr>

<tr>
    <th scope="row">가입일시</th>
    <td >{{FRST_REGIST_PNTTM}}</td>
	<th scope="row">개인정보<br>동의여부</th>
    <td>
		{{PRIVACY_AGREE_AT}}
		{{#ifeq PRIVACY_AGREE_AT 'Y'}}
			<button class="btn btn-default ml2 mb5 reportDown" type="button" data-user-no="{{USER_NO}}" data-jrf="USER_AGREEMENT.jrf"><i class="fa fa-edit" title="리포트 출력"></i> 동의서</button>
		{{/ifeq}}
	</td>
	<th scope="row">본인인증<br>여부</th>
    <td colspan="2">{{CRTFC_AT}}{{#ifeq CRTFC_AT 'Y'}}({{DI_INSERT_DE}}){{/ifeq}}</td>
</tr>

<tr>
	<th scope="row">직무자격<br>활성화</th>
	<td colspan="6">
		<label class="select col w150 mr5">
			<select id="packageAuthAt" name="packageAuthAt">
           		<option value="N" {{#ifeq PACKAGE_AUTH_AT 'N'}}selected{{/ifeq}}>N</option>
           		<option value="Y" {{#ifeq PACKAGE_AUTH_AT 'Y'}}selected{{/ifeq}}>Y</option>
			</select> <i></i>
		</label>
	</td>
</tr>
</script>

<script id="se-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">기준강의명</th>
	<th scope="row">수강여부</th>
    <th scope="row">기준강의명</th>
    <th scope="row">수강여부</th>
</tr>

{{#if .}}
{{#each .}}
<tr>
    <!-- <td bgcolor={{#ifnoteq ACTIVE_YN1 'Y'}}"#d2c0a4"{{/ifnoteq}}>{{CERT_CD1}}</td> -->
	<td bgcolor={{#ifnoteq ACTIVE_YN1 'Y'}}"#d2c0a4"{{/ifnoteq}}>{{LECTURE_NM1}}</td>
    <td>{{CERT_COMPLETED_CD1}}</td>
    <!-- <td bgcolor={{#ifnoteq CERT_CD2 ''}}{{#ifnoteq ACTIVE_YN2 'Y'}}"#d2c0a4"{{/ifnoteq}}{{/ifnoteq}}>{{CERT_CD2}}</td> -->
    <td bgcolor={{#ifnoteq CERT_CD2 ''}}{{#ifnoteq ACTIVE_YN2 'Y'}}"#d2c0a4"{{/ifnoteq}}{{/ifnoteq}}>{{LECTURE_NM2}}</td>
    <td>{{CERT_COMPLETED_CD2}}</td>
</tr>
{{/each}}
{{else}}
    <tr class="noData">                           
        <td colspan="4">데이터가 없습니다.</td>             
    </tr>
{{/if}}

</script>
<script id="video-se-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">동영상 교육명</th>
	<th scope="row">수강여부</th>
    <th scope="row">동영상 교육명</th>
    <th scope="row">수강여부</th>
</tr>

{{#if .}}
{{#each .}}
<tr>
    <td>{{LECTURE_ID1}}</td>
    <td>{{PASS_CD1}}</td>
    <td>{{LECTURE_ID2}}</td>
    <td>{{PASS_CD2}}</td>
</tr>
{{/each}}
{{else}}
    <tr class="noData">                           
        <td colspan="4">데이터가 없습니다.</td>             
    </tr>
{{/if}}

</script>