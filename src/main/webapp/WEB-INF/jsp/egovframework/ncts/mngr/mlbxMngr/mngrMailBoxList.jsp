<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">

$(function(){
	CKEDITOR.replace('contents',{height : 150});
	var excelPg = 0;
	var baseInfo = {
			insertKey : "${common.baseType[0].key() }",
			updateKey : "${common.baseType[1].key() }",
			deleteKey : "${common.baseType[2].key() }",
			lUrl : "/ncts/mngr/mlbxMngr/mngrMailBoxList.do",
			uUrl : "/ncts/mngr/mlbxMngr/updatePostProcess.do",
			eUrl : "/ncts/mngr/mlbxMngr/mngrMailBoxEmailSend.do",
			excel : "/ncts/mngr/mlbxMngr/mngrMailBoxDownload.do",
	}
	
	 $.fn.dataDetail = function(index){		
		$(this).on("click", function(){
			var $this = $(this);
			$("tr").removeClass("tr_clr_2");
			$this.addClass("tr_clr_2");
			$this.find(".index").prop("checked", true);
			document.sForm.postNo.value = $this.find(".index").val();
			
			$.ajax({
				type: 'POST',
				url: '/ncts/mngr/mlbxMngr/selectMngrMailBoxDetail.do',
				data: $("#sForm").serialize(),
				dataType: "json",
				success: function(data) {
					if(data.success == "success"){
	                	$("#iFormPostNo").val(data.rs.POST_NO);
	                	CKEDITOR.instances.contents.setData(data.rs.CONTENTS);
					}
				}
			})
		})
		//$(".tr_clr_2").find("#test").prop("checked",true);
		//$(this).prop('checked', true);
	} 
	
	$.fn.procBtnOnClickEvt = function(url, key){
		var _this = $(this);
		_this.on("click", function(){
			if(baseInfo.insertKey != key){
				if($("input.index:checked").size() <= 0) {
					alert("항목을 선택하시기 바랍니다.");
					return false;
				}else{
					document.sForm.eduSeq.value = $("input.index:checked").val();
				} 
			}else{
				document.sForm.eduSeq.value = "";
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
            target='';
            submit();
        }
	}
	
	$.fn.procOnClickEvt = function(e){
		var _this = $(this);
		
		_this.on("click", function(){
			var $this = $(this);
			var id = $this.attr("id");
			
			if($("input.postYnCheckbox:checked").size() <= 0) {
				alert("항목을 선택하시기 바랍니다.");
				return false;
			}
			
			var postVal = "";
			var postYn = "";
			var email = "";
			var isCheck = true;
			$("input:checkbox[name=postNo]:checked").each(function(idx){
				var $element = $(this);
				var yn = $element.data("yn");
				var email = $element.data("email");
				
	            if(idx != 0){
	            	postVal += ',';
	            	postYn += ',';
	            }
	            postVal += $element.val();
	            
	            if(id == 'emailBtn') {
	            	if(email == '') {
	            		alert("이메일 공란 시, 이메일을 전송할 수 없습니다.");
	            		isCheck = false;
		            	return false;
	            	}
	            	if(yn == 'Y') {
		            	alert("전송완료 시, 이메일을 전송할 수 없습니다.");
		            	isCheck = false;
		            	return false;
	            	}
	            	else if(yn == 'E') {
	            		alert("이미 이메일 전송을 완료한 사용자입니다.");
		            	isCheck = false;
		            	return false;
	            	}
	            }
	            else {
	            	if(yn == 'E') {
	            		alert("이메일 전송 완료 시, 전송처리 수정이 불가능합니다.");
		            	isCheck = false;
		            	return false;
	            	}
	            	else {
	            		postYn += yn;
	            		isCheck = true;
	            	}
	            }
	        });
			if(isCheck && postVal != ""){
				var url = "";
				document.sForm.procType.value = baseInfo.updateKey;
				document.sForm.postNo.value = postVal;
				
				if(id == 'complProcBtn') {
					document.sForm.postYn.value = postYn;
					url = baseInfo.uUrl;
				}
				else {
					url = baseInfo.eUrl;
					excelPg = 1;
					$.setCookie("fileDownloadToken","false"); 
	                $.loadingBarStart(e);
	                $.checkDownloadCheck();
				}
                
				$.ajax({
					type: 'POST',
					url: url,
					data: $("#sForm").serialize(),
					dataType: "json",
					success: function(data) {
						alert(data.msg);
						if(data.success == "success"){
							$.searchAction();
						}
					}
				})
			}
		});
	}
	
    $.fn.answerSave = function(){
        var _this = $(this);
        _this.on("click", function(){
        	if($("#iFormPostNo").val() == "") {
				alert("항목을 선택하시기 바랍니다.");
				return false;
			}
        	
        //  if(!confirm("답변하시겠습니까?")) return false;
            makeSnapshot(document.iForm, "contents");
            
            if(!$("input[name=contentsSnapshot]").val()){
                alert("답변을 작성해 주십시오.");
                
                return false;
            }
            
            if(document.iForm.postNo.value){
                document.iForm.procType.value = baseInfo.updateKey;
            }
            
            $.ajax({
                type: 'POST',
                url: baseInfo.uUrl,
                data: $("#iForm").serialize(),
                dataType: "json",
                success: function(result) {
                    alert(result.msg);
                    if(result.success == "success") location.replace(baseInfo.lUrl);
                }
            });
        })
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
	
	$.fn.mailUpdateBtnOnClickEvt = function(){
    	$(this).on("click", function(){
    		$.ajax({
	    		type: 'POST',
    			url : "/ncts/mngr/common/getMailList.do",
                data: $("#sForm").serialize(),
                dataType: "json",
                success: function(data) {
                	//alert(data.msg);
                    if(data.success == "success"){
                    	alert("완료");
                    }
                }
    		})
    	})
    }

	$.initView = function(){
		$.onClickTableTr();
		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
		$("#saveBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.insertKey);
		$("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
		$("#delBtn").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey);
		$("#complProcBtn, #emailBtn").procOnClickEvt();
		$("#mailUpdateBtn").mailUpdateBtnOnClickEvt();
		$("tbody tr").dataDetail();
		$(document).on("change", "#allCheck", function(){
			var _this = $(this);
			if(_this.is(":checked")){
				$("input:checkbox[name=postNo]").each(function(idx){
					$(this).prop('checked', true);
	            });
			} else{
				$("input:checkbox[name=postNo]").each(function(idx){
					$(this).prop('checked', false);

				});
			}
		});
		
		$("#answerBtn").answerSave();
		
		$(".excelDown").on("click", function(e){
			$("[name='excelFileNm']").val("사서함_"+$.toDay());
			$("[name='excelPageNm']").val("mngrMailBoxList.xlsx");
			excelPg = 1;
			with(document.sForm){
				target = "";
				action = baseInfo.excel;
				submit();
				
                $.setCookie("fileDownloadToken","false"); 
                $.loadingBarStart(e);
                $.checkDownloadCheck();
            }
        });
        
        $("body").on("keydown", function(e){
	        $.loadingBarKeyDown(e, excelPg);
        })
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
		<c:if test="${paginationInfo.userId eq 'master' }">
			<!-- <button class="btn btn-primary fRight" type="button" id="mailUpdateBtn" style="background: orange;">mailUpdateBtn</button> -->
		</c:if>
		<div class="search">
          	<form name="sForm" id="sForm" method="post">          	
          		<input type="hidden" name="excelFileNm">
				<input type="hidden" name="excelPageNm">
				<input type="hidden" name="postNo" id="postNo" value="">
				<input type="hidden" name="postYn" id="postYn" value="">
				<div class="fL wp80">
					<ul class="searchAreaBox">
						<li class="smart-form"><label class="label">이름</label></li>
                        <li class="w100 ml5">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">이메일</label></li>
                        <li class="w180 ml5">
                            <input id="searchKeyword2" name="searchKeyword2" class="form-control" value='<c:out value="${param.searchKeyword2}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">생년월일</label></li>
                        <li class="w180 ml5">
                            <input id="searchKeyword3" name="searchKeyword3" class="form-control" value='<c:out value="${param.searchKeyword3}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">연락처</label></li>
                        <li class="w130 ml5">
                            <input id="searchKeyword4" name="searchKeyword4" class="form-control" value='<c:out value="${param.searchKeyword4}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">전송여부</label></li>
                        <li class="w130">
                            <select id="sGubun1" name="sGubun1" class="form-control">
                                <option value="">전체</option>
                                <option value="N" ${param.sGubun1 eq 'N' ? 'selected="selected"':'' }>전송대기</option>
                                <option value="Y" ${param.sGubun1 eq 'Y' ? 'selected="selected"':'' }>전송완료</option>
                                <option value="E" ${param.sGubun1 eq 'E' ? 'selected="selected"':'' }>이메일 전송</option>
                            </select>
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
					<table class="table table-bordered tb_type01" id="">
						<colgroup>
							<col width="5%">
							<col width="15%">
							<col width="20%">
                            <col width="15%">
                            <col width="20%">
                            <col width="10%">
                            <col width="10%">
                            <col width="5%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>NO</th>
								<th>이름</th>
								<th>이메일</th>
								<th>생년월일</th>
								<th>연락처</th>
								<th>작성일</th>
								<th>전송여부</th>
								<th><input type="checkbox" id="allCheck"></th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr ><td colspan="8">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list }" varStatus="idx">
								<tr>
									<td class="invisible"><input type="checkbox" class="index" value="${list.POST_NO }"></td>
									<td>${paginationInfo.totalRecordCount - ((paginationInfo.currentPageNo-1) * paginationInfo.recordCountPerPage+ idx.index)}</td>
									<td>${list.USER_NAME }</td>
									<td>${list.USER_EMAIL }</td>
									<td>${list.USER_BIRTH }</td>
									<td>${list.TEL_NO }</td>
									<td>${list.FRST_REGIST_PNTTM }</td>
									<td>${list.POST_YN }</td>
									<td><input type="checkbox" name="postNo" value="${list.POST_NO }" data-yn="${list.POST_YN }" data-email="${list.USER_EMAIL }" class="postYnCheckbox"></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" />
				</article>
				
				<article class="col-md-12 col-lg-6" style="width: 49%;">
					<table class="table table-bordered tb_type03">
						<colgroup>
							<col width="25%">
							<col width="75%">
						</colgroup>
						<tbody id="detailTable">
							<div class="fL wp12 mt5 mr5 mb5" id="complProc">
							</div>
						</tbody>
					</table>
					<form name="iForm" id="iForm" method="post" class="smart-form">
						<c:if test="${pageInfo.INSERT_AT eq 'Y'}">
							<button class="btn btn-primary ml2" type="button" id="complProcBtn"><i class="fa fa-edit" title="전송처리"></i> 전송처리</button>
							<button type="button" class="btn btn-primary ml2 mb5" id="answerBtn">
		                        <i class="fa fa-edit" title="메모등록"></i> 메모등록
		                    </button>
							<button type="button" class="btn btn-primary ml2 mb5" id="emailBtn">
		                        <i class="fa fa-edit" title="이메일 전송"></i> 이메일 전송
		                    </button>
	                    </c:if>
	                        <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
	                        <td><input id="iFormPostNo" type="hidden" name="postNo"></td>
	                        <td><input id="pageType" type="hidden" name="pageType" value="contents"></td>
	                        <table class="table table-bordered table-hover tb_type01">
	                           <!--  <colgroup>
	                                <col width="7%">
	                                <col width="8%">
	                                <col width="10%">
	                                <col width="10%">
	                                <col width="10%">
	                                <col width="20%">
	                                <col width="20%">
	                                <col width="15%">
	                            </colgroup> -->
	                            <tbody id="mailDetail">
	                                <td class="board_contents">
	                                    <textarea id="contents" name="contents" class="part_long board_contents" style="width: 100%; min-width: 100%;" ${pageInfo.INSERT_AT eq 'Y' ? '':'disabled'}></textarea>
	                                </td>
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
