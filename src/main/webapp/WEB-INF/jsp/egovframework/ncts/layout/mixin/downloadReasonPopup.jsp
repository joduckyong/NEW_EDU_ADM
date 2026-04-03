<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form method="post" name="drForm" id="drForm">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
	<input type="hidden" name="menuSeq" value="${menuCd }" >
	
	<div id="downPopup" class="popup-con" style="display:none">
	    <div class="close_box fClr" style="text-align:left;">
	        <p class="tit fLeft">다운로드 :</p>
	        <p class="tit fLeft"><sec:authentication property="principal.userNm"/></p>
	        <a href="javascript:void(0);" class="fRight closeBox"><i class="fa fa-times"></i></a>
	    </div>
	        <div class="text_box">
	            <textarea name="excelCn1" id="excelCn1" cols="30" rows="10" placeholder="다운로드 사유작성 하세요."></textarea>
	            <button id="downInsertBtn" type="button">저장</button>
	        </div>
	</div>
</form>