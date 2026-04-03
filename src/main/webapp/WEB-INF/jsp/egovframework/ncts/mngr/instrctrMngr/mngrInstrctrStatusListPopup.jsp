<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

$(function(){
	var baseInfo = {
			insertKey : "${common.baseType[0].key() }",
			updateKey : "${common.baseType[1].key() }",
			deleteKey : "${common.baseType[2].key() }",
			lUrl : "/ncts/mngr/instrctrMngr/mngrInstrctrStatusListPopup.do",
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
        	<input type="hidden" name="userNo" id="userNo" value="${param.userNo }">
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
								<col width="20%">
								<col width="20%">
								<col width="20%">
								<col width="20%">
								<col width="20%">
							</colgroup>
							
							<tbody id="targetTable">	
									<tr>
										<th>강사구분</th>
										<th>변경 전</th>
										<th>변경 후</th>
										<th>변경자</th>
										<th>변경일자</th>
									</tr>
									<c:if test="${empty rslist }">
										<tr class="noData">                           
											<td colspan="5">데이터가 없습니다.</td>             
										</tr>
									</c:if>
									<c:forEach var="rslist" items="${rslist }">
										<tr>
											<td class="invisible"><input type="checkbox" class="index" value="${rslist.CHANGE_SEQ }" ></td>
											<td>${rslist.INSTRCTR_GUBUN_TXT }</td>
											<td>${rslist.ORG_STATUS_GUBUN_TXT}</td>
											<td>${rslist.STATUS_GUBUN_TXT}</td>
											<td>${rslist.LAST_USER_NM}</td>
											<td>${rslist.LAST_UPDT_PNTTM}</td>
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
