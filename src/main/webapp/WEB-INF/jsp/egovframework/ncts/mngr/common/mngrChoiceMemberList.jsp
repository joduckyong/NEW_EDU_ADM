<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
		
<form name="cForm" id="cForm" method="post">
	<input type="hidden" name="currentPageNo" id="currentPageNo" value='<c:out value="${pagination.currentPageNo}"/>'>
	<table class="table table-bordered table-hover tb_type01 mt20">
		<colgroup>
			<col width="16.6%">
			<col width="16.6%">
			<col width="16.6%">
			<col width="16.6%">
			<col width="16.6%">
			<col width="16.6%">
		</colgroup>
		<tbody id="targetTable">
			<tr>
				<th>아이디</th>
				<th>이름</th>
				<th>이메일</th>
				<th>아이디</th>
				<th>이름</th>
				<th>이메일</th>
			</tr>
			<c:if test="${empty userList }">
				<tr class="noData">                           
					<td colspan="6">수신자가 없습니다.</td>             
				</tr>
			</c:if>
			<c:forEach var="rslist" items="${userList }">
				<tr>
					<td><c:out value="${rslist.USER_ID1}"/></td>
					<td><c:out value="${rslist.USER_NM1}"/></td>
					<td><c:out value="${rslist.USER_EMAIL1}"/></td>
					<td><c:out value="${rslist.USER_ID2}"/></td>
					<td><c:out value="${rslist.USER_NM2}"/></td>
					<td><c:out value="${rslist.USER_EMAIL2}"/></td>
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
