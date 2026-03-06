<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

$(function(){
	var eduProgSeq = "";
	var procInfo = {
			activeId : $("#isueList li.active a").prop("id"),
			activeTxt : $("#isueList li.active a").prop("id") == "COMPL" ? "수료" : "이수",
			procUrl : $("#isueList li.active a").prop("id") == "COMPL" ? "/ncts/mngr/eduReqstMngr/packageCertificateProgress.do" : "/ncts/mngr/eduReqstMngr/updateDtyComplProgress.do",
	}
	var baseInfo = {
			insertKey : "${common.baseType[0].key() }",
			updateKey : "${common.baseType[1].key() }",
			deleteKey : "${common.baseType[2].key() }",
			lUrl : "/ncts/mngr/eduReqstMngr/mngrDtyEduProgressList.do",
			fUrl : "/ncts/mngr/eduReqstMngr/mngrDtyEduProgressForm.do",
	}
	
	$.dataDetail = function(index){
		if($.isNullStr(index)) return false;
		document.sForm.eduSeq.value = index;
		eduSeq = index;
		
		$("input[name='lectureId']").val($(".listtable tbody").data("seq") != index ? "" : procInfo.activeId);
		
		$.ajax({
			type: 'POST',
			url: "/ncts/mngr/eduReqstMngr/selectMngrDtyEduProgressDetail.do",
			data: $("#sForm").serialize(),
			dataType: "json",
			success: function(data) {
				if(data.success == "success"){
					var isueData = {};
					isueData.lectureId = data.rs.LECTURE_ID.split("|");
					isueData.activeId = $("input[name='lectureId']").val() == "" ? isueData.lectureId[0] : $("input[name='lectureId']").val();
					isueData.videoLectureId = data.rs.VIDEO_LECTURE_ID != undefined ? data.rs.VIDEO_LECTURE_ID.split("|") : '';
					$("#isueList ul").handlerbarsCompile($("#isue-template"), isueData);
					$("#isueList li").isueListliOnClickEvt();	
					
					$.setProcInfo(isueData.activeId);
					
					if(procInfo.activeId == "COMPL") {
						$("#complProcBtn span").html(procInfo.activeTxt+"처리");
						$("#autoCheck").show();
					}
					else {
						$("#complProcBtn span").html(procInfo.activeTxt+"처리");
						$("#autoCheck").hide();
					}
					
					data.rsList.ACTIVE_ID = procInfo.activeId;
					$("#applicantTable").handlerbarsCompile($("#applicant-template"), data.rsList);
					
					if($("#isueList li.active a").data("videoAt") == "Y") $("#complProcBtn, #applicantTable input[type='checkbox']").prop("disabled", true);
					else $("#complProcBtn, #applicantTable input[type='checkbox']").prop("disabled", false);
					
					$("input[name='eduDivision']").val(data.rs.PACKAGE_GUBUN);
					
					$(".listtable tbody").data("seq", index);
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
	
	$.fn.complProcOnClickEvt = function(){
		var _this = $(this);
		
		_this.on("click", function(){
			if($(".index:checked").length == 0) {
				alert("항목을 체크하시기 바랍니다.");
				return false;
			}
			
			var complCnt = 0;
			$("input:checkbox[name=complCheck]:checked").each(function(idx){
				var $this = $(this);
	            	++complCnt;
	        });
			if(complCnt == 0) {
				alert("항목을 체크하시기 바랍니다.");
				return false;
			}
			
			if(!confirm("현재 체크된 인원은 "+complCnt+"명입니다.\n여러개를 하면, 잘못 처리한 " + procInfo.activeTxt + "증은 다시 되돌릴수가 없으니 \n신중하시길 바랍니다. " + procInfo.activeTxt + " 처리 하시겠습니까?")) return false;
			var complVal = "";
			$("input:checkbox[name=complCheck]:checked").each(function(idx){
				var $this = $(this);
	            if(idx != 0){
	            	complVal += ',';
	            }
	            complVal += $(this).val();
	        });
			
			if(complVal){
				$.loadingBarStart();
				document.sForm.complProcUser.value = complVal;
				document.sForm.procType.value = baseInfo.updateKey;
				document.sForm.eduSeq.value = $(".tr_clr_2").children(".invisible").children(".index").val();
				
				$.ajax({
					type: 'POST',
					url: procInfo.procUrl,
					data: $("#sForm").serialize(),
					dataType: "json",
					success: function(data) {
						alert(data.msg);
						if(data.success == "success"){
							$.dataDetail(eduSeq);
						}
					},
					error: function(request,status,error) {
						alert(data.msg);
					},
					complete: function() {
						$.loadingBarClose();
					}
				})
			}
		});
	}
	
    $.fn.isueListliOnClickEvt = function(){
    	var _this = $(this);
    	_this.on("click", function(){
    		var $this = $(this);
    		var $ul = $this.closest("ul");
    		
    		$ul.find("li").removeClass("active");
    		$this.addClass("active");
    		
    		/* if($this.find("a").data("videoAt") == "Y") $("#complProcBtn").prop("disabled", true);
    		else $("#complProcBtn").prop("disabled", false); */
    		
    		$.setProcInfo($this.find("a").prop("id"));
    		$.dataDetail($(".index:checked").val());
    	})
    }	
    
    $.ubiFormBtnOnClickEvt = function($this){
    	var type = $this.data("jrf");
    	var $index = $this.closest("tr");
    	
        document.ubiForm.ubi_jrt.value =  $this.data("jrf");
        document.ubiForm.userNo.value = $index.find("input[name='userNo']").val();
        document.ubiForm.edcIssueNo.value =  $index.find("input[name='edcIssueNo']").val();
        document.ubiForm.eduSeq.value =  $index.find("input[name='eduSeq']").val();
        document.ubiForm.eduGubun.value =  $index.find("input[name='eduGubun']").val();
        document.ubiForm.ctfhvNo.value =  $index.find("input[name='ctfhvNo']").val();
        popUbiReport();
   }    
    
    $.setProcInfo = function(lectureId){
    	$("input[name='lectureId']").val(lectureId);
		procInfo.activeId = lectureId;
		procInfo.activeTxt = lectureId == "COMPL" ? "수료" : "이수";
		procInfo.procUrl = lectureId == "COMPL" ? "/ncts/mngr/eduReqstMngr/packageCertificateProgress.do" : "/ncts/mngr/eduReqstMngr/updateDtyComplProgress.do";
    }
    
    $.fn.autoCheckBtnOnClickEvt = function(){
    	$(this).on("click", function(){
    		var $this = $(this);
    		
			$.ajax({
				type: 'POST',
				url: "/ncts/mngr/eduReqstMngr/complAutoCheck.do",
				data: $("#sForm").serialize(),
				dataType: "json",
				success: function(data) {
					if(data.success == "success"){
						var checkList = data.rslist;
						$("#applicantTable tr input[type='checkbox']").prop("checked", false);
						checkList.forEach(function(value, index){
							$("#applicantTable input[name='userNo'][value='"+ value.USER_NO +"']").siblings("input[type='checkbox']").prop("checked", true);
						})
					}
				}
			})    		
    	})
    }
    

	$.initView = function(){
		$.onClickTableTr();
		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
		$("#saveBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.insertKey);
		$("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
		$("#complProcBtn").complProcOnClickEvt();
		$("#autoCheckBtn").autoCheckBtnOnClickEvt();
		
		$(document).on("change", "#allCheck", function(){
			var _this = $(this);
			
			if(_this.is(":checked")){
				$("input:checkbox[name=complCheck]").each(function(idx){
					$(this).prop('checked', true);
	            });
			} else{
				$("input:checkbox[name=complCheck]").each(function(idx){
					$(this).prop('checked', false);

				});
			}
		});
        $(document).on("click", ".reportBtn", function(){
            $.ubiFormBtnOnClickEvt($(this));
        });		
	}
	
	$.initView();
})
</script>

<form id="ubiForm" name="ubiForm" method="post">
    <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
    <input type="hidden" id="ubi_jrt" name="jrf" value="" />
    <input type="hidden" name="userNo" value="" />
    <input type="hidden" name="edcIssueNo" value="" />
    <input type="hidden" name="eduSeq" value="" />
    <input type="hidden" name="eduGubun" value="" />
    <input type="hidden" name="ctfhvNo" value="" />
</form>
		
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/ribbon.jsp" flush="false" />

<!-- MAIN CONTENT -->
<div id="content">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/menuTitle.jsp" flush="false" />
	
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
				<input type="hidden" name="eduSeq" id="eduSeq"  value="">
				<input type="hidden" name="eduProgSeq" id="eduProgSeq"  value="">
				<input type="hidden" name="complProcUser" id="complProcUser"  value="">
				<input type="hidden" name="userNo" id="userNo"  value="0">
				<input type="hidden" name="psitn" id="psitn"  value="">
				<input type="hidden" name="lectureId" id="lectureId"  value="">
				<input type="hidden" name="eduDivision" id="eduDivision"  value="">
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
										<option value="${center.DEPT_CD }" data-groupId="${center.GROUP_ID }" ${center.DEPT_CD eq paginationInfo.centerCd ? 'selected="selected"':'' } >${center.DEPT_NM }</option>
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
						    <label class="label">패키지명</label>
						</li>
						<li class="w150 mr5">    
							<select name="searchCondition1" class="form-control">
								<option value="">전체</option>
					    		<c:forEach var="list" items="${packageList }" varStatus="idx">
									<option value="${list.PACKAGE_NO }" ${param.searchCondition1 eq list.PACKAGE_NO ? 'selected="selected"' :'' }>${list.PACKAGE_NM }</option>
								</c:forEach>
							</select> <i></i>
						</li>
												
						<li class="ml10">
							<button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
						</li>
					</ul>
				</div>

				<%-- <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
					<jsp:param value="list"     name="formType"/>
					<jsp:param value="1,2,3,4"     name="buttonYn"/>
				</jsp:include> --%>
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
							<col width="25%">
							<col width="15%">
                            <col width="25%">
                            <col width="10%">
                            <col width="15%">
                            <col width="10%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>교육명</th>
								<th>교육일시</th>
								<th>교육대상</th>
								<th>교육인원</th>
								<th>센터</th>
								<th>작성일</th>
							</tr>
						</thead>
						<tbody data-seq="">
							<c:if test="${empty rslist }">
								<tr ><td colspan="6">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${rslist }" varStatus="idx">
								<tr>
									<td class="invisible">
										<input type="checkbox" class="index" value="${list.EDU_SEQ }">
									</td>
									<td>${list.EDU_NM }</td>
									<td>${list.EDU_DE }${not empty list.EDU_END_DE ?' ~ ':''}${not empty list.EDU_END_DE ? fn:substring(list.EDU_END_DE, 8, 10) : '' }<br> ${list.EDU_BEGIN_TIME_HOUR}:${list.EDU_BEGIN_TIME_MIN} ~ ${list.EDU_END_TIME_HOUR}:${list.EDU_END_TIME_MIN}</td>
									<td>${list.EDU_TARGET_TYPE }</td>
									<td>${list.EDU_NMPR }</td>
									<td>${list.CENTER_NM }</td>
									<td>${list.FRST_REGIST_PNTTM }</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" />
				</article>
				
				<article class="col-md-12 col-lg-6">
					<!-- <table class="table table-bordered tb_type03">
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
					</table> -->
					<div class="tab-content" style="display:block;">
						<div class="jarviswidget-sortable active" id="isueList" style="display:inline-block;">
							<ul class="nav nav-tabs" style="min-width:100%;">
							</ul>
						</div>
						<div class="fR wp12 mt5 mr5 mb5" id="complProc">
						  <button class="btn btn-primary ml2" type="button" id="complProcBtn" ${pageInfo.INSERT_AT eq 'Y' ? '':'disabled' }><i class="fa fa-magic" title="처리"></i><span>이수처리</span></button>
						</div>
						<div class="fR wp12 mt5 mr5 mb5" id="autoCheck" style="display:none;">
						  <button class="btn btn-primary ml2" type="button" id="autoCheckBtn" ${pageInfo.INSERT_AT eq 'Y' ? '':'disabled' }><i class="fa fa-check" title="처리"></i><span>자동선택</span></button>
						</div>						
					</div>					
					<table class="table table-bordered table-hover tb_type01">
						<colgroup>
							<col width="8%">
							<col width="12%">
							<col width="15%">
							<col width="20%">
							<col width="15%">
							<col width="10%">
							<col width="10%">
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


<script id="applicant-template" type="text/x-handlebars-template">
<tr>
    <th><input type="checkbox" id="allCheck"></th>
	<th>이름</th>
	<th>생년월일</th>
	<th>소속</th>
	<th>직급</th>
	<th>재난심리지원지역</th
	<th>{{#ifeq ACTIVE_ID "COMPL"}}수료{{else}}이수{{/ifeq}}여부</th>
	<th>{{#ifeq ACTIVE_ID "COMPL"}}수료{{else}}이수{{/ifeq}}여부</th>
	<th>{{#ifeq ACTIVE_ID "COMPL"}}수료{{else}}이수{{/ifeq}}일</th>
</tr>
{{#if .}}
{{#each .}}
	<tr>
        <td>
			<input type="checkbox" name="complCheck" value="{{APPLI_SEQ}}">
			<input type="hidden" name="userNo" value="{{USER_NO}}">
			<input type="hidden" name="edcIssueNo" value="{{EDC_ISSUE_NO}}">
			<input type="hidden" name="eduSeq" value="{{ISUE_EDU_SEQ}}">
			<input type="hidden" name="eduGubun" value="{{ISUE_EDU_GUBUN}}">
			<input type="hidden" name="ctfhvNo" value="{{CTFHV_NO}}">
		</td>
		<td>{{NM}}</td>
		<td>{{BIRTHDAY}}</td>
		<td>{{ORGANIZATION}}</td>
		<td>{{POSITION}}</td>
		<td>
			{{EDU_SUPORT_AREAS01_TXT}}{{#notempty EDU_SUPORT_AREAS02_TXT}},{{/notempty}}{{EDU_SUPORT_AREAS02_TXT}}
		</td>
		<td>
			{{#ifeq @root.ACTIVE_ID "COMPL"}}{{CERTIFICATE_AT}}{{else}}{{ISUE_AT}}{{/ifeq}}
		</td>
		<td class="reportBtn" data-jrf="{{#ifeq @root.ACTIVE_ID "COMPL"}}certificate_compl.jrf{{else}}certificate_isue.jrf{{/ifeq}}">
			{{#ifeq @root.ACTIVE_ID "COMPL"}}{{CERTIFICATE_DE}}{{else}}{{ISUE_DE}}{{/ifeq}}
		</td>
	</tr>
{{/each}}
{{else}}
	<tr class="noData">                           
		<td colspan="7">신청자가 없습니다.</td>             
	</tr>
{{/if}}
</script>
<script id="isue-template" type="text/x-handlebars-template">
{{#each lectureId}}
	<li class="{{#ifeq @root.activeId ""}}{{#ifeq @key 0}}active{{/ifeq}}{{else}}{{#ifeq this @root.activeId}}active{{/ifeq}}{{/ifeq}}">
		<a href="javascript:void(0);" id="{{this}}"
			{{#each ../videoLectureId}}
				{{#ifeq this @root.activeId}}data-video-at="Y"{{/ifeq}}
			{{/each}}
		>{{this}}</a>
	</li>
{{/each}}
{{!-- <li class="{{#ifeq activeId "COMPL"}}active{{/ifeq}}">
	<a href="javascript:void(0);" id="COMPL">수료</a>
</li> --}}
</script>