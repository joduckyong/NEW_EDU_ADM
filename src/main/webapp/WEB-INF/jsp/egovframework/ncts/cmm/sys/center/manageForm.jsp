<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

$(function(){
	var baseInfo = {
			lUrl : "${pageInfo.READ_AT eq 'Y' ? pageInfo.MENU_URL : pageInfo.MENU_DETAIL_URL   }",
			fUrl : "${pageInfo.MENU_DETAIL_URL }"
	}	
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				userId       : {required       : ['사용자ID']},
				userNm       : {required       : ['사용자명']},
				userBirth    : {required       : ['생년월일']},
				userGender   : {required       : ['성별']},
				userHp       : {required       : ['핸드폰번호']},
				userEmail    : {required       : ['이메일']},
				useAt        : {required       : ['사용여부']},
				groupId        : {required       : ['권한']}
			}
		});
	}
	
	$.setReadonly = function(){
		$("#iForm").readonly({
			basekey  : "${common.baseType[1].key()}" ,
			paramkey : "${common.procType}", 
			tags: {
				menuCd         : {className : "userId",  readonly  : true},
				parentCd       : {className : "isReadonly",  readonly  : true},
			}
		});
	}
	
	$.saveProc = function(){
		if(!confirm("저장하시겠습니까?")) return;
		if($("#dupChk").val()=="N"){
			alert("중복확인을 해주시기 바랍니다.");
			return;
		}
		if($(".onlyNum").val().length != 13){
			alert("핸드폰번호 형식에 맞게 입력해주세요");
			 $(".onlyNum").focus();
			return;
		}
		var emailCheck = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
        if(!emailCheck.test($("input[name=userEmail]").val())){
        	alert("이메일 형식에 맞게 입력해주시기 바랍니다.");
        	 $("input[name=userEmail]").focus();
        	return false;
        }
		$.ajax({
			type			: "POST",
			url				: "/ncts/cmm/sys/center/manageProcess.do",
			data			: $('#iForm').serialize(),
			dataType		: 'json',
			success			: function(result) {
				
				if(result.success == "success"){
					
					alert(result.msg);
					$.searchAction();
				} 			
					
			}
		});
		
	}
	
	$.searchAction = function(){
		with(document.sForm){
			action = baseInfo.lUrl;
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
	
	$.fn.centerComboOnChageEvt = function(){
		var _this = $(this);
		_this.on("change", function(){
			var $this = $(this);
			var groupid = $this.find("option:selected").data("groupid");
			if($.isNullStr(groupid)){
				alert("권한을 맵핑해주세요.");
				location.replace("/ncts/cmm/sys/auth/authMappingForm.do");
			}
		})
	}
	
	$.fn.initPwdBtnOnClickEvt = function(){
		var _this = $(this);
		_this.on("click", function(){
			if(!confirm("비밀번호를 초기화 하시겠습니까?")) return;
			var $this = $(this);
			
			$.ajax({
				type			: "POST",
				url				: "/ncts/cmm/sys/user/userInitPwd.do",
				data			: $('#iForm').serialize(),
				dataType		: 'json',
				success			: function(result) {
					alert(result.msg);
				}
			});
		})
	}
	
	
	$.fn.userIdChkBtnOnClickEvt = function(){
		var _this = $(this);
		_this.on("click", function(){
			$.ajax({
				type: 'POST',
				url: "/ncts/cmm/sys/center/selectUserIdDupChk.do",
				data: $("#iForm").serialize(),
				dataType: "json",
				success: function(data) {
					if(data.success == "success"){
						if($("#userId").val() != ''){
							if(data.rsType == "01"){
								 alert("중복된 사용자ID가 없습니다.");
								$("#dupChk").val("Y");
							}else if(data.rsType == "02"){
								if(!confirm("기존에 등록된 사용자ID가 있습니다.\n 새로 등록하시겠습니까?")) return;
								$("#userId").val("");
							} 	
						}else{
							alert("사용자ID를 입력해주십시오."); 
							return;
						}
					}
				}
			})
		})
	}
	
	
	
	$.initView = function(){		
		$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
		$("#listBtn").goBackList($.searchAction);
		$.setValidation();
		$("#saveBtn").saveBtnOnClickEvt();
		$("#centerCd").centerComboOnChageEvt();
		$("#userIdChk").userIdChkBtnOnClickEvt();
		$("#initPwd").initPwdBtnOnClickEvt();
	}
	
	$.initView(); 
	
})

