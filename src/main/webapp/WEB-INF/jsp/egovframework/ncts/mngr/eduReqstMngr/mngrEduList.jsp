<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

$(function(){
	var baseInfo = {
			insertKey : "${common.baseType[0].key() }",
			updateKey : "${common.baseType[1].key() }",
			deleteKey : "${common.baseType[2].key() }",
			lUrl : "/ncts/mngr/eduReqstMngr/mngrEduList.do",
			fUrl : "/ncts/mngr/eduReqstMngr/mngrEduForm.do",
			dUrl : "/ncts/mngr/eduReqstMngr/mngrDeleteEdu.do"
	}
	
	$.dataDetail = function(index){
		if($.isNullStr(index)) return false;
		document.sForm.eduSeq.value = index;
		$.ajax({
			type: 'POST',
			url: "/ncts/mngr/eduReqstMngr/selectMngrEduDetail.do",
			data: $("#sForm").serialize(),
			dataType: "json",
			success: function(data) {
				if(data.success == "success"){
					document.ubiForm.actStatus.value = data.rs.INSTRCTR_ACT_STATUS;
					data.rs.EDU_NM = data.rs.EDU_NM.replace(/&apos;/g, "'").replace(/&quot;/g,'"').replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">");
					$("#detailTable").handlerbarsCompile($("#detail-template"), data.rs);
					$("#applicantTable").handlerbarsCompile($("#applicant-template"), data.rsList);
				}
			}
		})
	}
	
	$.fn.procBtnOnClickEvt = function(url, key){
		var _this = $(this);
		_this.on("click", function(){
			if(baseInfo.insertKey != key){
				if($("input.index:checked").size() <= 0) {
					alert("항목을 선택하시기 바랍니다.");
					return false;
				}else{
					document.sForm.eduSeq.value = $("input.index:checked").val();
				} 
			}else{
				document.sForm.eduSeq.value = "";
			}
			
			if(baseInfo.deleteKey == key){
				$.delAction(url, key);
			}else{
				$.procAction(url, key);	
			}
		})
	}
	
	$.procAction = function(pUrl, pKey){
		with(document.sForm){
			procType.value = pKey;
			action = pUrl;
			target='';
			submit();
		}
	}
	
	$.delAction = function(pUrl, pKey){
		if(!confirm("삭제하시겠습니까?")) return false;
		document.sForm.procType.value = pKey;
		$.ajax({
			type: 'POST',
			url: pUrl,
			data: $("#sForm").serialize(),
			dataType: "json",
			success: function(data) {
				alert(data.msg);
				if(data.success == "success"){
					$.searchAction();
				}
			}
		});
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
	
	$.fn.ubiFormBtnOnClickEvt = function(){
		var _this = $(this);
		_this.on("click", function(){
			var $this = $(this);
			if($("input[name='actStatus']").val() == "Y") {
				document.ubiForm.reqstSeq.value = $("input.index:checked").val();
				popUbiReport();
			} else {
				alert("작성된 강사 보고서가 없습니다.");
			}
		})
	}
	
	$.instrctrOthbcYn = function(val){
    	var msg;
    	
	    if("Y" == val){
	    	msg = "강사모집을 공개하시겠습니까?";
	    } else if("N" == val){
	    	msg = "강사모집을 비공개하시겠습니까?";
	    }
	    
    	if(!confirm(msg))return false;
    	 
        $.ajax({
        	type: 'POST',
            url: "/ncts/mngr/eduReqstMngr/updateInstrctrOthbcYnProcess.do",
            data			: {
				"eduSeq" : $("#eduSeq").val(),
				"procType" : baseInfo.updateKey,
				"instrctrOthbcYn" : val,
				"${_csrf.parameterName}" : "${_csrf.token}"
			},
            dataType: "json",
            success: function(data) {
            	alert(data.msg);
                if(data.success == "success"){
                	$.searchAction();
                }
            }
        });  
    }
	
	$.initView = function(){
		$.onClickTableTr();
		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
		$("#saveBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.insertKey);
		$("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
		$("#delBtn").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey);
		$(".reportDown").ubiFormBtnOnClickEvt();
		$(document).on("click", "button[name=instrctrOthbcYn]", function(){
        	var _this = $(this);
        	$.instrctrOthbcYn(_this.data("instrctrOthbc"));
        });
	}
	
	$.initView();
})
</script>

		
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/ribbon.jsp" flush="false" />
<form id="ubiForm" name="ubiForm" method="post">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
	<input type="hidden" id="ubi_jrt" name="jrf" value="INSTRCTR_R001.jrf" />
	<input type="hidden" name="reqstSeq" value="" />
	<input type="hidden" name="actStatus" value="" />
	<input type="hidden" name="eduDivision" value="01" />
</form>

<!-- MAIN CONTENT -->
<div id="content">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/menuTitle.jsp" flush="false" />	
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
				<input type="hidden" name="eduSeq" id="eduSeq"  value="">
				<input type="hidden" name="eduDivision" id="eduDivision" value="01">
				<div class="fL wp50">
					<ul class="searchAreaBox">
						<li class="smart-form">
						    <label class="label">센터명</label>
						</li>
						<sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')">
							<li class="w150 mr5">
								<select name="centerCd" class="form-control">
									<option value="">전체</option>
									<c:forEach var="center" items="${centerList }" varStatus="idx">
										<option value="${center.DEPT_CD }" data-groupId="${center.GROUP_ID }" ${center.DEPT_CD eq param.centerCd ? 'selected="selected"':'' } >${center.DEPT_NM }</option>
									</c:forEach>
								</select> <i></i>
							</li>
						</sec:authorize>
						<sec:authorize access="hasRole('ROLE_ADMIN') or hasRole('ROLE_USER')">
							<li class="smart-form mr5">
								<input type="hidden" name="centerCd" value="<sec:authentication property="principal.centerId"/>" >
								<label class="label"><sec:authentication property="principal.centerNm"/></label>
							</li>
						</sec:authorize>
						
						<li class="smart-form">
						    <label class="label">교육명</label>
						</li>
						<li class="w150 mr5">
							<input type="text" id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'>
						</li>
						<li class="smart-form">
						    <label class="label">교육과정</label>
						</li>
						
						<li class="w150 mr5">    
							<select name="searchCondition1" class="form-control">
								<option value="">전체</option>
					    		<c:forEach var="list" items="${codeMap.DMH14 }" varStatus="idx">
									<c:if test="${list.CODE eq '01' or list.CODE eq '02' or list.CODE eq '03' or list.CODE eq '04' or list.CODE eq '07' or list.CODE eq '11'}">
										<option value="${list.CODE }" ${param.searchCondition1 eq list.CODE ? 'selected="selected"' :'' }>${list.CODE_NM }
									</c:if>
								</c:forEach>
							</select> <i></i>
						</li>
						
						<li class="ml10">
							<button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
						</li>
						
					</ul>
				</div>

				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
					<jsp:param value="list"     name="formType"/>
					<jsp:param value="2,3,4"     name="buttonYn"/>
				</jsp:include>
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
                 
			</form>
		</div>
		<!-- Search 영역 끝 -->
	
		<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />
		
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-6">
					<table class="table table-bordered tb_type01 listtable">
						<colgroup>
							<col width="10%">
							<col width="25%">
							<col width="15%">
                            <col width="20%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>센터</th>
								<th>교육명</th>
								<th>교육일시</th>
								<th>교육대상</th>
								<th>신청인원</th>
								<th>교육인원</th>
								<th>작성일</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty rslist }">
								<tr ><td colspan="7">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${rslist }" varStatus="idx">
								<tr>
									<td class="invisible"><input type="checkbox" class="index" value="${list.EDU_SEQ }"></td>
									<td>${list.CENTER_NM }</td>
									<td>${list.EDU_NM }</td>
									<td>${list.EDU_DE }${not empty list.EDU_END_DE ?' ~ ':''}${not empty list.EDU_END_DE ? fn:substring(list.EDU_END_DE, 8, 10) : '' }<br> ${list.EDU_BEGIN_TIME_HOUR}:${list.EDU_BEGIN_TIME_MIN} ~ ${list.EDU_END_TIME_HOUR}:${list.EDU_END_TIME_MIN}</td>
									<td>${list.EDU_TARGET_TYPE }</td>
									<td>${list.EDU_REQST_NMPR }</td>
									<td>${list.EDU_NMPR }</td>
									<td>${list.FRST_REGIST_PNTTM }</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" />
				</article>
				
				<article class="col-md-12 col-lg-6">
					<table class="table table-bordered tb_type03">
						<colgroup>
							<col width="10%">
							<col width="*">
							<col width="10%">
							<col width="*">
							<col width="10%">
							<col width="*">
						</colgroup>
						<tbody id="detailTable">
							<tr><td colspan="6" class="textAlignCenter">항목을 선택해주세요.</td></tr>
						</tbody>
					</table>
					
					<c:if test="${pageInfo.REPORT_AT eq 'Y' }">
						<button type="button" class="btn btn-default ml2 mb5 reportDown" id="">
							<i class="fa fa-print" title="강사 보고서"></i> 강사 보고서
						</button>
					</c:if>
					
					<table class="table table-bordered table-hover tb_type01">
						<colgroup>
							<col width="5%">
							<col width="8%">
							<col width="10%">
							<col width="19%">
							<col width="13%">
							<col width="22%">
							<col width="13%">
							<col width="10%">
						</colgroup>
						<tbody id="applicantTable">							
							
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

