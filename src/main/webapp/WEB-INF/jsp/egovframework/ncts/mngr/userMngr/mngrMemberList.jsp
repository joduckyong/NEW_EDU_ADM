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
	            lUrl : "/ncts/mngr/userMngr/mngrMemberList.do",
	            fUrl : "/ncts/mngr/userMngr/mngrMemberForm.do",
	            dUrl : "/ncts/mngr/userMngr/mngrDeleteMember.do",
	            excel : "/ncts/mngr/userMngr/memberExcelDownload.do",
	            pop01 : "/ncts/mngr/userMngr/mngrFileConfirmListPopup.do"
	    }
	    
	    $.dataDetail = function(index){
	        if($.isNullStr(index)) return false;
	        document.sForm.userNo.value = index;
	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/userMngr/mngrMemberDetail.do",
	            data: $("#sForm").serialize(),
	            dataType: "json",
	            success: function(data) {
	                if(data.success == "success"){
	                	var courses = "";
	                	var $template;
	                    //$("#prmoDetail").empty();
	                    //$.addTemplate("detail-template", "prmoDetail", data.rs) 
	                    if(data.de.INSTRCTR_DETAIL_GRADE_CD == "99") {
	                    	$("colgroup.member").show();
	                    	$("colgroup.instrctr").hide();
	                    	$template = $("#detail-template");
	                    } else {
	                    	$("colgroup.instrctr").show();
	                    	$("colgroup.member").hide();
	                    	$template = $("#instrctr-detail-template");
	                    }
	                    $(".tab-content").show();
	                    $("#detailTable").handlerbarsCompile($template, data.de);
	                    $("#seTable").handlerbarsCompile($("#se-template"), data.se);
	                    $("#seTable").handlerbarsAppendCompile($("#video-se-template"), data.seVideo);
	                    
	                    if($("#courses").val() == '') courses = "#coursesEtc";
	                    else courses = "#courses"+$("#courses").val();
	                    $(courses).closest("ul").find("li").removeClass("active");
	                    $(courses).closest("li").addClass("active");
	                    
	                    $.noteDataOnSettings(data);
	                    $(".instrctrSelect").instrctrSelectOnChangeEvt(baseInfo.updateKey, index);
	                    $.instrctrDetailViewOnSettings($("input[name='loginUserId']").val());
	                    $("#packageAuthAt").packageAuthAtOnChangeEvt(baseInfo.updateKey, index);
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
	    
	    $.fn.test = function(){
	    	var _this = $(this);
	    	_this.on("click", function(){
	    		if(!confirm("처리하시겠습니까?")) return false;
	            
		    	document.sForm.procType.value = baseInfo.insertKey;
	            
		    	$.ajax({
	                type: 'POST',
	                url: "/ncts/mngr/userMngr/isueCertProc.do",
	                data: $("#sForm").serialize(),
	                dataType: "json",
	                success: function(data) {
	                	alert(data.msg);
	                    if(data.success == "success"){
	                        //$.searchAction();
	                    }
	                }
	            });
	    	})
	    }
	    
	    $.fn.liOnClickEvt = function(){
	    	var _this = $(this);
	    	_this.on("click", function(){
	    		var $this = $(this);
	    		var id = $this.attr("id").replace("courses", "");
	    		var courses = id == "Etc" ? '' : id;
	    		
	    		document.sForm.courses.value = courses;
	    		$.dataDetail($(".index:checked").val());
	    	})
	    }
	    
	    $.fn.fileConfirmBtnOnClickEvt = function(){
	    	$(this).on("click", "#fileConfirmBtn", function(){
	    		var $this = $(this);
	    		var fileConfirmAt = $this.data("confirmAt");
	    		
	    		if(fileConfirmAt == "Y") fileConfirmAt = "N";
	    		else fileConfirmAt = "Y";
	    		
	    		document.sForm.fileConfirmAt.value = fileConfirmAt;
	    		document.sForm.procType.value = baseInfo.updateKey;
	    		
	    		$.ajax({
	                type: 'POST',
	                url: "/ncts/mngr/userMngr/fileConfirmProcess.do",
	                data: $("#sForm").serialize(),
	                dataType: "json",
	                success: function(data) {
	                	alert(data.msg);
	                    if(data.success == "success"){
	                    	$.dataDetail($("#userNo").val());
	                    }
	                }
	            });
	    	})
	    }
	    
	    $.fn.confirmDetailBtnOnClickEvt = function(){
	    	$(this).on("click", "#confirmDetailBtn", function(){
	    		var $this = $(this);
	    		
	    		$.popAction.width = 1200;
				$.popAction.height = 600;
				$.popAction.target = "selectFileConfirmListPopup";
				$.popAction.url = baseInfo.pop01;
				$.popAction.form = document.sForm;
				$.popAction.init();
	    	})
	    }
	    
	    $.fn.pwUnLockConfirmBtnOnClickEvt = function(){
	    	$(this).on("click", "#unLock", function(){
	    		var $this = $(this);
	    		
	    		document.sForm.procType.value = baseInfo.updateKey;
	    		
	    		$.ajax({
	                type: 'POST',
	                url: "/ncts/mngr/userMngr/updateMngrMemberPwUnLock.do",
	                data: $("#sForm").serialize(),
	                dataType: "json",
	                success: function(data) {
	                	alert(data.msg);
	                    if(data.success == "success"){
	                    	$.dataDetail($("#userNo").val());
	                    }
	                }
	            });
	    	})
	    }
	    
	    $.fn.excelDownOnClickEvt = function() {
	    	$(this).on("click", function(e){
		    	if(!confirm("엑셀다운로드하시겠습니까?")) return false;
		    	$("#downPopup").show();
	    	})
	    }	
	    
	    $.excelDownload = function(e){
        	excelPg = 1;
			$("[name='excelFileNm']").val("회원_"+$.toDay());
			$("[name='excelPageNm']").val("mngrMemberList.xlsx");	        	
            with(document.sForm){
                target = "";
                action = baseInfo.excel;
                submit();
                
                $.setCookie("fileDownloadToken","false");
                $.loadingBarStart(e);
                $.checkDownloadCheck();
            }
	    }
	    
	    $.initView = function(){
	        $.onClickTableTr();
	        $("#searchBtn").searchBtnOnClickEvt($.searchAction);
	        $("#saveBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.insertKey);
	        $("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
	        $("#delBtn").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey);
	        $("#isueList li a").liOnClickEvt();
	        
	        $(".excelDown").excelDownOnClickEvt();
	        $("#downInsertBtn").downInsertBtnOnClick(baseInfo.insertKey);
	        
	        $(document).on("click",".fileDown", function(){
	        	var url = $(this).prev(".fileView").find(".file_wrap");
	        	
	        	if(url.length == 0) alert("업로드 된 파일이 없습니다.");
	        	else {
	        		url = url.find("a").prop("href");
	        		location.href = url;
	        	}
	        });
	        
	        $("#btntest").test();
	        
	        $("body").on("keydown", function(e){
		        $.loadingBarKeyDown(e, excelPg);
	        })
	        
	        $("input[name='searchKeyword1']").keypress(function(e){if(e.keyCode == 13)  $.searchAction();});
	        
	        $("body").fileConfirmBtnOnClickEvt();
	        $("body").confirmDetailBtnOnClickEvt();
	        $("body").pwUnLockConfirmBtnOnClickEvt();
	        
	        $(".mailSendBtn").on("click", function(){ 
	        	$.procAction("/ncts/mngr/mail/mngrMemberMailForm.do", baseInfo.insertKey);
	        });	      
	        
	        $("body").on("click", ".reportDown", function(){
	        	var $this = $(this);
		        document.ubiForm.userNo.value = $this.data("userNo");
		        document.ubiForm.jrf.value = $this.data("jrf");
	            popUbiReport();
	        });
	        
			/* $("body").notePopupBtnOnClickEvt();
			$("body").notePopupBtnsOnClickEvt(baseInfo.updateKey);	 */
			
			
	        
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
                <input type="hidden" name="userNo" id="userNo" value="0">
                <input type="hidden" name="courses" id="courses" value="00">
                <input type="hidden" name="fileConfirmAt" id="fileConfirmAt" value="">
                <input type="hidden" name="loginUserId" value="<sec:authentication property="principal.userId"/>" >
                
                <div class="fL wp70">
                    <ul class="searchAreaBox">
                    	<li class="smart-form"><label class="label">아이디</label></li>
                        <li class="w100 ml5">
                            <input id="searchKeyword4" name="searchKeyword4" class="form-control" value='<c:out value="${param.searchKeyword4}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">이름</label></li>
                        <li class="w80 ml5">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">이메일</label></li>
                        <li class="w150 ml5">
                            <input id="searchKeyword2" name="searchKeyword2" class="form-control" value='<c:out value="${param.searchKeyword2}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">연락처</label></li>
                        <li class="w100 ml5">
                            <input id="searchKeyword3" name="searchKeyword3" class="form-control" value='<c:out value="${param.searchKeyword3}"/>'> 
                        </li>
                        <%-- <li class="smart-form ml5">
                            <label class="label">회원등급</label>
                        </li>
                        <li class="w80 ml5">
                            <select id="sGubun" name="sGubun" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap.DMH03 }" varStatus="idx">
                                    <option value="${list.CODE }" ${param.sGubun eq list.CODE ? 'selected="selected"':'' }>${list.CODE_NM }</option>
                                </c:forEach>
                            </select>
                        </li> --%>
                        <li class="smart-form ml5">
                            <label class="label">세부등급</label>
                        </li>
                        <li class="w80">
                            <select id="sGubun1" name="sGubun1" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap.DMH23 }" varStatus="idx">
                                    <option value="<c:out value='${list.CODE }'/>" <c:out value="${param.sGubun1 eq list.CODE ? 'selected=selected':'' }"/>>
										<c:out value="${list.CODE_NM}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </li>
                        <li class="smart-form ml5">
                            <label class="label">본인인증</label>
                        </li>
                        <li class="w80">
                            <select id="sGubun4" name="sGubun4" class="form-control">
                                <option value="">선택</option>
                                <option value="Y" <c:out value="${param.sGubun4 eq 'Y' ? 'selected=selected':'' }"/>>Y</option>
                                <option value="N" <c:out value="${param.sGubun4 eq 'N' ? 'selected=selected':'' }"/>>N</option>
                            </select>
                        </li>
                        <li class="ml10">
                            <button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
                        </li>
                    </ul>
                </div>
				<div class="fR wp30">
					<ul class="searchAreaBox fR">
						<li><button class="btn btn-default ml2 mailSendBtn" type="button" ><i class="fa fa-send" title="메일발송"></i> 메일발송</button></li>
						<c:if test="${pageInfo.EXCEL_AT eq 'Y' }">
							<li><button class="btn btn-default ml2 excelDown" type="button" ><i class="fa fa-print" title="엑셀다운로드"></i> 엑셀다운로드</button></li>
						</c:if>
						<c:if test="${pageInfo.INSERT_AT eq 'Y' }">
							<li><button class="btn btn-primary ml2" type="button" id="saveBtn"><i class="fa fa-edit" title="등록"></i> 등록</button></li>
						</c:if>
						<c:if test="${pageInfo.UPDATE_AT eq 'Y' }">
							<li><button class="btn btn-primary ml2" type="button" id="updBtn"><i class="fa fa-edit" title="수정"></i> 수정</button></li>
						</c:if>
						<c:if test="${pageInfo.DELETE_AT eq 'Y' }">
							<li><button class="btn btn-danger ml2"  type="button" id="delBtn"><i class="fa fa-cut" title="삭제"></i> 삭제</button></li>
						</c:if>
					</ul>
				</div>
				                
                <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
                <!-- <button class="btn btn-primary fRight" type="button" id="btntest" style="background: orange;">TEST</button> -->
            </form>
		</div>
		<!-- Search 영역 끝 -->
	
		<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />
		
		<form method="post" name="nForm" id="nForm">
			<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
			<input type="hidden" name="userNo" value="" >
			<input type="hidden" name="pfatGradeCd" value="" >
			<input type="hidden" name="sprtGradeCd" value="" >
			<input type="hidden" name="pmptGradeCd" value="" >
			<input type="hidden" name="mpgtGradeCd" value="" >
			<input type="hidden" name="packageAuthAt" value="" >
			
			<div class="dim-layer" style="display: none;">
        		<div class="dimBg"></div>			
				<div id="layer2" class="popup-con" style="width:300px;">
					<div class="close_box fClr" style="margin: 0 0 20px 0;"></div>
					<div class="file_box">
						<p class="tit">저장되었습니다.</p>
					</div>
					<button type="button" class="closeBtn" style="margin: 10px 0;">확인</button>
				</div>			
			</div>	
			<%-- <div id="notePopup" class="popup-con-d" style="display:none">
				<div class="close_box fClr" style="text-align:left;">
				</div>
		        <div class="tit_box fClr">
		        	<p class="tit fLeft">주강사구분</p>
		        	<label>
			        	<input type="checkbox" id="pfatGradeAt" name="pfatGradeAt" value="Y" ${result.PFAT_GRADE_AT eq 'Y'? 'checked':''}>
			        	<span class="col mt7 ml5 mr20">PFAT주강사</span>
		        	</label>
		        	<label>
			        	<input type="checkbox" id="pmptGradeAt" name="pmptGradeAt" value="Y" ${result.PMPT_GRADE_AT eq 'Y'? 'checked':''}>
			        	<span class="col mt7 ml5 mr20">PM+T주강사</span>
		        	</label>
		        	<label>
			        	<input type="checkbox" id="sprtGradeAt" name="sprtGradeAt" value="Y" ${result.SPRT_GRADE_AT eq 'Y'? 'checked':''}>
			        	<span class="col mt7 ml5 mr20">SPRT주강사</span>
		        	</label>
		        	
		        	<p class="tit fLeft">준강사구분</p>
		        	<label>
			        	<input type="checkbox" id="pfatAiGradeAt" name="pfatAiGradeAt" value="Y" ${result.PFAT_AI_GRADE_AT eq 'Y'? 'checked':''}>
			        	<span class="col mt7 ml5 mr20">PFAT준강사</span>
		        	</label>
		        	<label>
			        	<input type="checkbox" id="pmptAiGradeAt" name="pmptAiGradeAt" value="Y" ${result.PMPT_AI_GRADE_AT eq 'Y'? 'checked':''}>
			        	<span class="col mt7 ml5 mr20">PM+T준강사</span>
		        	</label>
		        	<label>
			        	<input type="checkbox" id="sprtAiGradeAt" name="sprtAiGradeAt" value="Y" ${result.SPRT_AI_GRADE_AT eq 'Y'? 'checked':''}>
			        	<span class="col mt7 ml5 mr20">SPRT준강사</span>
		        	</label>
		            <textarea name="note" id="note" cols="30" rows="10" placeholder="비고">${result.NOTE }</textarea>
		            
					<div class="btn_box fClr">
						<button type="button" class="fCenter" id="noteProcBtn">등록</button>
						<button type="button" class="fCenter close_popup">닫기</button>
					</div>		            
		        </div>
			</div> --%>
		</form>		
		
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-6">
					<table class="table table-bordered tb_type01 listtable">
						<colgroup>
							<col width="20%">
							<col width="25%">
							<col width="15%">
							<col width="20%">
							<col width="20%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>아이디</th>
								<th>이메일</th>
								<th>이름</th>
								<th>연락처</th>
								<th>세부등급</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr ><td colspan="5">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list }" varStatus="idx">
								<tr>
									<td class="invisible">
										<input type="checkbox" class="index" value="<c:out value='${list.USER_NO}'/>">
										
									</td>
									<%-- <td>${!empty list.DIST_MANAGE_NM ? list.DIST_MANAGE_NM : '전체'  }</td> --%>
									<td><c:out value="${list.USER_ID}"/></td>
									<td><c:out value="${list.USER_EMAIL}"/></td>
									<td><c:out value="${list.USER_NM}"/></td>
									<td><c:out value="${list.USER_HP_NO}"/></td>
									<td><c:out value="${list.DETAIL_GRADE_CD_NM}"/></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" />
				</article>
				
				<article class="col-md-12 col-lg-6">
					<table class="table table-bordered tb_type03">
						<colgroup class="member" style="display:none;">
							<col width="10%">
							<col width="23.2%">
							<col width="10.2%">
							<col width="23%">
							<col width="10%">
							<col width="23.2%">
						</colgroup>
						<colgroup class="instrctr" style="display:none;">
							<col width="10.5%">
							<col width="22%">
							<col width="10.5%">
							<col width="18%">
							<col width="10.5%">
							<col width="10.5%">
							<col width="18%">
						</colgroup>
						<tbody id="detailTable">
							<tr><td colspan="6" class="textAlignCenter">항목을 선택해주세요.</td></tr>
						</tbody>
					</table>
					
					<table class="table table-bordered table-hover tb_type01">
						<div class="wp12">
						  <span class="col mt7 mr5 ml15"><b>P:이수, T:시간부족, F:미이수</b></span>
						</div>
						
						<div class="tab-content" style="display:none;">
							<div class="jarviswidget-sortable active" id="isueList">
								<ul class="nav nav-tabs" style="min-width:100%;">
									<li class="active"><a href="javascript:void(0);" id="courses00">일반</a></li>
									<li><a href="javascript:void(0);" id="courses01">초급</a></li>
									<li><a href="javascript:void(0);" id="courses02">중급</a></li>
									<li><a href="javascript:void(0);" id="courses03">고급</a></li>
									<li><a href="javascript:void(0);" id="courses04">강사</a></li>
									<li><a href="javascript:void(0);" id="courses10">직무</a></li>
									<li><a href="javascript:void(0);" id="courses07">기타</a></li>
									<li><a href="javascript:void(0);" id="coursesEtc">미선택</a></li>
								</ul>
							</div>
						</div>
						<colgroup>
							<col width="28%">
							<col width="22%">
							<col width="28%">
							<col width="22%">
						</colgroup>
						<tbody id="seTable">
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
	<th scope="row">아이디</th>
	<td>{{USER_ID}}</td>
	<th scope="row">이메일</th>
	<td colspan="3">{{USER_EMAIL}}</td>
</tr>
<tr>
	<th scope="row">회원등급</th>
	<td>{{GRADE_CD_NM}}</td>
	<th scope="row">세부등급 </th>
	<td colspan="3">{{DETAIL_GRADE_CD_NM}}</td>
</tr>
<tr>
	<th scope="row">이름</th>
	<td>{{USER_NM}}</td>
    <th scope="row">생년월일</th>
    <td colspan = "3">{{USER_BIRTH_YMD}}</td>
</tr>
<tr>
	<th scope="row">학위</th>
	<td>{{ACADEMIC_DEGREE_CD_NM}}</td>
    <th scope="row">전화번호</th>
    <td colspan = "3">{{USER_HP_NO}}</td>
</tr>
<tr>
	<th scope="row">학과</th>
	<td>{{DEPARTMENT_NM}}</td>
    <th scope="row">전공</th>
    <td colspan = "3">{{MAJOR_NM}}</td>
</tr>
<tr>
	<th scope="row">졸업여부 </th>
	<td >{{GRADUATION_CD_NM}}</td>
    <th scope="row">졸업(예정)일</th>
    <td colspan = "3">{{GRADUATION_YMD}}</td>
</tr>
<tr>
    <th scope="row">현재소속 </th>
    <td >{{CURRENT_JOB_NM}}</td>
    <th scope="row">
		자격증
		<button type="button" class="btn btn-default ml2 mb5" id="confirmDetailBtn">
    		<i class="fa fa-search" title="변경내역"></i>변경내역
		</button>

	</th>
    <td colspan = "3">
		{{LICENSE_NM}}
		<br>
		<div class="fileView" style="display:none;">
			{{safe fileView}}
		</div>
		<button type="button" class="btn btn-default ml2 mb5 fileDown" id="">
			<i class="fa fa-print" title="첨부파일 down"></i> 첨부파일 down
		</button>
		<button type="button" class="btn ml2 {{#ifeq FILE_CONFIRM_AT 'Y'}}btn-primary{{else}}btn-danger{{/ifeq}}" id="fileConfirmBtn" data-confirm-at="{{FILE_CONFIRM_AT}}" <c:out value="${pageInfo.INSERT_AT eq 'Y' ? '':'disabled'}"/>>
			<i title="확인버튼"></i> {{#ifeq FILE_CONFIRM_AT 'Y'}}확인{{else}}미확인{{/ifeq}}
		</button>
		<br>
		{{#notempty FILE_CONFIRM_PNTTM}}({{FILE_CONFIRM_NM}}, {{FILE_CONFIRM_PNTTM}}){{/notempty}}
	</td>
</tr>

<tr>
    <th scope="row">가입일시</th>
    <td >{{FRST_REGIST_PNTTM}}</td>
	<th scope="row">개인정보<br>동의여부</th>
    <td>
		{{PRIVACY_AGREE_AT}}
		{{#ifeq PRIVACY_AGREE_AT 'Y'}}
			<button class="btn btn-default ml2 mb5 reportDown" type="button" data-user-no="{{USER_NO}}" data-jrf="USER_AGREEMENT.jrf" <c:out value="${pageInfo.REPORT_AT eq 'Y' ? '':'disabled'}"/><i class="fa fa-edit" title="리포트 출력"></i> 동의서</button>
		{{/ifeq}}
	</td>
	<th scope="row">본인인증<br>여부</th>
    <td>{{CRTFC_AT}}{{#ifeq CRTFC_AT 'Y'}}({{DI_INSERT_DE}}){{/ifeq}}</td>
</tr>

<tr>
	<th scope="row">직무자격<br>활성화</th>
	<td colspan="6">
		<label class="select col w150 mr5">
			<select id="packageAuthAt" name="packageAuthAt">
           		<option value="N" {{#ifeq PACKAGE_AUTH_AT 'N'}}selected{{/ifeq}}>N</option>
           		<option value="Y" {{#ifeq PACKAGE_AUTH_AT 'Y'}}selected{{/ifeq}}>Y</option>
			</select> <i></i>
		</label>
		{{#ifeq LOCK_AT 'Y'}}
		<button class="btn btn-danger ml2"  type="button" id="unLock">잠김해제</button>
		{{/ifeq}}
	</td>
</tr>
</script>

<script id="instrctr-detail-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">아이디</th>
	<td>{{USER_ID}}</td>
	<th scope="row">이메일</th>
	<td colspan="4">{{USER_EMAIL}}</td>
</tr>
<tr>
	<th scope="row" rowspan="4">회원등급</th>
	<td rowspan="4">{{GRADE_CD_NM}}</td>
	<th scope="row" rowspan="4">세부등급 </th>
	<td rowspan="4">{{DETAIL_GRADE_CD_NM}} / {{INSTRCTR_DETAIL_GRADE_CD_NM}}</td>
	<th scope="row" rowspan="4">강사등급 </th>
	<th scope="row">PFA</th>
	<td>
		<label class="select col w150 mr5">
			<select id="pfatGradeCd" name="pfatGradeCd" class="instrctrSelect">
           		<option value="">해당없음</option>
                	<c:forEach var="list" items="${codeMap.DMH24 }" varStatus="idx">
                    	<option value="${list.CODE }">
	                    	${list.CODE_NM}
                        </option>
               	 	</c:forEach>    
			</select> <i></i>
		</label>
	</td>
</tr>
<tr>
	<th scope="row">SPR</th>
	<td>
		<label class="select col w150 mr5">
			<select id="sprtGradeCd" name="sprtGradeCd" class="instrctrSelect">
           		<option value="">해당없음</option>
                	<c:forEach var="list" items="${codeMap.DMH24 }" varStatus="idx">
                    	<option value="<c:out value='{list.CODE }'/>">
						<c:out value="${list.CODE_NM}"/>
                        </option>
               	 	</c:forEach>  
			</select> <i></i>
		</label>
	</td>
</tr>
<tr>
	<th scope="row">PM+</th>
	<td>
		<label class="select col w150 mr5">
			<select id="pmptGradeCd" name="pmptGradeCd" class="instrctrSelect">
           		<option value="">해당없음</option>
                	<c:forEach var="list" items="${codeMap.DMH24 }" varStatus="idx">
                    	<option value="<c:out value='${list.CODE }'/>">
						<c:out value="${list.CODE_NM}"/>
                        </option>
               	 	</c:forEach>  
			</select> <i></i>
		</label>
	</td>
</tr>
<tr>
	<th scope="row">MPG</th>
	<td>
		<label class="select col w150 mr5">
			<select id="mpgtGradeCd" name="mpgtGradeCd" class="instrctrSelect">
           		<option value="">해당없음</option>
                	<c:forEach var="list" items="${codeMap.DMH24 }" varStatus="idx">
                    	<option value="<c:out value='${list.CODE }'/>">
							<c:out value="${list.CODE_NM}"/>
                        </option>
               	 	</c:forEach>  
			</select> <i></i>
		</label>
	</td>
</tr>
<tr>
	<th scope="row">이름</th>
	<td>{{USER_NM}}</td>
    <th scope="row">생년월일</th>
    <td colspan = "4">{{USER_BIRTH_YMD}}</td>
</tr>
<tr>
	<th scope="row">학위</th>
	<td>{{ACADEMIC_DEGREE_CD_NM}}</td>
    <th scope="row">전화번호</th>
    <td colspan = "4">{{USER_HP_NO}}</td>
</tr>
<tr>
	<th scope="row">학과</th>
	<td>{{DEPARTMENT_NM}}</td>
    <th scope="row">전공</th>
    <td colspan = "4">{{MAJOR_NM}}</td>
</tr>
<tr>
	<th scope="row">졸업여부 </th>
	<td >{{GRADUATION_CD_NM}}</td>
    <th scope="row">졸업(예정)일</th>
    <td colspan = "4">{{GRADUATION_YMD}}</td>
</tr>
<tr>
    <th scope="row">현재소속 </th>
    <td >{{CURRENT_JOB_NM}}</td>
    <th scope="row">
		자격증
		<button type="button" class="btn btn-default ml2 mb5" id="confirmDetailBtn">
    		<i class="fa fa-search" title="변경내역"></i>변경내역
		</button>

	</th>
    <td colspan = "4">
		{{LICENSE_NM}}
		<br>
		<div class="fileView" style="display:none;">
			{{safe fileView}}
		</div>
		<button type="button" class="btn btn-default ml2 mb5 fileDown" id="">
			<i class="fa fa-print" title="첨부파일 down"></i> 첨부파일 down
		</button>
		<button type="button" class="btn ml2 {{#ifeq FILE_CONFIRM_AT 'Y'}}btn-primary{{else}}btn-danger{{/ifeq}}" id="fileConfirmBtn" data-confirm-at="{{FILE_CONFIRM_AT}}" <c:out value="${pageInfo.INSERT_AT eq 'Y' ? '':'disabled'}"/>
			<i title="확인버튼"></i> {{#ifeq FILE_CONFIRM_AT 'Y'}}확인{{else}}미확인{{/ifeq}}
		</button>
		<br>
		{{#notempty FILE_CONFIRM_PNTTM}}({{FILE_CONFIRM_NM}}, {{FILE_CONFIRM_PNTTM}}){{/notempty}}
	</td>
</tr>

<tr>
    <th scope="row">가입일시</th>
    <td >{{FRST_REGIST_PNTTM}}</td>
	<th scope="row">개인정보<br>동의여부</th>
    <td>
		{{PRIVACY_AGREE_AT}}
		{{#ifeq PRIVACY_AGREE_AT 'Y'}}
			<button class="btn btn-default ml2 mb5 reportDown" type="button" data-user-no="{{USER_NO}}" data-jrf="USER_AGREEMENT.jrf" <c:out value="${pageInfo.REPORT_AT eq 'Y' ? '':'disabled'}"/>><i class="fa fa-edit" title="리포트 출력"></i> 동의서</button>
		{{/ifeq}}
	</td>
	<th scope="row">본인인증<br>여부</th>
    <td colspan="2">{{CRTFC_AT}}{{#ifeq CRTFC_AT 'Y'}}({{DI_INSERT_DE}}){{/ifeq}}</td>
</tr>

<tr>
	<th scope="row">직무자격<br>활성화</th>
	<td colspan="6">
		<label class="select col w150 mr5">
			<select id="packageAuthAt" name="packageAuthAt">
           		<option value="N" {{#ifeq PACKAGE_AUTH_AT 'N'}}selected{{/ifeq}}>N</option>
           		<option value="Y" {{#ifeq PACKAGE_AUTH_AT 'Y'}}selected{{/ifeq}}>Y</option>
			</select> <i></i>
		</label>
		{{#ifeq LOCK_AT 'Y'}}
		<button class="btn btn-danger ml2"  type="button" id="unLock">잠김해제</button>
		{{/ifeq}}
	</td>
</tr>
</script>

<script id="se-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">기준강의명</th>
	<th scope="row">수강여부</th>
    <th scope="row">기준강의명</th>
    <th scope="row">수강여부</th>
</tr>

{{#if .}}
{{#each .}}
<tr>
    <!-- <td bgcolor={{#ifnoteq ACTIVE_YN1 'Y'}}"#d2c0a4"{{/ifnoteq}}>{{CERT_CD1}}</td> -->
    <td bgcolor={{#ifnoteq ACTIVE_YN1 'Y'}}"#d2c0a4"{{/ifnoteq}}>{{LECTURE_NM1}}</td>
    <td>{{CERT_COMPLETED_CD1}}</td>
    <!-- <td bgcolor={{#ifnoteq CERT_CD2 ''}}{{#ifnoteq ACTIVE_YN2 'Y'}}"#d2c0a4"{{/ifnoteq}}{{/ifnoteq}}>{{CERT_CD2}}</td> -->
    <td bgcolor={{#ifnoteq CERT_CD2 ''}}{{#ifnoteq ACTIVE_YN2 'Y'}}"#d2c0a4"{{/ifnoteq}}{{/ifnoteq}}>{{LECTURE_NM2}}</td>
    <td>{{CERT_COMPLETED_CD2}}</td>
</tr>
{{/each}}
{{else}}
    <tr class="noData">                           
        <td colspan="4">데이터가 없습니다.</td>             
    </tr>
{{/if}}

</script>

<script id="video-se-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">동영상 교육명</th>
	<th scope="row">수강여부</th>
    <th scope="row">동영상 교육명</th>
    <th scope="row">수강여부</th>
</tr>

{{#if .}}
{{#each .}}
<tr>
    <td>{{LECTURE_ID1}}</td>
    <td>{{PASS_CD1}}</td>
    <td>{{LECTURE_ID2}}</td>
    <td>{{PASS_CD2}}</td>
</tr>
{{/each}}
{{else}}
    <tr class="noData">                           
        <td colspan="4">데이터가 없습니다.</td>             
    </tr>
{{/if}}

</script>