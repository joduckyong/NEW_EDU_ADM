 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

	$(function(){
	    var baseInfo = {
	            insertKey : "${common.baseType[0].key() }",
	            updateKey : "${common.baseType[1].key() }",
	            deleteKey : "${common.baseType[2].key() }",
	            lUrl : "/ncts/mngr/homeMngr/mngrFaqRegistList.do",
	            fUrl : "/ncts/mngr/homeMngr/mngrFaqRegistForm.do",
	            dUrl : "/ncts/mngr/homeMngr/mngrDeleteFaqRegist.do",
	    }
	    
	    $.dataDetail = function(index, obj){
	        if($.isNullStr(index)) return false;

	        document.sForm.bbsNo.value = index;
	        
	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/homeMngr/mngrFaqRegistDetail.do",
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
	                }else{
	                    /* document.sForm.userNo.value = $("input.index:checked").val(); */
	                } 
	            }else{
	               /*  document.sForm.userNo.value = ""; */
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
	        $.onClickTableTr();
	        $("#searchBtn").searchBtnOnClickEvt($.searchAction);
	        $("#saveBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.insertKey);
	        $("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
	        $("#delBtn").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey);
	        $(".excelDown").on("click", function(){
	            with(document.sForm){
	                target = "";
	                action = baseInfo.excel;
	                submit();
	            }
	        });
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
                <input type="hidden" name="bbsNo" id="bbsNo"  value="0">
                <div class="fL wp70">
                    <ul class="searchAreaBox">
                        <%-- <li class="smart-form ml5"><label class="label">작성자</label></li>
                        <li class="w100 ml5">
                            <input id="searchKeyword3" name="searchKeyword3" class="form-control" value="${param.searchKeyword3}"> 
                        </li> --%>
                        <li class="smart-form ml5">
                            <label class="label">구분</label>
                        </li>
                        <li class="w130 ml5">
                            <select id="sGubun" name="sGubun" class="form-control">
                                <option value="">선택</option>
                                <%-- <c:forEach var="list" items="${codeMap.DMH03 }" varStatus="idx"> --%>
                                <option value="01" ${param.sGubun eq '01' ? 'selected="selected"':'' }>교육</option>
                                <option value="02" ${param.sGubun eq '02' ? 'selected="selected"':'' }>강사</option>
                                <option value="03" ${param.sGubun eq '03' ? 'selected="selected"':'' }>회원</option>
                                <option value="04" ${param.sGubun eq '04' ? 'selected="selected"':'' }>기타</option>
                                <%-- </c:forEach> --%>
                            </select>
                        </li>
                        <li class="smart-form ml5">
                            <label class="label">제목</label>
                        </li>
                        <li class="w200 ml5" id = "search">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'>
                        </li>
                        <li class="smart-form ml5">
                            <label class="label">내용</label>
                        </li>
                        <li class="w250 ml5" id = "search">
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
							<col width="15%">
							<col width="60%">
                            <col width="20%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>작성자</th>
								<th>구분</th>
								<th>제목</th>
								<th>작성일</th>
								<!-- <th>기간(시작)</th>
								<th>기간(종료)</th>
								<th>활동내용</th> -->
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr ><td colspan="4">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list }" varStatus="idx">
								<tr>
									<td class="invisible">
										<input type="checkbox" class="index" value="${list.BBS_NO}">
									</td>
									<td>${list.LAST_USER_NM}</td>
									<td>${list.BBS_TYPE_NM}</td>
									<td>${list.TITLE}</td>
									<td>${list.FRST_REGIST_PNTTM}</td>
									<%-- <td>${list.START_TIME}</td>
									<td>${list.END_TIME}</td>
									<td>${list.ACTIVITY_CONTENT}</td> --%>
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
							<tr><td colspan="2" class="textAlignCenter">항목을 선택해주세요.</td></tr>
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
    <th scope="row">구분 </th>
    <td colspan="3">{{BBS_TYPE_NM}}</td>
</tr>
<tr>
	<th scope="row">제목</th>
	<td colspan="3">{{TITLE}}</td>
</tr>
<tr>
    <th scope="row">내용</th>
    <td colspan="3" class="board_contents">{{safe CONTENTS}}</td>
</tr>
<tr>
    <th scope="row">첨부파일</th>
    <td colspan="3">{{safe fileView}}</td>
</tr>
<tr>
	<th scope="row">작성자 </th>
	<td>{{LAST_USER_NM}}</td>
	<th scope="row">작성일</th>
	<td>{{FRST_REGIST_PNTTM}}</td>
</tr>
</script>