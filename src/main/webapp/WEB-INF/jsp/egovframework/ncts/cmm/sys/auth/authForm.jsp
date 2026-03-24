<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
$(function(){
	var baseInfo = {
			lUrl : "<c:out value='${pageInfo.READ_AT eq "Y" ? pageInfo.MENU_URL : pageInfo.MENU_DETAIL_URL   }'/>",
			fUrl : "<c:out value='${pageInfo.MENU_DETAIL_URL }'/>"
	}	
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				authCd       : {required       : ['메뉴코드']},
				parentCd     : {required       : ['메뉴상위코드']},
				authNm       : {required       : ['메뉴명']},
				authUrl      : {required       : ['메뉴경로']},
				useAt        : {required       : ['사용여부']},
				authGrpNm: {required       : ['권한그룹명']}
			}
		});
	}
	
	$.saveProc = function(){
		if(!confirm("저장하시겠습니까?")) return;
		
		$.ajax({
			type			: "POST",
			url				: "/ncts/cmm/sys/auth/authProcess.do",
			data			: $('#iForm').serialize(),
			dataType		: 'json',
			success			: function(result) {
				
				alert(result.msg);
				if(result.success == "success") $.searchAction();
									
			}
		});
		
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
	
	$.fn.lineChk = function(){
		var _this = $(this);
		_this.on("click", function(){
			var $this = $(this);
			var targetTr = $(this).closest('tr');
			if($this.is(':checked')){
				targetTr.find('input[type=checkbox]').prop('checked', true);
				targetTr.find('.invisible').each(function(){
					$(this).find('input[type=checkbox]').prop('checked', false);
				})
			}else{
				targetTr.find('input[type=checkbox]').prop('checked', false);
			}
		})
	}
	
	$.fn.rowChk = function(){
		var _this = $(this);
		_this.on("click", function(){
			var $this = $(this);
			var targetNm = "."+$this.attr("name");
			var target = $(targetNm);
			if($this.is(':checked')){
				target.prop('checked', true);
				$this.closest('tbody').find('.invisible').each(function(){
					$(this).find('input[type=checkbox]').prop('checked', false);
				})
			}else{
				target.prop('checked', false);
			}
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
		$("#listBtn").goBackList($.searchAction);
		$.setValidation();
		$("#saveBtn").saveBtnOnClickEvt();
		$(".lineChk").lineChk();
		$(".rowAllChk").rowChk();
		$(".allChk").allChk();
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
				<input type="hidden" name="searchKeyword1" value="<c:out value='${param.searchKeyword1}'/>" >
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
			<form name="iForm" id="iForm" method="post"  >
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
				<input type="hidden" name="authGrpNo" value="<c:out value='${common.authGrpNo }'/>">
				<!-- row 메뉴조회 시작 -->
				<div class="row">
					<article class="col-md-12 col-lg-12">
						<table class="table table-bordered tb_type03 smart-form">
							<colgroup>
								<col width="10%">
								<col width="25%">
								<col width="10%">
								<col width="25%">
								<col width="10%">
								<col width="20%">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">센터명 </th>
									<td>
										<sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')">
											<label class="select w250 mr5">
												<select id="centerCd" name="centerCd">
													<option value="">선택</option>
													<c:forEach var="center" items="${centerList }" varStatus="idx">
														<option value="<c:out value='${center.DEPT_CD }'/>" <c:out value="${center.DEPT_CD eq result.CENTER_CD ? 'selected=selected':'' }"/> ><c:out value="${center.DEPT_NM }"/></option>
													</c:forEach>
												</select> <i></i>
											</label>
										</sec:authorize>
										<sec:authorize access="hasRole('ROLE_ADMIN') or hasRole('ROLE_USER')">
											<input type="hidden" name="centerCd" value="<sec:authentication property="principal.centerId"/>" >
											<sec:authentication property="principal.centerNm"/>
										</sec:authorize>
									</td>
									<th scope="row">권한그룹명 </th>
									<td>
										<label class="input w250">
											<input type="text" id="authGrpNm" name="authGrpNm" value="<c:out value='${result.AUTH_GRP_NM}'/>">
										</label>
									</td>
									<th scope="row">사용여부 </th>
									<td>
										<div class="inline-group">
											<c:forEach var="list" items="${codeMap.SYS01 }" varStatus="idx">
												<label class="radio">
													<input type="radio" value="<c:out value='${list.CODE }'/>" name="useAt" <c:out value="${result.USE_AT eq list.CODE or idx.first ? 'checked=checked' :'' }"/>><i></i><c:out value="${list.CODE_NM }"/>
												</label>
											</c:forEach>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</article>
					
				</div>
				<!-- row 메뉴조회 끝 -->
				
				<!-- row 메뉴조회 시작 -->
				<div class="row">
					<article class="col-md-12 col-lg-12">
						<table class="table table-bordered tb_type03 smart-form">
							<colgroup>
								<col width="12%">
								<col width="12%">
								<col width="9.5%">
								<col width="9.5%">
								<col width="9.5%">
								<col width="9.5%">
								<col width="9.5%">
								<col width="9.5%">
								<col width="9.5%">
							</colgroup>
							<tbody>
								<tr>
									<th>메뉴코드</th>
									<th>메뉴명</th>
									<th>
										조회권한
										<label class="checkbox checkboxCenter">
                                            <input type="checkbox" name="readAt" class="rowAllChk"><i></i>
                                        </label>
									</th>
									<th>
										쓰기권한
										<label class="checkbox checkboxCenter">
                                            <input type="checkbox" name="insertAt" class="rowAllChk"><i></i>
                                        </label>
									</th>
									<th>
										수정권한
										<label class="checkbox checkboxCenter">
                                            <input type="checkbox" name="updateAt" class="rowAllChk"><i></i>
                                        </label>
									</th>
									<th>
										삭제권한
										<label class="checkbox checkboxCenter">
                                            <input type="checkbox" name="deleteAt" class="rowAllChk"><i></i>
                                        </label>
									</th>
									<th>
										엑셀다운
										<label class="checkbox checkboxCenter">
                                            <input type="checkbox" name="excelAt" class="rowAllChk"><i></i>
                                        </label>
									</th>
									<th>
										레포트
										<label class="checkbox checkboxCenter">
                                            <input type="checkbox" name="reportAt" class="rowAllChk"><i></i>
                                        </label>
									</th>
									<th>
										전체체크
										<label class="checkbox checkboxCenter">
                                            <input type="checkbox" class="allChk"><i></i>
                                        </label>
									</th>
								</tr>
								<c:forEach var="list" items="${rslist }" varStatus="idx">
									<tr>
										<td>
											<c:out value="${list.MENU_CD }"/>
											<input type="hidden" name="authList[<c:out value='${idx.index }'/>].menuCd" value="<c:out value='${list.MENU_CD}'/>">
										</td>
										<td><c:out value="${list.MENU_NM }"/></td>
										<td>
											<label class="checkbox checkboxCenter">
												<input type="checkbox" name="authList[<c:out value='${idx.index }'/>].readAt" <c:out value="${list.READ_AT eq 'Y'? 'checked=checked':''}"/> class="readAt" value="Y"><i></i>
											</label>
										</td>
										<td>
											<label class="checkbox checkboxCenter">
												<input type="checkbox" name="authList[<c:out value='${idx.index }'/>].insertAt" <c:out value="${list.INSERT_AT eq 'Y'? 'checked=checked':''}"/> class="insertAt" value="Y"><i></i>
											</label>
										</td>
										<td>
											<label class="checkbox checkboxCenter">
												<input type="checkbox" name="authList[<c:out value='${idx.index }'/>].updateAt" <c:out value="${list.UPDATE_AT eq 'Y'? 'checked=checked':''}"/> class="updateAt" value="Y"><i></i>
											</label>
										</td>
										<td>
											<label class="checkbox checkboxCenter">
												<input type="checkbox" name="authList[<c:out value='${idx.index }'/>].deleteAt" <c:out value="${list.DELETE_AT eq 'Y'? 'checked=checked':''}"/> class="deleteAt" value="Y"><i></i>
											</label>
										</td>
										<td>
											<label class="checkbox checkboxCenter <c:out value="${list.EXCEL_DOWN_AUTH eq 'N'? 'invisible':'' }"/>">
												<input type="checkbox" name="authList[<c:out value='${idx.index }'/>].excelAt" <c:out value="${list.EXCEL_AT eq 'Y'? 'checked=checked':''}"/> class="excelAt" value="Y"><i></i>
											</label>
										</td>
										<td>
											<label class="checkbox checkboxCenter <c:out value="${list.REPORT_AUTH eq 'N'? 'invisible':'' }"/>">
												<input type="checkbox" name="authList[<c:out value='${idx.index }'/>].reportAt" <c:out value="${list.REPORT_AT eq 'Y'? 'checked=checked':''}"/> class="reportAt" value="Y"><i></i>
											</label>
										</td>
										<td>
											<label class="checkbox checkboxCenter">
												<input type="checkbox" class="lineChk"><i></i>
											</label>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</article>
					
				</div>
				<!-- row 메뉴조회 끝 -->
			</form>
		</div>
	</section>
	<!-- widget grid end -->

</div>
<!-- END MAIN CONTENT -->