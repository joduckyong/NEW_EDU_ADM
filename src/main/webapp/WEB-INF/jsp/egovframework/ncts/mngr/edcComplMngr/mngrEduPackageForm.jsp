<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">
$(function(){
	var baseInfo = {
			insertKey : "${common.baseType[0].key() }",
            updateKey : "${common.baseType[1].key() }",
            deleteKey : "${common.baseType[2].key() }",
            lUrl : "/ncts/mngr/edcComplMngr/mngrEduPackageList.do",
            pop01 : "/ncts/mngr/common/stddLecListPopup.do"
	}	
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				packageNm   	: {required       : ['패키지명']},
				packageGubun   : {required       : ['패키지 구분']},
				courses     : {required       : ['교육과정']},
				tdId   			: {required       : ['선택된 강의']},
			}
		});
	}
	
	$.saveProc = function(){
		if(!confirm("저장하시겠습니까?")) return;
		
		$.ajax({
            type: 'POST',
            url: "/ncts/mngr/edcComplMngr/mngrEduPackageProc.do",
            data: $("#iForm").serialize(),
            dataType: "json",
            success: function(result) {
                alert(result.msg);
                if(result.success == "success") location.replace(baseInfo.lUrl);    
            }
        });
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
	
	$.fn.offlectAddBtnOnClickEvt = function(){
		var _this = $(this);
		_this.on("click", function(){
			$.popAction.width = 1200;
            $.popAction.height = 600;
            $.popAction.target = "popup01";
            $.popAction.url = baseInfo.pop01;
            $.popAction.form = document.sForm;
            $.popAction.init();
		});
	}
	
	$.fn.goBackList = function(){
		$(this).on("click", function(){
			$.searchAction();
		})
	}
	
	$.selectLecture = function(obj){
		var oldTxt = ""
		if(obj){
	    	$("#tdId").val(obj);
	        $("input[name=lectureId]").val(obj);
	    }
	}	
	
	$.initView = function(){
		$("#listBtn").goBackList();
		$.setValidation();
		$("#saveBtn").saveBtnOnClickEvt();
		$("#offlectAddBtn").offlectAddBtnOnClickEvt();
	}
	
	$.initView(); 
})
</script>
		
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/ribbon.jsp" flush="false" />
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />
<!-- MAIN CONTENT -->
<div id="content">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/menuTitle.jsp" flush="false" />
	
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
					<jsp:param value="form"     name="formType"/>
					<jsp:param value="1,2"     name="buttonYn"/>
				</jsp:include>
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
                <input type="hidden" name="lectureId" value='<c:out value="${result.LECTURE_ID}"/>'>
                <input type="hidden" name="packageNo" value="${result.PACKAGE_NO }">
                <input type="hidden" name="pageType" value="PACKAGE">
			</form>
		</div>
		<!-- Search 영역 끝 -->
        <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />
		
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<form name="iForm" id="iForm" method="post" class="smart-form">
                        <input type="hidden" id="lectureId" name="lectureId" value='<c:out value="${result.LECTURE_ID}"/>'>
                        <input type="hidden" id="packageNo" name="packageNo" value='<c:out value="${result.PACKAGE_NO}"/>'>
						<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="20%">
								<col width="80%">
							</colgroup>
							<tbody>
	                            <tr>
	                                <th scope="row">패키지명</th>
	                                <td>
	                                    <label class="input w500 col">
	                                        <input type="text" id="packageNm" name="packageNm" value="${result.PACKAGE_NM}">
	                                    </label>
	                                </td>
	                            </tr>
								<tr>
									<th scope="row">패키지 구분</th>
									<td>
										<div class="inline-group col">
											<c:forEach var="list" items="${codeMap.DMH19 }" varStatus="idx">
												<c:if test="${list.CODE ne '01' and list.CODE ne '02' and list.CODE ne '03'}">
													<label class="radio">
														<input type="radio" value="${list.CODE }" name="packageGubun" ${result.PACKAGE_GUBUN eq list.CODE ? 'checked="checked"' :'' } ${result.PROC_YN eq 'N' ? 'disabled' : '' }><i></i>${list.CODE_NM }
													</label>
												</c:if>
											</c:forEach>
										</div>                                                                                                          
									</td>                                                                                                               
								</tr>
								<tr>
                                    <th scope="row">교육과정</th>
                                    <td>
                                        <div class="inline-group" id="divRadio">
                                            <c:forEach var="list" items="${codeMap.DMH29}" varStatus="status">
					                            <label class="radio">
					                                   <input type="radio" name="courses" value="${list.CODE}" ${result.COURSES eq list.CODE? 'checked="checked"':''} ${result.PROC_YN eq 'N' ? 'disabled' : '' }><i></i>${list.CODE_NM}
					                            </label>
                                            </c:forEach>
                                        </div>
                                    </td>
                                </tr>									                            
	                            <tr>
	                                <th scope="row">선택된 강의</th>
	                                <td>
		                                <label class="input w500 col">
		                                	<input type="text" id="tdId" name="tdId" value="${result.LECTURE_ID}" readonly>
		                                </label>
	                                	<button class="btn btn-primary ml10" type="button" id="offlectAddBtn" ${result.PROC_YN eq 'N' ? 'disabled' : '' }><i class="fa fa-edit" title="등록"></i> 등록</button>
	                                </td>
	                            </tr>
								<tr>
									<th>사용여부</th>
									<td>
										<div class="inline-group">
											<c:forEach var="list" items="${codeMap.SYS01 }" varStatus="idx">
												<label class="radio">
													<input type="radio" value="${list.CODE }" name="useAt" ${result.USE_AT eq list.CODE or idx.first ? 'checked="checked"' :'' }><i></i>${list.CODE_NM }
												</label>
											</c:forEach>
										</div>
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
<!-- END MAIN CONTENT -->