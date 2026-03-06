<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">

$(function(){
	var baseInfo = {
			insertKey : "${common.baseType[0].key() }",
			updateKey : "${common.baseType[1].key() }",
			deleteKey : "${common.baseType[2].key() }",
			lUrl : "/ncts/mngr/simsaMngr/mngrSimsaList.do",
			fUrl : "/ncts/mngr/simsaMngr/mngrSimsaForm.do", 
			dUrl : "/ncts/mngr/simsaMngr/mngrSimsaProcess.do",
			aUrl : "/ncts/mngr/simsaMngr/mngrSimsaDelete.do",
			bUrl : "/ncts/mngr/simsaMngr/mngrSimsaApplicant.do",
			excel : "/ncts/mngr/simsaMngr/mngrSimsaAppExcelDownload.do"
	}
	
	$.checkDownloadCheck = function(){
        FILEDOWNLOAD_INTERVAL = setInterval(function() {
             if (document.cookie.indexOf("fileDownloadToken=true") != -1) {
                excelPg = 0;
                clearInterval(FILEDOWNLOAD_INTERVAL);
                $.loadingBarClose();
              }
        }, 500);
    }
	
	$.dataDetail = function(index){ 
		
		
		
		if(!($("input.index:checked").size() > 0 && $(".tr_clr_2").length > 0)) { 
			
				$("#detailTable").html('<tr class="noCheck"><td colspan="6" class="textAlignCenter">항목을 선택해주세요.</td></tr>');
				$("#applicantTable").html('<tr class="noData"> <td colspan="6">항목을 선택해주세요.</td></tr>');	
				$("#simsa").handlerbarsCompile($("#simsa-template"), null); 
				$("#excelBtn").hide();
				
			}else{ 
			
			
			document.sForm.simsaSeq.value = index;
			
			
			$.ajax({
				type: 'POST',
				url: "/ncts/mngr/simsaMngr/simsaListDetail.do",
				data: $("#sForm").serialize(),
				dataType: "json",
				async : false,
				success: function(data) {
					if(data.success == "success"){
						
						$("#detailTable").handlerbarsCompile($("#detail-template"), data.rs);
						$("#applicantTable").handlerbarsCompile($("#applicant-template"), data.de);
						$("#simsa").handlerbarsCompile($("#simsa-template"), data.rs);
						$("#people").handlerbarsCompile($("#people-template"), data.allList);
						$("#excelBtn").show();
						
					}
				}
			})
			
			 
	}
		$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
		$.datepickerOnSettings();
}
	
	
	
	 $.fn.saveBtnFunc = function(){
		var _this = $(this);
		_this.on("click", function(){
			
		 	var index = $("input.index:checked").val();
				$.dataDetail(index); 
				$(".dim-layer").css("display","block"); 
			
		})
	}  
	 
	

  
	 $.procAction = function(pUrl, pKey){
			with(document.sForm){
					procType.value = pKey;
					action = pUrl;
					target='';
					submit();
				}
			}
	 
	
	$.fn.procBtnOnClickEvt = function(url, key){
		var _this = $(this);
		_this.on("click", function(){
			if(baseInfo.insertKey != key){
				if(!($("input.index:checked").size() > 0 && $(".tr_clr_2").length > 0)) {  
					alert("항목을 선택하시기 바랍니다.");
					return false;
				}else{
					document.sForm.simsaSeq.value = $("input.index:checked").val(); 
				} 
			}else{
				document.sForm.simsaSeq.value = "";
			}
			
			if(baseInfo.deleteKey == key){
				$.delAction(url, key); 
			}else if(baseInfo.updateKey == key){
				$.procAction(url, key);	
			}
		})
	}
	
	
	
	$.searchAction = function(){
		var no = 1;
        if(typeof(arguments[0]) != "undefined") no = arguments[0].pageNo;
        with(document.sForm){
        	currentPageNo.value = no;
        	action = baseInfo.lUrl;
            target='';
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
			success: function(dd) {
			if(dd != null){
				
				if(dd[0].fail == "fail"){ 
					
					alert("자격심사가 진행중이거나 마감되어 삭제가 불가능합니다");
					
				}else if(dd[0].success == "success"){ 
					alert(dd[0].msg); 
					$.searchAction();
					
				}
				
			  }		
			}	
		});
	
	  
	}
	
	
	
	
	
	$.setValidation = function(){
		validator = $("#aForm").validate({
			ignore : "",
			rules: {
				
				useAt            : {required       : ['Active']},
				simsaDe			 : {required       : ['시작날짜']},
				simsaEndDe       : {required       : ['종료날짜']},
				simsaTitle       : {required       : ['제목']}
				
			}
		});
	}
	
	

	$.saveProc = function(url,key){
		if(!confirm("저장하시겠습니까?")) return;
		
		//var actCnt = $("#sForm input[name=actCnt]").val();
		var isChecked = $("#inp1").is(':checked');
		
		
		
			var index = document.aForm.simsaSeq.value;
		
		if(($("input.index:checked").size() > 0 && $(".tr_clr_2").length > 0)){  
			
			
			
				document.aForm.simsaSeq.value = $("input.index:checked").val();
				
				$("#aForm input[name=procType]").val(baseInfo.updateKey);
			
			
		}else if($.isNullStr(index)){ 
			
			
			
			$("#aForm input[name=procType]").val(key);
			
		}
		
		
		
		
		$.ajax({
			
			type: 'POST',
			url: url,
			data: $("#aForm").serialize(),
			dataType: "json",
			success: function(rr) {
				
				
		if(rr != null){
				
				if(rr[0].actCnt != null){ 
					
					if((rr[0].actCnt == 1) && ($("#inp1").is(':checked'))){ 
					
						alert("이미 활성화된 자격심사가 있습니다.");
						$("#inp1").prop("disabled", true).prop("checked", false);
						$("#inp2").prop("disabled", false);
						return;
						
					}else if((rr[0].actCnt == 1) && ($("#inp2").is(':checked'))){ 
						
						alert(rr[0].msg);
						if(rr[0].success == "success") location.replace(baseInfo.lUrl);
						
						
					
					}  
					
					
				}else if (rr[0].success != null){ 
					
					
					alert(rr[0].msg);
					if(rr[0].success == "success") location.replace(baseInfo.lUrl);
				}
				
			   }
			}
        });
		
	
	
	
		
       
		
	} 
	
	$.fn.saveBtnOnClickEvt = function(url, key){
		
		var _this = $(this);
		_this.on("click", function(){
			if(!$("#aForm").valid()) {
				validator.focusInvalid();
				return false;
			}
			$.saveProc(url,key);	
		})
	}
	
	 
	$(document).on("click", "#close", function(){
    	
    	$(".dim-layer").css("display","none");
    });
	
	
   
	$.datepickerOnSettings = function(){
		 var simsaDe = $("#simsaDe").datepicker("getDate");  
		if(simsaDe != null) simsaDe.setDate(simsaDe.getDate()-1);
		
		 $("#simsaDe").datepicker("option", "maxDate", $("#simsaEndDe").val());
		$("#simsaEndDe").datepicker("option", "minDate", $("#simsaDe").val());
			
		
		$("#simsaDe").datepicker("option", "onClose", function ( selectedDate ){
			
			simsaDe = $("#simsaDe").datepicker("getDate");
			if(simsaDe != null) simsaDe.setDate(simsaDe.getDate() - 1);
			$("#simsaEndDe").datepicker( "option", "minDate", selectedDate);
			
		});	 
		

		$("#simsaEndDe").datepicker("option", "onClose", function ( selectedDate ){$("#simsaDe").datepicker( "option", "maxDate", selectedDate );}); 
	
	}
	
	
	
	
	

	
	$.initView = function(){
		
		$("#saveBtn").saveBtnFunc();
		$.setValidation();
		
		$("#save").saveBtnOnClickEvt(baseInfo.dUrl, baseInfo.insertKey);
		$.onClickTableTr2();
		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
		$("#delBtn").procBtnOnClickEvt(baseInfo.aUrl, baseInfo.deleteKey);
		$("#updBtn").procBtnOnClickEvt(baseInfo.bUrl, baseInfo.updateKey);
		
		$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
		
		$(".excelDown").on("click", function(e){
        	excelPg = 1;
			$("[name='excelFileNm']").val("자격심사_"+$.toDay());
			$("[name='excelPageNm']").val("mngrSimsaAppList.xlsx");	     	        	
            with(document.sForm){
                target = "";
                action = baseInfo.excel;
                submit();
                
                $.setCookie("fileDownloadToken","false");
                $.loadingBarStart(e);
                $.checkDownloadCheck();
            }
        });
		
		
		
	}
	
	
	$.initView();
	
	
})
</script>

		
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/ribbon.jsp" flush="false" />


