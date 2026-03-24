<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

$(function(){
	var baseInfo = {
			insertKey : '<c:out value="${common.baseType[0].key() }"/>',
			updateKey : '<c:out value="${common.baseType[1].key() }"/>',
			deleteKey : '<c:out value="${common.baseType[2].key() }"/>',
			lUrl : "/ncts/mngr/eduReqstMngr/mngrEdcRequsetUpdateCenterListPopup.do",
	}
	
	$.searchAction = function(){
		var no = 1;
        if(typeof(arguments[0]) != "undefined") no = arguments[0].pageNo;
        with(document.sForm){
            currentPageNo.value = no;
            action = baseInfo.lUrl;
            submit();
        }
    }
	
	
	$.initView = function(){
		$.onClickTableTr();
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
        	<input type="hidden" name="reqstSeq" id="reqstSeq" value='<c:out value="${param.reqstSeq }"/>'>
			<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
		</form>
		<!-- Search 영역 끝 -->	
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<div class="article_medical" id="pList">
						<table class="table table-bordered table-hover tb_type01">
							<colgroup>
								<col width="25%">
								<col width="25%">
								<col width="25%">
								<col width="25%">
							</colgroup>
							
							<tbody id="targetTable">	
									<tr>
										<th>기존센터명</th>
										<th>변경센터명</th>
										<th>변경자</th>
										<th>변경일자</th>
									</tr>
									<c:if test="${empty rslist }">
										<tr class="noData">                           
											<td colspan="4">데이터가 없습니다.</td>             
										</tr>
									</c:if>
									<c:forEach var="rslist" items="${rslist }">
										<tr>
											<td class="invisible"><input type="checkbox" class="index" value='<c:out value="${rslist.REQST_SEQ }"/>' ></td>
											<td><c:out value="${rslist.ORI_CENTER_NM }"/></td>
											<td><c:out value="${rslist.NEW_CENTER_NM }"/></td>
											<td><c:out value="${rslist.LAST_USER_NM }"/></td>
											<td><c:out value="${rslist.LAST_UPDT_PNTTM }"/></td>
										</tr>
									</c:forEach>
							</tbody>
						</table>
						<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" />
					</div>
				</article>
			</div>
		</div>
	</section>
	<!-- widget grid end -->

</div>
<!-- END MAIN CONTENT -->
