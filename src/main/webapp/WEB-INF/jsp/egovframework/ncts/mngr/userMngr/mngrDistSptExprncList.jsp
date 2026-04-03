 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

	$(function(){
		var excelPg = 0;
	    var baseInfo = {
	            insertKey : "${common.baseType[0].key() }",
	            updateKey : "${common.baseType[1].key() }",
	            deleteKey : "${common.baseType[2].key() }",
	            lUrl : "/ncts/mngr/userMngr/mngrDistSptExprncList.do",
	            dUrl : "/ncts/mngr/userMngr/mngrDeleteDistSptExprnc.do",
	            excel : "/ncts/mngr/userMngr/mngrDistSptExprncDownload.do"
	    }
	    
	    $.dataDetail = function(index, obj){
	        if($.isNullStr(index)) return false;

	        document.sForm.distSpotExprncSeq.value = index;
	        
	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/userMngr/mngrDistSptExprncDetail.do",
	            data: $("#sForm").serialize(),
	            dataType: "json",
	            success: function(data) {
	                if(data.success == "success"){
	                	if(data.de.USER_BIRTH_YMD.length == 8) {
	                		var birthYmd = data.de.USER_BIRTH_YMD;
	                		data.de.USER_BIRTH_YMD = birthYmd.substr(0,4) + '.' + birthYmd.substr(4,2) + '.' + birthYmd.substr(6,2);
	                	}
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
	        $(".excelDown").on("click", function(e){
	        	excelPg = 1;
				$("[name='excelFileNm']").val("재난대응관련 현장경험_"+$.toDay());
				$("[name='excelPageNm']").val("mngrDistSptExprncList.xlsx");		        	
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
                <input type="hidden" name="distSpotExprncSeq" id="distSpotExprncSeq"  value="0">
                <div class="fL wp70">
                    <ul class="searchAreaBox">
                        <li class="smart-form ml5">
                            <label class="label">구분</label>
                        </li>
                        <li class="w115 ml5">
                            <select id="sGubun" name="sGubun" class="form-control">
                                <option value="">선택</option>
                                <option value="01" ${param.sGubun eq '01' ? 'selected="selected"':'' }>작성자</option>
                                <option value="02" ${param.sGubun eq '02' ? 'selected="selected"':'' }>재난사건명</option>
                                <option value="03" ${param.sGubun eq '03' ? 'selected="selected"':'' }>지역</option>
                                <option value="04" ${param.sGubun eq '04' ? 'selected="selected"':'' }>활동내용</option>
                            </select>
                        </li>
                        <li class="w200 ml5" id = "search">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'>
                        </li>
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
							<col width="10%">
							<col width="20%">
                            <col width="15%">
                            <col width="15%">
                            <col width="30%">
                            <col width="10%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>작성자</th>
								<th>재난사건명</th>
								<th>기간(시작)</th>
								<th>기간(종료)</th>
								<th>활동내용</th>
								<th>지역</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr ><td colspan="6">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list }" varStatus="idx">
								<tr>
									<td class="invisible">
										<input type="checkbox" class="index" value="${list.DIST_SPOT_EXPRNC_SEQ}">
									</td>
									<td>${list.USER_NM}</td>
									<td class="text-left">${list.DIST_INCIDENT_NM}</td>
									<td>${list.START_TIME}</td>
									<td>${list.END_TIME}</td>
									<td class="text-left">${list.ACTIVITY_CONTENT}</td>
									<td>${list.DIST_INCIDENT_AREA}</td>
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
	<th scope="row">작성자 </th>
	<td>{{USER_NM}}{{#notempty USER_ID}}({{USER_ID}}){{/notempty}}</td>
	<th scope="row">생년월일 </th>
	<td>{{USER_BIRTH_YMD}}</td>
</tr>
<tr>
	<th scope="row">재난사건명</th>
	<td colspan="3">{{DIST_INCIDENT_NM}}</td>
</tr>
<tr>
    <th scope="row">기간(시작)</th>
    <td>{{START_TIME}}</td>
    <th scope="row">기간(종료)</th>
    <td>{{END_TIME}}</td>
</tr>
<tr>
    <th scope="row">활동내용</th>
    <td colspan="3">{{ACTIVITY_CONTENT}}</td>
</tr>
<tr>
	<th scope="row">지역</th>
	<td colspan="3">{{DIST_INCIDENT_AREA}}</td>
</tr>
</script>