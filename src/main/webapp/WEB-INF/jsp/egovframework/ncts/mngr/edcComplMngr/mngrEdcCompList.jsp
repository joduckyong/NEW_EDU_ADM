 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

	$(function(){
		var excelPg = 0;
	    var baseInfo = {
	            insertKey : '<c:out value="${common.baseType[0].key() }"/>',
	            updateKey : '<c:out value="${common.baseType[1].key() }"/>',
	            deleteKey : '<c:out value="${common.baseType[2].key() }"/>',
	            lUrl : "/ncts/mngr/edcComplMngr/mngrEdcCompList.do",
	            fUrl : "/ncts/mngr/edcComplMngr/mngrEdcCompForm.do",
	            dUrl : "/ncts/mngr/edcComplMngr/mngrDeleteEdcComp.do",
	            excel : "/ncts/mngr/edcComplMngr/mngrEdcComplDownload.do"
	    }
	    
	    
	    $.dataDetail = function(index, obj){
	        if($.isNullStr(index)) return false;

	        document.sForm.edcIssueNo.value = index;
	        
	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/edcComplMngr/mngrEdcCompDetail.do",
	            data: $("#sForm").serialize(),
	            dataType: "json",
	            success: function(data) {
	            	if(data.de.CERT_CD == 'CGP(3H)'){
	            		$("#ubi_jrt").val("certificate_conparti.jrf");
	            	}else{
	            		$("#ubi_jrt").val("certificate_isue.jrf");
	            	}
	            	// data.de.USER_HP_NO = data.de.USER_HP_NO.replace(/-/gi, "");
	            	data.de.ISSUE_DT = data.de.ISSUE_DT.substr(0,4) + '.' + data.de.ISSUE_DT.substr(4,2) + '.' + data.de.ISSUE_DT.substr(6);
	            	
	            	/* if(data.de.USER_HP_NO != undefined) {
		            	if(0 != data.de.USER_HP_NO.length){
			            	if(11 < data.de.USER_HP_NO.length){
			            		data.de.USER_HP_NO = data.de.USER_HP_NO.substr(0, 3) + '-' + data.de.USER_HP_NO.substr(3, 3) + '-' + data.de.USER_HP_NO.substr(6)
			            	}else{
			            		data.de.USER_HP_NO = data.de.USER_HP_NO.substr(0, 3) + '-' + data.de.USER_HP_NO.substr(3, 4) + '-' + data.de.USER_HP_NO.substr(7)
			            	}
		            	}
	            	} */
	            	
	            	if(data.de.USER_BIRTH_YMD != undefined){
		            	if(0 != data.de.USER_BIRTH_YMD.length){
		            	    if(8 == data.de.USER_BIRTH_YMD.length){
		            		    data.de.USER_BIRTH_YMD = data.de.USER_BIRTH_YMD.substr(0,4) + '.' + data.de.USER_BIRTH_YMD.substr(4,2) + '.' + data.de.USER_BIRTH_YMD.substr(6);
		            	    }else{
		            	    	data.de.USER_BIRTH_YMD = data.de.USER_BIRTH_YMD.substr(0,2) + '.' + data.de.USER_BIRTH_YMD.substr(2,2) + '.' + data.de.USER_BIRTH_YMD.substr(4);
		            	    }
		            	}
	            	}
	            	
	            	
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
	    
	    $.ubiFormBtnOnClickEvt = function(){
	    	var $index = $(".tr_clr_2").children(".invisible");
            document.ubiForm.userNo.value = $index.children("#userNo").val();
            document.ubiForm.edcIssueNo.value =  $index.children("#edcIssueNo").val();
            document.ubiForm.eduSeq.value =  $index.children("#eduSeq").val();
            document.ubiForm.eduGubun.value =  $index.children("#eduGubun").val();
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
	        $(".excelDown").on("click", function(e){
	        	excelPg = 1;
				$("[name='excelFileNm']").val("교육이수증 발급대장_"+$.toDay());
				$("[name='excelPageNm']").val("mngrEdcCompList.xlsx");	        	
	        	
	            with(document.sForm){
	                target = "";
	                action = baseInfo.excel;
	                submit();
	                
	                $.setCookie("fileDownloadToken","false"); //Cookie 생성
	                $.loadingBarStart(e);
	                $.checkDownloadCheck();// Cookie Token 값 체크
	            }
	        });
	        $(document).on("click", "#reportBtn", function(){
                $.ubiFormBtnOnClickEvt();
            });
	        
	        $("body").on("keydown", function(e){
		        $.loadingBarKeyDown(e, excelPg);
	        })
	    }
	    
	    $.initView();
	})
</script>

<form id="ubiForm" name="ubiForm" method="post">
    <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
    <input type="hidden" id="ubi_jrt" name="jrf" value="certificate_isue.jrf" />
    <input type="hidden" name="userNo" value="" />
    <input type="hidden" name="edcIssueNo" value="" />
    <input type="hidden" name="eduSeq" value="" />
    <input type="hidden" name="eduGubun" value="" />
</form>
		
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
                <input type="hidden" name="edcIssueNo" id="edcIssueNo"  value="0">
                <div class="fL wp80">
                    <ul class="searchAreaBox">
                        <li class="smart-form ml5">
                            <label class="label">구분</label>
                        </li>
                        <li class="w120 ml5">
                            <select id="sGubun2" name="sGubun2" class="form-control">
                                <option value="">선택</option>
                                <option value="01" <c:out value="${param.sGubun2 eq '01' ? 'selected=selected':'' }"/>>이름</option>
                                <option value="09" <c:out value="${param.sGubun2 eq '09' ? 'selected=selected':'' }"/>>아이디</option>
                                <option value="02" <c:out value="${param.sGubun2 eq '02' ? 'selected=selected':'' }"/>>연번</option>
                                <option value="03" <c:out value="${param.sGubun2 eq '03' ? 'selected=selected':'' }"/>>이메일</option>
                                <option value="04" <c:out value="${param.sGubun2 eq '04' ? 'selected=selected':'' }"/>>연락처</option>
                                <option value="05" <c:out value="${param.sGubun2 eq '05' ? 'selected=selected':'' }"/>>소속</option>
                                <option value="06" <c:out value="${param.sGubun2 eq '06' ? 'selected=selected':'' }"/>>워크샵명</option>
                                <option value="07" <c:out value="${param.sGubun2 eq '07' ? 'selected=selected':'' }"/>>진행구분</option>
                                <option value="08" <c:out value="${param.sGubun2 eq '08' ? 'selected=selected':'' }"/>>시행기관</option>
                                
                            </select>
                        </li>
                        <li class="w200 ml5">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'>
                        </li>
                        <li class="smart-form ml5">
                            <label class="label">교육명</label>
                        </li>
                        <li class="w200 ml5">
                            <select id="sGubun" name="sGubun" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="lecList" items="${eduResult}" varStatus="idx">
                                    <c:if test="${lecList.LECTURE_ID ne '일반'}">
                                        <option value='<c:out value="${lecList.LECTURE_ID}"/>' <c:out value="${param.sGubun eq lecList.LECTURE_ID ? 'selected=selected' : ''}"/>> <c:out value="${lecList.LECTURE_NM}"/></option>
                                    </c:if>
                                </c:forEach>
                                <%-- <c:forEach var="list" items="${codeMap.DMH12 }" varStatus="idx">
                                    <option value="${list.CODE }" ${param.sGubun eq list.CODE ? 'selected="selected"':'' }>${list.CODE_NM }</option>
                                </c:forEach> --%>
                            </select>
                        </li>
                        <li class="smart-form ml5">
                            <label class="label">지역</label>
                        </li>
                        <li class="w80 ml5">
                            <select id="sGubun1" name="sGubun1" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap.DMH07 }" varStatus="idx">
                                    <option value='<c:out value="${list.CODE }"/>' <c:out value="${param.sGubun1 eq list.CODE ? 'selected=selected':'' }"/>><c:out value="${list.CODE_NM }"/></option>
                                </c:forEach>
                            </select>
                        </li>
                        <li class="smart-form ml5">
                            <label class="label">교육구분</label>
                        </li>
                        <li class="w100 ml5">
                            <select id="sGubun3" name="sGubun3" class="form-control">
                                <option value="">선택</option>
                                <option value="ON" <c:out value="${param.sGubun3 eq 'ON' ? 'selected=selected':'' }"/>>온라인</option>
                                <option value="OFF" <c:out value="${param.sGubun3 eq 'OFF' ? 'selected=selected':'' }"/>>오프라인</option>
                            </select>
                        </li>
                        <li class="smart-form ml5">
                            <label class="label">교육상세구분</label>
                        </li>
                        <li class="w80 ml5">
                            <select id="sGubun4" name="sGubun4" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap.DMH19 }" varStatus="idx">
                                	<c:if test="${list.CODE ne '03' }">
                                    	<option value='<c:out value="${list.CODE }"/>' <c:out value="${param.sGubun4 eq list.CODE ? 'selected=selected':'' }"/>><c:out value="${list.CODE_NM }"/></option>
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
							<col width="15%">
							<col width="10%">
                            <col width="20%">
                            <col width="15%">
                            <col width="15%">
                            <!-- <col width="10%"> -->
                            <col width="10%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>연번</th>
								<th>이름</th>
								<th>소속</th>
								<th>워크샵명</th>
								<th>교육명</th>
								<!-- <th>지역</th> -->
								<th>진행팀</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr ><td colspan="7">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list }" varStatus="idx">
								<tr>
									<td class="invisible">
										<input type="checkbox" id="edcIssueNo" class="index" value='<c:out value="${list.EDC_ISSUE_NO}"/>'>
										<input type="hidden" id="userNo" value='<c:out value="${list.USER_NO}"/>'>
										<input type="hidden" id="eduSeq" value='<c:out value="${list.EDU_SEQ}"/>'>
										<input type="hidden" id="eduGubun" value='<c:out value="${list.EDU_GUBUN}"/>'>
										<%-- <input type="hidden" name = "searchLectureSq" value="${list.LECTURE_SQ}"> --%>
									</td>
									<%-- <td>${!empty list.DIST_MANAGE_NM ? list.DIST_MANAGE_NM : '전체'  }</td> --%>
									<td><c:out value="${list.SERIAL_NUM}"/></td>
									<td><c:out value="${list.USER_NM  }"/></td>
									<td><c:out value="${list.USER_PSITN  }"/></td>
									<td><c:out value="${list.WORKSHP_NM}"/></td>
									<td><c:out value="${list.EDC_NM }"/></td>
									<%-- <td>${list.USER_AREA }</td> --%>
									<td><c:out value="${list.PROGRS_TEAM }"/></td>
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
	<th scope="row">연번 </th>
	<td colspan="3">{{SERIAL_NUM}}
		<c:if test="${pageInfo.REPORT_AT eq 'Y'}">
			<button type="button" class="btn btn-default ml2 mb5 reportDown" id="reportBtn">
        		<i class="fa fa-print" title="이수증"></i> 이수증
        	</button>
		</c:if>
    </td>
