<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">

$(function(){
	// ckEditor Height 설정
	CKEDITOR.replace('contents',{height : 400});
	
	var baseInfo = {
			insertKey : "${common.baseType[0].key() }",
            updateKey : "${common.baseType[1].key() }",
            deleteKey : "${common.baseType[2].key() }",
            lUrl : "/ncts/mngr/homeMngr/mngrPopupList.do",
            fUrl : "/ncts/mngr/homeMngr/mngrPopupForm.do",
            dUrl : "/ncts/mngr/homeMngr/mngrDeletePopup.do",
            excel : "/ncts/mngr/homeMngr/mngrPopupDownload.do"
	}	
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				popShowYn    : {required       : ['팝업여부']},
				title               : {required       : ['제목']},
				contentsSnapshot    : {required       : ['내용']},
				popBasicformYn    : {required       : ['팝업배경']},
			}
		});
	}
	
	$.saveProc = function(){
		if(!confirm("저장하시겠습니까?")) return;
		if(!$('input[name=popNo]').val())$('input[name=popNo]').val(0)
		makeSnapshot(document.iForm, "contents");
		
		$("#iForm").ajaxForm({
			type: 'POST',
			url: "/ncts/mngr/homeMngr/mngrProgressPopup.do",
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
		$(".onlyNum").onlyNumber(4);
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
						<input type="hidden" id="popNo" name="popNo" value="${result.POP_NO}">
						<input type="hidden" name="atchFileId" value="${result.ATCH_FILE_ID}">
						<input type="hidden" name="centerCd" value="<sec:authentication property="principal.centerId"/>" >
						
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="10%">
	                            <col width="8%">
	                            <col width="8%">
	                            <col width="15%">
	                            <col width="8%">
	                            <col width="8%">
	                            <col width="8%">
	                            <col width="15%">
	                            <col width="10%">
	                            <col width="10%">
							</colgroup>
							<tbody>
                                <tr>
	                                <th scope="row">팝업여부 </th>
	                                <td><select id="popShowYn" name="popShowYn" class="form-control" style="text-align-last:center;">
                                            <option value="">선택</option>
                                            <option value="Y" ${result.POP_SHOW_YN eq 'Y' ? 'selected="selected"':''}>Y</option>
                                            <option value="N" ${result.POP_SHOW_YN eq 'N' ? 'selected="selected"':''}>N</option>
                                        </select>
                                    </td>
	                                <th scope="row">위치 </th>
	                                <td>상단 : <input type="text" id="popTop" name="popTop" value="${result.POP_TOP}" style="width:45px;height: 25px;border: 1px solid #ccc;" class="onlyNum">&nbsp;&nbsp;
	                                                                                                좌측 : <input type="text" id="popLeft" name="popLeft" value="${result.POP_LEFT}" style="width:45px;height: 25px;border: 1px solid #ccc;" class="onlyNum">
                                    </td>
	                                <th scope="row">팝업배경 </th>
	                                <td><select id="popBasicformYn" name="popBasicformYn" class="form-control" style="text-align-last:center;">
                                            <option value="">선택</option>
                                            <option value="Y" ${result.POP_BASICFORM_YN eq 'Y' ? 'selected="selected"':''}>Y</option>
                                            <option value="N" ${result.POP_BASICFORM_YN eq 'N' ? 'selected="selected"':''}>N</option>
                                        </select>
                                    </td>
	                                <th scope="row">크기 </th>
	                                <td>가로 : <input type="text" id="popWidth" name="popWidth" value="${result.POP_WIDTH}" style="width:45px;height: 25px;border: 1px solid #ccc;" class="onlyNum">&nbsp;&nbsp;
                                                                                                           세로 : <input type="text" id="popHeight" name="popHeight" value="${result.POP_HEIGHT}" style="width:45px;height: 25px;border: 1px solid #ccc;" class="onlyNum">
                                    </td>
	                                <th scope="row">시간(분 기준) </th>
	                                <td>
	                                <input type="text" id="popCloseHour" name="popCloseHour" value="${result.POP_CLOSE_HOUR}" style="width:60px;height: 25px;border: 1px solid #ccc;" class="onlyNum"></td>
								<tr>
									<th scope="row">제목 </th>
									<td colspan="9">
										<label class="input w500 col">
											<input type="text" id="title" name="title" value="${result.TITLE}">
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">내용 </th>
									<td colspan="9" class="board_contents">
										<textarea id="contents" name="contents" class="part_long board_contents" style="width: 100%; min-width: 100%;">${result.CONTENTS}</textarea>
									</td>
								</tr>
								<tr>
                                    <th scope="row">첨부파일 </th>
                                    <td colspan="9">
                                        ${markup }
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