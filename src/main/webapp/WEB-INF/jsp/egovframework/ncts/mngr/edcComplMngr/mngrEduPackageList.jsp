 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
	$(function(){
	    var baseInfo = {
	            insertKey : "${common.baseType[0].key() }",
	            updateKey : "${common.baseType[1].key() }",
	            deleteKey : "${common.baseType[2].key() }",
	            lUrl : "/ncts/mngr/edcComplMngr/mngrEduPackageList.do",
	            fUrl : "/ncts/mngr/edcComplMngr/mngrEduPackageForm.do",
	            dUrl : "/ncts/mngr/edcComplMngr/deleteMngrEduPackageInfo.do",
	    }
	    
	    $.dataDetail = function(index, obj){
	        if($.isNullStr(index)) return false;
	        document.sForm.packageNo.value = index;
	        
	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/edcComplMngr/mngrEduPackageDetail.do",
	            data: $("#sForm").serialize(),
	            dataType: "json",
	            success: function(data) {
	                if(data.success == "success"){
	                	/* if(data.detail.PROC_YN == "Y") $("#updBtn, #delBtn").show();
	                	else $("#updBtn, #delBtn").hide(); */
	                    $("#detailTable").handlerbarsCompile($("#detail-template"), data.detail);
	                    $("#codeTable").handlerbarsCompile($("#codelist-template"), data.codeList);
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
	    
	    $.initView = function(){
	    	$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
	        $.onClickTableTr();
	        $("#searchBtn").searchBtnOnClickEvt($.searchAction);
	        $("#saveBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.insertKey);
	        $("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
	        $("#delBtn").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey);
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
                <input type="hidden" name="packageNo" id="packageNo">
                <div class="fL wp70">
                    <ul class="searchAreaBox">
                        <li class="smart-form ml5"><label class="label">패키지명</label></li>
                        <li class="w150 ml5">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'>
                        </li>
                        <li class="ml10">
                            <button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
                        </li>
                    </ul>
                </div>
                
				<div class="fR wp26">
					<ul class="searchAreaBox fR">
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
                            <col width="30%">
							<col width="%">
                            <col width="10%">
                            <col width="9%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>패키지명</th>
								<th>강의코드</th>
								<th>등록일</th>
								<th>사용여부</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty packageList}">
								<tr><td colspan="3">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${packageList}" varStatus="idx">
								<tr>
									<td class="invisible">
									   <input type="checkbox" name="packageNo" class="index" value="${list.PACKAGE_NO}">
									</td>
									<td>${list.PACKAGE_NM}</td>
									<td>${list.LECTURE_ID}</td>
									<td>${list.FRST_REGIST_PNTTM}</td>
									<td>${list.USE_AT}</td>
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

					<table class="table table-bordered table-hover tb_type01">
						<colgroup>
							<col width="*">
							<col width="*">
							<col width="*">
						</colgroup>
						<tbody id="codeTable">							
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
	<th scope="row">패키지명</th>
	<td colspan="3">{{PACKAGE_NM}}</td>
</tr>
<tr>
    <th scope="row">패키지 구분</th>
    <td>{{PACKAGE_GUBUN_TXT}}</td>
    <th scope="row">교육과정</th>
    <td>{{COURSES_TXT}}</td>
</tr>
<tr>
    <th scope="row">강의코드</th>
    <td colspan="3">{{LECTURE_ID}}</td>
</tr>
<tr>
    <th scope="row">사용여부</th>
    <td colspan="3">{{USE_AT}}</td>
</tr>
<tr>
    <th scope="row">등록일자</th>
    <td>{{FRST_REGIST_PNTTM}}</td>
    <th scope="row">등록자</th>
    <td>{{FRST_USER_NM}}</td>
</tr>
</script>
<script id="codelist-template" type="text/x-handlebars-template">
<tr>
	<th colspan="3" style="text-align:left; font-weight: bold;">과목상세</th>
</tr>
<tr>
    <td scope="row" style="font-weight: bold;">강의코드명</th>
    <td scope="row" style="font-weight: bold;">등급</th>
    <td scope="row" style="font-weight: bold;">수강형태</th>
</tr>
{{#each .}}
<tr>
    <td>{{LECTURE_ID}}</td>
    <td>{{COURSES_NM}}</td>
    <td>{{#ifeq VIDEO_AT 'Y'}}온라인{{else}}오프라인{{/ifeq}}</td>
</tr>
{{/each}}
</script>