</tr>
<tr>
	<th scope="row">이름</th>
	<td>{{USER_NM}}</td>
    <th scope="row">생년월일</th>
    <td>{{USER_BIRTH_YMD}}</td>
</tr>
<tr>
	<th scope="row">이메일</th>
	<td>{{USER_EMAIL}}</td>
    <th scope="row">연락처</th>
    <td>{{USER_HP_NO}}</td>
</tr>
<tr>
    <th scope="row">아이디</th>
    <td>{{USER_ID}}</td>
    <th scope="row">소속</th>
    <td>{{USER_PSITN}}</td>
</tr>
<tr>
	<th scope="row">교육일</th>
	<td>{{ISSUE_DT}}</td>
    <th scope="row">교육시간</th>
    <td>{{EDC_TIME}}</td>
</tr>
<tr>
    <th scope="row">워크샵명</th>
    <td>{{WORKSHP_NM}}</td>
    <th scope="row">교육명</th>
    <td>{{EDC_NM}}</td>
</tr>
<tr>
	<!--
    <th scope="row">직업</th>
    <td>{{USER_JOB}}</td>
	
    <th scope="row">지역</th>
    <td colspan="3">{{USER_AREA}}</td>
	-->
</tr>
<tr>
    <th scope="row">진행팀</th>
    <td>{{PROGRS_TEAM}}</td>
    <th scope="row">시행기관</th>
    <td>{{OPERTN_INSTT}}</td>
</tr>
<tr>
    <th scope="row">동영상 강의</th>
    <td colspan="3">{{#empty VIDEO_AT}}N{{else}}{{VIDEO_AT}}{{/empty}}</td>
</tr>
<tr>
    <th scope="row">발급일</th>
    <td colspan="3">{{REGIST_DT}}</td>
</tr>
</script>