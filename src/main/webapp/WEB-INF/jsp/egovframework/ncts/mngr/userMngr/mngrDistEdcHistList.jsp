 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

	$(function(){
		var excelPg = 0;
	    var baseInfo = {
	            insertKey : '<c:out value="${common.baseType[0].key() }"/>',
	            updateKey : '<c:out value="${common.baseType[1].key() }"/>',
	            deleteKey : '<c:out value="${common.baseType[2].key() }"/>',
	            lUrl : "/ncts/mngr/userMngr/mngrDistEdcHistList.do",
	            dUrl : "/ncts/mngr/userMngr/mngrDeleteDistEdcHist.do",
	            excel : "/ncts/mngr/userMngr/mngrDistEdcHistDownload.do"
	    }
	    
	    $.dataDetail = function(index, obj){
	        if($.isNullStr(index)) return false;

	        document.sForm.distEdcHistSeq.value = index;
	        
	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/userMngr/mngrDistEdcHistDetail.do",
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
	        $("#sGubun").change();
	        $(".excelDown").on("click", function(e){
	        	excelPg = 1;
				$("[name='excelFileNm']").val("재난관련 교육이력_"+$.toDay());
				$("[name='excelPageNm']").val("mngrDistEdcHistList.xlsx");		        	
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
	    
        /* $("#sGubun").change(function(){
            if($('#sGubun').val() == '01'){
                $('#search').hide();
                $('#sel').show();
            } else {
                $('#search').show();
                $('#sel').hide();
            }
        }) */

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
                <input type="hidden" name="distEdcHistSeq" id="distEdcHistSeq"  value="0">
                <div class="fL wp70">
                    <ul class="searchAreaBox">
                        <li class="smart-form ml5">
                            <label class="label">구분</label>
                        </li>
                        <li class="w130 ml5">
                            <select id="sGubun" name="sGubun" class="form-control">
                                <option value="">선택</option>
                                <option value="01" <c:out value="${param.sGubun eq '01' ? 'selected=selected':'' }"/>>작성자</option>
                                <option value="02" <c:out value="${param.sGubun eq '02' ? 'selected=selected':'' }"/>>교육제목</option>
                                <option value="03" <c:out value="${param.sGubun eq '03' ? 'selected=selected':'' }"/>>주최(기관명)</option>
                                <option value="04" <c:out value="${param.sGubun eq '04' ? 'selected=selected':'' }"/>>시간</option>
                            </select>
                        </li>
                        <li class="w200 ml5" id = "search">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'>
                        </li>
                        <%-- <li class="w280 ml5" id = "sel">
                            <select id="sGubun1" name="sGubun1" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap.DMH11 }" varStatus="idx">
                                    <option value="${list.CODE }" ${param.sGubun1 eq list.CODE ? 'selected="selected"':'' }>${list.CODE_NM }</option>
                                </c:forEach>
                            </select>
                        </li> --%>
                        <li class="ml10">
                            <button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
                        </li>
                    </ul>
                </div>
                <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
                    <jsp:param value="list"     name="formType"/>
                    <jsp:param value="1,2"  name="buttonYn"/>
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
							<col width="20%">
							<col width="35%">
                            <col width="35%">
                            <col width="10%">
                            
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>작성자</th>
								<th>교육제목</th>
								<th>주최(기관명)</th>
								<th>시간</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr ><td colspan="4">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list }" varStatus="idx">
								<tr>
									<td class="invisible">
										<input type="checkbox" class="index" value='<c:out value="${list.DIST_EDC_HIST_SEQ}"/>'>
									</td>
									<td><c:out value="${list.USER_NM}"/></td>
									<td><c:out value="${list.DIST_EDC_NM}"/></td>
									<td><c:out value="${list.AUSPC_INSTT}"/></td>
									<td><c:out value="${list.EDC_TIME}"/></td>
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
							<col width="80%">
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

<script id="detail-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">작성자 </th>
	<td>{{USER_NM}}</td>
</tr>
<tr>
	<th scope="row">교육제목</th>
	<td>{{DIST_EDC_NM}}</td>
</tr>
<tr>
	<th scope="row">주최(기관명)</th>
	<td>{{AUSPC_INSTT}}</td>
</tr>
<tr>
    <th scope="row">시간</th>
    <td>{{EDC_TIME}}</td>
</tr>
</script>