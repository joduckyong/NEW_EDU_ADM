<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
$(function(){
	var baseInfo = {
		insertKey : '<c:out value="${common.baseType[0].key() }"/>',
		updateKey : '<c:out value="${common.baseType[1].key() }"/>',
		deleteKey : '<c:out value="${common.baseType[2].key() }"/>',
		lUrl : "/ncts/mngr/simsaMngr/mngrSimsaApplicant.do",
		dUrl : "/ncts/mngr/simsaMngr/updateSimsaAppList.do",
		excel : "/ncts/mngr/simsaMngr/simsaAppExcelDownload.do"
	}	
	
    $.searchAction = function(){
        var no = 1;
        if(typeof(arguments[0]) != "undefined") no = arguments[0].pageNo;
        
		if($("#searchCondition2").val() == ""){
			alert("검색조건을 먼저 선택해주세요.");
			$("#searchCondition2").focus();
			return false;
		}        
        with(document.sForm){
            currentPageNo.value = no;
            action = baseInfo.lUrl;
            target='';
            submit();
        }
    }
	
	$.fn.updBtnOnClickEvt = function(url, key){
		var _this = $(this);
		_this.on("click", function(){
			if(!$("#iForm").valid()) {
				validator.focusInvalid();
				return false;
			}
			$.saveProc(url,key);	
		})
	}	
    
	$.fn.sumValueOnChangeEvt = function(){
		$(this).on("change", function(){
			var result = 0;
			var $tr = $(this).closest("tr");
			$tr.find(".sumValue").each(function(){
				var $element = $(this);
				result += Number($element.val());
			})
			$tr.find(".appSum").val(result);
		})
	}
	
	
	$.fn.searchCondition2OnChangeEvt = function(){
		$(this).on("change", function(){
			$.searchConditionOnSettings($(this).val());
		})
	}
			
	$.searchConditionOnSettings = function(thisVal){
		var searchCondition3Val = '<c:out value="${param.searchCondition3}"/>';
		if(thisVal != undefined && '<c:out value="${param.searchCondition2}"/>' != thisVal) searchCondition3Val = "";
		var searchCondition2Val = thisVal != undefined ? thisVal : '<c:out value="${param.searchCondition2}"/>';
		if(thisVal == undefined && '<c:out value="${rs.SIMSA_SEQ}"/>' != "") {
			searchCondition2Val = "sn";
			searchCondition3Val = '<c:out value="${rs.SIMSA_NUM}"/>';
		}
		
		$("#searchCondition3 option").remove();
		if(searchCondition2Val == "year") {
			for(var i=2023; i<currentYear; i++) {
				$("#searchCondition3").append("<option value="+ i +">"+ i +"</option>");
			}
		}
		else if(searchCondition2Val == "sn") {
			$.ajax({
				type: 'POST',
				url: "/ncts/mngr/simsaMngr/selectSimsaNumList.do",
				data: $("#sForm").serialize(),
				dataType: "json",
				async: false,
				success: function(result) {
					if(result.success == "success"){
						$(result.simsaNumList).each(function(){
							$("#searchCondition3").append("<option value="+ this.SIMSA_NUM +">"+ this.SIMSA_NUM +"</option>");
						});
					}		
				}	
			});
		}
		else $("#searchCondition3").append("<option value=''>선택</option>");
		
		if(searchCondition2Val != "") $("#searchCondition2 option[value="+ searchCondition2Val +"]").prop("selected", true);
		if(searchCondition3Val != "") {
			$("#searchCondition3 option[value="+ searchCondition3Val +"]").prop("selected", true);
			$("#searchYearTxt").html(searchCondition3Val);
		}
	}
	
	$.fn.appBigOnChangeEvt = function(){
		$(this).on("change", function(){
			var $this = $(this);
			var thisVal = $this.val() == ''? 'reset' : $this.val();
			$this.closest("tr").find(".appSmall option[value='']").prop("selected", true);
			$this.closest("tr").find(".appSmall").css("display", "none").addClass("disabled");
			$this.closest("tr").find(".appSmall." + thisVal).css("display", "block").removeClass("disabled");
		})
	}
	
	$.fn.formCheckOnSettings = function(){
		$(this).on("change keyup keypress", function(){
			var $this = $(this);
			var inputVal = $this.val();
			
			if($this.is(".appJubge")) {
				$this.val(inputVal.replace(/[^\ㄱ-ㅎㅏ-ㅣ가-힣\s,]/g,""));
			}
			if($this.is(".appDocNum")) {
				$this.val(inputVal.replace(/[^\ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9-,]/g,""));
			}
		})
	}
	
	$.saveProc = function(url, key){
		if(!confirm("저장하시겠습니까?")) return;
		$("#iForm input[name=procType]").val(key);
		$(".disabled").prop("disabled", true);
		$.beforSubmitRenameForModelAttribute();
		
		$.ajax({
			type: 'POST',
			url: url,
			data: $("#iForm").serialize(),
			dataType: "json",
			success: function(result) {
				$.afterSubmitRenameForView();
				alert(result.msg);
				if(result.success == "success") location.reload();
				else $(".disabled").prop("disabled", false);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				$.afterSubmitRenameForView();
				$(".disabled").prop("disabled", false);
			}
        });
	}	
	
	
	$.beforSubmitRenameForModelAttribute = function() {
		$("#iForm [name='appList.appSeq']").each(function(index){$(this).attr("name","appList["+index+"].appSeq");});
		$("#iForm [name='appList.appBig']").each(function(index){$(this).attr("name","appList["+index+"].appBig");});
		$("#iForm [name='appList.appSmall']").not(".disabled").each(function(index){$(this).attr("name","appList["+index+"].appSmall");});
		$("#iForm [name='appList.appJakyeok']").each(function(index){$(this).attr("name","appList["+index+"].appJakyeok");});
		$("#iForm [name='appList.appCareer']").each(function(index){$(this).attr("name","appList["+index+"].appCareer");});
		$("#iForm [name='appList.appSimsa']").each(function(index){$(this).attr("name","appList["+index+"].appSimsa");});
		$("#iForm [name='appList.appSum']").each(function(index){$(this).attr("name","appList["+index+"].appSum");});
		$("#iForm [name='appList.appResult']").each(function(index){$(this).attr("name","appList["+index+"].appResult");});
		$("#iForm [name='appList.appJubge']").each(function(index){$(this).attr("name","appList["+index+"].appJubge");});
		$("#iForm [name='appList.appNotice']").each(function(index){$(this).attr("name","appList["+index+"].appNotice");});
		$("#iForm [name='appList.appNoticeDe']").each(function(index){$(this).attr("name","appList["+index+"].appNoticeDe");});
		$("#iForm [name='appList.appDocNum']").each(function(index){$(this).attr("name","appList["+index+"].appDocNum");});
		$("#iForm [name='appList.appManager']").each(function(index){$(this).attr("name","appList["+index+"].appManager");});
	}	
	
	$.afterSubmitRenameForView = function() {
		$('[name^="appList"]').each(function(index) { 
			var orgName = $(this).attr("name");
			$(this).attr("name", orgName.replace(/\[[0-9]\]/g, ''));	
		});
	}	
	
    $.fn.excelDownOnClickEvt = function() {
    	$(this).on("click", function(e){
			$("[name='excelFileNm']").val("자격심사_"+$.toDay());
			$("[name='excelPageNm']").val("mngrSimsaAppList.xlsx");	        	
	        with(document.sForm){
	            target = "";
	            action = baseInfo.excel;
	            submit();
	        }
    	})
    }
    
    $.fn.onlyDpNumber = function(){
    	$(this).on("keyup change", function(){
    		var $this = $(this);
    		var thisVal = $this.val();
    		$this.val(thisVal.replace(/[^-\.0-9]/g,''));
    	})
    }
    
	
	$.initView = function(){
		$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
		$("#updBtn").updBtnOnClickEvt(baseInfo.dUrl, baseInfo.updateKey);
		$("#searchCondition2").searchCondition2OnChangeEvt();
		$.searchConditionOnSettings();
		$(".sumValue").sumValueOnChangeEvt();
		$(".onlyDpNum").onlyDpNumber();
		$(".appBig").appBigOnChangeEvt();
		$("input[type='text']").formCheckOnSettings();
		$(".excelDown").excelDownOnClickEvt();
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
	          	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
				<input type="hidden" name="excelPageNm">
				<input type="hidden" name="excelFileNm">
				<div class="fL wp70">
					<ul class="searchAreaBox">
						<c:if test="${not empty rs }">
							<li class="smart-form">
								<label class="label">· 회차 : <c:out value="${rs.SIMSA_NUM }"/>회차</label>
							</li>
							<li class="smart-form ml5">
							    <label class="label">· 접수기간 : <c:out value="${fn:substring(rs.SIMSA_DE, 0, 10)}"/> ~ <c:out value="${fn:substring(rs.SIMSA_END_DE, 0, 10)}"/></label>
							</li>
						</c:if>
						<c:if test="${empty rs }">
							<li class="smart-form">
								<label class="label">· 연도 : <span id="searchYearTxt"></span></label>
							</li>
						</c:if>
						
						<li class="smart-form ml5">
						    <label class="label">· 선택 : </label>
						</li>
						
						<li class="w150 mr5">							
	                           <select name="searchCondition2" class="form-control" id="searchCondition2">
	                           	<option value="">선택</option>
	                           	<option value="year">연도</option>
	                           	<option value="sn">회차</option>
	                           </select><i></i>                           
						</li>
	                      						
						 <li class="w150 mr5">  						  
							<select name="searchCondition3" class="form-control" id="searchCondition3">
								<option value="">선택</option>
							</select> <i></i>
						</li>
						
						<li class="ml10">
							<button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 조회</button>
						</li>
					</ul>
				</div>
	
				 <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
					<jsp:param value="list"     name="formType"/>
					<jsp:param value="1,3"     name="buttonYn"/>
				</jsp:include> 
                  
			</form>
		</div>
		<!-- Search 영역 끝 -->
		
		<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />


		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<form name="iForm" id="iForm" method="post" class="smart-form">
						<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						<table class="table table-bordered tb_type01"> 
						<!-- <table class="table table-bordered tb_type03"> -->
							<colgroup>
								<col width="5%">
								<col width="7%">
	                            <col width="7%">
	                            <col width="7.5%">
	                            <col width="5%">
	                            <col width="7%">
	                            <col width="3%">
	                            <col width="3%">
	                            <col width="3%">
	                            <col width="4%">
	                            <col width="6%">
	                            <col width="12.5%">
	                            <col width="7.5%">
	                            <col width="7.5%">
	                            <col width="7.5%">
	                            <col width="7.5%">
							</colgroup>
							<thead>
								<tr>
									<th class="invisible"></th>
									<th rowspan="2">회차</th>
									<th rowspan="2">접수일자</th>
									<th rowspan="2">신청인</th>
									<th rowspan="2">첨부</th>
									<th colspan="2">심사유형</th>
									<th colspan="6">심사평가</th>
									<th colspan="4">결과고지</th>
								</tr>
								<tr>
									<th>대분류</th>
									<th>소분류</th>
									<th>자격</th>
									<th>경력</th>
									<th>심사</th>
									<th>합계</th>
									<th>심사결과</th>
									<th>심사위원</th>
									<th>통보방법</th>
									<th>통보일자</th>
									<th>공문서번호</th>
									<th>담당자</th>
								</tr> 
							</thead>
							<tbody>
								<c:if test="${empty rslist }">
									<tr ><td colspan="16">데이터가 없습니다.</td></tr>
								</c:if>
								<c:forEach var="list" items="${rslist }" >
									<tr>
										<td class="invisible">
											<input type="hidden" class="index" name="appList.appSeq" value='<c:out value="${list.APP_SEQ }"/>'>
										</td>
										<td><c:out value="${list.SIMSA_NUM }"/></td>
										<td><c:out value="${fn:substring(list.APP_RECEIPT_DE, 0, 10) }"/></td>
										<td><c:out value="${list.USER_NM }"/></td>
										<td><c:out value="${list.fileView }"/></td>								
										<td>
											<select name="appList.appBig" class="form-control appBig">
												<option value="">선택</option>
												<option value="01" <c:out value="${list.APP_BIG eq '01'? 'selected':''}"/>>교육</option>
												<option value="02" <c:out value="${list.APP_BIG eq '02'? 'selected':''}"/>>강사</option>
											</select><i></i>
										</td>
										<td>
											<select name="appList.appSmall" class="form-control appSmall 01 <c:out value="${list.APP_BIG eq '01'? '':'disabled' }"/> style='<c:out value="${list.APP_BIG eq '01'? 'display:block;':'display:none;' }"/>'>
												<option value=">선택</option>
												<c:forEach var="dmh25" items="${codeMap.DMH25}" varStatus="idx">
													<option value='<c:out value="${dmh25.CODE}"/>' <c:out value="${list.APP_SMALL eq dmh25.CODE? 'selected':'' }"/>>
														<c:out value="${dmh25.CODE_NM}"/>
													</option>																									
												</c:forEach> 
											</select><i></i>
											<select name="appList.appSmall" class="form-control appSmall 02 <c:out value="${list.APP_BIG eq '02'? '':'disabled' }"/> style='<c:out value="${list.APP_BIG eq '02'? 'display:block;':'display:none;' }"/>'>
												<option value=">선택</option>
												<c:forEach var="dmh26" items="${codeMap.DMH26}" varStatus="idx">
													<option value='<c:out value="${dmh26.CODE}"/>' <c:out value="${list.APP_SMALL eq dmh26.CODE? 'selected':'' }"/>>
														<c:out value="${dmh26.CODE_NM}"/>
													</option>																									
												</c:forEach> 
											</select><i></i>							
											<select name="appList.appSmall" class="form-control appSmall reset <c:out value="${list.APP_BIG eq '' or empty list.APP_BIG? '':'disabled' }"/>" style='<c:out value="${list.APP_BIG eq '' or empty list.APP_BIG? 'display:block;':'display:none;' }"/>' >
												<option value="">선택</option>
											</select><i></i>							
										</td>
									
										<td>
											<label class="input w60">
												<input type="text" class="sumValue onlyDpNum w60" name="appList.appJakyeok" value='<c:out value="${list.APP_JAKYEOK }"/>' maxlength="4">
											</label>	
										</td>
										<td>
											<label class="input w60">
												<input type="text" class="sumValue onlyDpNum w60" name="appList.appCareer" value='<c:out value="${list.APP_CAREER }"/>' maxlength="4">
											</label>
										</td>
										<td>
											<label class="input w60">
												<input type="text" class="sumValue onlyDpNum w60" name="appList.appSimsa" value='<c:out value="${list.APP_SIMSA }"/>' maxlength="4">
											</label>
										</td>
								
										<td>
											<label class="input w60">
												<input type="text" name="appList.appSum" class="appSum" class="w60" value='<c:out value="${list.APP_SUM }"/>' readonly>
											</label>	
										</td>
										<td>
											<select name="appList.appResult" class="form-control">
												<option value="">선택</option>
												<c:forEach var="dmh28" items="${codeMap.DMH28}" varStatus="idx">
													<option value='<c:out value="${dmh28.CODE}"/>' <c:out value="${dmh28.CODE eq list.APP_RESULT ? 'selected':''}"/>>
														<c:out value="${dmh28.CODE_NM}"/>
													</option>																									
												</c:forEach> 												
											</select><i></i>										
										</td>
										<td>
											<label class="input">
		                               			<input type="text" class="appJubge" name="appList.appJubge" value='<c:out value="${list.APP_JUBGE }"/>' maxlength="100">
		                            		</label>										
										</td>
										<td>
											<select name="appList.appNotice" class="form-control">
												<c:forEach var="dmh27" items="${codeMap.DMH27}" varStatus="idx">
													<option value='<c:out value="${dmh27.CODE}"/>' <c:out value="${dmh27.CODE eq list.APP_NOTICE ? 'selected':'' }"/>>
														<c:out value="${dmh27.CODE_NM}"/>
													</option>																									
												</c:forEach> 
											</select><i></i>
										</td>
										<td>
											<label class="input w120"> <i class="icon-append fa fa-calendar"></i>
		                               			<input type="text" class="date inputcal" name="appList.appNoticeDe" value='<c:out value="${list.APP_NOTICE_DE }"/>'>
		                            		</label>
	                            		</td>
										<td>
											<label class="input w120">
		                               			<input type="text" class="appDocNum" name="appList.appDocNum" value='<c:out value="${list.APP_DOC_NUM }"/>' maxlength="100">
		                            		</label>											
										</td>
										<td>
											<label class="input w120">
		                               			<input type="text" class="" name="appList.appManager" value='<c:out value="${list.APP_MANAGER }"/>' maxlength="100">
		                            		</label>										
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

