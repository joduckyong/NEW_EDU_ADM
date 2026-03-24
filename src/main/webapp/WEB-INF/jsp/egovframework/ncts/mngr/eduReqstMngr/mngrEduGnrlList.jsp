<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

$(function(){
	var baseInfo = {
			excelPg : 0,
			insertKey : '<c:out value="${common.baseType[0].key() }"/>',
			updateKey : '<c:out value="${common.baseType[1].key() }"/>',
			deleteKey : '<c:out value="${common.baseType[2].key() }"/>',
			lUrl : "/ncts/mngr/eduReqstMngr/mngrEduGnrlList.do",
			fUrl : "/ncts/mngr/eduReqstMngr/mngrEduGnrlForm.do",
			dUrl : "/ncts/mngr/eduReqstMngr/mngrDeleteGnrlEdu.do",
			excel : "/ncts/mngr/eduReqstMngr/mngrGnrlExcelDownload.do"
	}
	
	$.dataDetail = function(index){
		if($.isNullStr(index)) return false;
		document.sForm.gnrlEduSeq.value = index;
		$.ajax({
			type: 'POST',
			url: "/ncts/mngr/eduReqstMngr/selectMngrEduGnrlDetail.do",
			data: $("#sForm").serialize(),
			dataType: "json",
			success: function(data) {
				if(data.success == "success"){
					document.ubiForm.actStatus.value = data.rs.INSTRCTR_ACT_STATUS;
					$("#detailTable").handlerbarsCompile($("#detail-template"), data.rs);
					// $("#applicantTable").handlerbarsCompile($("#applicant-template"), data.rsList);
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
					document.sForm.gnrlEduSeq.value = $("input.index:checked").val();
				} 
			}else{
				document.sForm.gnrlEduSeq.value = "";
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
            url: "/ncts/mngr/eduReqstMngr/updateGnrlInstrctrOthbcYnProcess.do",
            data			: {
				"gnrlEduSeq" : $("#gnrlEduSeq").val(),
				"procType" : baseInfo.updateKey,
				"gnrlInstrctrOthbcYn" : val,
				'<c:out value="${_csrf.parameterName}"/>' : '<c:out value="${_csrf.token}"/>'
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
		/* 강사모집기간 여부 
		$(document).on("click", "button[name=gnrlInstrctrOthbcYn]", function(){
        	var _this = $(this);
        	$.instrctrOthbcYn(_this.data("instrctrOthbc"));
        }); */
        
        $(".excelDown").on("click", function(e){
        	excelPg = 1;
			$("[name='excelFileNm']").val("일반교육관리_"+$.toDay());
			$("[name='excelPageNm']").val("mngrEduGnrlList.xlsx");
            with(document.sForm){
                target = "";
                action = baseInfo.excel;
                submit();
                
                $.setCookie("fileDownloadToken","false"); //Cookie 생성
                $.loadingBarStart(e);
                $.checkDownloadCheck(baseInfo.excelPg);// Cookie Token 값 체크
            }
        });
        
        $("body").on("keydown", function(e){
	        $.loadingBarKeyDown(e, excelPg);
        })
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
	<input type="hidden" name="eduDivision" value="03" />
</form>

<!-- MAIN CONTENT -->
<div id="content">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/menuTitle.jsp" flush="false" />
	
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
				<input type="hidden" name="gnrlEduSeq" id="gnrlEduSeq"  value="">
				<input type="hidden" name="excelFileNm">
				<input type="hidden" name="excelPageNm">				
				<input type="hidden" name="eduDivision" value="03" />
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
										<option value='<c:out value="${center.DEPT_CD }"/>' data-groupId='<c:out value="${center.GROUP_ID }"/>' <c:out value="${center.DEPT_CD eq paginationInfo.centerCd ? 'selected=selected':'' }"/>><c:out value="${center.DEPT_NM }"/></option>
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
						<li class="w150">
							<input type="text" id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'>
						</li>
						<li class="ml10">
							<button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
						</li>
					</ul>
				</div>

				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
					<jsp:param value="list"     name="formType"/>
					<jsp:param value="1,2,3,4"     name="buttonYn"/>
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
							<col width="25%">
							<col width="25%">
                            <col width="20%">
                            <col width="10%">
                            <col width="10%">
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
						<tbody>
							<c:if test="${empty rslist }">
								<tr ><td colspan="6">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${rslist }" varStatus="idx">
								<tr>
									<td class="invisible"><input type="checkbox" class="index" value='<c:out value="${list.GNRL_EDU_SEQ }"/>'></td>
									<td><c:out value="${list.GNRL_EDU_NM }"/></td>
									<td><c:out value="${list.GNRL_EDU_DE }"/><c:out value="${not empty list.GNRL_EDU_END_DE ?' ~ ':''}"/><c:out value="${not empty list.GNRL_EDU_END_DE ? fn:substring(list.GNRL_EDU_END_DE, 8, 10) : '' }"/><br> <c:out value="${list.GNRL_EDU_BEGIN_TIME_HOUR}"/>:<c:out value="${list.GNRL_EDU_BEGIN_TIME_MIN}"/> ~ <c:out value="${list.GNRL_EDU_END_TIME_HOUR}"/>:<c:out value="${list.GNRL_EDU_END_TIME_MIN}"/></td>
									<td><c:out value="${list.GNRL_EDU_TARGET_TYPE }"/></td>
									<td><c:out value="${list.GNRL_EDU_NMPR }"/></td>
									<td><c:out value="${list.CENTER_NM }"/></td>
									<td><c:out value="${list.FRST_REGIST_PNTTM }"/></td>
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
					
					<!-- <button type="button" class="btn btn-default ml2 mb5 reportDown" id="">
						<i class="fa fa-print" title="강사 보고서"></i> 강사 보고서
					</button> -->
					
					<table class="table table-bordered table-hover tb_type01">
						<colgroup>
							<col width="10%">
							<col width="12%">
							<col width="15%">
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

<script id="detail-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">교육명 </th>
	<td colspan="3">{{GNRL_EDU_NM}}</td>
	<th scope="row">과목코드</th>
	<td>{{GNRL_LECTURE_ID}}</td>
</tr>
<tr>
	<th scope="row">교육일시</th>
	<td colspan="5">
		{{GNRL_EDU_DE}}{{#notempty GNRL_EDU_END_DE}}~{{#right GNRL_EDU_END_DE 2}}{{/right}}{{/notempty}}<br/> {{GNRL_EDU_BEGIN_TIME_HOUR}}:{{GNRL_EDU_BEGIN_TIME_MIN}} ~ {{GNRL_EDU_END_TIME_HOUR}}:{{GNRL_EDU_END_TIME_MIN}}
	</td>
</tr>
<tr>
	<th scope="row">강사 </th>
	<td colspan="3">
		{{INSTRCTR_NM_I}}{{#notempty INSTRCTR_NM_S}},{{/notempty}}{{INSTRCTR_NM_S}}
	</td>
	<th scope="row">장소 </th>
	<td>{{GNRL_EDU_PLACE}}</td>
</tr>

<tr>
	<th scope="row">교육과정</th>
	<td>{{GNRL_EDU_PROCESS_TXT}}</td>
	<th scope="row">교육대상</th>
	<td>{{GNRL_EDU_TARGET_TYPE}}</td>
	<th scope="row">교육인원 </th>
	<td>{{GNRL_EDU_NMPR}}</td>
</tr>
<tr>
	<th>신청기관 </th>
	<td colspan="3">{{GNRL_EDU_REQST_INSTT}}</td>
	<th>센터 </th>
	<td>{{CENTER_NM}}</td>
</tr>
<tr>
	<th scope="row">첨부파일 </th>
	<td colspan="5">
		{{safe fileView}}
	</td>
</tr>
<tr>
	<th scope="row">내용 </th>
	<td colspan="5"  class="board_contents">
		{{safe GNRL_EDU_CN}}
	</td>
</tr>
<tr>
    <th scope="row">작성일</th>
    <td>{{FRST_REGIST_PNTTM}}</td>
    <th>작성자</th>
    <td colspan="5">{{LAST_USER_NM}}</td>
</tr>

</script>