<!-- MAIN CONTENT -->
<div id="content">
<form name="aForm" id="aForm" method="post">
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
	<input type="hidden" name="simsaSeq"  value="" >
	<input type="hidden" name="simsaStartYn" id="simsaStartYn" value="">
	<input type="hidden" name="simsaEndYn" id="simsaEndYn" value="">
	<div class="dim-layer" style="display: none;">
        <div class="dimBg"></div>
        <div id="layer1" class="popup-con w800 p15" style="z-index: 0;">
          <h1 class="page-title txt-color-blueDark tLeft"><i class="fa fa-pencil-square-o fa-fw "></i>자격심사 등록</h1>

          <div class="tbl_box">
            <table>
              <colgroup>
                <col style="width: 15%;">
                <col style="width: 30%;">
                <col style="width: 15%;">
                <col style="width: 40%;">
              </colgroup>
              <tbody id="simsa">
                
              </tbody>
            </table>
          </div>

          <div class="btn_box fClr p0">
           	<button type="button" class="fRight" id="close">닫기</button>
            <button type="button" class="fRight" id="save">저장</button> 
            
          </div>
        </div>
      </div>
</form>
<script id="simsa-template" type="text/x-handlebars-template">
<tr>
                  <th>회차</th>
                  	    
                  	<td><input type="text" value="{{SIMSA_NUM}}" style="width:30px;" readonly>회차</td>
                  	
                  <th>Active</th>
                  <td>
                    <p class="inp_radio">
                 
                     
                      <label for="inp1">
                        <input type="radio" id="inp1" name="useAt" value="Y"  {{#ifeq USE_AT 'Y'}} checked="checked" {{/ifeq}}>
                        <span>활성화</span>
                      </label>
                      
                      <label for="inp2">
                        <input type="radio" id="inp2" name="useAt" value="N" {{#ifeq USE_AT 'N'}} checked="checked" {{/ifeq}}>
                        <span>비활성화</span>
                      </label>
                      
                    </p>
                  </td>
                </tr>
                <tr>
                  <th>접수기간</th>
                  <td colspan="3">
                    <ul class="searchAreaBox">
                     <li class="smart-form">
                        <label class="input w120"> <i class="icon-append fa fa-calendar"></i>
                          		 <input type="text" class="date inputcal" name="simsaDe" id="simsaDe" value="{{SIMSA_DE}}" {{#ifeq SIMSA_START_YN 'Y'}} disabled="disabled" {{/ifeq}}> 
                        </label>
                      </li>
                      
                      <li class="ml5 mr5 mt7">
                        <label class="label">-</label>
                      </li>
                      
                      <li class="smart-form">
                        <label class="input w120"> <i class="icon-append fa fa-calendar"></i>
                           <input type="text" class="date inputcal" name="simsaEndDe" id="simsaEndDe" value="{{SIMSA_END_DE}}" > 
                        </label>
                      </li>
                    </ul>
                  </td>
                </tr>
                <tr>
                  <th>제목</th>
                  	<td colspan="3">
                  		 <input type="text" id="simsaTitle" name="simsaTitle" value="{{SIMSA_TITLE}}" >    		
					</td>
                </tr>

</script>
     
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/menuTitle.jsp" flush="false" />	
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
          		<input type="hidden" name="excelFileNm" id="excelFileNm"  value="">
				<input type="hidden" name="excelPageNm" id="excelPageNm"  value=""> 
          	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
				<input type="hidden" name="simsaSeq" id="simsaSeq" value="" >
				<c:forEach items="${rr }" var="rr">
					<input type="hidden" id="actCnt" name="actCnt" value="${rr.actCnt}" >
					<input type="hidden" id="msg" name="msg" value="${rr.msg}" >
					<input type="hidden" id="success" name="success" value="${rr.success}" >
				</c:forEach>
				
				<div class="fL wp70">
					<ul class="searchAreaBox">
						<!-- <li class="smart-form"> -->
						<li class="smart-form ml5">
						    <label class="label">접수기간</label>
						</li>
                        <li class="smart-form ml5">
                            <label class="input w120"> <i class="icon-append fa fa-calendar"></i>
                                <input type="text" class="date inputcal" name="sDate01" id="sDate01" value='<c:out value="${param.sDate01 }"/>'>
                            </label>
                        </li>
                       <!--  <li class="ml5 mr5 mt7"> -->
                        <li class="smart-form mr5">
                            <label class="label"> &nbsp;&nbsp;&nbsp;~ </label>  
                        </li>
                        <!-- <li class="smart-form ml5 mr10"> -->
                        <li class="smart-form mr5">
                            <label class="input w120"> <i class="icon-append fa fa-calendar"></i>
                                <input type="text" class="date inputcal"name="sDate02" id="sDate02" value='<c:out value="${param.sDate02}"/>'>
                            </label>
                        </li>
						
						<!-- <li class="smart-form"> -->
						<li class="smart-form mr5">
						    <label class="label">Active</label>
						</li>
						
						 <li class="w150 mr5">  						  
							<select name="searchCondition1" class="form-control" id="searchCondition1">
								<option value="">전체</option>
								<option value="D" ${param.searchCondition1 eq 'D' ? 'selected="selected"':'' }>대기중</option>
					    		<option value="J" ${param.searchCondition1 eq 'J' ? 'selected="selected"':'' }>진행중</option>
					    		<option value="M" ${param.searchCondition1 eq 'M' ? 'selected="selected"':'' }>마감</option>
					    		<option value="N" ${param.searchCondition1 eq 'N' ? 'selected="selected"':'' }>비활성화</option>					    		
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
				
                  
			</form>
		</div>
		<!-- Search 영역 끝 -->
		

		<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />
		
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-6">
					<table class="table table-bordered tb_type01 listtable2">
						<colgroup>
							<col width="10%">
							<col width="30%">
                            <col width="20%">
                            <col width="*">
                            <col width="*">
                            <col width="*">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>회차</th>
								<th>제목</th>
								<th>접수기간</th>
								<th>신청자</th>
								<th>심사완료</th>
								<th>Active</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr ><td colspan="6">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list }" varStatus="idx">
								<tr>
									<td class="invisible">
										<input type="checkbox" class="index" value="${list.SIMSA_SEQ }">
									</td>
									<td>${list.SIMSA_NUM }</td>
									<td>${list.SIMSA_TITLE }</td>
									<td>${list.SIMSA_DE} ~ ${fn:substring(list.SIMSA_END_DE,5,10) }</td>
									<td>${list.APP_ALL_CNT }</td>
									<td>${list.APP_PASS_CNT }</td>
									<td>
										<c:if test="${list.USE_AT eq 'Y'}">
											
											<c:if test="${list.SIMSA_START_YN eq 'N'}">
												대기중
											</c:if>
											<c:if test="${list.SIMSA_START_YN eq 'Y' and list.SIMSA_END_YN eq 'Y'}">
												진행중
											</c:if>
											<c:if test="${list.SIMSA_START_YN eq 'Y' and list.SIMSA_END_YN eq 'N'}">
												마감
											</c:if> 
										</c:if>
										
										<c:if test="${list.USE_AT eq 'M'}">
											마감
										</c:if>
										
										<c:if test="${list.USE_AT eq 'N'}">
											비활성화
										</c:if>
										
										
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" />
				</article>
				
				<article class="col-md-12 col-lg-6">
					<table class="table table-bordered tb_type03">
						<colgroup>
							<col width="10%">
							<col width="*">
							<col width="10%">
							<col width="*">
							<col width="10%">
							<col width="*">
						</colgroup>
						<tbody id="detailTable">
							<tr class="noCheck"><td colspan="6" class="textAlignCenter">항목을 선택해주세요.</td></tr>
						</tbody>
					</table>
					
					
               
				<div id="excelBtn" style="display: none;">
					<table>
						<colgroup>
							<col width="100%">
						</colgroup>
						<tbody id="people">
						
							<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
								<jsp:param value="list"     name="formType"/>
								<jsp:param value="1"     name="buttonYn"/>
							</jsp:include>
						</tbody>
					</table>
					
					
				<div class="tb_stky small" style="width:100%;overflow:auto">
					
					<table class="table table-bordered table-hover tb_type01">
						<colgroup>
							<col width="10%">
		                    <col width="15%">
		                    <col width="15%">
		                    <col width="15%">
		                    <col width="auto">
		                    <col width="15%">
						</colgroup>
						<tbody id="applicantTable">							
							
						</tbody>
					</table>
					
				</div>
			</div>
				</article>
			</div>
			<!-- row 메뉴조회 끝 -->
		</div>
	</section>
	<!-- widget grid end -->

</div>
<!-- END MAIN CONTENT -->
<script id="people-template" type="text/x-handlebars-template">

<tr>
	<td><b>˙ 접수인원 : {{ALLNUM }} ( {{DIID}} /<span style="color:red;"> {{YET}}</span> ) </b>[ 전체인원 (심사완료/심사대기) ] </td>

</tr>

</script>
<script id="detail-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">회차 </th>
		<td>{{SIMSA_NUM}}</td>
	<th scope="row">접수기간</th> 
		<td>{{SIMSA_DE}} ~ {{SIMSA_END_DE}}</td>
	<th>Active</th>
		<td>
			
		{{#ifeq USE_AT 'Y'}}
				{{#ifeq SIMSA_START_YN 'N'}}
						대기중
				{{/ifeq}}
				
				{{#ifeq SIMSA_START_YN 'Y'}}
					{{#ifeq SIMSA_END_YN 'Y'}}
						진행중
					{{/ifeq}}

					{{#ifeq SIMSA_END_YN 'N'}}
						마감
					{{/ifeq}}
				{{/ifeq}}

			{{/ifeq}}
			
			{{#ifeq USE_AT 'M'}}
				마감
			{{/ifeq}}

			{{#ifeq USE_AT 'N'}}
				비활성화
			{{/ifeq}}

	
			
			
		</td>
</tr>
<tr>
	<th scope="row">제목</th>
	<td colspan="5">
		{{SIMSA_TITLE}}
	</td>
</tr>

</script>
<script id="applicant-template" type="text/x-handlebars-template">
<tr>
	<th>성명</th>
	<th>ID</th>
	<th>회원등급</th>
	<th>연락처</th>
	<th>이메일</th>
	<th>심사결과</th>
		
</tr>
{{#if .}}
{{#each .}}
	<tr>
		<td>{{USER_NM}}</td>
		<td>{{USER_ID}}</td>
		<td>{{DETAIL_GRADE_CD}}</td>
		<td>{{USER_HP_NO}}</td>
		<td>{{USER_EMAIL}}</td>
		<td>{{APP_RESULT_NM}}</td>
	</tr>
{{/each}}
{{else}}
	<tr class="noData">                           
		<td colspan="6">신청자가 없습니다.</td>             
	</tr>
{{/if}}
</script>
