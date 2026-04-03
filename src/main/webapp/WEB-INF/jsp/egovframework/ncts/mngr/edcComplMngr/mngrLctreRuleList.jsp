 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
	$(function(){
	    var baseInfo = {
	            insertKey : "${common.baseType[0].key() }",
	            updateKey : "${common.baseType[1].key() }",
	            deleteKey : "${common.baseType[2].key() }",
	            lUrl : "/ncts/mngr/edcComplMngr/mngrLctreRuleList.do",
	            fUrl : "/ncts/mngr/edcComplMngr/mngrLctreRuleForm.do",
	            dUrl : "/ncts/mngr/edcComplMngr/mngrDeleteRuleLctre.do",
	    }
	    
	    $.dataDetail = function(index, obj){
	        if($.isNullStr(index)) return false;

	        document.sForm.ruleNo.value = index;
	        
	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/edcComplMngr/mngrLctreRuleDetail.do",
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
                <input type="hidden" name="ruleNo" id="ruleNo"  value=0>
                <div class="fL wp70">
                    <ul class="searchAreaBox">
                        <li class="smart-form ml5">
                            <label class="label">교육과정</label>
                        </li>
                        <li class="w100">
                            <select id="sGubun1" name="sGubun1" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap }" varStatus="idx">
                                	<c:if test="${idx.index ne 0 and idx.index lt 5}">
                                    	<option value="${list.CODE }" ${param.sGubun1 eq list.CODE ? 'selected="selected"':'' }>${list.CODE_NM }</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </li>
                        <li class="smart-form ml5"><label class="label">Rule명</label></li>
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
							<col width="40%">
                            <col width="30%">
                            <col width="15%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>교육과정</th>
								<th>강의코드</th>
								<th>Rule명</th>
								<th>강의등록일자</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr ><td colspan="4">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list}" varStatus="idx">
								<tr>
									<td class="invisible">
									   <input type="checkbox" name="ruleNO" class="index" value="${list.RULE_NO}">
									</td>
									<td>${list.COURSES_NM}</td>
									<td>${list.LECTURE_ID}</td>
									<td>${list.LECTURE_NM}</td>
									<td>${list.FRST_REGIST_PNTTM}</td>
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
	<th scope="row">교육과정 </th>
	<td>{{COURSES_NM}}</td>
    <th scope="row">등록일자 </th>
    <td>{{FRST_REGIST_PNTTM}}</td>
</tr>
<tr>
    <th scope="row">강의코드</th>
    <td colspan="3">{{LECTURE_ID}}</td>
</tr>
<tr>
	<th scope="row">Rule명</th>
	<td colspan="3">{{LECTURE_NM}}</td>
</tr>
</script>