 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

	$(function(){
		var excelPg = 0;
	    var baseInfo = {
	            insertKey : '<c:out value="${common.baseType[0].key() }"/>',
	            updateKey : '<c:out value="${common.baseType[1].key() }"/>',
	            deleteKey : '<c:out value="${common.baseType[2].key() }"/>',
	            lUrl : "/ncts/mngr/edcComplMngr/mngrCtfhvIssueList.do",
	            //fUrl : "/ncts/mngr/edcComplMngr/mngrEdcCompForm.do",
	            dUrl : "/ncts/mngr/edcComplMngr/mngrDeleteCtfhvIssue.do",
	            excel : "/ncts/mngr/edcComplMngr/mngrCtfhvIssueDownload.do"
	    }
	    
	    $.dataDetail = function(index, obj){
	        if($.isNullStr(index)) return false;

	        document.sForm.ctfhvNo.value = index;
	        
	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/edcComplMngr/mngrCtfhvIssueDetail.do",
	            data: $("#sForm").serialize(),
	            dataType: "json",
	            success: function(data) {
	                if(data.success == "success"){
	                    $("#detailTable").handlerbarsCompile($("#detail-template"), data.de);
	                    
		            	
 		            	/* if(data.de.USER_BIRTH_YMD != undefined){
			            	if(0 != data.de.USER_BIRTH_YMD.length){
			            	    if(8 == data.de.USER_BIRTH_YMD.length){
			            		    data.de.USER_BIRTH_YMD = data.de.USER_BIRTH_YMD.substr(0,4) + '.' + data.de.USER_BIRTH_YMD.substr(4,2) + '.' + data.de.USER_BIRTH_YMD.substr(6);
			            	    }else{
			            	    	data.de.USER_BIRTH_YMD = data.de.USER_BIRTH_YMD.substr(0,2) + '.' + data.de.USER_BIRTH_YMD.substr(2,2) + '.' + data.de.USER_BIRTH_YMD.substr(4);
			            	    }
			            	}
		            	}  */
		            	
		                if(data.success == "success"){
		                    $("#detailTable").handlerbarsCompile($("#detail-template"), data.de);
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
	    
	    $.ubiFormBtnOnClickEvt = function(){
	    	 $(".tr_clr_2").children(".invisible").children("#compleCourse").val();
                document.ubiForm.userNo.value = $(".tr_clr_2").children(".invisible").children("#userNo").val();
                document.ubiForm.ctfhvNo.value =  $(".tr_clr_2").children(".invisible").children(".index").val();
               
                popUbiReport();
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
	        $(document).on("click", "#reportBtn", function(){
                $.ubiFormBtnOnClickEvt();
            });
	        
	        $(".excelDown").on("click", function(e){
	        	excelPg = 1;
				$("[name='excelFileNm']").val("수료증 발급대장_"+$.toDay());
				$("[name='excelPageNm']").val("mngrCtfhvIssueList.xlsx");		        	
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

<form id="ubiForm" name="ubiForm" method="post">
    <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
    <input type="hidden" id="ubi_jrt" name="jrf" value="certificate_compl.jrf" />
    <input type="hidden" name="userNo" value="" />
	<input type="hidden" name="ctfhvNo" value="">
</form>

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
                <input type="hidden" name="ctfhvNo" id="ctfhvNo"  value="0">
                <div class="fL wp70">
                    <ul class="searchAreaBox">
                        <li class="w100 ml5">
                            <select id="sGubun1" name="sGubun1" class="form-control">
                                <option value="">선택</option>
                                <option value="01" <c:out value="${param.sGubun1 eq '01' ? 'selected=selected':'' }"/>>이름</option>
                                <option value="02" <c:out value="${param.sGubun1 eq '02' ? 'selected=selected':'' }"/>>아이디</option>
                                <option value="03" <c:out value="${param.sGubun1 eq '03' ? 'selected=selected':'' }"/>>이메일</option>
                            </select>
                        </li>
                        <li class="w160 ml5">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'> 
                        </li>
                        <li class="smart-form ml5">
                            <label class="label">수료증 종류</label>
                        </li>
                        
                        <li class="w300 ml5">
                        	<c:set var="packageAt" value="N" />
                            <select id="sGubun2" name="sGubun2" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap.DMH04 }" varStatus="idx">
                                	<c:if test="${idx.count <= 3}">
                                    	<option value='<c:out value="${list.CODE }"/>' <c:out value="${param.sGubun2 eq list.CODE ? 'selected=selected':'' }"/>><c:out value="${list.CODE_NM }"/>과정</option>
                                    </c:if>	
                                   	<c:if test="${idx.last }"><c:set var="packageAt" value="Y" /></c:if>
                                </c:forEach>
                                <c:forEach var="list" items="${codeMap.DMH29 }" varStatus="idx">
                                	<c:if test="${packageAt eq 'Y'}">
                                    	<option value='<c:out value="${list.CODE }"/>' <c:out value="${param.sGubun2 eq list.CODE ? 'selected=selected':'' }"/>>직무<c:out value="(${list.CODE_NM }"/>)과정</option>
                                    </c:if>	
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
							<col width="10%">
							<col width="15%">
                            <col width="20%">
                            
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>수료증 번호</th>
								<th>이름</th>
								<th>수료증 종류</th>
								<th>발급일</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr ><td colspan="4">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list }" varStatus="idx">
								<tr>
									<td class="invisible">
										<input type="checkbox" class="index" value='<c:out value="${list.CTFHV_NO}"/>'>
										<input type="hidden" id="compleCourse" value='<c:out value="${list.CTFHV_CD}"/>'>
									    <input type="hidden" id="userNo" value='<c:out value="${list.USER_NO}"/>'>
									</td>
									<td><c:out value="${list.CTFHV_ISSUE_NO}"/></td>
									<td><c:out value="${list.USER_NM}"/></td>
									<td>
										<c:if test="${list.PACKAGE_AT eq 'Y' }">직무(<c:out value="${list.CTFHV_NM  }"/>)과정</c:if>
										<c:if test="${list.PACKAGE_AT ne 'Y' }"><c:out value="${list.CTFHV_NM  }"/>과정</c:if>
									</td>
									<td><c:out value="${list.ISSUE_DT  }"/></td>
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
	<th scope="row">이름 </th>
	<td>{{USER_NM}}
		<c:if test="${pageInfo.REPORT_AT eq 'Y'}"> 
			<button type="button" class="btn btn-default ml2 mb5 reportDown" id="reportBtn">
        		<i class="fa fa-print" title="수료증"></i> 수료증
        	</button>
		</c:if>
    </td>
	<th scope="row">아이디</th>
    <td>{{USER_ID}}</td>
</tr>
<tr>
    <th scope="row">생년월일</th>
    <td>{{USER_BIRTH_YMD}}</td>
	<th scope="row">연락처</th>
    <td>{{USER_HP_NO}}</td>
</tr>
<tr>
	<th scope="row">수료증 종류</th>
	<td>
		{{#ifeq PACKAGE_AT 'Y'}}
			직무({{CTFHV_NM}})과정
			{{else}}
			{{CTFHV_NM}}과정{{#notempty CTFHV_DETAIL_NM}}({{CTFHV_DETAIL_NM}}){{/notempty}}
		{{/ifeq}}
	</td>
	<th scope="row">이메일</th>
	<td>{{USER_EMAIL}}</td>
</tr>
<tr>
	<th scope="row">발급일</th>
	<td colspan="3">{{ISSUE_DT}}</td>
</tr>
</script>