 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
  .fClr:after {display: block;content: "";clear: both;}
  .fLeft {float: left;}
  .fRight {float: right;}
  .fa-times:before {content: "\f00d";font-size: 24px;color: #fff;}

  .popup-con * {margin: 0;padding: 0;box-sizing: border-box;}
  .popup-con {position: fixed;left: 50%;top: 50%;transform: translate(-50%, -50%);width: 530px; height: auto;text-align: center;box-shadow: 2px 2px 3px rgba(0, 0, 0, .1), -2px 2px 3px rgba(0, 0, 0, .1), 2px -1px 3px rgba(0, 0, 0, .1), -2px -1px 3px rgba(0, 0, 0, .1);}
  .popup-con .close_box {height: 30px;background: #57698e;}
  .popup-con .close_box p {margin-left: 10px;line-height: 30px;font-size: 14px;font-weight: bold;color: #fff;}
  .popup-con .close_box a {padding: 2px 8px;}
  .popup-con .text_box {width: 100%;border-bottom: 1px solid #9ca2a7;border-left: 1px solid #9ca2a7;border-right: 1px solid #9ca2a7;background-color:white;}
  .popup-con textarea {margin: 10px 0;padding: 5px;width: 510px;height: 120px;border: 1px solid #ccc;resize: none;}
  .popup-con button {margin-bottom: 10px;width: 65px;height: 32px;color: #fff;background: #3276b1;border: 1px solid #2c699d;border-radius: 2px;}
</style>
<script type="text/javascript">
	$(function(){
		var excelPg = 0;
	    var baseInfo = {
	            insertKey : "<c:out value='${common.baseType[0].key() }'/>",
	            updateKey : "<c:out value='${common.baseType[1].key() }'/>",
	            deleteKey : "<c:out value='${common.baseType[2].key() }'/>",
	            lUrl : "/ncts/mngr/instrctrMngr/instrctrSttusList.do",
	            excel : "/ncts/mngr/instrctrMngr/instrctrSttusExcelDownload.do",
	            pop01 : "/ncts/mngr/userMngr/mngrFileConfirmListPopup.do",
	            instrctrDetailPop : "/ncts/mngr/instrctrMngr/instrctrDetailPopup.do"
	    }
	    
	    $.dataDetail = function(index){
	        if($.isNullStr(index)) return false;
	        document.sForm.reqstSeq.value = index;
	        var obj = $.hiddenObj($(".index:checked"));
	        document.sForm.eduDivision.value = obj.eduDivision;
	        document.sForm.rank.value = obj.rank;
	        
	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/instrctrMngr/instrctrSttusDetail.do",
	            data: $("#sForm").serialize(),
	            dataType: "json",
	            success: function(data) {
	                if(data.success == "success"){
	                    $("#detailTable").handlerbarsCompile($("#detail-template"), data.de);
	                }
	            }
	        })
	    }
	    
	    $.fn.procBtnOnClickEvt = function(url, key){
	        var _this = $(this);
	        _this.on("click", function(){
	            if(baseInfo.insertKey != key){
	                if($("input.index:checked").size() <= 0) {
	                    alert("항목을 선택하시기 바랍니다.");
	                    return false;
	                }else{
	                    /* document.sForm.userNo.value = $("input.index:checked").val(); */
	                } 
	            }else{
	               /*  document.sForm.userNo.value = ""; */
	            }
	            
	            if(baseInfo.deleteKey == key){
	            	$.delAction(url, key);
	            } else {
	                $.procAction(url, key);	
	            }
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
	    
	    $.setCookie = function(c_name,value){
	        var exdate=new Date();
	        var c_value=escape(value);
	        document.cookie=c_name + "=" + c_value + "; path=/";
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
	    $.fn.excelDownOnClickEvt = function() {
	    	$(this).on("click", function(e){
		    	if(!confirm("엑셀다운로드하시겠습니까?")) return false;
		    	$("#downPopup").show();
	    	})
	    }	    
	    
	    $.excelDownload = function(e){
	    	excelPg = 1;
			$("[name='excelFileNm']").val("강사활동 현황_"+$.toDay());
			$("[name='excelPageNm']").val("instrctrSttusList.xlsx");		        	
            with(document.sForm){
                target = "";
                action = baseInfo.excel;
                submit();
                
                $.setCookie("fileDownloadToken","false");
                $.loadingBarStart(e);
                $.checkDownloadCheck();
            }
	    }
	    
	    $.fn.instrctrDetailOnClickEvt = function(){
	    	$(this).on("click", function(){
	    		if($.isNullStr($(this).data("no"))) return false;
	    		document.sForm.instrctrNo.value = $(this).data("no");
	    		
	    		$.popAction.width = 1200;
				$.popAction.height = 600;
				$.popAction.target = "instrctrDetailPopup";
				$.popAction.url = baseInfo.instrctrDetailPop;
				$.popAction.form = document.sForm;
				$.popAction.init();	    		
	    	})
	    }
	    
	    $.initView = function(){
	        $.onClickTableTr();
	        $("#searchBtn").searchBtnOnClickEvt($.searchAction);
	        $(".excelDown").excelDownOnClickEvt();
	        $("#downInsertBtn").downInsertBtnOnClick(baseInfo.insertKey);
	        $(".instrctrDetail").instrctrDetailOnClickEvt();
	        
	        
	        $("body").on("keydown", function(e){
		        $.loadingBarKeyDown(e, excelPg);
	        })
	    }
	    
	    $.initView();
	})
</script>
		
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/ribbon.jsp" flush="false" />

<form id="ubiForm" name="ubiForm" method="post">
    <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
    <input type="hidden" id="ubi_jrt" name="jrf" value="" />
    <input type="hidden" name="userNo" value="" />
</form>

<!-- MAIN CONTENT -->
<div id="content">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/menuTitle.jsp" flush="false" />
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
				<input type="hidden" name="excelFileNm" id="excelFileNm"  value="">
				<input type="hidden" name="excelPageNm" id="excelPageNm"  value="">              	
                <input type="hidden" name="reqstSeq" id="reqstSeq" value="">
                <input type="hidden" name="eduDivision" id="eduDivision" value="">
                <input type="hidden" name="instrctrNo" id="instrctrNo" value="">
                <input type="hidden" name="rank" id="rank" value="">
                
                <div class="fL wp75">
                    <ul class="searchAreaBox">
						<li class="smart-form">
						    <label class="label">센터명</label>
						</li>
						<%-- <sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')"> --%>
							<li class="w150 mr5">
								<select name="centerCd" class="form-control">
									<option value="">전체</option>
									<c:forEach var="center" items="${centerList }" varStatus="idx">
										<option value="<c:out value='${center.DEPT_CD }'/>" data-groupId="<c:out value='${center.GROUP_ID }'/>" <c:out value="${center.DEPT_CD eq param.centerCd ? 'selected=selected':'' }"/> ><c:out value="${center.DEPT_NM }"/></option>
									</c:forEach>
								</select> <i></i>
							</li>
						<%-- </sec:authorize> --%>
						<%-- <sec:authorize access="hasRole('ROLE_ADMIN') or hasRole('ROLE_USER')">
							<li class="smart-form mr5">
								<input type="hidden" name="centerCd" value="<sec:authentication property="principal.centerId"/>" >
								<label class="label"><sec:authentication property="principal.centerNm"/></label>
							</li>
						</sec:authorize> --%>                    
                    
						<li class="smart-form">
						    <label class="label">단계</label>
						</li>
                        <li class="w80 ml5">
							<select name="searchCondition3" class="form-control">
								<option value="">전체</option>
								<c:forEach var="code" items="${codeMap.DMH14 }" varStatus="idx">
									<c:if test="${code.CODE le '04' }">
										<option value="<c:out value='${code.CODE }'/>" <c:out value="${code.CODE eq param.searchCondition3 ? 'selected=selected':'' }"/> ><c:out value="${code.CODE_DC }"/></option>
									</c:if>	
								</c:forEach>
							</select> <i></i>                        
                        </li>
                        
						<li class="smart-form ml5">
						    <label class="label">교육구분</label>
						</li>
                        <li class="w100 ml5">
							<select name="searchCondition4" class="form-control">
								<option value="">전체</option>
								<c:forEach var="code" items="${codeMap.DMH19 }" varStatus="idx">
									<option value="<c:out value='${code.CODE }'/>" <c:out value="${code.CODE eq param.searchCondition4 ? 'selected=selected':'' }"/> ><c:out value="${code.CODE_NM }"/></option>
								</c:forEach>
							</select> <i></i>                        
                        </li>
                        
                        <li class="smart-form ml5"><label class="label">교육명</label></li>
                        <li class="w200 ml5">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">강사∙준강사</label></li>
                        <li class="w80 ml5">
                            <input id="searchKeyword2" name="searchKeyword2" class="form-control" value='<c:out value="${param.searchKeyword2}"/>'> 
                        </li>
                        
						<li class="ml10">
							<button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
						</li>                        
                    </ul>
                </div>
                
                <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
                    <jsp:param value="list"     name="formType"/>
                    <jsp:param value="1"     name="buttonYn"/>
                </jsp:include>                
                <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
            </form>
		</div>
		<!-- Search 영역 끝 -->
	
		<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />
		
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-6">
					<table class="table table-bordered tb_type01 listtable">
						<colgroup>
							<col width="10%">
							<col width="10%">
							<col width="*">
                            <col width="10%">
                            <col width="15%">
                            <col width="15%">
                            <col width="15%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>번호</th>
								<th>단계</th>
								<th>교육명</th>
								<th>연도</th>
								<th>교육일자</th>
								<th>강사</th>
								<th>준강사</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr ><td colspan="7">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list }" varStatus="idx">
								<tr style="${list.ACTIVE_AT eq 'N' ? 'background-color: #eee;' : ''}">
									<td class="invisible">
										<input type="checkbox" class="index" value="<c:out value='${list.SEQ}'/>">
										<input type="hidden" name="eduDivision" value="<c:out value='${list.EDU_DIVISION}'/>">
										<input type="hidden" name="rank" value="<c:out value='${list.RANK_NUM}'/>">
									</td>
									<td><c:out value="${paginationInfo.totalRecordCount - ((paginationInfo.currentPageNo-1) * paginationInfo.recordCountPerPage+ idx.index)}"/></td>
									<td><c:out value="${list.EDU_DIVISION gt '03' ? list.EDU_DIVISION_NM : list.EDU_PROCESS_TXT}"/></td>
									<td><c:out value="${list.EDUCATION_TXT}"/></td>
									<td><c:out value="${fn:substring(list.END_YMD, 0, 4)}"/></td>
									<td><c:out value="${list.START_YMD}"/> ~ <c:out value="${fn:substring(list.END_YMD, 8, 10)}"/></td>
									<td class="instrctrDetail" data-no="<c:out value='${list.INSTRCTR_NO_I }'/>"><c:out value="${list.INSTRCTR_NM_I}"/><%-- <c:if test="${not empty list.INSTRCTR_CERT_I }">(${list.INSTRCTR_CERT_I })</c:if> --%></td>
									<td class="instrctrDetail" data-no="<c:out value='${list.INSTRCTR_NO_S }'/>"><c:out value="${list.INSTRCTR_NM_S}"/><%-- <c:if test="${not empty list.INSTRCTR_CERT_S }">(${list.INSTRCTR_CERT_S })</c:if> --%></td>
									<c:set var="p_seq" value="${list.SEQ }"/>
									<c:set var="p_edu_division" value="${list.EDU_DIVISION }"/>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" />
				</article>
				
				<article class="col-md-12 col-lg-6">
					<table class="table table-bordered tb_type03">
						<colgroup>
							<col width="15%">
							<col width="35%">
							<col width="15%">
							<col width="35%">
						</colgroup>
						<tbody id="detailTable">
							<tr><td colspan="6" class="textAlignCenter">항목을 선택해주세요.</td></tr>
						</tbody>
					</table>
				</article>
			</div>
			<!-- row 메뉴조회 끝 -->
		</div>
		
	</section>
	<!-- widget grid end -->
	
</div>
<!-- END MAIN CONTENT -->

<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/downloadReasonPopup.jsp" flush="false" />

<script id="detail-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">센터명</th>
	<td>{{CENTER_NM}}</td>
	<th scope="row">과목</th>
	<td>{{LECTURE_ID}}</td>
</tr>
<tr>
	<th scope="row">단계</th>
	<td>{{#ifgt EDU_DIVISION '03'}}{{EDU_DIVISION_NM}} {{else}}{{EDU_PROCESS_TXT}}{{/ifgt}}</td>
	<th scope="row">교육구분</th>
	<td>{{EDU_DIVISION_NM}}</td>
</tr>
<tr>
	<th scope="row">교육명</th>
	<td>{{EDUCATION_TXT}}</td>
	<th scope="row">교육일자 </th>
	<td>{{START_DATE}} ~ <br>{{END_DATE}}</td>
</tr>
<tr>
	<th scope="row">강사</th>
	<td>{{INSTRCTR_NM_I}}{{#ifnoteq INSTRCTR_CERT_I ''}}({{INSTRCTR_CERT_I}}){{/ifnoteq}}</td>
	<th scope="row">준강사</th>
	<td>{{INSTRCTR_NM_S}}{{#ifnoteq INSTRCTR_CERT_S ''}}({{INSTRCTR_CERT_S}}){{/ifnoteq}}</td>
</tr>
</script>