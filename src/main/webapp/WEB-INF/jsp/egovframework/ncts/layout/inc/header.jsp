<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
$(function(){
	$.urgentNoticeChk = function(){
		
		$.ajax({
			type			: "POST",
			url				: "/ncts/cmm/sys/urgent/urgentDetail.do",
			data			: {
				"${_csrf.parameterName}" : "${_csrf.token}"
			},
			dataType		: 'json',
			success			: function(result) {
				console.log(result.rs.NOTICE_DE);
				console.log(result.rs.NOTICE_START_HOUR);
				console.log(result.rs.NOTICE_START_MIN);
				console.log(result.rs.NOTICE_END_HOUR);
				console.log(result.rs.NOTICE_END_MIN);
			}
		});
		
	}
	
	//$.urgentNoticeChk();
	
	window.sessionTimer = new Counter();
	window.sessionTimer.set();
})
</script>

<form id="logoutForm" method="post" action="/ncts/login/logoutRequest.do">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
</form>
<header id="header">
	<div id="logo-group" style="text-align:center">
		<span id="logo" style="margin-top:7px"><a href="/ncts/egovNctsMain.do"><img src="/images/logo.png" title="국가트라우마센터" style="width:auto;height:35px;"></a></span>
	</div>
	<div class="project-context" >
		<div class="jarviswidget-sortable" id="top_menu">
			<ul class="nav nav-tabs pull-left" id="myTab_top_menu" style="font-size:15px;">
				<c:forEach var="high" items="${highmenu }" varStatus="idx">
					<c:set var="HIGH_PARENT_CD" value="${fn:substring(pageInfo.HIGH_PARENT_CD, 0, 5) }" /> 
					<c:if test="${fn:substring(pageInfo.PARENT_CD,0,3) eq '110' }">
						<c:if test="${high.MENU_CD ne '110110000' and high.MENU_CD ne '110120000' and high.MENU_CD ne '110130000' and high.MENU_CD ne '110140000' }">
							<c:choose>
								<%-- 자격심사, 직무 교육 관리 --%>
								<c:when test="${(HIGH_PARENT_CD eq '11011') or (HIGH_PARENT_CD eq '11012')}">
									<li><a class="${high.MENU_CD eq '110020000' ? 'on':'' }" href="/ncts/high/${high.MENU_CD }.do">${high.MENU_NM }</a></li>
								</c:when>
								<%-- 직무 이수관리 --%>
								<c:when test="${(HIGH_PARENT_CD eq '11013')}">
									<li><a class="${high.MENU_CD eq '110040000' ? 'on':'' }" href="/ncts/high/${high.MENU_CD }.do">${high.MENU_NM }</a></li>
								</c:when>
								<%-- 직무 동영상관리 --%>
								<c:when test="${(HIGH_PARENT_CD eq '11014')}">
									<li><a class="${high.MENU_CD eq '110030000' ? 'on':'' }" href="/ncts/high/${high.MENU_CD }.do">${high.MENU_NM }</a></li>
								</c:when>
								<c:otherwise>
									<li><a class="${pageInfo.HIGH_PARENT_CD eq high.MENU_CD ? 'on':'' }" href="/ncts/high/${high.MENU_CD }.do">${high.MENU_NM }</a></li>
								</c:otherwise>
							</c:choose>
						</c:if>
					</c:if>
					<c:if test="${fn:substring(pageInfo.PARENT_CD,0,3) ne '110' }">
						<c:if test="${high.MENU_CD ne '110110000' and high.MENU_CD ne '110120000' and high.MENU_CD ne '110130000' and high.MENU_CD ne '110140000' }">
							<c:choose>
								<c:when test="${(HIGH_PARENT_CD eq '11011') or (HIGH_PARENT_CD eq '11012')}">
									<li><a class="${high.MENU_CD eq '110020000' ? 'on':'' }" href="/ncts/high/${high.MENU_CD }.do">${high.MENU_NM }</a></li>
								</c:when>
								<c:when test="${(HIGH_PARENT_CD eq '11013')}">
									<li><a class="${high.MENU_CD eq '110040000' ? 'on':'' }" href="/ncts/high/${high.MENU_CD }.do">${high.MENU_NM }</a></li>
								</c:when>
								<c:when test="${(HIGH_PARENT_CD eq '11014')}">
									<li><a class="${high.MENU_CD eq '110030000' ? 'on':'' }" href="/ncts/high/${high.MENU_CD }.do">${high.MENU_NM }</a></li>
								</c:when>
								<c:otherwise>
									<li><a class="${fn:substring(pageInfo.PARENT_CD,0,3) eq fn:substring(high.MENU_CD,0,3)?'on':'' }" href="/ncts/high/${high.MENU_CD }.do">${high.MENU_NM }</a></li>
								</c:otherwise>
							</c:choose>
						</c:if>
					</c:if>
				</c:forEach>
			</ul>
		</div>
	</div>

	<div class="pull-right">
		<div id="logout" class="btn-header transparent pull-right">
			<span><a href="#" id="logoutBtn" title="로그아웃" style="font-size:9pt;">&nbsp;LOGOUT&nbsp;</a> </span>
		</div>
		<div class="btn-header transparent pull-right">
			<span><a href="/ncts/egovNctsMypage.do" title="마이페이지" style="font-size:9pt;">&nbsp;MY PAGE&nbsp;</a> </span>
		</div>
		<c:if test="${userinfo.deptAllAuthorAt eq 'Y' }">
			<div class="btn-header transparent pull-right">
				<span><a href="http://bceduadm.nct.go.kr/" title="as-is" target='_blank' style="font-size:9pt;">&nbsp;AS-IS&nbsp;</a> </span>
			</div>
		</c:if>
	</div>
</header>
