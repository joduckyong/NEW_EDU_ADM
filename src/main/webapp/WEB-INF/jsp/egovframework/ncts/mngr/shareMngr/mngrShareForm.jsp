<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">
$(function(){

	CKEDITOR.replace('shareCn',{height : 200});	
	
	var baseInfo = {
			insertKey : "<c:out value='${common.baseType[0].key() }'/>",
            updateKey : "<c:out value='${common.baseType[1].key() }'/>",
            deleteKey : "<c:out value='${common.baseType[2].key() }'/>",
            lUrl : "/ncts/mngr/shareMngr/mngrShareList.do",
            fUrl : "/ncts/mngr/shareMngr/mngrShareForm.do"
            
	}	
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				shareTitle         : {required       : ['제목']},
				centerCd            : {required       : ['센터명']}
			}
		});
	}
	
	$.saveProc = function(){
		if(!confirm("저장하시겠습니까?")) return;
		if(!$('input[name=shareSeq]').val())$('input[name=shareSeq]').val(0)
		makeSnapshot(document.iForm, "shareCn");
		
		$("#iForm").ajaxForm({
			type: 'POST',
			url: "/ncts/mngr/shareMngr/mngrProgressShare.do",
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
			target='';
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
			
	$.initView = function(){
		$("#listBtn").goBackList($.searchAction);
		$.setValidation();
		$("#saveBtn").saveBtnOnClickEvt();
	}
	
	$.initView(); 
	
	


})
</script>
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/ribbon.jsp" flush="false" />
<!-- MAIN CONTENT -->
<div id="content">
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />

	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/menuTitle.jsp" flush="false" />
	
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
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
				<article class="col-md-12 col-lg-12">
					<form name="iForm" id="iForm" method="post" class="smart-form" enctype="multipart/form-data">
						<input type="hidden" id="shareCnSnapshot" name="shareCnSnapshot">
						<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						<input type="hidden" id="shareSeq" name="shareSeq" value="<c:out value='${result.SHARE_SEQ}'/>">
						<input type="hidden" name="atchFileId" value="<c:out value='${result.ATCH_FILE_ID}'/>">
						<%-- <input type="hidden" name="centerCd" value="<sec:authentication property="principal.centerId"/>" > --%>
						
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="20%">
								<col width="30%">
								<col width="20%">
								<col width="30%">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">센터 </th>
									<td colspan="5">
										<c:choose>
											<c:when test="${common.baseType[1].key() eq common.procType }">
												<input type="hidden" id="centerCd" name="centerCd" value="<c:out value='${result.CENTER_CD }'/>" >
												<c:out value="${result.CENTER_NM }" />
											</c:when>
											<c:otherwise>
												<sec:authorize access="hasRole('ROLE_MASTER')">
													<label class="select col w150 mr5">
														<select id="centerCd" name="centerCd">
															<option value="">선택</option>
															<c:forEach var="center" items="${centerList }" varStatus="idx">
																<option value="<c:out value='${center.DEPT_CD }'/>" data-groupId="<c:out value='${center.GROUP_ID }'/>" <c:out value="${center.DEPT_CD eq result.CENTER_CD ? 'selected=selected':'' }"/> ><c:out value="${center.DEPT_NM }"/></option>
															</c:forEach>
														</select> <i></i>
													</label>
												</sec:authorize>
												<sec:authorize access="hasRole('ROLE_SYSTEM') or hasRole('ROLE_ADMIN') or hasRole('ROLE_USER')">
													<input type="hidden" name="centerCd" value="<sec:authentication property="principal.centerId"/>" >
													<sec:authentication property="principal.centerNm"/>
												</sec:authorize>	
											</c:otherwise>
										</c:choose>
									</td>
								</tr>					
								<tr>
									<th scope="row">제목 </th>
									<td>
										<label class="input w500 col">
											<input type="text" id="shareTitle" name="shareTitle" value="<c:out value='${result.SHARE_TITLE}'/>">
										</label>
									</td>
									<th scope="row">작성자 </th>
									<td>
										<label class="input w500 col">
											<input type="text" id="frstRegisterId" name="frstRegisterId" value="<c:out value='${result.FRST_REGISTER_ID}'/><c:if test="${empty result.FRST_REGISTER_ID }"><sec:authentication property="principal.userNm"/></c:if>" readonly/>
										</label>											
									</td>
							    </tr>
							    <tr>
                                    <th scope="row">첨부파일 </th>
                                    <td colspan="5">
										<c:out value="${markup }"/>
                                    </td>
                                </tr>
								<tr>
									<th scope="row">내용 </th>
									<td class="board_contents" colspan="5">
										<textarea id="shareCn" name="shareCn" class="part_long board_contents" style="width: 100%; min-width: 100%;"><c:out value="${result.SHARE_CN}"/></textarea>
									</td>
								</tr>
											
								
							</tbody>
						</table>
					</form>
				</article>
				
			</div>
			<!-- row 메뉴조회 끝 -->
		</div>
	</section>
	<!-- widget grid end -->
</div>