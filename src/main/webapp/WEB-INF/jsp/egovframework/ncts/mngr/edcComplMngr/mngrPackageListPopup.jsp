<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
$(function(){
	var baseInfo = {
			insertKey : "${common.baseType[0].key() }",
			updateKey : "${common.baseType[1].key() }",
			deleteKey : "${common.baseType[2].key() }",
			lUrl : "/ncts/mngr/edcComplMngr/mngrPackageListPopup.do",
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
	
	$.fn.saveBtnOnClickEvt = function(){
		var _this = $(this);
        _this.on("click", function(){
        	if($(".devQua:checked").length != 1) {
        		alert("1개의 패키지를 선택해주세요.");
        		return false
        	}
        	
        	var obj = {
        			checkedPackageNm : 	$(".devQua:checked").closest("tr").find("input[name='packageNm']").val(),
        			checkedLectureId : 	$(".devQua:checked").closest("tr").find("input[name='lectureId']").val(),
        			checkedPackageNo : $(".devQua:checked").val(),
        			checkedCourses : $("#courses").val(),
        	};
          
            self.opener.$.selectPackageNo(obj);
            self.close();
        })
	}
	
	$.packageNoOnSetting = function(){
		$("input[type='checkbox'][value='"+"${param.packageNo}"+"']").prop("checked", true);
	}
	
	$.fn.devQuaOnClickEvt = function(){
		$(this).on("click", function(){
			var $this = $(this);
			if($this.is(":checked")) $(".devQua").not($this).prop("checked", false);
		})
	}
	
	$.initView = function(){
		$("#saveBtn").saveBtnOnClickEvt($.searchAction);
		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
		$(".devQua").devQuaOnClickEvt();
		$.packageNoOnSetting();
		if($("#pList tbody tr").length == 0) $("tbody").append('<tr><td colspan="4">데이터가 없습니다.</td></tr>');
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
          		<input type="hidden" name="pageType" id="pageType" value="${param.pageType }">
				<input type="hidden" name="packageNo" id="packageNo" value="${param.packageNo}">
				<input type="hidden" name="courses" id="courses" value="${param.courses}">
				<div class="fL wp70">
                    <ul class="searchAreaBox">
                        <li class="smart-form ml5"><label class="label">패키지명</label></li>
                        <li class="w150 ml5">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'>
                        </li>
                    	<li class="smart-form ml5"><label class="label">강의코드</label></li>
                        <li class="w150 ml5">
                            <input id="searchKeyword2" name="searchKeyword2" class="form-control" value='<c:out value="${param.searchKeyword2}"/>'>
                        </li>
                        <li class="ml10">
                            <button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
                        </li>
                    </ul>
                </div>
				<div class="fR wp10">
					<ul class="searchAreaBox fR">
						<li>
							<button class="btn btn-primary m12" type="button" id="saveBtn"><i class="fa"></i> 확인</button>
						</li>
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
								<col width="5%">
								<col width="40%">
								<col width="40%">
								<col width="15%">
							</colgroup>
							<thead>
								<tr>
									<th class="invisible"></th>
									<th>선택</th>
									<th>패키지명</th>
									<th>강의코드</th>
									<%-- <th>동영상 활성화</th> --%>
									<th>강의등록일</th>
								</tr>
							</thead>
							<tbody>
								<c:if test="${empty list }">
									<tr><td colspan="4">데이터가 없습니다.</td></tr>
								</c:if>
								<c:forEach var="list" items="${list }" varStatus="idx">
									<c:if test="${list.USE_AT eq 'Y' and list.COURSES eq param.courses}">
										<tr>
											<td class="invisible">
												<input type="hidden" name="packageNm" value="${list.PACKAGE_NM }">
												<input type="hidden" name="lectureId" value="${list.LECTURE_ID }">
											</td>
											<td><input type="checkbox" class="devQua" value="${list.PACKAGE_NO }"></td>
											<td>${list.PACKAGE_NM }</td>
											<td>${list.LECTURE_ID }</td>
											<td>${list.FRST_REGIST_PNTTM}</td>
										</tr>
									</c:if>
								</c:forEach>
							</tbody>
						</table>
					<%-- <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" /> --%>
					</div>
				</article>
			</div>
		</div>
	</section>
	<!-- widget grid end -->
</div>
<!-- END MAIN CONTENT -->

<script id="tr-template2" type="text/x-handlebars-template">
<tr><td colspan="4">데이터가 없습니다.</td></tr>
</script>