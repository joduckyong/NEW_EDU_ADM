<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
var _self = window;

$(function(){
	var baseInfo = {
			pUrl : "/ncts/cmm/sys/auth/authGroupPopup.do",
			lUrl : "/ncts/cmm/sys/auth/authStaffMappingForm.do"
	}	
	
	
	$.saveProc = function(groupId){
		document.iForm.groupId.value = groupId;
		document.iForm.procType.value = "${common.baseType[1].key() }";
		var $target=$("#iForm [name='userList.userId']:checked");
		if($target.length==0){
			alert("맵핑할 사용자를 선택해주세요.");
			return;
		}
		
		$.beforSubmitRenameForModelAttribute();
		
		$.ajax({
			type			: "POST",
			url				: "/ncts/cmm/sys/auth/authStaffMappingProcess.do",
			data			: $('#iForm').serialize(),
			dataType		: 'json',
			async           : true,
			success			: function(result) {
				
				alert(result.msg);
				if(result.success == "success") $.searchAction();
				
			}
		});
		
	}
	
	$.beforSubmitRenameForModelAttribute = function() {
		$("#iForm [name='userList.userId']:checked").each(function(index){$(this).attr("name","userList["+index+"].userId");})
	}
	
	$.afterSubmitRenameForView = function() {
		$('[name^="userList"]').each(function(index) { 
			var orgName = $(this).attr("name");
			$(this).attr("name", orgName.replace(/\[[0-9]\]/g, ''));
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
			$.popAction.width = 1200;
			$.popAction.height = 800;
			$.popAction.target = "popup01";
			$.popAction.url = baseInfo.pUrl;
			$.popAction.form = document.sForm;
			$.popAction.init();
		})
	}
	
	$.fn.authDetailOnClickEvt = function(){
		var _this = $(this);
		_this.on("click", function(){
			_this=$(this);
			var target_id=_this.find("[name='authGroupId']").val();
			
			$.popAction.width = 1200;
			$.popAction.height = 800;
			$.popAction.target = "popup02";
			$.popAction.url = '/ncts/cmm/sys/auth/authDetailPopup.do?authGrpNo='+target_id;
			$.popAction.form = document.sForm;
			$.popAction.init();
		})
	}
	
	$.fn.allChk = function(){
		var _this = $(this);
		_this.on("click", function(){
			var $this = $(this);
			var target = $this.closest('tbody');
			if($this.is(':checked')){
				target.find('input[type=checkbox]').prop('checked', true);
				target.find('.invisible').each(function(){
					$(this).find('input[type=checkbox]').prop('checked', false);
				})
			}else{
				target.find('input[type=checkbox]').prop('checked', false);
			}
		})
	}
	
	$.fn.deleteAuthOnClickEvt = function(){
		$(this).on("click", function(){
			if(confirm("삭제하시겠습니까?")){
				var $this = $(this);
				document.dForm.procType.value = "${common.baseType[2].key() }";
				document.dForm.userId.value = $this.closest("tr").find("input[name*='userId']").val();
				document.dForm.groupId.value = $this.closest("tr").find("input[name='authGroupId']").val();
				
				$.ajax({
					type			: "POST",
					url				: "/ncts/cmm/sys/auth/insertDeleteAuthRcord.do",
					data			: $('#dForm').serialize(),
					dataType		: 'json',
					async           : true,
					success			: function(result) {
						alert(result.msg);
						if(result.success == "success") $.searchAction();
						
					}
				});
			}
		})
	}
	
	$.initView = function(){

		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
		$("#saveBtn").saveBtnOnClickEvt();
		$(".authDetail").authDetailOnClickEvt();
		$(".deleteAuth").deleteAuthOnClickEvt();
		$(".allChk").allChk();
	}
	
	$.initView(); 
	
})

</script>

		
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/ribbon.jsp" flush="false" />

<form name="dForm" id="dForm" method="post">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
	<input type="hidden" name="userId" value="">
	<input type="hidden" name="groupId" value="">
</form>
<!-- MAIN CONTENT -->
<div id="content">

	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/menuTitle.jsp" flush="false" />
	
	<!-- widget grid start -->
	<section id="widget-grid" class="">
	
		
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
				
				<div class="fL wp50">
					<ul class="searchAreaBox">
						<li class="smart-form">
						    <label class="label">센터명</label>
						</li>
						<sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')">
							<li class="w150 mr5">
								<select name="searchKeyword1" class="form-control">
									<option value="">선택</option>
									<c:forEach var="center" items="${centerList }" varStatus="idx">
										<option value="${center.DEPT_CD }" data-groupId="${center.GROUP_ID }" ${center.DEPT_CD eq paginationInfo.searchKeyword1 ? 'selected="selected"':'' } >${center.DEPT_NM }</option>
									</c:forEach>
								</select> <i></i>
							</li>
						</sec:authorize>
						<sec:authorize access="hasRole('ROLE_ADMIN') or hasRole('ROLE_USER')">
							<li class="smart-form mr5">
								<input type="hidden" name="searchKeyword1" value="<sec:authentication property="principal.centerId"/>" >
								<label class="label"><sec:authentication property="principal.centerNm"/></label>
							</li>
						</sec:authorize>
						<li class="ml10">
							<button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
						</li>
					</ul>
				</div>
				
				<c:if test="${pageInfo.INSERT_AT eq 'Y'}">
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
						<jsp:param value="form"     name="formType"/>
						<jsp:param value="1"     name="buttonYn"/>
					</jsp:include>
				</c:if>
					
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
                 
			</form>
		</div>
		<!-- Search 영역 끝 -->
	
		<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />
		
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<form name="iForm" id="iForm" method="post" class="smart-form"  >
						<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						<input type="hidden" id="groupId" name="groupId">
						
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="10%">
								<col width="15%">
								<col width="15%">
								<col width="*">
								<col width="15%">
								<col width="5%">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">	
										<label class="checkbox checkboxCenter"><input type="checkbox" id="allChk1" name="allChk1" class="allChk"><i></i></label>
                                    </th>
                                    <th scope="row">사용자ID</th>
                                    <th scope="row">사용자 이름</th>
                                    <th scope="row">센터명</th>
                                    <th scope="row">권한그룹명</th>
                                    <th scope="row">삭제</th>
								</tr>
								<c:forEach var="list" items="${rslist }" varStatus="idx">
									<tr>
										<td>
											<label class="checkbox checkboxCenter">
												<c:if test="${list.AUTH_GRP_NO ne 30}">
													<input type="checkbox" name="userList.userId" value="${list.USER_ID}"><i></i>
												</c:if>
											</label>
										</td>
										<td>${list.USER_ID }</td>
										<td>${list.USER_NM }</td>
										<td>${list.CENTER_NM }</td>
										<td>
											<a class="authDetail">
												<input type="hidden" name="authGroupId" value="${list.AUTH_GRP_NO }">
												${list.GROUP_NM }
											</a>
										</td>
										<td>
											<c:choose>
												<c:when test="${not empty list.AUTH_GRP_NO }">
													<a class="deleteAuth">삭제</a>
												</c:when>
												<c:when test="${not empty list.DELETE_DATE }">
													${list.DELETE_DATE }
												</c:when>
											</c:choose>
										</td>
									</tr>
								</c:forEach>
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