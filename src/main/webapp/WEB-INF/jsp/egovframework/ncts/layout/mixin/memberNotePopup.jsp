<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form method="post" name="noteForm" id="noteForm">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
	<input type="hidden" name="menuSeq" value="${menuCd }" >
	<input type="hidden" name="userNo" value="${param.userNo }" >
	<input type="hidden" name="noteSeq" value="${param.noteSeq }" >
	
	<div id="notePopup" class="popup-con" style="display:none;">
	    <div class="close_box fClr" style="text-align:left;">
	        <p class="tit fLeft">
	        	<%String today = new java.text.SimpleDateFormat("yyyy.MM.dd").format(new java.util.Date());%>
	        	<%= today %>
	         / </p>
	        <p class="tit fLeft"><sec:authentication property="principal.userNm"/></p>
	        <a href="javascript:void(0);" class="fRight closeBox"><i class="fa fa-times"></i></a>
	    </div>
	        <div class="text_box">
	            <textarea name="noteCn" id="noteCn" cols="30" rows="10"></textarea>
	            <button id="addNoteBtn" type="button">저장</button>
	        </div>
	</div>
</form>