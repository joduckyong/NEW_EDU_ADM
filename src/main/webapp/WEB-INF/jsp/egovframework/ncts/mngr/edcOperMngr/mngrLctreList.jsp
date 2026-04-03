 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
	$(function(){
	    var baseInfo = {
	            insertKey : "${common.baseType[0].key() }",
	            updateKey : "${common.baseType[1].key() }",
	            deleteKey : "${common.baseType[2].key() }",
	            lUrl : "/ncts/mngr/edcOperMngr/mngrLctreList.do",
	            fUrl : "/ncts/mngr/edcOperMngr/mngrLctreForm.do",
	            dUrl : "/ncts/mngr/edcOperMngr/mngrDeleteLctre.do",
	    }
	    
	    $.dataDetail = function(index, obj){
	        if($.isNullStr(index)) return false;

	        document.sForm.lectureId.value = index;
	        
	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/edcOperMngr/mngrLctreDetail.do",
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
                <input type="hidden" name="lectureId" id="lectureId"  value="">
                <div class="fL wp70">
                    <ul class="searchAreaBox">
                        <li class="smart-form ml5"><label class="label">강의명</label></li>
                        <li class="w150 ml5">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'>
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
							<col width="15%">
							<col width="35%">
                            <col width="30%">
                            <col width="20%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>강의아이디</th>
								<th>강의명</th>
								<th>교육과정</th>
								<th>강의시간</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr ><td colspan="4">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list }" varStatus="idx">
								<tr>
									<td class="invisible">
									   <input type="checkbox" name="lectureId" class="index" value="${list.LECTURE_ID}">
									</td>
									<td>${list.LECTURE_ID}</td>
									<td>${list.LECTURE_NM}</td>
									<td>${list.COURSES}</td>
									<td>${list.VIDEO_DURATION}</td>
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
							<tr><td colspan="6" class="textAlignCenter">항목을 선택해주세요.</td></tr>
						</tbody>
					</table>
					
					<table class="table table-bordered table-hover tb_type01">
						<colgroup>
							<col width="20%">
							<col width="80%">
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
<tr>
	<th scope="row">강의<br>아이디 </th>
	<td colspan="5">{{LECTURE_ID}}</td>
</tr>

<tr>
	<th scope="row">강의명</th>
	<td>{{LECTURE_NM}}</td>
	<th scope="row">교육과정</th>
	<td>{{COURSES}}</td>
	<th scope="row">동영상<br>아이디 </th>
	<td>{{YOUTUBE_ID}}</td>
</tr>

<tr>
	<th scope="row">동영상<br>시간</th>
	<td>{{VIDEO_DURATION}}</td>
	<th scope="row">동영상<br> 가로 사이즈</th>
    <td>{{VIDEO_WIDTH}} px</td>
    <th scope="row">동영상<br> 세로 사이즈</th>
    <td>{{VIDEO_HEIGHT}} px</td>
</tr>

<tr>
	<th scope="row">수강대상</th>
	<td>{{ATNLC_TAGET}}</td>
	<th scope="row">수강형태</th>
	<td>{{ATNLC_STLE}}</td>
	<th scope="row">수강시간</th>
	<td>{{ATNLC_TIME}}분</td>
</tr>

<tr>
	<th scope="row">교육목표</th>
	<td colspan="5">{{EDC_GOAL}}</td>
</tr>

<tr>
	<th scope="row">프로그램<br>구성</th>
	<td colspan="5">{{PROGRM_COMPOSITION}}</td>
</tr>
{{#ifnoteq COURSES '일반'}}
<tr>
    <th scope="row">퀴즈<br>시작안내</th>
    <td colspan="5">{{safe START_GUIDE}}</td>
</tr>

<tr>
    <th scope="row">퀴즈<br>실패안내</th>
    <td colspan="5">{{safe FAIL_GUIDE}}</td>
</tr>
{{/ifnoteq}}
<tr>
    <th scope="row">대표이미지</th>
    <td colspan="5">
        {{#empty STRE_FILE_NM}}
        {{else}}
            <img src="/utl/web/imageSrc.do?path=mngr/{{STRE_FILE_NM}}" width="240" height="135"/>
        {{/empty}}  
    </td>
</tr>
</script>