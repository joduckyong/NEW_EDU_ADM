 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
  .fClr:after {display: block;content: "";clear: both;}
  .fLeft {float: left;}
  .fRight {float: right;}
  .fa-times:before {content: "\f00d";font-size: 24px;color: #fff;}
  td select {padding: 4px; border: 1px solid #ccc;}

  .popup-con * {margin: 0;padding: 0;box-sizing: border-box;}
  .popup-con {position: fixed;left: 50%;top: 50%;transform: translate(-50%, -50%);width: 530px; height: auto;text-align: center;box-shadow: 2px 2px 3px rgba(0, 0, 0, .1), -2px 2px 3px rgba(0, 0, 0, .1), 2px -1px 3px rgba(0, 0, 0, .1), -2px -1px 3px rgba(0, 0, 0, .1);}
  .popup-con .close_box {height: 30px;background: #57698e;}
  .popup-con .close_box p {margin-left: 10px;line-height: 30px;font-size: 14px;font-weight: bold;color: #fff;}
  .popup-con .close_box a {padding: 2px 8px;}
  .popup-con .text_box {width: 100%;border-bottom: 1px solid #9ca2a7;border-left: 1px solid #9ca2a7;border-right: 1px solid #9ca2a7;background-color:white;}
  .popup-con textarea {margin: 10px 0;padding: 5px;width: 510px;height: 120px;border: 1px solid #ccc;resize: none;}
  .popup-con button {margin-bottom: 10px;width: 65px;height: 32px;color: #fff;background: #3276b1;border: 1px solid #2c699d;border-radius: 2px;}
  
  /* .tr_clr_no {
  	border: 2px solid red !important;
  } */
</style>
<script type="text/javascript">
	$(function(){
		var excelPg = 0;
		
	    var baseInfo = {
	            insertKey : "<c:out value='${common.baseType[0].key() }'/>",
	            updateKey : "<c:out value='${common.baseType[1].key() }'/>",
	            deleteKey : "<c:out value='${common.baseType[2].key() }'/>",
	            lUrl : "/ncts/mngr/instrctrMngr/instrctrMngrList.do",
	            fUrl : "/ncts/mngr/instrctrMngr/instrctrForm.do",
	            dUrl : "/ncts/mngr/userMngr/mngrDeleteMember.do",
	            excel : "/ncts/mngr/instrctrMngr/instrctrOfflectExcelDownload.do",
	            pop01 : "/ncts/mngr/userMngr/mngrFileConfirmListPopup.do",
	            instrctrTabPop : "/ncts/mngr/instrctrMngr/instrctrTabPopup.do"
	    }
	    
	    $.dataDetail = function(index){
	        if($.isNullStr(index)) return false;
	        document.sForm.userNo.value = index;
	        /* $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/userMngr/mngrMemberDetail.do",
	            data: $("#sForm").serialize(),
	            dataType: "json",
	            success: function(data) {
	                if(data.success == "success"){
	                	var courses = "";
	                    //$("#prmoDetail").empty();
	                    //$.addTemplate("detail-template", "prmoDetail", data.rs) 
	                    $(".tab-content").show();
	                    $("#detailTable").handlerbarsCompile($("#detail-template"), data.de);
	                    $("#seTable").handlerbarsCompile($("#se-template"), data.se);
	                    $("#seTable").handlerbarsAppendCompile($("#video-se-template"), data.seVideo);
	                    
	                    if($("#courses").val() == '') courses = "#coursesEtc";
	                    else courses = "#courses"+$("#courses").val();
	                    $(courses).closest("ul").find("li").removeClass("active");
	                    $(courses).closest("li").addClass("active");
	                    
	                    $.noteDataOnSettings(data);     
	                    $(".instrctrSelect").instrctrSelectOnChangeEvt(baseInfo.updateKey, index);
	                    $("#packageAuthAt").packageAuthAtOnChangeEvt(baseInfo.updateKey, index);
	                }
	            }
	        }) */
	    }
	    
	    $.fn.procBtnOnClickEvt = function(url, key){
	        var _this = $(this);
	        _this.on("click", function(){
	        	document.sForm.recordCountPerPage.value = $("select[name='recordCountPerPage']").val();
	        	document.sForm.searchCondition3.value = $("select[name='searchCondition3']").val();
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
	    	$.loadingBarStart();
	        var no = 1;
	        
	        if(typeof(arguments[0]) != "undefined") no = arguments[0].pageNo;
	        with(document.sForm){
	            currentPageNo.value = no;
	            recordCountPerPage.value = $("select[name='recordCountPerPage']").val();
	            searchCondition3.value = $("select[name='searchCondition3']").val();
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
	    
	    $.fn.instrctrListATagOnClickEvt = function(){
	    	var _this = $(this);
	    	_this.on("click", function(){
	    		var $this = $(this);
	    		document.sForm.searchCondition1.value = $this.data("val");
	    		$.searchAction();
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
	    
	    $.fn.excelDownOnClickEvt = function() {
	    	$(this).on("click", function(e){
		    	if(!confirm("엑셀다운로드하시겠습니까?")) return false;
		    	$("#downPopup").show();
	    	})
	    }	    
	    
	    $.excelDownload = function(e){
	    	excelPg = 1;
			$("[name='excelFileNm']").val($("#instrctrList .active a").data("excel")+"_강사(명단)관리_"+$.toDay());
			$("[name='excelPageNm']").val("instrctrOfflectList.xlsx");		        	
            with(document.sForm){
            	currentPageNo.value = "${paginationInfo.currentPageNo}";
            	recordCountPerPage.value = "${paginationInfo.recordCountPerPage}";
            	target = "";
                action = baseInfo.excel;
                submit();
                
                $.setCookie("fileDownloadToken","false");
                $.loadingBarStart(e);
                $.checkDownloadCheck();
            }
	    }
	    
		$.fn.instrctrSelectOnChangeEvt2 = function(pKey){
			$(this).on("change",  function(){
				var $this = $(this);
				//if($this.prop("id") == "noteProcBtn") {
				var nForm = document.nForm;
				if(nForm.pfatGradeCd != undefined) nForm.pfatGradeCd.value = $("#pfatGradeCd").val();
				if(nForm.sprtGradeCd != undefined) nForm.sprtGradeCd.value = $("#sprtGradeCd").val();
				if(nForm.pmptGradeCd != undefined) nForm.pmptGradeCd.value = $("#pmptGradeCd").val();
				if(nForm.mpgtGradeCd != undefined) nForm.mpgtGradeCd.value = $("#mpgtGradeCd").val();
				nForm.procType.value = pKey;
				nForm.userNo.value = $this.closest("tr").find(".index").val();
				//}
				$.ajax({
					type: 'POST',
					data : $("#nForm").serialize(),
					url: "/ncts/mngr/userMngr/updateMngrMemberNote.do",
					dataType: "json",
					success: function(result) {
						if(result.success == "success") {
							$("#layer2").closest(".dim-layer").show();
							/*alert(result.msg);
							$("#notePopup").hide();*/
						}
					}
				});
			})
		}
			
	    $.fn.instrctrTabOnClickEvt = function(){
	    	$(this).on("click", function(){
	    		if($.isNullStr($(this).closest("tr").find(".index").val())) return false;
	    		document.sForm.userNo.value = $(this).closest("tr").find(".index").val();
	    		document.sForm.recordCountPerPage.value = $("select[name='recordCountPerPage']").val();
	    		document.sForm.searchCondition3.value = $("select[name='searchCondition3']").val();
	    		
	    		$.popAction.width = 1200;
				$.popAction.height = 600;
				$.popAction.target = "instrctrTabPopup";
				$.popAction.url = baseInfo.instrctrTabPop;
				$.popAction.form = document.sForm;
				$.popAction.init();	    		
	    	})
	    }		
	    
	    $.fn.orderBtnOnClickEvt = function(){
	    	$(this).on("click", function(){
	    		var $this = $(this);
	    		var orderVal = $this.data("orderVal") == "ASC" ? "DESC" : "ASC";
	    		
	    		$this.data("val", orderVal);
	    		$("input[name='orderSeq']").val($this.data("orderSeq"));
	    		$("input[name='orderVal']").val(orderVal);
	    		
	    		$.searchAction();
	    	})
	    }
	    
		$.onClickTableTr = function(){
			var $listtable = $(".listtable > tbody > tr");
			
			$listtable.on("click", function(){
				var $this = $(this);
				var $body = $this.parent();
				var $chkbox = $this.find("td.invisible:first > input[type=checkbox]");
				var $hidden = $this.find("td.invisible:first > input[type=hidden]");
				var $tr = $this.closest('tr');
				var obj = {};  
				
				$body.find('input[type=checkbox]').each(function(){ $(this).prop("checked", false); })
				$body.find('tr').each(function(){ $(this).removeClass("tr_clr_no"); })
				
				if($chkbox.is(":checked")){
					$chkbox.prop("checked", false);
					$tr.removeClass("tr_clr_no");
				}else{
					if($hidden.size() > 0){
						$hidden.each(function(){
							obj[$(this).attr("name")] = $(this).val(); 
						})	
					}
					
					$chkbox.prop("checked", true);
					$tr.addClass("tr_clr_no");
					if(typeof $.dataDetail != "undefined" ) $.dataDetail($chkbox.val(), obj);
				}
			})
			
			$listtable.find("td.invisible:first > input[type=checkbox]").prop("checked", false);
			
			$listtable.on("dblclick", function(){
				if(typeof $.dblClickEvt != "undefined" ) $.dblClickEvt();
			})
			
		}	    
	    
	    $.initView = function(){
	        $.onClickTableTr();
	        $("#searchBtn").searchBtnOnClickEvt($.searchAction);
	        $("#saveBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.insertKey);
	        $("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
	        $("#delBtn").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey);
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
	        
	        $("body").on("keydown", function(e){
		        $.loadingBarKeyDown(e, excelPg);
	        })
	        
	        $("input[name='searchKeyword1']").keypress(function(e){if(e.keyCode == 13)  $.searchAction();});
	        
	        $("body").fileConfirmBtnOnClickEvt();
	        $("body").confirmDetailBtnOnClickEvt();
	        
	        $("body").on("click", ".reportDown", function(){
	        	var $this = $(this);
		        document.ubiForm.userNo.value = $this.data("userNo");
		        document.ubiForm.jrf.value = $this.data("jrf");
	            popUbiReport();
	        });	        
	        $("#instrctrList a").instrctrListATagOnClickEvt();
	        $(".instrctrSelect").instrctrSelectOnChangeEvt2(baseInfo.updateKey);
	        $.instrctrDetailViewOnSettings($("input[name='loginUserId']").val());
	        
	        $(".instrctrTab").instrctrTabOnClickEvt();
	        $(".orderBtn").orderBtnOnClickEvt();
	        
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
                <input type="hidden" name="courses" id="courses" value="04">
                <input type="hidden" name="fileConfirmAt" id="fileConfirmAt" value="">
                <input type="hidden" name="sGubun3" id="sGubun3"  value="INSTRCTR">
                <input type="hidden" name="searchCondition1" id="searchCondition1" value="<c:out value='${param.searchCondition1 }'/>">
                <input type="hidden" name="searchCondition3" id="searchCondition3" value="<c:out value='${param.searchCondition3 }'/>">
                <input type="hidden" name="recordCountPerPage" id="recordCountPerPage" value="<c:out value='${param.recordCountPerPage }'/>">
                <input type="hidden" name="loginUserId" value="<sec:authentication property="principal.userId"/>" >
                
                <input type="hidden" name="orderSeq" value="<c:out value='${param.orderSeq }'/>">
                <input type="hidden" name="orderVal" value="<c:out value='${param.orderVal }'/>">
                
                <div class="fL wp75">
                    <ul class="searchAreaBox" style="float:left;">
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
                        <li class="w150 ml5">
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
                                    <option value="<c:out value="${list.CODE }"/>" <c:out value="${param.sGubun1 eq list.CODE ? 'selected=selected':'' }"/>>
	                                    <c:out value="${list.CODE_NM}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </li>
                        
                        <li class="smart-form ml5">
                            <label class="label">강사등급</label>
                        </li>
                        <li class="w80">
                            <select id="sGubun5" name="sGubun5" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap.DMH24 }" varStatus="idx">
                                    <option value="<c:out value="${list.CODE }"/>" <c:out value="${param.sGubun5 eq list.CODE ? 'selected=selected':'' }"/>>
	                                    <c:out value="${list.CODE_NM}"/>
                                    </option>
                                </c:forEach>                                
                            </select>
                        </li>
                    </ul>
                    <ul class="searchAreaBox" style="float: left; margin-top: 10px;">
                        <li class="smart-form">
                            <label class="label">본인인증</label>
                        </li>
                        <li class="w80">
                            <select id="sGubun4" name="sGubun4" class="form-control">
                                <option value="">선택</option>
                                <option value="Y" <c:out value="${param.sGubun4 eq 'Y' ? 'selected=selected':'' }"/>>Y</option>
                                <option value="N" <c:out value="${param.sGubun4 eq 'N' ? 'selected=selected':'' }"/>>N</option>
                            </select>
                        </li>     
                        <li class="smart-form ml5">
                            <label class="label">현재직장</label>
                        </li>
                        <li class="w150 ml5">
                            <input id="searchKeyword5" name="searchKeyword5" class="form-control" value='<c:out value="${param.searchKeyword5}"/>'> 
                        </li>                        
                        <li class="smart-form ml5">
                            <label class="label">자격</label>
                        </li>
                        <li class="w150 ml5">
                            <input id="searchKeyword6" name="searchKeyword6" class="form-control" value='<c:out value="${param.searchKeyword6}"/>'> 
                        </li>                        
                        <li class="smart-form ml5">
                            <label class="label">심리지원 1순위</label>
                        </li>
                        <li class="w100">
                            <select id="sGubun6" name="sGubun6" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap.DMH07 }" varStatus="idx">
                                    <option value="<c:out value="${list.CODE }"/>" <c:out value="${param.sGubun6 eq list.CODE ? 'selected=selected':'' }"/>>
	                                    <c:out value="${list.CODE_NM}"/>
                                    </option>
                                </c:forEach>                                
                            </select>
                        </li>                       
                        <li class="smart-form ml5">
                            <label class="label">심리지원 2순위</label>
                        </li>
                        <li class="w100">
                            <select id="sGubun7" name="sGubun7" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap.DMH07 }" varStatus="idx">
                                    <option value="<c:out value="${list.CODE }"/>" <c:out value="${param.sGubun7 eq list.CODE ? 'selected=selected':'' }"/>>
	                                    <c:out value="${list.CODE_NM}"/>
                                    </option>
                                </c:forEach>                                
                            </select>
                        </li>                       
                        
                        <li class="ml10">
                            <button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
                        </li>
                    </ul>
                </div>
                <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
                    <jsp:param value="list"     name="formType"/>
                    <jsp:param value="1,2,3"     name="buttonYn"/>
                </jsp:include>
                
                <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
                <!-- <button class="btn btn-primary fRight" type="button" id="btntest" style="background: orange;">TEST</button> -->
            </form>
		</div>
		<!-- Search 영역 끝 -->
	
		<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />
		
		<form method="post" name="nForm" id="nForm">
			<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
			<input type="hidden" name="userNo" value="" >
			<input type="hidden" name="${fn:toLowerCase(param.searchCondition1)}GradeCd" value="" >
			
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
		</form>		
		
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<div class="tab-content">
						<div class="jarviswidget-sortable active" id="instrctrList">
							<ul class="fL nav nav-tabs">
								<li class="<c:out value="${empty param.searchCondition1 or param.searchCondition1 eq  '' 	  ? 'active' : ''}"/>"><a href="javascript:void(0);" data-val="">전체</a></li>
								<li class="<c:out value="${param.searchCondition1 eq 'PFAT' ? 'active' : ''}"/>"><a href="javascript:void(0);" data-val="PFAT" data-excel="PFA">PFA</a></li>
								<li class="<c:out value="${param.searchCondition1 eq 'PMPT' ? 'active' : ''}"/>"><a href="javascript:void(0);" data-val="PMPT" data-excel="PMPLUS">PM+</a></li>
								<li class="<c:out value="${param.searchCondition1 eq 'SPRT' ? 'active' : ''}"/>"><a href="javascript:void(0);" data-val="SPRT" data-excel="SPR">SPR</a></li>
								<li class="<c:out value="${param.searchCondition1 eq 'MPGT' ? 'active' : ''}"/>"><a href="javascript:void(0);" data-val="MPGT" data-excel="MPG">MPG</a></li>
								<li class="w80 mr5" style="float: right !important;">
									<select name="recordCountPerPage" class="form-control">
										<option value="20"   <c:out value="${param.recordCountPerPage eq '20' ?'selected=selected':''}"/>>20</option>
										<option value="40"   <c:out value="${param.recordCountPerPage eq '40'?'selected=selected':'' }"/>>40</option>
										<option value="80"   <c:out value="${param.recordCountPerPage eq '80'?'selected=selected':'' }"/>>80</option>
										<option value="100"  <c:out value="${param.recordCountPerPage eq '100'?'selected=selected':'' }"/>>100</option>
										<option value="120"  <c:out value="${param.recordCountPerPage eq '120'?'selected=selected':'' }"/>>120</option>
										<option value="140"  <c:out value="${param.recordCountPerPage eq '140'?'selected=selected':'' }"/>>140</option>
										<option value="160"  <c:out value="${param.recordCountPerPage eq '160'?'selected=selected':'' }"/>>160</option>
										<option value="180"  <c:out value="${param.recordCountPerPage eq '180'?'selected=selected':'' }"/>>180</option>
										<option value="200"  <c:out value="${param.recordCountPerPage eq '200'?'selected=selected':'' }"/>>200</option>
									</select> <i></i> 
								</li>								
								<li class="w100 mr5" style="float: right !important;">
									<select name="searchCondition3" class="form-control">
										<option value="">선택</option>
					                	<c:forEach var="list" items="${codeMap.DMH30 }" varStatus="idx">
					                		<c:if test="${list.CODE ne '00' }">
												<option value="<c:out value="${list.CODE}"/>" data-change-at="<c:out value="${list.CODE eq '02' or list.CODE eq '03' ? 'Y' : ''}"/>" data-other="<c:out value="${list.CODE eq '99' ? 'Y' : ''}"/>" <c:out value="${param.searchCondition3 eq list.CODE ? 'selected':''}"/>><c:out value="${list.CODE_NM}"/></option>
											</c:if>	
					             	 	</c:forEach> 
									</select> <i></i> 
								</li>								
							</ul>
						</div>
					</div>				
					<table class="table table-bordered tb_type01 listtable">
						<colgroup>
							<col width="3%">
							<col width="0%">
							<col width="6%">
							<col width="4%">
                            <col width="5%">
                            <col width="7%">
                            <col width="9%">
                            <col width="10%">
                            <col width="8%">
                            <col width="5%">
                            <col width="5%">
                            <col width="5%">
                            <col width="5%">
                            <col width="7%">
				     	    <col width="7%">
                            <col width="7%">
                            <col width="7%">
                            
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>연번</th>
								<th>강사등급<br><button class="btn btn-default ml2 orderBtn" type="button" data-order-seq="1" data-order-val="<c:out value="${param.orderSeq eq 1 ? param.orderVal : 'ASC' }"/>"><i class="fa fa-align-justify"></i></button></th>
								<th>성명</th>
								<th>생년월일</th>
								<th>아이디</th>
								<th>이메일</th>
								<th>연락처</th>
								<th>현재직장<br><button class="btn btn-default ml2 orderBtn" type="button" data-order-seq="2" data-order-val="<c:out value="${param.orderSeq eq 2 ? param.orderVal : 'ASC' }"/>"><i class="fa fa-align-justify"></i></button></th>
								<th>자격<br><button class="btn btn-default ml2 orderBtn" type="button" data-order-seq="3" data-order-val="<c:out value="${param.orderSeq eq 3 ? param.orderVal : 'ASC' }"/>"><i class="fa fa-align-justify"></i></button></th>
								<th>심리지원<br>1순위</th>
								<th>심리지원<br>2순위</th>
								<th>강의횟수<button class="btn btn-default ml2 orderBtn" type="button" data-order-seq="4" data-order-val="<c:out value="${param.orderSeq eq 4 ? param.orderVal : 'ASC' }"/>"><i class="fa fa-align-justify"></i></button></th>
								<th>강사<br>보고서<br>(최종)<br><button class="btn btn-default ml2 orderBtn" type="button" data-order-seq="5" data-order-val="<c:out value="${param.orderSeq eq 5 ? param.orderVal : 'ASC' }"/>"><i class="fa fa-align-justify"></i></button></th>
								
								<th>강사교육<br>이수일<br><button class="btn btn-default ml2 orderBtn" type="button" data-order-seq="7" data-order-val="<c:out value="${param.orderSeq eq 7 ? param.orderVal : 'ASC' }"/>"><i class="fa fa-align-justify"></i></button></th>
					     	    <c:if test="${param.searchCondition1 eq 'PFAT'}">
					     	    	<th>위촉날짜<br><button class="btn btn-default ml2 orderBtn" type="button" data-order-seq="9" data-order-val="<c:out value="${param.orderSeq eq 9 ? param.orderVal : 'ASC' }"/>"><i class="fa fa-align-justify"></i></button></th>
								</c:if>
								<c:if test="${param.searchCondition1 eq 'PMPT'}">
					     	    	<th>위촉날짜<br><button class="btn btn-default ml2 orderBtn" type="button" data-order-seq="10" data-order-val="<c:out value="${param.orderSeq eq 10 ? param.orderVal : 'ASC' }"/>"><i class="fa fa-align-justify"></i></button></th>
								</c:if>
								<c:if test="${param.searchCondition1 eq 'SPRT'}">
					     	    	<th>위촉날짜<br><button class="btn btn-default ml2 orderBtn" type="button" data-order-seq="11" data-order-val="<c:out value="${param.orderSeq eq 11 ? param.orderVal : 'ASC' }"/>"><i class="fa fa-align-justify"></i></button></th>
								</c:if>
								<c:if test="${param.searchCondition1 eq 'MPGT'}">
					     	    	<th>위촉날짜<br><button class="btn btn-default ml2 orderBtn" type="button" data-order-seq="12" data-order-val="<c:out value="${param.orderSeq eq 12 ? param.orderVal : 'ASC' }"/>"><i class="fa fa-align-justify"></i></button></th>
								</c:if>
								<th>마지막<br>강의일<br><button class="btn btn-default ml2 orderBtn" type="button" data-order-seq="6" data-order-val="<c:out value="${param.orderSeq eq 6 ? param.orderVal : 'ASC' }"/>"><i class="fa fa-align-justify"></i></button></th>
								<th>교육<br>재이수일<br><button class="btn btn-default ml2 orderBtn" type="button" data-order-seq="8" data-order-val="<c:out value="${param.orderSeq eq 8 ? param.orderVal : 'ASC' }"/>"><i class="fa fa-align-justify"></i></button></th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr ><td colspan="13">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list }" varStatus="idx">
								<c:choose>
									<c:when test="${list.INSTRCTR_ACT_CNT eq '2' }">
										<tr style="background: #c2e2ef;">
									</c:when>
									<c:when test="${list.INSTRCTR_RESULT eq '01' }">
										<tr style="background: #cce1f4;">
									</c:when>
									<c:when test="${list.INSTRCTR_RESULT eq '02' }">
										<tr style="background: #fbe3d6;">
									</c:when>
									<c:when test="${list.INSTRCTR_RESULT eq '03' }">
										<tr style="background: #d9f2d0;">
									</c:when>
								</c:choose>
									<td class="invisible">
										<input type="checkbox" class="index" value="<c:out value='${list.USER_NO}'/>">
									</td>
									<td>${(paginationInfo.currentPageNo - 1) * paginationInfo.recordCountPerPage + idx.index + 1}</td>
									<td>
										<label class="select col mr5">
											<select id="${fn:toLowerCase(param.searchCondition1)}GradeCd" name="${fn:toLowerCase(param.searchCondition1)}GradeCd" class="instrctrSelect">
												<option value="">해당없음</option>
							                	<c:forEach var="code" items="${codeMap.DMH24 }" varStatus="idx">
							                    	<option value="<c:out value='${code.CODE }'/>" <c:out value="${code.CODE eq list.INSTRCTR_GRADE_CD ? 'selected':'' }"/>>
								                    	<c:out value="${code.CODE_NM}"/>
							                        </option>
							               	 	</c:forEach>  
											</select>	 <i></i>				
										</label>				
									</td>
									<td class="instrctrTab"><c:out value="${list.USER_NM}"/></td>
									<td><c:out value="${list.USER_BIRTH_YMD}"/></td>
									<td><c:out value="${list.USER_ID}"/></td>
									<td><c:out value="${list.USER_EMAIL}"/></td>
									<td><c:out value="${list.USER_HP_NO}"/></td>
									<td><c:out value="${list.CURRENT_JOB_NM}"/></td>
									<td><c:out value="${list.LICENSE_NM}"/></td>
									<td><c:out value="${list.ACTIVE_AREA_CD1_NM}"/></td>
									<td><c:out value="${list.ACTIVE_AREA_CD2_NM}"/></td>
									<td><c:out value="${list.INSTRCTR_LCTRE_CNT}"/></td>
									<td><c:out value="${list.INSTRCTR_ACT_CNT}"/></td>
									<td><c:out value="${list.T_ISSUE_DT_F}"/></td>
									<c:choose>
										<c:when test="${param.searchCondition1 eq 'PFAT'}">
											<c:if test="${list.PFAT_INSTRCTR_ENTRST_DE ne 'undefined'}">
												<td><c:out value="${list.PFAT_INSTRCTR_ENTRST_DE}"/></td>
											</c:if>
											<c:if test="${list.PFAT_INSTRCTR_ENTRST_DE eq 'undefined' or list.PFAT_INSTRCTR_ENTRST_DE eq 'null'}">
												<td></td>
											</c:if>
										</c:when>
										<c:when test="${param.searchCondition1 eq 'PMPT'}">
											<c:if test="${list.PMPT_INSTRCTR_ENTRST_DE ne 'undefined'}">
												<td><c:out value="${list.PMPT_INSTRCTR_ENTRST_DE}"/></td>
											</c:if>
											<c:if test="${list.PMPT_INSTRCTR_ENTRST_DE eq 'undefined' or list.PMPT_INSTRCTR_ENTRST_DE eq 'null'}">
												<td></td>
											</c:if>
										</c:when>
										<c:when test="${param.searchCondition1 eq 'SPRT'}">
											<c:if test="${list.SPRT_INSTRCTR_ENTRST_DE ne 'undefined'}">
												<td><c:out value="${list.SPRT_INSTRCTR_ENTRST_DE}"/></td>
											</c:if>
											<c:if test="${list.SPRT_INSTRCTR_ENTRST_DE eq 'undefined' or list.SPRT_INSTRCTR_ENTRST_DE eq 'null'}">
												<td></td>
											</c:if>
										</c:when>
										<c:when test="${param.searchCondition1 eq 'MPGT'}">
											<c:if test="${list.MPGT_INSTRCTR_ENTRST_DE ne 'undefined'}">
												<td><c:out value="${list.MPGT_INSTRCTR_ENTRST_DE}"/></td>
											</c:if>
											<c:if test="${list.MPGT_INSTRCTR_ENTRST_DE eq 'undefined' or list.MPGT_INSTRCTR_ENTRST_DE eq 'null'}">
												<td></td>
											</c:if>
										</c:when>
									</c:choose>
									<td><c:out value="${list.END_YMD}"/></td>
									<td><c:out value="${list.E_ISSUE_DT_F}"/></td>
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

<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/downloadReasonPopup.jsp" flush="false" />