<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
		
<form name="cForm" id="cForm" method="post">
	<input type="hidden" name="currentPageNo" id="currentPageNo" value='<c:out value="${pagination.currentPageNo}"/>'>
	<p class="mt20">발송결과 : P(발송준비중) / R(발송준비) / I(발송중) / S(발송성공) / F(발송실패) / U(수신거부) / C(발송취소) / PE(일부실패)</p>
	<table class="table table-bordered table-hover tb_type01 mt10">
		<colgroup>
			<col width="10%">
			<col width="10%">
			<col width="15%">
			<col width="10%">
			<col width="5%">
			<col width="10%">
			<col width="10%">
			<col width="15%">
			<col width="10%">
			<col width="5%">
		</colgroup>
		<tbody id="targetTable">
			<tr>
				<th>아이디</th>
				<th>이름</th>
				<th>이메일</th>
				<th>발송<br>일시</th>
				<th>발송<br>결과</th>
				<th>아이디</th>
				<th>이름</th>
				<th>이메일</th>
				<th>발송<br>일시</th>
				<th>발송<br>결과</th>
			</tr>
			<c:if test="${empty statusList }">
				<tr class="noData">                           
					<td colspan="10">수신자가 없습니다.</td>             
				</tr>
			</c:if>
			<c:forEach var="rslist" items="${statusList }">
				<tr>
					<td class="invisible"><input type="hidden" name="mailId" value="${rslist.MAIL_ID1 }"></td>
					<td>${rslist.USER_ID1}</td>
					<td>${rslist.USER_NM1}</td>
					<td>${rslist.USER_EMAIL1}</td>
					<td>${rslist.SEND_DATE1}</td>
					<td>${rslist.SEND_STATUS1}</td>
					<td class="invisible"><input type="hidden" name="mailId" value="${rslist.MAIL_ID2 }"></td>
					<td>${rslist.USER_ID2}</td>
					<td>${rslist.USER_NM2}</td>
					<td>${rslist.USER_EMAIL2}</td>
					<td>${rslist.SEND_DATE2}</td>
					<td>${rslist.SEND_STATUS2}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<!-- 페이지 네비게이션 -->
	<div class="pagenavi text-center">
		<ul class='pagination pagination-lg'>
			<ui:pagination paginationInfo="${pagination }" type="image" jsFunction="$.linkPage2"/>
		</ul>
	</div>
	<!--// END: 페이지 네비게이션 -->    
</form>
