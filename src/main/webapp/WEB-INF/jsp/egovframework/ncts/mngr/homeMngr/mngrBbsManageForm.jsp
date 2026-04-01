<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">

$(function(){
	// ckEditor Height 설정
	CKEDITOR.replace('contents',{height : 400});
	
	var baseInfo = {
			insertKey : '<c:out value="${common.baseType[0].key() }"/>',
            updateKey : '<c:out value="${common.baseType[1].key() }"/>',
            deleteKey : '<c:out value="${common.baseType[2].key() }"/>',
            lUrl : "/ncts/mngr/homeMngr/mngrBbsManageList.do",
            fUrl : "/ncts/mngr/homeMngr/mngrBbsManageForm.do",
            dUrl : "/ncts/mngr/homeMngr/mngrDeleteBbsManage.do",
            excel : "/ncts/mngr/homeMngr/mngrBbsManageDownload.do"
	}	
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				title               : {required       : ['제목']},
                contentsSnapshot    : {required       : ['내용']},
			}
		});
	}
	
	$.saveProc = function(){
		if(!confirm("저장하시겠습니까?")) return;
		if(!$('input[name=bbsNo]').val()) $('input[name=bbsNo]').val(0);
		
		if(!$('input[name=holdYn]:checked').val() && $(".holdYn").length == 0) $("#iForm").append('<input type="hidden" class="holdYn" name="holdYn" value="N">');
		else if($('input[name=holdYn]:checked').val() == "Y") $(".holdYn").remove();
		
		makeSnapshot(document.iForm, "contents");
		
		$("#iForm").ajaxForm({
			type: 'POST',
			url: "/ncts/mngr/homeMngr/mngrProgressBbsManage.do",
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
		$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
		$("#listBtn").goBackList($.searchAction);
		$.setValidation();
		$("#saveBtn").saveBtnOnClickEvt();
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
						<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						<input type="hidden" id="bbsNo" name="bbsNo" value="<c:out value='${result.BBS_NO}'/>" />
						<input type="hidden" name="atchFileId" value="<c:out value='${result.ATCH_FILE_ID}'/>" />
						<input type="hidden" name="centerCd" value="<sec:authentication property="principal.centerId"/>" >
						
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="15%">
								<col width="35%">
								<col width="15%">
								<col width="35%">
							</colgroup>
							<tbody>
								<tr>
                                    <th scope="row">게시판</th>
                                    <td colspan="3"><div class="inline-group col">
                                            <c:forEach var="list" items="${result.DMH13 }" varStatus="idx">
                                                <c:if test="${list.CODE eq '00' or list.CODE eq '04' or list.CODE eq '05' or list.CODE eq '06' or list.CODE eq '07'}">
	                                                <label class="radio">
	                                                    <input type="radio" value="<c:out value='${list.CODE }'/>" name="bbsTypeCd" <c:out value="${result.BBS_TYPE_CD eq list.CODE ? 'checked=checked' :'' }"/>><i></i><c:out value="${list.CODE_NM }"/>
	                                                </label>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
									<th scope="row">홈페이지 게시여부 </th>
									<td>
										<label class="checkbox checkboxCenter col ml10 mt5">
											<input type="checkbox" id="homepageAt" name="homepageAt" value="Y" <c:out value="${result.HOMEPAGE_AT eq 'Y' ? 'checked=checked':''}"/>><i></i>
										</label>
										<span class="col mt7 ml30 mr5">홈페이지 게시</span>												
									</td>                                	
									<th scope="row">상단고정 여부 </th>
									<td>
										<label class="checkbox checkboxCenter col ml10 mt5">
											<input type="checkbox" id="holdYn" name="holdYn" value="Y" <c:out value="${result.HOLD_YN eq 'Y' ? 'checked=checked':''}"/>><i></i>
										</label>
										<span class="col mt7 ml30 mr5">상단고정</span>												
									</td>
                                </tr>
                                <%-- <c:if test="${result.inUp eq 'U'}">
	                                <tr>
	                                    <th scope="row">작성자</th>
	                                    <td colspan="3">${result.LAST_USER_NM }</td>
	                                </tr>
	                                <tr>
	                                    <th scope="row">작성일</th>
	                                    <td colspan="3">${result.FRST_REGIST_PNTTM }</td>
	                                </tr>
                                </c:if> --%>
								<tr>
									<th scope="row">제목 </th>
									<td colspan="3">
										<label class="input w500 col">
											<input type="text" id="title" name="title" value='<c:out value="${result.TITLE}"/>'>
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">내용 </th>
									<td class="board_contents" colspan="3">
										<textarea id="contents" name="contents" class="part_long board_contents" style="width: 100%; min-width: 100%;"><c:out value="${result.CONTENTS}"/></textarea>
									</td>
								</tr>
								<tr>
                                    <th scope="row">첨부파일 </th>
                                    <td colspan="3">
	                                <c:out value="${markup}" escapeXml="false"/>
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