 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

	$(function(){
		var excelPg = 0;
	    var baseInfo = {
	            insertKey : "${common.baseType[0].key() }",
	            updateKey : "${common.baseType[1].key() }",
	            deleteKey : "${common.baseType[2].key() }",
	            lUrl : "/ncts/mngr/edcComplMngr/mngrOnEdcHisList.do",
	            dUrl : "/ncts/mngr/edcComplMngr/mngrDeleteOnEdc.do",
	            excel : "/ncts/mngr/edcComplMngr/onEdcExcelDownload.do"
	    }
	    
	    $.dataDetail = function(index, obj){
	        if($.isNullStr(index)) return false;

	        document.sForm.userNo.value = index;
	        document.sForm.lectureId.value = obj.searchLectureId;
	        document.sForm.resultNo.value = obj.searchResultNo;
	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/edcComplMngr/mngrOnEdcHisDetail.do",
	            data: $("#sForm").serialize(),
	            dataType: "json",
	            success: function(data) {
	                if(data.success == "success"){
	                    $("#detailTable").handlerbarsCompile($("#detail-template"), data.de);
	                    
	                    if(!data.de){
	                    	$("#nodata").css("text-align", "center")
	                    }
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
	                }
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
	        $("#searchBtn").searchBtnOnClickEvt($.searchAction);
	        $("#saveBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.insertKey);
	        $("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
	        $("#delBtn").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey);
	        $(".excelDown").on("click", function(e){
	        	excelPg = 1;
				$("[name='excelFileNm']").val("동영상 교육 이력_"+$.toDay());
				$("[name='excelPageNm']").val("mngrOnEdcList.xlsx");	     	        	
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
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
				<input type="hidden" name="excelFileNm" id="excelFileNm"  value="">
				<input type="hidden" name="excelPageNm" id="excelPageNm"  value="">             	
                <input type="hidden" name="userNo" id="userNo"  value="0">
                <input type="hidden" name="lectureId" id="lectureId"  value="">
                <input type="hidden" name="resultNo" id="resultNo"  value="0">
                <div class="fL wp70">
                    <ul class="searchAreaBox">
                        <li class="smart-form ml5">
                            <label class="label">강의</label>
                        </li>
                        <li class="w300 ml5">
                            <select id="sGubun" name="sGubun" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap.LECLIST }" varStatus="idx">
                                    <option value="${list.LECTURE_ID}" ${param.sGubun eq list.LECTURE_ID ? 'selected="selected"':'' }>${list.LECTURE_NM }</option>
                                </c:forEach>
                            </select>
                        </li>
                        <li class="smart-form ml5"><label class="label">이름</label></li>
                        <li class="w100 ml5">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'> 
                        </li>
                        <li class="smart-form ml5">
                            <label class="label">통과여부</label>
                        </li>
                        <li class="w100">
                            <select id="sGubun1" name="sGubun1" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap.DMH02 }" varStatus="idx">
                                    <option value="${list.CODE }" ${param.sGubun1 eq list.CODE ? 'selected="selected"':'' }>${list.CODE_NM }</option>
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
				<article class="col-md-12 col-lg-6">
					<table class="table table-bordered tb_type01 listtable">
						<colgroup>
							<col width="10%">
							<col width="25%">
                            <col width="15%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="20%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>이름</th>
								<th>강의명</th>
								<th>동영상보기</th>
								<th>평가1</th>
								<th>평가2</th>
								<th>통과</th>
								<th>강의시작일</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr ><td colspan="7">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list }" varStatus="idx">
								<tr>
									<td class="invisible">
										<input type="checkbox" class="index" value="${list.USER_NO}">
										<input type="hidden" name="searchLectureId" value="${list.LECTURE_ID}">
										<input type="hidden" name="searchResultNo" value="${list.RESULT_NO}">
									</td>
									<td>${list.USER_NM}</td>
									<td>${list.LECTURE_NM  }</td>
									<td>${list.MOVIE_VIEW_ST  }</td>
									<td>${list.FIRST_ROUND_RESULT_CD}</td>
									<td>${list.SECOND_ROUND_RESULT_CD }</td>
									<td>${list.PASS_CD }</td>
									<td>${list.LECTURE_ST_DT }</td>
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
							<col width="15%">
							<col width="20%">
							<col width="15%">
							<col width="10%">
						</colgroup>
						<tbody id="detailTable">
							<tr><td colspan="6" class="textAlignCenter">항목을 선택해주세요.</td></tr>
						</tbody>
					</table>
					
					<table class="table table-bordered table-hover tb_type01">
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


<script id="detail-template" type="text/x-handlebars-template">
{{#if .}}
<tr>
	<th scope="row">이름 </th>
	<td colspan="1">{{USER_NM}}</td>
	<th scope="row">아이디 </th>
	<td colspan="1">{{USER_ID}}</td>
	<th scope="row">이메일 </th>
	<td colspan="2">{{USER_EMAIL}}</td>
</tr>
<tr>
	<th scope="row">강의명</th>
	<td colspan="5">{{LECTURE_NM}}</td>
</tr>
<tr>
	<th scope="row">동영상시간(초)</th>
	<td>{{MOVIE_VIEW_TIME}}</td>
    <th scope="row">동영상보기</th>
    <td colspan = "3">{{MOVIE_VIEW_ST}}</td>
</tr>
<tr>
	<th scope="row">평가1</th>
	<td>{{FIRST_ROUND_RESULT_CD}}</td>
    <th scope="row">평가1 답안</th>
    <td colspan = "3">{{USER_ANSWER1}}</td>
</tr>
<tr>
    <th scope="row">평가2</th>
    <td>{{SECOND_ROUND_RESULT_CD}}</td>
    <th scope="row">평가2 답안</th>
    <td colspan = "3">{{USER_ANSWER2}}</td>
</tr>
<tr>
	<th scope="row">통과</th>
	<td colspan = "5">{{PASS_CD}}</td>
</tr>
<tr>
    <th scope="row">강의시작일</th>
    <td colspan="5">{{LECTURE_ST_DT}}</td>
</tr>
{{else}}
    <tr class="noData">                           
        <td colspan="7" id="nodata">데이터가 없습니다.</td>             
    </tr>
{{/if}}
</script>