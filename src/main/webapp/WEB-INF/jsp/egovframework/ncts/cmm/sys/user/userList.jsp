<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

$(function(){
	var baseInfo = {
			insertKey : "<c:out value='${common.baseType[0].key() }'/>",
			updateKey : "<c:out value='${common.baseType[1].key() }'/>",
			deleteKey : "<c:out value='${common.baseType[2].key() }'/>",
			lUrl : "/ncts/cmm/sys/user/userList.do",
			fUrl : "/ncts/cmm/sys/user/userForm.do",
			dUrl : "/ncts/cmm/sys/user/userProcess.do",
			excel : "/ncts/stat/common/statExcelDownload.do",
	}
	
	$.dataDetail = function(index){
		if($.isNullStr(index)) return false;
		document.sForm.userId.value = index;
	}
	
	$.fn.procBtnOnClickEvt = function(url, key){
		var _this = $(this);
		_this.on("click", function(){
			if(baseInfo.insertKey != key){
				if($("input.index:checked").size() <= 0) {
					alert("항목을 선택하시기 바랍니다.");
					return false;
				}else{
					document.sForm.userId.value = $("input.index:checked").val();
				} 
			}else{
				document.sForm.userId.value = "";
			}
			
			if(baseInfo.deleteKey == key){
				$.delAction(url, key);
			}else{
				$.procAction(url, key);	
			}
		})
	}
	
	$.procAction = function(pUrl, pKey){
		with(document.sForm){
			procType.value = pKey;
			action = pUrl;
			submit();
		}
	}
	
	$.delAction = function(pUrl, pKey){
		if(!confirm("삭제하시겠습니까?")) return false;
		document.sForm.procType.value = pKey;
		$.ajax({
			type: 'POST',
			url: pUrl,
			data: $("#sForm").serialize(),
			dataType: "json",
			success: function(data) {
				alert(data.msg);
				if(data.success == "success"){
					$.searchAction();
				}
			}
		});
	}
	
	$.searchAction = function(){
		var no = 1;
        if(typeof(arguments[0]) != "undefined") no = arguments[0].pageNo;
        with(document.sForm){
            currentPageNo.value = no;
            action = baseInfo.lUrl;
            submit();
        }
	}
	
	
	$.initView = function(){
		$.onClickTableTr();
		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
		$("#saveBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.insertKey);
		$("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
		$("#delBtn").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey);
		
		$(".excelDown").on("click", function(){
			$("[name='excelFileNm']").val("직원 전체리스트 "+$.toDay());
			$("[name='excelPageNm']").val("userAll");
			with(document.sForm){
				target = "";
				action = baseInfo.excel;
				submit();
			}
		});
	}
	
	$.initView();
})
</script>

		
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/ribbon.jsp" flush="false" />

<!-- MAIN CONTENT -->
<div id="content">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/menuTitle.jsp" flush="false" />
	
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
				<input type="hidden" name="userId" id="userId"  value="">
				<input type="hidden" name="excelFileNm">
				<input type="hidden" name="excelPageNm">
				<div class="fL wp80">
					<ul class="searchAreaBox">
						<li class="smart-form">
						    <label class="label">센터명</label>
						</li>
						<sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')">
							<li class="w150 mr5">
								<select name="searchKeyword1" class="form-control">
									<option value="">선택</option>
									<c:forEach var="center" items="${centerList }" varStatus="idx">
										<option value="<c:out value='${center.DEPT_CD }'/>" data-groupId="<c:out value='${center.GROUP_ID }'/>" <c:out value="${center.DEPT_CD eq param.searchKeyword1 ? 'selected=selected':'' }"/> ><c:out value="${center.DEPT_NM }"/></option>
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
						<li class="smart-form">
						    <label class="label">구분</label>
						</li>
						<li class="w100">
							<select id="searchCondition2" name="searchCondition2" class="form-control">
								<option value="0" <c:out value="${'0' eq param.searchCondition2 ? 'selected=selected':'' }"/>>사용자ID</option>
								<option value="1" <c:out value="${'1' eq param.searchCondition2 ? 'selected=selected':'' }"/>>이름</option>
							</select> <i></i>
						</li>
						<li class="w150 ml5">
							<input id="searchKeyword2" name="searchKeyword2" class="form-control" value="<c:out value='${param.searchKeyword2}'/>"> 
						</li>
						<li class="smart-form ml5">
						    <label class="label">사용여부</label>
						</li>
						<li class="w100">
							<select id="searchCondition3" name="searchCondition3" class="form-control">
								<option value="">전체</option>
								<option value="Y" <c:out value="${'Y' eq param.searchCondition3 ? 'selected=selected':'' }"/>>사용</option>
								<option value="N" <c:out value="${'N' eq param.searchCondition3 ? 'selected=selected':'' }"/>>미사용</option>
							</select> <i></i>
						</li>
						<li class="smart-form ml5">
						    <label class="label">잠금여부</label>
						</li>
						<li class="w100">
							<select id="searchCondition4" name="searchCondition4" class="form-control">
								<option value="">전체</option>
								<option value="Y" <c:out value="${'Y' eq param.searchCondition4 ? 'selected=selected':'' }"/>>잠금</option>
								<option value="N" <c:out value="${'N' eq param.searchCondition4 ? 'selected=selected':'' }"/>>미잠금</option>
							</select> <i></i>
						</li>
						<li class="ml10">
							<button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
						</li>
					</ul>
				</div>

				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
					<jsp:param value="list"     name="formType"/>
					<jsp:param value="2,3,4"     name="buttonYn"/>
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
					<table class="table table-bordered tb_type01 listtable">
						<colgroup>
							<col width="8%">
							<col width="8%">
                            <col width="8%">
                            <col width="4%">
                            <col width="8%">
                            <col width="8%">
                            <col width="8%">
                            <col width="8%">
                            <col width="8%">
                            <col width="8%">
                            <col width="8%">
                            <col width="8%">
                            <col width="8%">
                            <col width="8%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>사용자ID</th>
								<th>이름</th>
								<th>생년월일</th>
								<th>성별</th>
								<th>자격</th>
								<th>핸드폰번호</th>
								<th>이메일</th>
								<th>초기<br>비밀번호</th>
								<th>인증서여부</th>
								<th>사용자유형</th>
								<th>사용여부</th>
								<th>최초등록일</th>
								<th>잠금여부</th>
								<th>최근로그아웃일자</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty rslist }">
								<tr ><td colspan="13">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${rslist }" varStatus="idx">
								<tr>
									<td class="invisible"><input type="checkbox" class="index" value="<c:out value='${list.USER_ID }'/>"></td>
									<td><c:out value="${list.USER_ID }"/></td>
									<td><c:out value="${list.USER_NM }"/></td>
									<td><c:out value="${list.USER_BIRTH }"/></td>
									<td><c:out value="${list.USER_GENDER_TXT }"/></td>
									<td><c:out value="${list.USER_QUALF_TXT }"/></td>
									<td><c:out value="${list.USER_HP }"/></td>
									<td><c:out value="${list.USER_EMAIL }"/></td>
									<td><c:out value="${list.INIT_PW_STAT eq 'Y' ? 'O' : ''}"/></td>
									<td><c:out value="${empty list.DN ? 'X' : 'O'}"/></td>
									<td>
										${list.ROLE_NM_TXT}						
									</td>
									<td>
										<c:out value="${list.USE_AT}"/>
										<c:if test="${list.USE_AT eq 'N' and not empty list.USE_AT_DISABLED_DE}"><br>(<c:out value="${list.USE_AT_DISABLED_DE }"/>)</c:if>
									</td>
									<td>
										<c:out value="${list.FRST_REGIST_PNTTM }"/>
									</td>
									<td>
										<c:out value="${list.LOCK_AT }"/>
										<c:if test="${list.LOCK_AT eq 'Y' and not empty list.LOCK_DE}"><br>(<fmt:formatDate pattern="yyyy.MM.dd" value="${ list.LOCK_DE }"/>)</c:if>
									</td>
									<td><c:out value="${list.IO_DATE }"/></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" />
				</article>
			</div>
			<!-- row 메뉴조회 끝 -->
		</div>
	</section>
	<!-- widget grid end -->

</div>
<!-- END MAIN CONTENT -->