$(document).on("keyup", ".phoneNumber", function() {
	$(this).val( $(this).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/,"$1-$2-$3").replace("--", "-") ); 
	});
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
				<input type="hidden" name="searchKeyword1" class="form-control" value="${param.searchKeyword1}"> 
				<input type="hidden" name="searchKeyword2" class="form-control" value="${param.searchKeyword2}"> 
				<input type="hidden" name="searchCondition2" class="form-control" value="${param.searchCondition2}"> 
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
					<form name="iForm" id="iForm" method="post" class="smart-form"  >
						<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						<input type="hidden" id="userId2" value="${result.USER_ID }">
						<c:if test="${ common.procType eq common.baseType[0].key()  }">
							<input type="hidden" id="dupChk" value="N">
						</c:if>
						<c:if test="${ common.procType eq common.baseType[1].key()  }">
							<input type="hidden" id="dupChk" value="Y">
						</c:if>
						<input type="hidden" id="orginlLockAt" name="orginlLockAt" value="${result.LOCK_AT }">
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="10%">
								<col width="*">
								<col width="10%">
								<col width="*">
								<col width="10%">
								<col width="*">
								<col width="10%">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">사용자ID </th>
									<td>
										<label class="input w150 fL">
											<c:if test="${common.procType ne common.baseType[1].key()}">
												<input type="text" id="userId" name="userId" value="${result.USER_ID}">
											</c:if>
											<c:if test="${common.procType eq common.baseType[1].key()}">
												<input type="text" id="userId" name="userId" value="${result.USER_ID}" readonly>
											</c:if>
										</label>
										<label class="input col ml5 fR">
											<button class="btn btn-primary " type="button" id="userIdChk" <c:if test="${common.procType eq common.baseType[1].key()}">style="display:none;"</c:if>><i class="fa fa-search"></i> 중복확인</button>
										</label>
									</td>
									<th scope="row">사용자명 </th>
									<td>
										<label class="input w250">
											<input type="text" id="userNm" name="userNm" value="${result.USER_NM}">
										</label>
									</td>
									<th scope="row">생년월일 </th>
									<td>
										<label class="input w250">
											<i class="icon-append fa fa-calendar"></i>
											<input type="text" id="userBirth" class="inputcal" name="userBirth" value="${result.USER_BIRTH}">
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">성별 </th>
									<td>
										<div class="inline-group">
											<c:forEach var="list" items="${codeMap.SYS02 }" varStatus="idx">
												<label class="radio">
													<input type="radio" id="${list.CODE }" value="${list.CODE }" name="userGender" ${result.USE_AT eq list.CODE or idx.first ? 'checked="checked"' :'' }><i></i>${list.CODE_NM }
												</label>
											</c:forEach>
										</div>
									</td>
									<th scope="row">핸드폰번호 </th>
									<td>
										<label class="input w250">
											<input class="phoneNumber onlyNum" type="text" id="userHp" maxlength='13' name="userHp" value="${result.USER_HP}">
										</label>
									</td>
									<th scope="row">이메일 </th>
									<td>
										<label class="input w250">
											<input type="text" id="userEmail" name="userEmail" value="${result.USER_EMAIL}" >
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">센터 </th>
									<td>
										<sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')">
											<label class="select w250 mr5">
												<select id="centerCd" name="centerCd">
												<option value="">선택</option>
												<c:forEach var="center" items="${centerList }" varStatus="idx">
													<option value="${center.DEPT_CD }" data-groupId="${center.GROUP_ID }" ${center.DEPT_CD eq result.CENTER_CD ? 'selected="selected"':'' } >${center.DEPT_NM }</option>
												</c:forEach>
											</select> <i></i>
											</label>
										</sec:authorize>
										<sec:authorize access="hasRole('ROLE_ADMIN') or hasRole('ROLE_USER')">
											<input type="hidden" name="centerCd" value="<sec:authentication property="principal.centerId"/>" >
											<sec:authentication property="principal.centerNm"/>
										</sec:authorize>
									</td>
									
									<th scope="row">권한</th>
									<td>
										<div class="inline-group w200">
											<select id="groupId" name="groupId" class="form-control">
												<option value="">선택</option>
												<c:forEach var="list" items="${authList }" varStatus="idx">
													<option value="${list.AUTH_GRP_NO}" ${result.AUTH_GRP_NO eq list.AUTH_GRP_NO  ? 'selected' :'' }>${list.AUTH_GRP_NM}</option>
												</c:forEach>
											</select>
										</div>
									</td>
									<th scope="row">사용자유형 </th>
									<td>
										<label class="input w100">
											<select id="roleNm" name="roleNm" class="form-control">
												<c:forEach var="list" items="${codeMap.SYS03 }" varStatus="idx">
													<sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')">
														<c:if test="${list.CODE ne 'ROLE_SYSTEM' and list.CODE ne 'ROLE_MASTER' and list.CODE ne 'ROLE_USER'}">
															<option value="${list.CODE }" ${result.ROLE_NM eq list.CODE  ? 'selected' :'' }>${list.CODE_NM }</option>
														</c:if>
													</sec:authorize>
												</c:forEach>
											</select> <i></i>
										</label>
									</td>
								</tr>
								<tr>
									<th scope="row">자격</th>
									<td>
										<label class="select col w150 mr5">
											<select name="userQualf">
												<option value="">선택</option>
												<c:forEach var="cd" items="${codeMap.NCTS10 }">
													<option value="${cd.CODE }" ${result.USER_QUALF eq cd.CODE ? 'selected':''}>${cd.CODE_NM }</option>
												</c:forEach>	
											</select> <i></i>
										</label>
									</td>
									<th scope="row">사용여부 </th>
									<td>
										<div class="inline-group">
											<c:forEach var="list" items="${codeMap.SYS01 }" varStatus="idx">
												<label class="radio">
													<input type="radio" value="${list.CODE }" name="useAt" ${result.USE_AT eq list.CODE or idx.first ? 'checked="checked"' :'' }><i></i>${list.CODE_NM }
												</label>
											</c:forEach>
										</div>
									</td>
									<th scope="row">잠금여부 </th>
									<td>
										<div class="inline-group">
											<label class="radio">
												<input type="radio" value="N" name="lockAt" ${result.LOCK_AT eq 'N' or empty result.LOCK_AT ? 'checked="checked"' :'' }><i></i>미잠금
											</label>
											<label class="radio">
												<input type="radio" value="Y" name="lockAt" ${result.LOCK_AT eq 'Y' ? 'checked="checked"' :'' }><i></i>잠금
											</label>
										</div>
									</td>											
									<td colspan="4">
										<button class="btn btn-danger ml2" id="initPwd"  style="padding: 7px 13px;" data-seq="0" type="button">
											<i class="fa fa-refresh" title="초기화"></i> 패스워드 초기화
										</button>
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