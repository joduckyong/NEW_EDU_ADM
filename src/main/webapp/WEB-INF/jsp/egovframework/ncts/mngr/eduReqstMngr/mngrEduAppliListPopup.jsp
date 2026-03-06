<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

$(function(){
	var baseInfo = {
			insertKey : "${common.baseType[0].key() }",
			updateKey : "${common.baseType[1].key() }",
			deleteKey : "${common.baseType[2].key() }",
			lUrl : "/ncts/mngr/eduReqstMngr/mngrEduAppliListPopup.do",
	}
	
	$.fn.selectBtnOnClickEvt = function(){
		$(this).on("click", function(){
			var $this = $(this);
			
			if($("input.index:checked").length == 0) {
				alert("항목을 선택하시기 바랍니다.");
			} else {
				self.opener.$.dataDetail($("input.index:checked").val());
				self.close();
			}
		})
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
		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
		$("#selectBtn").selectBtnOnClickEvt();
		//$.checkUser();
	}
	
	$.initView();
})
</script>

<!-- MAIN CONTENT -->
<div id="content" class="popPage">
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
				<div class="fL wp50">
					<ul class="searchAreaBox">
						<li class="smart-form ml5">
						    <label class="label">아이디</label>
						</li>
						<li class="w150">
							<input type="text" id="searchKeyword4" name="searchKeyword4" value='<c:out value="${param.searchKeyword4}"/>' class="form-control">
						</li>
						
						<li class="smart-form ml5">
						    <label class="label">이름</label>
						</li>
						<li class="w150">
							<input type="text" id="searchKeyword1" name="searchKeyword1" value='<c:out value="${param.searchKeyword1}"/>' class="form-control">
						</li>
						<li class="ml10">
							<button class="btn btn-primary searchReset" id="searchBtn" type="button"><i class="fa fa-search"></i> 검색</button>
						</li>
					</ul>
				</div>
				<div class="fR wp50">
					<ul class="searchAreaBox fR">
						<li><button class="btn btn-primary ml2" type="button" id="selectBtn"><i class="fa fa-edit" title="선택"></i>선택</button></li>
					</ul>
				</div>
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
                 
			</form>
		</div>
		<!-- Search 영역 끝 -->	
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<div class="article_medical" id="pList" >
						<table class="table table-bordered tb_type01 listtable">
							<colgroup>
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
							</colgroup>
							<thead>
								<tr>
									<th class="invisible"></th>
									<th>아이디</th>
									<th>이메일</th>
									<th>이름</th>
									<th>연락처</th>
									<th>회원등급</th>
									<th>세부등급</th>
									<th>강사등급</th>
								</tr>
							</thead>
							<tbody>
								<c:if test="${empty list }">
									<tr><td colspan="7">데이터가 없습니다.</td></tr>
								</c:if>
								<c:forEach var="list" items="${list }" varStatus="idx"> 
									<tr>                                                                                        
										<td class="invisible"><input type="checkbox" class="index" value="${list.USER_NO}"></td>
										<%-- <td>${!empty list.DIST_MANAGE_NM ? list.DIST_MANAGE_NM : '전체'  }</td> --%>         
										<td>${list.USER_ID}</td>                                                                
										<td>${list.USER_EMAIL}</td>                                                             
										<td>${list.USER_NM}</td>                                                                
										<td>${list.USER_HP_NO}</td>                                                             
										<td>${list.GRADE_CD_NM}</td>                                                            
										<td>${list.DETAIL_GRADE_CD_NM}</td>                                                     
										<td>${list.INSTRCTR_DETAIL_GRADE_CD_NM}</td>                                                     
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
