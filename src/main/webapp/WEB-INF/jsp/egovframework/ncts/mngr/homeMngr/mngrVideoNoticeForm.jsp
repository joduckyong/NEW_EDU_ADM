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
            lUrl : "/ncts/mngr/homeMngr/mngrVideoNoticeList.do",
            fUrl : "/ncts/mngr/homeMngr/mngrVideoNoticeForm.do",
            dUrl : "/ncts/mngr/homeMngr/mngrDeleteVideoNotice.do",
	}	
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				title               : {required       : ['제목']},
                youtubeId    : {required       : ['URL']},
			}
		});
	}
	
	$.saveProc = function(){
		if(!confirm("저장하시겠습니까?")) return;
		if(!$('input[name=bbsNo]').val())$('input[name=bbsNo]').val(0)
		makeSnapshot(document.iForm, "contents");
		
		$("#iForm").ajaxForm({
			type: 'POST',
			url: "/ncts/mngr/homeMngr/mngrProgressVideoNotice.do",
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
						<input type="hidden" id="bbsNo" name="bbsNo" value='<c:out value="${result.BBS_NO}"/>'>
						<input type="hidden" name="atchFileId" value='<c:out value="${result.ATCH_FILE_ID}"/>'>
						<input type="hidden" name="contentsSnapshot" value="">
						<input type="hidden" name="centerCd" value="<sec:authentication property="principal.centerId"/>" >
						<input type="hidden" name="bbsTypeCd" value="10">
						<input type="hidden" name="typeCd" value="02">
						<input type="hidden" name="pwSeq" value="${result.PW_SEQ }">
						
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="15%">
								<col width="35%">
								<col width="15%">
								<col width="35%">
							</colgroup>
							<tbody>
                                <c:if test="${result.inUp eq 'U'}">
                                <tr>
                                    <th scope="row">작성자</th>
                                    <td colspan="3">${result.LAST_USER_NM }</td>
                                </tr>
                                <tr>
                                    <th scope="row">작성일</th>
                                    <td colspan="3">${result.FRST_REGIST_PNTTM }</td>
                                </tr>
                                </c:if>
								<tr>
									<th scope="row">제목 </th>
									<td>
										<label class="input w500 col">
											<input type="text" id="title" name="title" value="${result.TITLE}">
										</label>
									</td>
									<th scope="row">홈페이지 게시여부 </th>
									<td>
										<label class="checkbox checkboxCenter col ml10 mt5">
											<input type="checkbox" id="homepageAt" name="homepageAt" value="Y" ${result.HOMEPAGE_AT eq 'Y' ? 'checked="checked"':''}><i></i>
										</label>
										<span class="col mt7 ml30 mr5">홈페이지 게시</span>										
									</td>
								</tr>
								<tr>
									<th scope="row">내용 </th>
									<td class="board_contents" colspan="3">
										<textarea id="contents" name="contents" class="part_long board_contents" style="width: 100%; min-width: 100%;">${result.CONTENTS}</textarea>
									</td>
								</tr>
								<tr>
									<th scope="row">URL </th>
									<td colspan="3">
										<label class="input w250">
											<input type="text" id="youtubeId" name="youtubeId" value="${result.YOUTUBE_ID}" placeholder="https://youtu.be/동영상ID">
										</label>
									</td>
								</tr>
								<tr>
                                    <th scope="row">썸네일 이미지 </th>
                                    <td colspan="3">
                                        ${markup }
                                    </td>
                                </tr>
								<tr>
									<th scope="row">비밀번호</th>
									<td colspan="3">
										<label class="input w250 fL">
											<input type="password" id="bbsPw" name="bbsPw" class="pw" value="${result.BBS_PW}" maxlength="20">
										</label>
										<a href="javascript:void(0);" class="pw_show pwControl fL" style="margin-top: 6px;"></a>
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