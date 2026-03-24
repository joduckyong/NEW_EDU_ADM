 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
$(function(){
	
	  var baseInfo = {
	            insertKey : "<c:out value='${common.baseType[0].key() }'/>",
	            updateKey : "<c:out value='${common.baseType[1].key() }'/>",
	            deleteKey : "<c:out value='${common.baseType[2].key() }'/>",
	            lUrl : "/ncts/mngr/shareMngr/mngrShareList.do",
	            fUrl : "/ncts/mngr/shareMngr/mngrShareForm.do",
	            dUrl : "/ncts/mngr/shareMngr/mngrDeleteShareList.do",
	            //excel : "/ncts/mngr/shareMngr/shareExcelDownload.do"
	    } 
	
		
    
	    $.dataDetail = function(index, obj){
	        if($.isNullStr(index)) return false;
	        
	        document.sForm.shareSeq.value = index;

	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/shareMngr/mngrShareDetail.do",
	            data: $("#sForm").serialize(),
	            dataType: "json",
	            success: function(data) {
	                if(data.success == "success"){
	                    $("#detailTable").handlerbarsCompile($("#detail-template"), data.rs);
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
	                     document.sForm.shareSeq.value = $("input.index:checked").val(); 
	                } 
	            }else{
	                 document.sForm.shareSeq.value = ""; 
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
	    
	 	 $.fn.numTdOnClickEvt = function(){
			$(this).on("click", function(){
				var numVal = $(this).closest("tr").find(".index").val();
				with(document.sForm){
		            searchKeyword2.value = numVal;
		            action = "/ncts/mngr/shareMngr/mngrShareList.do";
					target='';
		            submit();
		        }
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
	 	
    $.initView = function(){
		
		$.onClickTableTr();  
		$("#saveBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.insertKey);
		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
	    $("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
	    $("#delBtn").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey);
	    /* $(".excelDown").on("click", function(e){
        	excelPg = 1;
			$("[name='excelFileNm']").val("공유자료실_"+$.toDay());
			$("[name='excelPageNm']").val("mngrShareList.xlsx");	        	
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
        }) */
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
				<input type="hidden" id="shareSeq" name="shareSeq" value="" >
				<input type="hidden" name="excelFileNm">
				<input type="hidden" name="excelPageNm">
					<div class="fl wp70">
						<ul class="searchAreaBox">
							<li class="smart-form ml5">
								<label class="label">센터명</label>
							</li>
							<sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')">
								<li class="w150 mr10">
										<select name="centerCd" class="form-control">
											<option value="">전체</option>
											<c:forEach var="center" items="${centerList }" varStatus="idx">
												<c:if test="${center.DEPT_CD eq '10000000' or center.DEPT_CD eq '30000000' or center.DEPT_CD eq '50000000' or center.DEPT_CD eq '60000000' or center.DEPT_CD eq '70000000'}">
													<option value="<c:out value='${center.DEPT_CD }'/>" data-groupId="<c:out value='${center.GROUP_ID }'/>" <c:out value="${center.DEPT_CD eq param.centerCd ? 'selected=selected':'' }"/> ><c:out value="${center.DEPT_NM }"/></option>
												</c:if>
											</c:forEach>
										</select> <i></i>
								</li>
							</sec:authorize>
							<sec:authorize access="hasRole('ROLE_ADMIN') or hasRole('ROLE_USER')"> 
								    <li class="smart-form mr5">
										<input type="hidden" name="centerCd" value="<sec:authentication property="principal.centerId"/>" >
										<label class="label"><sec:authentication property="principal.centerNm"/></label>
									</li> 
							</sec:authorize>
							 <li class="smart-form ml5">
		                            <label class="label">제목</label>
		                     </li>
		                     <li class="w200 ml5">
		                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'>
		                     </li>
		                     <li class="smart-form ml5">
		                            <label class="label">작성자</label>
		                     </li>
		                     <li class="w180 ml5">
		                            <input id="searchKeyword2" name="searchKeyword2" class="form-control" value='<c:out value="${param.searchKeyword2}"/>'>
		                     </li>
		                     <li class="ml10">
		                            <button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
		                     </li>
							                 
						</ul>
					
					</div>
			        <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
	                    <jsp:param value="list"     name="formType"/>
	                    <jsp:param value="2,3,4"  name="buttonYn"/>
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
							<col width="45%">
							<col width="20%">
                            <col width="25%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>작성자</th>
								<th>제목</th>
								<th>센터명</th>
								<th>작성일</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr ><td colspan="4">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list }" varStatus="idx">
								<tr>
									<td class="invisible">
										<input type="checkbox" class="index" value="<c:out value='${list.SHARE_SEQ}'/>">
									</td>
									<td><c:out value="${list.USER_NM}"/></td>
									<td><c:out value="${list.SHARE_TITLE}"/></td>
									<td><c:out value="${list.CENTER_NM}"/></td>
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
							<tr><td colspan="4" class="textAlignCenter">항목을 선택해주세요.</td></tr>
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

<script id="detail-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">제목</th>
	<td colspan="3">{{SHARE_TITLE}}</td>
</tr>
<tr>
	<th>작성자</th>
	<td>{{USER_NM}}</td>
	<th>작성일자</th>
	<td>{{FRST_REGIST_PNTTM}}</td>
</tr>
<tr>
	<th scope="row">첨부파일</th>
	<td colspan="5">
		{{safe fileView}}
	</td>
</tr>
<tr height="500">
	<th scope="cal">내용</th>
	<td colspan="5" class="board_contents">
		{{safe SHARE_CN}}
	</td>
</tr>
</script>