<script id="detail-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">교육명 </th>
	<td colspan="3">{{EDU_NM}}</td>
	<th scope="row">과목코드</th>
	<td>{{LECTURE_ID}}</td>
</tr>
<tr>
	<th scope="row">교육일시</th>
	<td colspan="3">
		{{EDU_DE}}{{#notempty EDU_END_DE}}~{{#right EDU_END_DE 2}}{{/right}}{{/notempty}}<br/> {{EDU_BEGIN_TIME_HOUR}}:{{EDU_BEGIN_TIME_MIN}} ~ {{EDU_END_TIME_HOUR}}:{{EDU_END_TIME_MIN}}
	</td>
	<th scope="row">캘린더노출여부</th>
	<td>{{#ifeq CALENDAR_YN 'Y'}}Y{{/ifeq}}</td>
</tr>
<tr>
	<th scope="row">모집기간</th>
	<td colspan="3">
		{{START_DE}} {{START_HH}}:{{START_MM}} ~ {{END_DE}} {{END_HH}}:{{END_MM}}
	</td>
	<th scope="row">별도접수여부</th>
	<td>{{#ifeq WE_ACCEPT_AT 'Y'}}Y{{/ifeq}}</td>
</tr>
<tr>
	<th scope="row">강사 </th>
	<td>{{INSTRCTR_NM_I}}{{#notempty INSTRCTR_NM_S}}{{#notempty INSTRCTR_NM_I}},{{/notempty}}{{/notempty}}{{INSTRCTR_NM_S}}</td>
	<th scope="row">장소 </th>
	<td>{{EDU_PLACE}}</td>
	<th scope="row">홈페이지<br>게시여부 </th>
	<td>{{#ifeq HOMEPAGE_AT 'Y'}}게시{{/ifeq}}</td>
</tr>
<tr>
	<th scope="row">교육과정</th>
	<td>{{EDU_PROCESS_TXT}}</td>
	<th scope="row">신청인원</th>
	<td>{{EDU_REQST_NMPR}}</td>
	<th scope="row">교육인원 </th>
	<td>{{EDU_NMPR}}</td>
</tr>
<tr>
	<th>교육대상</th>
	<td colspan="5">{{EDU_TARGET_TYPE}}</td>
</tr>
<tr>
	<th>센터 </th>
	<td colspan="5">{{CENTER_NM}}</td>
</tr>
<tr>
	<th scope="row">첨부파일 </th>
	<td colspan="5">
		{{safe fileView}}
	</td>
</tr>
<tr>
	<th scope="row">내용 </th>
	<td colspan="5" class="board_contents">
		{{safe EDU_CN}}
	</td>
</tr>
<tr>
    <th scope="row">강사모집여부</th>
    <td>{{INSTRCTR_OTHBC_YN}}</td>
    <th>공개/비공개</th>
    <td colspan="5">
    	<button class="btn btn-primary instrctrOthbcBtn" name="instrctrOthbcYn" type="button" style="padding: 7px 13px;" data-instrctr-othbc="Y">
        	<i class="fa" title="공개"></i>공개
        </button>
        <button class="btn btn-danger instrctrOthbcBtn" name="instrctrOthbcYn" type="button" style="padding: 7px 13px;" data-instrctr-othbc="N">
        	<i class="fa" title="비공개"></i>비공개
        </button>
    </td>
</tr>
<tr>
	<th scope="row">강사모집기간</th>
	<td colspan="5">
		{{#notempty INSTRCTR_START_DE}} {{INSTRCTR_START_DE}} {{INSTRCTR_START_HH}}:{{INSTRCTR_START_MM}} ~ {{INSTRCTR_END_DE}} {{INSTRCTR_END_HH}}:{{INSTRCTR_END_MM}}{{/notempty}}
	</td>
</tr>
<tr>
    <th scope="row">작성일</th>
    <td>{{FRST_REGIST_PNTTM}}</td>
    <th>작성자</th>
    <td colspan="5">{{LAST_USER_NM}}</td>
</tr>
</script>
<script id="applicant-template" type="text/x-handlebars-template">
<tr>
	<th>연번</th>
	<th>이름</th>
	<th>생년월일</th>
	<th>소속</th>
	<th>직급</th>
	<th>자격</th>
	<th>세부등급</th>
	<th>신청상태</th>
	
</tr>
{{#if .}}
{{#each .}}
	<tr>
		<td>{{inc @key}}</td>
		<td>{{NM}}</td>
		<td>{{BIRTHDAY}}</td>
		<td>{{ORGANIZATION}}</td>
		<td>{{POSITION}}</td>
		<td>{{EDU_QUALIFICATION_DETAIL}}{{#notempty EDU_QUALIFICATION_18_DETAIL}}({{EDU_QUALIFICATION_18_DETAIL}}){{/notempty}}</td>
		{{!--<td>{{EDU_QUALIFICATION_DETAIL}}{{#notempty EDU_QUALIFICATION_18_DETAIL}}({{EDU_QUALIFICATION_18_DETAIL}}){{/notempty}}</td>--}}
		<td>{{DETAIL_GRADE_CD}}</td>
		<td>
			{{#ifeq APPL_STAT "Y"}}승인됨{{/ifeq}}
			{{#ifeq APPL_STAT "F"}}반려됨{{/ifeq}}
			{{#ifeq APPL_STAT "N"}}취소{{#notempty CANCEL_DATE}}({{CANCEL_DATE}}){{/notempty}}{{/ifeq}}
			{{#ifnoteq APPL_STAT "N"}}{{#ifnoteq APPL_STAT "Y"}}{{#ifnoteq APPL_STAT "F"}}신청됨{{/ifnoteq}}{{/ifnoteq}}{{/ifnoteq}}
		</td>
		
	</tr>
{{/each}}
{{else}}
	<tr class="noData">                           
		<td colspan="8">신청자가 없습니다.</td>             
	</tr>
{{/if}}
</script>
