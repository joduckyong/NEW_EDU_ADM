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
	            insertKey : "<c:out value='${common.baseType[0].key() }'/>",
	            updateKey : "<c:out value='${common.baseType[1].key() }'/>",
	            deleteKey : "<c:out value='${common.baseType[2].key() }'/>",
	            lUrl : "/ncts/mngr/instrctrMngr/instrctrCardList.do",
	            /* fUrl : "/ncts/mngr/instrctrMngr/instrctrForm.do", */
	            /* dUrl : "/ncts/mngr/instrctrMngr/mngrDeleteMember.do", */
	            /* excel : "/ncts/mngr/instrctrMngr/instrctrExcelDownload.do" */
	    }
	    
	    $.dataDetail = function(index){
	        if($.isNullStr(index)) return false;
	       
	        document.sForm.userNo.value = index;
	        
	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/instrctrMngr/instrctrCardDetail.do",
	            data: $("#sForm").serialize(),
	            dataType: "json",
	            success: function(data) {
	                if(data.success == "success"){
	                	data.de.INSERT_AT = "${pageInfo.INSERT_AT}";
	                    $("#detailTable").handlerbarsCompile($("#detail-template"), data.de);
	                    $("#file_input_file1").attr("style", "border:1px solid #e5e5e5;background-color:#ffffff;font-size:12px;;color:#666666;width:98%;height:30px;line-height:18px;padding:2px;");
	                    $("#div_file_pack1").attr("style", "display:block;float:left;width:70%;margin-bottom:15px;")
	                }
	            }
	        })
	    }
	    
	    $.procAction = function(val){
	    	if("F" == val){
	    		$("#layer1").css("display","block");
	    		
	    		return;
	    	} else if("A" == val){
	    		val = "F";
	    	}
	    	
	    	with(document.sForm){
	            procType.value = baseInfo.updateKey;
	            confmAt.value = val;
	            nonApplyCon.value = $("textarea[name=nonApplyCon]").val();
	            
	            $.ajax({
	                type: 'POST',
	                url: "/ncts/mngr/instrctrMngr/cardProc.do",
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
	    
	    $.ubiFormBtnOnClickEvt = function($this){
	        document.ubiForm.userNo.value = $this.data("userNo");
	        document.ubiForm.jrf.value = $this.data("jrf");
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
	    
	    $.saveFile = function(){
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
	        	$.procAction($(this).data("applyBtn"));
	        });
	        $(document).on("click", ".reportDown", function(){
                $.ubiFormBtnOnClickEvt($(this));
            });
	        $(".close_box").onClose();
	        $("#nonApplBtn").onNonAppl();
	        $(document).on("click", "#updateBtn", function(){
	        	$.saveFile();
	        })
	        
	        $("#file_input_file1").attr("style", "height:36px");
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
          	<form name="sForm" id="sForm" method="post" class="smart-form">
                <input type="hidden" name="userNo" id="userNo"  value="0">
                <input type="hidden" name="confmAt" id="confmAt"  value="">
                <input type="hidden" name="nonApplyCon" id="nonApplyCon"  value="">
                <input type="hidden" name="atchFileId" value="">
                
                <div class="fL wp75">
                    <ul class="searchAreaBox">
                    	<li class="smart-form"><label class="label">아이디</label></li>
                        <li class="w100 ml5">
                            <input id="searchKeyword4" name="searchKeyword4" class="form-control" value='<c:out value="${param.searchKeyword4}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">이름</label></li>
                        <li class="w100 ml5">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">이메일</label></li>
                        <li class="w180 ml5">
                            <input id="searchKeyword2" name="searchKeyword2" class="form-control" value='<c:out value="${param.searchKeyword2}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">연락처</label></li>
                        <li class="w130 ml5">
                            <input id="searchKeyword3" name="searchKeyword3" class="form-control" value='<c:out value="${param.searchKeyword3}"/>'> 
                        </li>
                        <li class="smart-form ml5">
                            <label class="label">세부등급</label>
                        </li>
                        <li class="w80">
                            <select id="sGubun1" name="sGubun1" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap.DMH23}" varStatus="idx">
	                                <option value="<c:out value='${list.CODE}'/>" <c:out value="${param.sGubun1 eq list.CODE ? 'selected=selected':'' }"/>><c:out value="${list.CODE_NM }"/></option>
                                </c:forEach>
                            </select>
                        </li>
                        <li class="smart-form ml5">
                            <label class="label">강사등급</label>
                        </li>
                        <li class="w80">
                            <select id="sGubun2" name="sGubun2" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap.DMH24}" varStatus="idx">
	                                <option value="<c:out value='${list.CODE}'/>" <c:out value="${param.sGubun2 eq list.CODE ? 'selected=selected':'' }"/>><c:out value="${list.CODE_NM }"/></option>
                                </c:forEach>
                            </select>
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
							<col width="12.5%">
							<col width="12.5%">
							<col width="12.5%">
                            <col width="12.5%">
                            <col width="12.5%">
                            <col width="12.5%">
                            <col width="12.5%">
                            <col width="12.5%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>아이디</th>
								<th>이메일</th>
								<th>이름</th>
								<th>연락처</th>
								<th>신청여부</th>
								<th>세부등급</th>
								<th>강사등급</th>
								<th>강사카드<br>작성날짜</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr ><td colspan="8">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list }" varStatus="idx">
								<tr>
									<td class="invisible"><input type="checkbox" class="index" value="<c:out value='${list.USER_NO}'/>"></td>
									<td><c:out value="${list.USER_ID}"/></td>
									<td><c:out value="${list.USER_EMAIL}"/></td>
									<td><c:out value="${list.USER_NM}"/></td>
									<td><c:out value="${list.USER_HP_NO}"/></td>
									<td><c:out value="${list.STATUS_NM}"/></td>
									<td><c:out value="${list.DETAIL_GRADE_CD_NM}"/></td>
									<td><c:out value="${list.INSTRCTR_DETAIL_GRADE_CD_NM}"/></td>
									<td><c:out value="${list.FRST_REGIST_PNTTM}"/></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" />
				</article>
				
				<article class="col-md-12 col-lg-6">
					<table class="table table-bordered tb_type03">
						<colgroup>
							<col width="20%">
							<col width="30%">
							<col width="20%">
							<col width="30%">
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
<div id="layer1" class="popup-con" style="display:none">
    <div class="close_box fClr" style="text-align:left;">
        <p class="tit fLeft">반려사유 입력</p>
        <a href="javascript:void(0);" class="fRight"><i class="fa fa-times"></i></a>
    </div>
        <div class="text_box">
            <textarea name="nonApplyCon" id="" cols="30" rows="10"></textarea>
            <button id="nonApplBtn" type="button">반려</button>
        </div>
</div>

<script id="detail-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">신청여부 </th>
	<td colspan="3"><div class="fL wp5 mt10">{{STATUS_NM}}</div>
        <div class="fR wp5">
            <button class="btn btn-default ml2 mb5 reportDown" type="button" data-user-no="{{USER_NO}}" data-jrf="INSTRREQSTDOC.jrf" <c:out value="${pageInfo.REPORT_AT eq 'Y' ? '':'disabled'}"/>><i class="fa fa-edit" title="리포트 출력"></i> 리포트</button></ul>
				{{#ifeq INSERT_AT "Y"}}
            		{{#ifnoteq CONFM_AT "N"}}
	                	<button class="btn btn-primary" type="button" name="applyBtn" data-apply-btn="N"><i class="fa fa-edit" title="승인 및 반려 취소"></i> 승인 및 반려 취소</button></ul>
            		{{/ifnoteq}}
            		{{#ifnoteq CONFM_AT "F"}}
	                	<button class="btn btn-danger ml2 mb5" type="button" name="applyBtn" data-apply-btn="F"><i class="fa fa-edit" title="반려"></i> 반려</button></ul>
            		{{/ifnoteq}}
            		{{#ifnoteq CONFM_AT "Y"}}
                		<button class="btn btn-primary" type="button" name="applyBtn" data-apply-btn="Y"><i class="fa fa-edit" title="승인"></i> 승인</button></ul></div>
            		{{/ifnoteq}}
				{{/ifeq}}
        </div>
    </td>
</tr>

<tr>
    <th scope="row">아이디</th>
    <td>{{USER_ID}}</td>
	<th scope="row">이름</th>
	<td>{{USER_NM}}</td>
</tr>
<tr>
    <th scope="row">이메일</th>
    <td>{{USER_EMAIL}}</td>
	<th scope="row">강사카드 작성날짜</th>
	<td>{{FRST_REGIST_PNTTM}}</td>
</tr>
<tr>
	<th scope="row">주소</th>
	<td colspan="3">{{ADDRESS}}</td>
</tr>
<tr>
    <th scope="row">연락처</th>
    <td colspan = "3">{{USER_HP_NO}}</td>
</tr>
<tr>
	<th scope="row">1지망</th>
	<td>{{INSTRCTR_ACT_AREA1}}</td>
    <th scope="row">2지망</th>
    <td>{{INSTRCTR_ACT_AREA2}}</td>
</tr>
<tr>
    <th scope="row">부서 </th>
    <td>{{DEPT_NM}}</td>
    <th scope="row">직급</th>
    <td>{{CLSF}}</td>
</tr>
{{#ifeq CONFM_AT "F"}}
<tr>
    <th scope="row">반려사유</th>
    <td colspan="3">{{CONTENTS}}</td>
</tr>
{{/ifeq}}

<tr>
    <th scope="row">첨부파일 </th>
    <td colspan="3">{{safe fileView}}</td>
</tr>
<tr>
	<th scope="row">개인정보 동의여부</th>
	<td colspan="3">
		{{AGREE_AT}} 
		{{#ifeq AGREE_AT 'Y'}}
			<button class="btn btn-default ml2 mb5 reportDown" type="button" data-user-no="{{USER_NO}}" data-jrf="INSTRCTR_AGREEMENT.jrf" <c:out value="${pageInfo.REPORT_AT eq 'Y' ? '':'disabled'}"/>><i class="fa fa-edit" title="리포트 출력"></i> 동의서</button>
		{{/ifeq}}
	</td>
</tr>
</script>