<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

$(function(){
	var baseInfo = {
			insertKey : '<c:out value="${common.baseType[0].key() }"/>',
			updateKey : '<c:out value="${common.baseType[1].key() }"/>',
			deleteKey : '<c:out value="${common.baseType[2].key() }"/>',
			lUrl : "/ncts/mngr/instrctrMngr/instrctrDetailPopup.do",
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
	
    $.fn.instrctrListATagOnClickEvt = function(){
    	var _this = $(this);
    	_this.on("click", function(){
    		var $this = $(this);
    		document.sForm.searchCondition1.value = $this.data("val");
    		$.searchAction();
    	})
    }	
	
	
	
	$.initView = function(){
		$("#instrctrList a").instrctrListATagOnClickEvt();
	}
	
	$.initView();
})
</script>


<!-- MAIN CONTENT -->
<div id="content" class="popPage">
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
        <form name="sForm" id="sForm" method="post">
        	<input type="hidden" name="instrctrNo" id="instrctrNo" value='<c:out value="${param.instrctrNo }"/>'>
        	<input type="hidden" name="searchCondition1" id="searchCondition1" value='<c:out value="${param.searchCondition1 }"/>'>
        	<input type="hidden" name="searchCondition2" id="searchCondition2" value='<c:out value="${param.searchCondition2 }"/>'>
			<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
		</form>
		<!-- Search 영역 끝 -->	
		<div class="content" style="border:none;">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<div class="tab-content">
						<div class="jarviswidget-sortable active" id='<c:out value="${not empty param.searchCondition2 ? 'instrctrList2' : 'instrctrList' }"/>'>
							<ul class="nav nav-tabs" style="min-width:100%;">
								<li class='<c:out value="${empty param.searchCondition1 or param.searchCondition1 eq  ''  ? 'active' : ''}"/>'><a href="javascript:void(0);" data-val="">전체</a></li>
								<li class='<c:out value="${param.searchCondition1 eq 'PFAT' ? 'active' : ''}"/>'><a href="javascript:void(0);" data-val="PFAT">PFA</a></li>
								<li class='<c:out value="${param.searchCondition1 eq 'PMPT' ? 'active' : ''}"/>'><a href="javascript:void(0);" data-val="PMPT">PM+</a></li>
								<li class='<c:out value="${param.searchCondition1 eq 'SPRT' ? 'active' : ''}"/>'><a href="javascript:void(0);" data-val="SPRT">SPR</a></li>
								<li class='<c:out value="${param.searchCondition1 eq 'MPGT' ? 'active' : ''}"/>'><a href="javascript:void(0);" data-val="MPGT">MPG</a></li>
								<li class='<c:out value="${param.searchCondition1 eq 'ETC' ? 'active' : ''}"/>'><a href="javascript:void(0);" data-val="ETC">기타</a></li>
							</ul>
						</div>
					</div>					
				
					<div class="article_medical" id="pList">
						<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						
						<c:set var="instrctrICnt" value="0" />
						<c:set var="instrctrSCnt" value="0" />
						<c:forEach var="list" items="${list }" varStatus="idx">
							<c:if test="${list.INSTRCTR_NO_I eq param.instrctrNo }">
								<c:set var="instrctrICnt" value="${instrctrICnt+1 }" />
							</c:if>
							<c:if test="${list.INSTRCTR_NO_S eq param.instrctrNo }">
								<c:set var="instrctrSCnt" value="${instrctrSCnt+1 }" />
							</c:if>
						</c:forEach>
						
						<span class="fL mt5 mb5" style="font-size:17px; font-weight: bold;">
							<c:out value="${user.INSTRCTR_DETAIL_GRADE_CD_NM }"/> : <c:out value="${user.USER_NM }"/>(<c:out value="${user.USER_ID }"/>)
							<c:if test="${param.searchCondition1 eq 'PFAT' }">
								<c:set var="instrctrCertGradeAt" value="Y" />
								<c:set var="instrctrCertGradeCd" value="${user.PFAT_GRADE_CD }" />
							</c:if>
							<c:if test="${param.searchCondition1 eq 'PMPT' }">
								<c:set var="instrctrCertGradeAt" value="Y" />
								<c:set var="instrctrCertGradeCd" value="${user.PMPT_GRADE_CD }" />
							</c:if>
							<c:if test="${param.searchCondition1 eq 'SPRT' }">
								<c:set var="instrctrCertGradeAt" value="Y" />
								<c:set var="instrctrCertGradeCd" value="${user.SPRT_GRADE_CD }" />
							</c:if>
							<c:if test="${param.searchCondition1 eq 'MPGT' }">
								<c:set var="instrctrCertGradeAt" value="Y" />
								<c:set var="instrctrCertGradeCd" value="${user.MPGT_GRADE_CD }" />
							</c:if>
							<c:if test="${instrctrCertGradeAt eq 'Y' }">
								-
		                		<c:if test="${instrctrCertGradeCd eq '99'}">해당없음</c:if>
			                	<c:forEach var="list" items="${codeMap.DMH24 }" varStatus="idx">
			                		<c:if test="${list.CODE eq instrctrCertGradeCd }"><c:out value="${list.CODE_DC}"/></c:if>
			               	 	</c:forEach>  							
							</c:if>
						</span>
						<span class="fR mt15">총<c:out value="${fn:length(list)}"/>회(위촉강사 <c:out value="${instrctrICnt }"/>회 / 준강사 <c:out value="${instrctrSCnt }"/>회)</span>
						<table class="table table-bordered tb_type01 listtable">
							<colgroup>
								<col width="8%">
								<col width="8%">
								<col width="25%">
	                            <col width="11%">
	                            <col width="13%">
	                            <col width="15%">
	                            <col width="10%">
	                            <col width="10%">
							</colgroup>
							<thead>
								<tr>
									<th class="invisible"></th>
									<th>구분</th>
									<th>단계</th>
									<th>교육명</th>
									<th>교육일자</th>
									<th>주관</th>
									<th>시행기관</th>
									<th>위촉강사</th>
									<th>준강사</th>
								</tr>
							</thead>
							<tbody>
								<c:if test="${empty list }">
									<tr><td colspan="8">데이터가 없습니다.</td></tr>
								</c:if>
								<c:forEach var="list" items="${list }" varStatus="idx">
									<tr>
										<td class="invisible">
											<input type="checkbox" class="index" value='<c:out value="${list.SEQ}">'/>
											<input type="hidden" name="eduDivision" value='<c:out value="${list.EDU_DIVISION}">'/>
										</td>
										<td><c:out value="${list.EDU_DIVISION_NM}"/></td>
										<td><c:out value="${list.EDU_DIVISION gt '03' ? list.EDU_DIVISION_NM : list.EDU_PROCESS_TXT}"/></td>
										<td><c:out value="${list.EDUCATION_TXT}"/></td>
										<td><c:out value="${list.START_YMD}"/> ~ <c:out value="${fn:substring(list.END_YMD, 8, 10)}"/></td>
										<td><c:out value="${list.CENTER_NM }"/></td>
										<td><c:out value="${list.INSTT }"/></td>
										<td><c:out value="${list.INSTRCTR_NM_I}"/><c:if test="${not empty list.INSTRCTR_CERT_I }">(<c:out value="${list.INSTRCTR_CERT_I }"/>)</c:if></td>
										<td><c:out value="${list.INSTRCTR_NM_S}"/><c:if test="${not empty list.INSTRCTR_CERT_S }">(<c:out value="${list.INSTRCTR_CERT_S }"/>)</c:if></td>
										<c:set var="p_seq" value="${list.SEQ }"/>
										<c:set var="p_edu_division" value="${list.EDU_DIVISION }"/>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<button class="btn fR" type="button" id="closeBtn" onclick="self.close()" style="border: 1px solid #222; font-weight: bold;">닫기</button>
				</article>
			</div>
		</div>
	</section>
	<!-- widget grid end -->

</div>
<!-- END MAIN CONTENT -->
