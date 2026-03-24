 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
	$(function(){
	    var baseInfo = {
	            insertKey : '<c:out value="${common.baseType[0].key() }"/>',
	            updateKey : '<c:out value="${common.baseType[1].key() }"/>',
	            deleteKey : '<c:out value="${common.baseType[2].key() }"/>',
	            lUrl : "/ncts/mngr/edcOperMngr/mngrFrmatnEvlList.do",
	            fUrl : "/ncts/mngr/edcOperMngr/mngrFrmatnEvlForm.do",
	            dUrl : "/ncts/mngr/edcOperMngr/mngrDeleteEvl.do",
	    }
	    
	    $.dataDetail = function(index, obj){
	        if($.isNullStr(index)) return false;

	        document.sForm.lectureId.value = index;
	        document.sForm.examNo.value = obj.examNo;
	        document.sForm.examSqno.value = obj.examSqno;
	        
	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/edcOperMngr/mngrFrmatnEvlDetail.do",
	            data: $("#sForm").serialize(),
	            dataType: "json",
	            success: function(data) {
	                if(data.success == "success"){
	                    $("#detailTable").handlerbarsCompile($("#detail-template"), data.de);
	                    /* $("#seTable").handlerbarsCompile($("#seTable-template"), data.se); */
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
                <input type="hidden" name="examNo" id="examNo"  value="0">
                <input type="hidden" name="examSqno" id="examSqno"  value="0">
                <div class="fL wp70">
                    <ul class="searchAreaBox">
                        <li class="smart-form ml5"><label class="label">강의명</label></li>
                        <li class="w150 ml5">
                            <select id="sGubun" name="sGubun" class="form-control" style="text-align-last:center;">
                                <option value="">선택</option>
                                    <c:forEach var="lecIdList" items="${lecIdList }" varStatus="idx">
                                        <option value='<c:out value="${lecIdList.LECTURE_ID}"/>' <c:out value="${param.sGubun eq lecIdList.LECTURE_ID ? 'selected=selected':'' }"/>><c:out value="${lecIdList.LECTURE_NM }"/></option>
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
							<col width="10%">
							<col width="55%">
                            <col width="15%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>강의명</th>
								<th>번호</th>
								<th>형성평가명</th>
								<th>항목유형</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr ><td colspan="4">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list }" varStatus="idx">
								<tr>
									<td class="invisible">
									   <input type="checkbox" name="lectureId" class="index" value='<c:out value="${list.LECTURE_ID}"/>'>
									   <input type="hidden" name="examNo" class="" value='<c:out value="${list.EXAM_NO}"/>'>
									   <input type="hidden" name="examSqno" class="" value='<c:out value="${list.EXAM_SQNO}"/>'>
									</td>
									<td><c:out value="${list.LECTURE_NM}"/></td>
									<td><c:out value="${list.EXAM_NO}"/></td>
									<td><c:out value="${list.EXAM_NM}"/></td>
									<td><c:forEach var="codeMap" items="${codeMap }" varStatus="ix">
									       <c:if test = "${list.EXAM_TYPE_CD eq codeMap.CODE}"><c:out value="${codeMap.CODE_NM}"/></c:if>
									    </c:forEach>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" />
				</article>
				
				<article class="col-md-12 col-lg-6">
					<table class="table table-bordered table-hover tb_type01">
						<colgroup>
							<col width="10%">
							<col width="80%">
							<col width="10%">
						</colgroup>
						<tbody id="detailTable">
							<tr><td colspan="6" class="textAlignCenter">항목을 선택해주세요.</td></tr>
						</tbody>
					</table>
					
					<table class="table table-bordered table-hover tb_type01">
						<colgroup>
							<col width="100%">
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
	<th scope="row">번호 </th>
    <th scope="row">항목명 </th>
	<th scope="row">정답</th>
</tr>
{{#if .}}
{{#each .}}
    <tr>
        <td>{{ITEM_NO}}</td>
        <td>{{ITEM_NM}}</td>
        <td>{{CORRECT_ANSWER}}</td>
    </tr>
{{/each}}
{{else}}

{{/if}}
</script>
<script id="seTable-template" type="text/x-handlebars-template">
<tr>
    <th scope="row">형성평가오답설명 </th>
</tr>
<tr>
    <td>{{LECTURE_NM}}</td>
</tr>
</script>