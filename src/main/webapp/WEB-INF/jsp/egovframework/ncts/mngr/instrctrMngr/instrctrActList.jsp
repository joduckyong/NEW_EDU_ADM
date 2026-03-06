<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
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
	    var baseInfo = {
	            insertKey : "${common.baseType[0].key() }",
	            updateKey : "${common.baseType[1].key() }",
	            deleteKey : "${common.baseType[2].key() }",
	            lUrl : "/ncts/mngr/instrctrMngr/instrctrActList.do",
	            instrctrTabPop : "/ncts/mngr/instrctrMngr/instrctrTabPopup.do"
	            /* fUrl : "/ncts/mngr/instrctrMngr/instrctrForm.do", */
	            /* dUrl : "/ncts/mngr/instrctrMngr/mngrDeleteMember.do", */
	            /* excel : "/ncts/mngr/instrctrMngr/instrctrExcelDownload.do" */
	    }
	    
	    $.dataDetail = function(index, obj){
	        if($.isNullStr(index)) return false;
	       
	        document.sForm.reqstSeq.value = index;
	        document.sForm.eduDivision.value = obj.eduDivision;
	        document.sForm.dtyEduYn.value = obj.dtyEduYn;
	        document.sForm.certCd.value = obj.lectureId;
	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/instrctrMngr/instrctrActDetail.do",
	            data: $("#sForm").serialize(),
	            dataType: "json",
	            success: function(data) {
	                if(data.success == "success"){
	                	var userCenterCd = $("#userCenterCd").val();
	                	data.DTY_EDU_YN = $("#dtyEduYn").val();
	                	data.INSERT_AT = "${pageInfo.INSERT_AT}";
	                	data.BUTTON_AT = (userCenterCd == obj.reqstCenterCd) || userCenterCd == "10000000" || $("#userId").val() == "master" ? "Y":"N";
	                    $("#detailTable").handlerbarsCompile($("#detail-template"), data);
	                    
	                    if(data.DTY_EDU_YN == "Y") {
		                    $(data.de).each(function(){
		                    	$("#detailTable tr[data-seq="+ this.REQST_SEQ +"][data-no="+ this.INSTRCTR_NO +"]").find(".certCd option[value='"+ this.CERT_CD +"']").prop("selected", true);
		                    })
	                    }
	                    
	                    $("#file_input_file1").attr("style", "border:1px solid #e5e5e5;background-color:#ffffff;font-size:12px;;color:#666666;width:98%;height:30px;line-height:18px;padding:2px;");
	                    $("#div_file_pack1").attr("style", "display:block;float:left;width:70%;margin-bottom:15px;");
	                    $(".instrctrTab").instrctrTabOnClickEvt();
	                    
	                    /* var $certCdList = $("#certCdList");
	                    if(data.de.dtyEduYn == "Y") {
		                    data.lectureIds.certCd = "${param.certCd}";
		                    $certCdList.find("ul").handlerbarsCompile($("#cert-cd-template"), data.lectureIds);
		                    $certCdList.show();
	                    } else {
	                    	$certCdList.hide();
	                    } */
	                }
	            }
	        })
	    }
	    var complVal = "";
	    $.procAction = function(val){
	    	var obj = $.hiddenObj($(".index:checked"));
	    	
	    	if("A" != val){
	    	    var compl = val.data("applyBtn");
		        $("#instrctrDivision").val(val.data("instrctrDivision"));

	    	    if("F" == compl){
	                $("#layer1").css("display","block");
	                $("#nonApplyConLayer").val(val.data("instrctrReturnResn"));
	                complVal = val;
	                return;
	    	    } 
	    	} else if("A" == val){
	    		compl = "F";
	    	}
	    	
	    	if(obj.dtyEduYn == "Y" && compl == "Y" && val.siblings(".certCd").val() == "") {
	    		alert("강의명을 선택해주세요.");
	    		return false;
	    	}

	    	with(document.sForm){
	            procType.value = baseInfo.updateKey;
	            confmAt.value = compl;
	            if("F" == compl){
	            	instrctrNo.value = complVal.data("instrctrNo");
	            	nonApplyCon.value = $("textarea[name=nonApplyCon]").val();
	            } else {
	            	instrctrNo.value = val.data("instrctrNo");
	            	if(obj.dtyEduYn == "Y") certCd.value = val.siblings(".certCd").val();
	            }
	            
	            $.ajax({
	                type: 'POST',
	                url: "/ncts/mngr/instrctrMngr/actProc.do",
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
	    
	    $.ubiFormBtnOnClickEvt = function(val){
	        document.ubiForm.userNo.value = val;
            popUbiReport();
        }
	    
	    $.fn.onClose = function(){
	    	var _this = $(this);
	    	
	    	_this.on("click", function(){
	    		$("#layer1").css("display", "none");
	    	})
	    }
	    
	    $.fn.onNonAppl = function(){
	    	var _this = $(this);
	    	
	    	_this.on("click", function(){
	    		if(!confirm("반려하시겠습니까?"))return false;
	    		
	    		if(!$("textarea[name=nonApplyCon]").val()){
	    			alert("반려사유를 입력해 주십시오");
	    			$("textarea").focus();
	    			
	    			return false;
	    		}
	    		$("#layer1").css("display", "none");
	    		
	    		$.procAction("A");
	    	})
	    }
	    
	    /* $.saveFile = function(){
	    	$("#sForm").children().remove("#file_input_file1");

	    	var file = $("#file_input_file1").clone(true);
	    	    file.hide();
	    	    file.appendTo("#sForm");
	    	    
	    	if(!confirm("저장하시겠습니까?")) return;
	        
	    	document.sForm.procType.value = baseInfo.insertKey;
	        	          
	        $("#sForm").ajaxForm({
	            type: 'POST',
	            url: "/ncts/mngr/instrctrMngr/updateFile.do",
	            dataType: "json",
	            success: function(result) {
	                alert(result.msg);
	                if(result.success == "success") location.replace(baseInfo.lUrl);    
	            }
	        });
	        
	        $("#sForm").submit();
	    } */
	    
	    $.fn.sGubunOnChangeEvt = function(){
	    	$(this).on("change", function(){
	    		if($("#sGubun").val() == "B") $("#centerCd").val(''); 
	    	})
	    }
	    
	    $.fn.instrctrTabOnClickEvt = function(){
	    	$(this).on("click", function(){
				var $this = $(this);
				var userNo = $this.closest("tr").data("no");	   
				
	    		if($.isNullStr(userNo)) return false;
	    		document.userForm.userNo.value = userNo;
	    		
	    		$.popAction.width = 1200;
				$.popAction.height = 600;
				$.popAction.target = "instrctrTabPopup";
				$.popAction.url = baseInfo.instrctrTabPop;
				$.popAction.form = document.userForm;
				$.popAction.init();	    		
	    	})
	    }		    
	    
	    $.initView = function(){
	        $.onClickTableTr();
	        $("#searchBtn").searchBtnOnClickEvt($.searchAction);
	        /* $("#saveBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.insertKey);
	        $("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
	        $("#delBtn").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey); */
	        /* $(".excelDown").on("click", function(){
	            with(document.sForm){
	                target = "";
	                action = baseInfo.excel;
	                submit();
	            }
	        }); */
	        
	        $(document).on("click", "button[name=applyBtn]", function(){
	        	$.procAction($(this));
	        });
	        $(document).on("click", ".reportDown", function(){
                $.ubiFormBtnOnClickEvt($(this).data("userNo"));
            });
	        $(".close_box").onClose();
	        $("#nonApplBtn").onNonAppl();
	        $(document).on("click", "#updateBtn", function(){
	        	$.saveFile();
	        })
	        
	        // $("#sGubun, #centerCd").sGubunOnChangeEvt();
	        $("#file_input_file1").attr("style", "height:36px");
	    }
	    
	    $.initView();
	})
</script>
		
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/ribbon.jsp" flush="false" />

<form id="ubiForm" name="ubiForm" method="post">
    <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
    <input type="hidden" id="ubi_jrt" name="jrf" value="INSTRREQSTDOC.jrf" />
    <input type="hidden" name="userNo" value="" />
</form>

<!-- MAIN CONTENT -->
<div id="content">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/menuTitle.jsp" flush="false" />
	
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post" class="smart-form">
                <input type="hidden" name="reqstSeq" id="reqstSeq"  value="0">
                <input type="hidden" name="eduDivision" id="eduDivision"  value="">
                <input type="hidden" name="confmAt" id="confmAt"  value="">
                <input type="hidden" name="nonApplyCon" id="nonApplyCon"  value="">
                <input type="hidden" name="instrctrNo" id="instrctrNo"  value="">
                <input type="hidden" name="instrctrDivision" id="instrctrDivision"  value="">
                <input type="hidden" name="dtyEduYn" id="dtyEduYn" value="">
                <input type="hidden" name="certCd" id="certCd" value="">
                <input type="hidden" name="userCenterCd" id="userCenterCd" value="<sec:authentication property="principal.centerId"/>">
                <input type="hidden" name="userId" id="userId" value="<sec:authentication property="principal.userId"/>">
                
                <div class="fL wp75">
                    <ul class="searchAreaBox">
						<li class="smart-form">
						    <label class="label">센터명</label>
						</li>
						<%-- <sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')"> --%>
							<li class="w150 mr5">
								<select name="centerCd" id="centerCd" class="form-control">
									<option value="">전체</option>
									<c:forEach var="center" items="${centerList }" varStatus="idx">
										<option value="${center.DEPT_CD }" data-groupId="${center.GROUP_ID }" ${center.DEPT_CD eq paginationInfo.centerCd ? 'selected="selected"':'' } >${center.DEPT_NM }</option>
									</c:forEach>
								</select> <i></i>
							</li>
						<%-- </sec:authorize>
						<sec:authorize access="hasRole('ROLE_ADMIN') or hasRole('ROLE_USER')">
							<li class="smart-form mr5">
								<input type="hidden" name="centerCd" id="centerCd" value="<sec:authentication property="principal.centerId"/>" >
								<label class="label"><sec:authentication property="principal.centerNm"/></label>
							</li>
						</sec:authorize> --%>
						                    
                    	<li class="smart-form"><label class="label">교육 구분</label></li>
                    	
                        <li class="w100 mr5">
                            <select id="sGubun" name="sGubun" class="form-control">
                                <option value="">전체</option>
								<c:forEach var="list" items="${codeMap.DMH19 }" varStatus="idx">
									<c:if test="${list.CODE ne '03'}">
		                                <option value="${list.CODE }" ${param.sGubun eq list.CODE ? 'selected="selected"':'' }>${list.CODE_NM }</option>
									</c:if>
								</c:forEach>
                            </select>
                        </li>
                    	
                    	<li class="smart-form"><label class="label">강사구인 구분</label></li>
                        <li class="w100 mr5">
                            <select id="sGubun1" name="sGubun1" class="form-control">
                                <option value="">전체</option>
                                <option value="B" ${param.sGubun1 eq 'B' ? 'selected="selected"':'' }>모집전</option>
                                <option value="I" ${param.sGubun1 eq 'I' ? 'selected="selected"':'' }>모집중</option>
                                <option value="A" ${param.sGubun1 eq 'A' ? 'selected="selected"':'' }>모집완료</option>
                            </select>
                        </li>
                        
						<li class="smart-form">
						    <label class="label">교육명</label>
						</li>
						<li class="w150 mr5">
							<input type="text" id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'>
						</li>                    
						    
						<li class="smart-form">
						    <label class="label">장소</label>
						</li>
						<li class="w150">
							<input type="text" id="searchKeyword2" name="searchKeyword2" class="form-control" value='<c:out value="${param.searchKeyword2}"/>'>
						</li>                        
                        
                        <li class="ml10">
                            <button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
                        </li>
                    </ul>
                </div>
                <%-- <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
                    <jsp:param value="list"     name="formType"/>
                    <jsp:param value="1,3"     name="buttonYn"/>
                </jsp:include> --%>
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
							<col width="6%">
							<col width="17%">
							<col width="15%">
                            <col width="19%">
                            <col width="17%">
                            <col width="5%">
                            <col width="10%">
                            <col width="11%">
                            
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>구분</th>
								<th>교육일시</th>
								<th>교육명</th>
								<th>교육대상</th>
								<th>장소</th>
								<th>신청</th>
								<th>여부</th>
								<th>센터</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr><td colspan="8">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list }" varStatus="idx">
								<tr>
									<td class="invisible">
										<input type="checkbox" class="index" value="${list.EDU_SEQ}">
									    <input type="hidden" name="eduDivision" value="${list.EDU_DIVISION}">
									    <input type="hidden" name="dtyEduYn" value="${list.DTY_EDU_YN}">
									    <input type="hidden" name="lectureId" value="${list.LECTURE_ID}">
									    <input type="hidden" name="reqstCenterCd" value="${list.CENTER_CD}">
									</td>
									<td>${list.EDU_DIVISION_NM }</td>
									<td>${list.EDU_DATE}</td>
									<td>${list.EDU_NM}</td>
									<td>${list.EDU_TARGET_TYPE}</td>
									<td>${list.EDU_PLACE}</td>
									<td><c:if test="${empty list.CNT }">0</c:if>${list.CNT }/10</td>
									<td>${list.YN}</td>
									<td>${list.CENTER_NM}</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" />
				</article>
				
				<article class="col-md-12 col-lg-6">
					<table class="table table-bordered tb_type03">
						<colgroup>
							<col width="1%">
							<col width="4%">
							<col width="10%">
							<col width="21.25%">
							<col width="21.25%">
							<col width="21.25%">
							<col width="21.25%">
						</colgroup>
						<tbody id="detailTable">
							<tr><td colspan="7" class="textAlignCenter">항목을 선택해주세요.</td></tr>
						</tbody>
					</table>
				</article>
				
				<form name="userForm" id="userForm" method="post" class="smart-form">
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
					<input type="hidden" name="userNo" value="">
					<input type="hidden" name="pageType" value="INSTRCTR">
				</form>					
			</div>
			<!-- row 메뉴조회 끝 -->
		</div>
	</section>
	<!-- widget grid end -->

</div>
<!-- END MAIN CONTENT -->
	<div id="layer1" class="popup-con" style="display:none;">
		<div class="close_box fClr"><a href="javascript:void(0);" class="close_popup fRight closeBtn" id="closeBtn"><i class="fa fa-times" style="margin: -5px 0 !important;"></i></a></div>
	    <div class="file_box fClr" style="text-align:left;">
	        <p class="tit fLeft" style="padding: 5px 0 0 10px;">반려사유 입력</p>
	    </div>
        <div class="text_box">
            <textarea name="nonApplyCon" id="nonApplyConLayer" cols="30" rows="10"></textarea>
            <button id="nonApplBtn" type="button">반려</button>
        </div>
	</div>

<script id="detail-template" type="text/x-handlebars-template">
{{#if .}}
{{#each de}}
<tr data-seq={{REQST_SEQ}} data-no={{INSTRCTR_NO}}>
	<th scope="row">신청인 </th>
	<td colspan="3">
		<div class="fL wp7 mt10">
			<span class="instrctrTab">{{INSTRCTR_NM}}</span>({{INSTRCTR_DIVISION_NM}} - {{DCSN_YN_NM}}) {{#notempty CERT_CD}}<br> {{CERT_CD_NM}}{{/notempty}}
			<span><br> 신청일: {{REGIST_PNTTM}}<span>
			<span><br> 마지막 강의일: {{MAX_END_YMD}}<span>
			<span><br> 최근 1년내 강의횟수(총 강의횟수): {{#sum I_CNT_TT S_CNT_TT}}{{/sum}}({{#sum I_CNT S_CNT}}{{/sum}})<span>
		</div>
	</td>
	<td colspan="3">
        <div class="wp1">
            <button class="btn btn-default ml2 mb5 reportDown" type="button" name="reportBtn" data-user-no="{{INSTRCTR_NO}}" ${pageInfo.REPORT_AT eq 'Y' ? '':'disabled'}><i class="fa fa-edit" title="리포트 출력" ></i> 리포트</button></ul>
			{{#ifeq ../INSERT_AT 'Y'}}
				{{#ifeq ../DTY_EDU_YN 'Y'}}
					<select name="certCd" class="form-control certCd" style="width:20%; height:34px; display:inline-block; padding:2px;">
   	                	<option value="">선택</option>
						{{#each ../lectureIds}}
							{{#ifeq VIDEO_AT 'N'}}
								<option value="{{LECTURE_ID}}">{{LECTURE_ID}}</option>
							{{/ifeq}}
						{{/each}}
        	        </select>
				{{/ifeq}}

            	{{#ifeq DCSN_YN 'Y'}}
            			<button class="btn btn-danger ml2 mb5" type="button" name="applyBtn" data-apply-btn="F" data-edu-division="{{EDU_DIVISION}}" data-reqst-seq="{{REQST_SEQ}}" data-instrctr-no="{{INSTRCTR_NO}}" data-instrctr-return-resn="{{INSTRCTR_RETURN_RESN}}" data-instrctr-division="{{INSTRCTR_DIVISION}}" {{#ifeq ../BUTTON_AT 'N'}}disabled{{/ifeq}}><i class="fa fa-edit" title="반려"></i> 반려</button></ul>
            			<button class="btn" style="{{#ifnoteq INSTRCTR_DIVISION 'I'}}background-color:#3276b1; color: #fff;{{else}}background-color:#e6e6e6;{{/ifnoteq}}" type="button" name="applyBtn" data-apply-btn="Y" data-instrctr-no="{{INSTRCTR_NO}}" data-instrctr-division="I" {{#ifeq ../BUTTON_AT 'N'}}disabled{{/ifeq}}><i class="fa fa-edit" title="승인"></i> 주강사 승인</button></ul>
						<button class="btn" style="{{#ifnoteq INSTRCTR_DIVISION 'S'}}background-color:#3276b1; color: #fff;{{else}}background-color:#e6e6e6;{{/ifnoteq}}" type="button" name="applyBtn" data-apply-btn="Y" data-instrctr-no="{{INSTRCTR_NO}}" data-instrctr-division="S" {{#ifeq ../BUTTON_AT 'N'}}disabled{{/ifeq}}><i class="fa fa-edit" title="승인"></i> 준강사 승인</button></ul>
					</div>
            	{{else}}
            		{{#ifeq DCSN_YN 'F'}}
            				<button class="btn ml2 mb5" style="background-color:e6e6e6;" type="button" name="applyBtn" data-apply-btn="F" data-edu-division="{{EDU_DIVISION}}" data-reqst-seq="{{REQST_SEQ}}" data-instrctr-no="{{INSTRCTR_NO}}" data-instrctr-return-resn="{{INSTRCTR_RETURN_RESN}}" data-instrctr-division="{{INSTRCTR_DIVISION}}"><i class="fa fa-edit" title="반려"></i> 반려</button></ul>
            				<button class="btn" style="background-color:#3276b1; color: #fff;" type="button" name="applyBtn" data-apply-btn="Y" data-instrctr-no="{{INSTRCTR_NO}}" data-instrctr-division="I" {{#ifeq ../BUTTON_AT 'N'}}disabled{{/ifeq}}><i class="fa fa-edit" title="승인"></i> 주강사 승인</button></ul>
							<button class="btn" style="background-color:#3276b1; color: #fff;" type="button" name="applyBtn" data-apply-btn="Y" data-instrctr-no="{{INSTRCTR_NO}}" data-instrctr-division="S" {{#ifeq ../BUTTON_AT 'N'}}disabled{{/ifeq}}><i class="fa fa-edit" title="승인"></i> 준강사 승인</button></ul>
						</div>
            		{{else}}
            				<button class="btn btn-danger ml2 mb5" type="button" name="applyBtn" data-apply-btn="F" data-edu-division="{{EDU_DIVISION}}" data-reqst-seq="{{REQST_SEQ}}" data-instrctr-no="{{INSTRCTR_NO}}" data-instrctr-return-resn="{{INSTRCTR_RETURN_RESN}}" data-instrctr-division="{{INSTRCTR_DIVISION}}" {{#ifeq ../BUTTON_AT 'N'}}disabled{{/ifeq}}><i class="fa fa-edit" title="반려"></i> 반려</button></ul>
            				<button class="btn" style="{{#ifnoteq INSTRCTR_DIVISION 'I'}}background-color:#3276b1; color: #fff;{{else}}background-color:#e6e6e6;{{/ifnoteq}}" type="button" name="applyBtn" data-apply-btn="Y" data-instrctr-no="{{INSTRCTR_NO}}" data-instrctr-division="I" {{#ifeq ../BUTTON_AT 'N'}}disabled{{/ifeq}}><i class="fa fa-edit" title="승인"></i> 주강사 승인</button></ul>
							<button class="btn" style="{{#ifnoteq INSTRCTR_DIVISION 'S'}}background-color:#3276b1; color: #fff;{{else}}background-color:#e6e6e6;{{/ifnoteq}}" type="button" name="applyBtn" data-apply-btn="Y" data-instrctr-no="{{INSTRCTR_NO}}" data-instrctr-division="S" {{#ifeq ../BUTTON_AT 'N'}}disabled{{/ifeq}}><i class="fa fa-edit" title="승인"></i> 준강사 승인</button></ul>
						</div>
            		{{/ifeq}}
            	{{/ifeq}}
           	{{/ifeq}}
        </div>
    </td>
</tr>
{{/each}}
{{else}}
    <tr class="noData">                           
        <td colspan="8">신청자가 없습니다.</td>             
    </tr>
{{/if}}
</script>
<%--
<script id="cert-cd-template" type="text/x-handlebars-template">
{{#each .}}
{{#empty certCd}}
	{{#if @first}}<li class="active">{{else}}<li>{{/if}} <a href="javascript:void(0);" data-cert-cd="{{LECTURE_ID}}">{{LECTURE_NM}}</a></li>
	{{else}}
	<li class="{{certCd}} eq {{LECTURE_ID}} ? 'active':''"><a href="javascript:void(0);" data-cert-cd="{{LECTURE_ID}}">{{LECTURE_NM}}</a></li>
{{/empty}}
{{/each}}
</script>
 --%>