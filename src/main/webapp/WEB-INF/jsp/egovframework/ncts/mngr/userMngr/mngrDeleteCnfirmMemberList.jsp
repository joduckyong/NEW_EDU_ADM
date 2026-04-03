 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">
	$(function(){
	    var baseInfo = {
	            insertKey : "${common.baseType[0].key() }",
	            updateKey : "${common.baseType[1].key() }",
	            deleteKey : "${common.baseType[2].key() }",
	            lUrl : "/ncts/mngr/userMngr/mngrDeleteCnfirmMemberList.do",
	            dUrl : "/ncts/mngr/userMngr/deleteMngrDeleteCnfirmMember.do",
	            pop01 : "/ncts/mngr/userMngr/mngrFileConfirmListPopup.do"
	    }
	    
	    $.dataDetail = function(index){
	        if($.isNullStr(index)) return false;
	        document.sForm.userNo.value = index;
	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/userMngr/mngrDeleteCnfirmMemberDetail.do",
	            data: $("#sForm").serialize(),
	            dataType: "json",
	            success: function(data) {
	                if(data.success == "success"){
	                	var courses = "";
	                    //$("#prmoDetail").empty();
	                    //$.addTemplate("detail-template", "prmoDetail", data.rs) 
	                    $(".tab-content").show();
	                    $("#detailTable").handlerbarsCompile($("#detail-template"), data.de);
	                    $("#seTable").handlerbarsCompile($("#se-template"), data.se);
	                    $("#seTable").handlerbarsAppendCompile($("#video-se-template"), data.seVideo);
	                    
	                    if($("#courses").val() == '') courses = "#coursesEtc";
	                    else courses = "#courses"+$("#courses").val();
	                    $(courses).closest("ul").find("li").removeClass("active");
	                    $(courses).closest("li").addClass("active");
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
	            } else {
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
	    
	    $.fn.liOnClickEvt = function(){
	    	var _this = $(this);
	    	_this.on("click", function(){
	    		var $this = $(this);
	    		var id = $this.attr("id").replace("courses", "");
	    		var courses = id == "Etc" ? '' : id;
	    		
	    		document.sForm.courses.value = courses;
	    		$.dataDetail($(".index:checked").val());
	    	})
	    }
	    
	    $.fn.confirmDetailBtnOnClickEvt = function(){
	    	$(this).on("click", "#confirmDetailBtn", function(){
	    		var $this = $(this);
	    		
	    		$.popAction.width = 1200;
				$.popAction.height = 600;
				$.popAction.target = "selectFileConfirmListPopup";
				$.popAction.url = baseInfo.pop01;
				$.popAction.form = document.sForm;
				$.popAction.init();
	    	})
	    }
	    
	    $.initView = function(){
	        $.onClickTableTr();
	        $("#searchBtn").searchBtnOnClickEvt($.searchAction);
	        $("#delBtn").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey);
	        $("#isueList li a").liOnClickEvt();
	        
	        $(document).on("click",".fileDown", function(){
	        	var url = $(this).prev(".fileView").find(".file_wrap");
	        	
	        	if(url.length == 0) alert("업로드 된 파일이 없습니다.");
	        	else {
	        		url = url.find("a").prop("href");
	        		location.href = url;
	        	}
	        });
	        
	        $("body").on("keydown", function(e){
		        $.loadingBarKeyDown(e, excelPg);
	        })
	        
	        $("input[name='searchKeyword1']").keypress(function(e){if(e.keyCode == 13)  $.searchAction();});
	        
	        $("body").confirmDetailBtnOnClickEvt();
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
                <input type="hidden" name="userNo" id="userNo" value="0">
                <input type="hidden" name="courses" id="courses" value="00">
                <input type="hidden" name="fileConfirmAt" id="fileConfirmAt" value="">
                
                <div class="fL wp75">
                    <ul class="searchAreaBox">
                    	<li class="smart-form"><label class="label">아이디</label></li>
                        <li class="w100 ml5">
                            <input id="searchKeyword4" name="searchKeyword4" class="form-control" value='<c:out value="${param.searchKeyword4}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">이름</label></li>
                        <li class="w80 ml5">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">이메일</label></li>
                        <li class="w150 ml5">
                            <input id="searchKeyword2" name="searchKeyword2" class="form-control" value='<c:out value="${param.searchKeyword2}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">연락처</label></li>
                        <li class="w100 ml5">
                            <input id="searchKeyword3" name="searchKeyword3" class="form-control" value='<c:out value="${param.searchKeyword3}"/>'> 
                        </li>
                        <li class="smart-form ml5">
                            <label class="label">회원등급</label>
                        </li>
                        <li class="w80 ml5">
                            <select id="sGubun" name="sGubun" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap.DMH03 }" varStatus="idx">
                                    <option value="${list.CODE }" ${param.sGubun eq list.CODE ? 'selected="selected"':'' }>${list.CODE_NM }</option>
                                </c:forEach>
                            </select>
                        </li>
                        <li class="smart-form ml5">
                            <label class="label">세부등급</label>
                        </li>
                        <li class="w80">
                            <select id="sGubun1" name="sGubun1" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap.DMH23 }" varStatus="idx">
                                    <option value="${list.CODE }" ${param.sGubun1 eq list.CODE ? 'selected="selected"':'' }>
	                                    ${list.CODE_NM}
                                    </option>
                                </c:forEach>
                            </select>
                        </li>
                        
                        <li class="smart-form ml5">
                            <label class="label">강사등급</label>
                        </li>
                        <li class="w80">
                            <select id="sGubun2" name="sGubun2" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap.DMH24 }" varStatus="idx">
                                    <option value="${list.CODE }" ${param.sGubun2 eq list.CODE ? 'selected="selected"':'' }>
	                                    ${list.CODE_NM}
                                    </option>
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
                    <jsp:param value="2"     name="buttonYn"/>
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
							<col width="23.2%">
							<col width="15.2%">
							<col width="23%">
							<col width="23.2%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>아이디</th>
								<th>이메일</th>
								<th>이름</th>
								<th>연락처</th>
								<th>세부등급</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr ><td colspan="5">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list }" varStatus="idx">
								<tr>
									<td class="invisible">
										<input type="checkbox" class="index" value="${list.USER_NO}">
										
									</td>
									<%-- <td>${!empty list.DIST_MANAGE_NM ? list.DIST_MANAGE_NM : '전체'  }</td> --%>
									<td>${list.USER_ID}</td>
									<td>${list.USER_EMAIL}</td>
									<td>${list.USER_NM}</td>
									<td>${list.USER_HP_NO}</td>
									<td>${list.DETAIL_GRADE_CD_NM}</td>
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
							<col width="20%">
							<col width="15%">
							<col width="20%">
							<col width="15%">
							<col width="20%">
						</colgroup>
						<tbody id="detailTable">
							<tr><td colspan="6" class="textAlignCenter">항목을 선택해주세요.</td></tr>
						</tbody>
					</table>
					
					<table class="table table-bordered table-hover tb_type01">
						<div class="wp12">
						  <span class="col mt7 mr5 ml15"><b>P:이수, T:시간부족, F:미이수</b></span>
						</div>
						
						<div class="tab-content" style="display:none;">
							<div class="jarviswidget-sortable active" id="isueList">
								<ul class="nav nav-tabs" style="min-width:100%;">
									<li class="active"><a href="javascript:void(0);" id="courses00">일반</a></li>
									<li><a href="javascript:void(0);" id="courses01">초급</a></li>
									<li><a href="javascript:void(0);" id="courses02">중급</a></li>
									<li><a href="javascript:void(0);" id="courses03">고급</a></li>
									<li><a href="javascript:void(0);" id="courses04">강사</a></li>
									<li><a href="javascript:void(0);" id="courses10">직무</a></li>
									<li><a href="javascript:void(0);" id="courses07">기타</a></li>
									<li><a href="javascript:void(0);" id="coursesEtc">미선택</a></li>									
								</ul>
							</div>
						</div>
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
<tr>
	<th scope="row">아이디</th>
	<td>{{USER_ID}}</td>
	<th scope="row">이메일</th>
	<td colspan="3">{{USER_EMAIL}}</td>
</tr>
<tr>
	<th scope="row">회원등급</th>
	<td>{{GRADE_CD_NM}}</td>
	<th scope="row">세부등급 </th>
	<td>{{DETAIL_GRADE_CD_NM}}</td>
	<th scope="row">강사등급 </th>
	<td>{{INSTRCTR_DETAIL_GRADE_CD_NM}}</td>
</tr>
<tr>
	<th scope="row">이름</th>
	<td>{{USER_NM}}</td>
    <th scope="row">생년월일</th>
    <td colspan = "3">{{USER_BIRTH_YMD}}</td>
</tr>
<tr>
	<th scope="row">학위</th>
	<td>{{ACADEMIC_DEGREE_CD_NM}}</td>
    <th scope="row">전화번호</th>
    <td colspan = "3">{{USER_HP_NO}}</td>
</tr>
<tr>
	<th scope="row">학과</th>
	<td>{{DEPARTMENT_NM}}</td>
    <th scope="row">전공</th>
    <td colspan = "3">{{MAJOR_NM}}</td>
</tr>
<tr>
	<th scope="row">졸업여부 </th>
	<td >{{GRADUATION_CD_NM}}</td>
    <th scope="row">졸업(예정)일</th>
    <td colspan = "3">{{GRADUATION_YMD}}</td>
</tr>
<tr>
    <th scope="row">현재소속 </th>
    <td >{{CURRENT_JOB_NM}}</td>
    <th scope="row">
		자격증
		<button type="button" class="btn btn-default ml2 mb5" id="confirmDetailBtn">
    		<i class="fa fa-search" title="변경내역"></i>변경내역
		</button>

	</th>
    <td colspan = "3">
		{{LICENSE_NM}}
		<br>
		<div class="fileView" style="display:none;">
			{{safe fileView}}
		</div>
		<button type="button" class="btn btn-default ml2 mb5 fileDown" id="">
			<i class="fa fa-print" title="첨부파일 down"></i> 첨부파일 down
		</button>
		<br>
		{{#notempty FILE_CONFIRM_PNTTM}}({{FILE_CONFIRM_NM}}, {{FILE_CONFIRM_PNTTM}}){{/notempty}}
	</td>
</tr>

<tr>
    <th scope="row">가입일시</th>
    <td >{{FRST_REGIST_PNTTM}}</td>
	<th scope="row">개인정보<br>동의여부</th>
    <td colspan = "3">{{PRIVACY_AGREE_AT}}</td>
</tr>
</script>

<script id="se-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">교육명</th>
	<th scope="row">수강여부</th>
    <th scope="row">교육명</th>
    <th scope="row">수강여부</th>
</tr>

{{#if .}}
{{#each .}}
<tr>
	<td bgcolor={{#ifnoteq ACTIVE_YN1 'Y'}}"#d2c0a4"{{/ifnoteq}}>{{LECTURE_NM1}}</td>
    <td>{{CERT_COMPLETED_CD1}}</td>
    <td bgcolor={{#ifnoteq CERT_CD2 ''}}{{#ifnoteq ACTIVE_YN2 'Y'}}"#d2c0a4"{{/ifnoteq}}{{/ifnoteq}}>{{LECTURE_NM2}}</td>
    <td>{{CERT_COMPLETED_CD2}}</td>
</tr>
{{/each}}
{{else}}
    <tr class="noData">                           
        <td colspan="4">데이터가 없습니다.</td>             
    </tr>
{{/if}}

</script>
<script id="video-se-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">동영상 교육명</th>
	<th scope="row">수강여부</th>
    <th scope="row">동영상 교육명</th>
    <th scope="row">수강여부</th>
</tr>

{{#if .}}
{{#each .}}
<tr>
    <td>{{LECTURE_ID1}}</td>
    <td>{{PASS_CD1}}</td>
    <td>{{LECTURE_ID2}}</td>
    <td>{{PASS_CD2}}</td>
</tr>
{{/each}}
{{else}}
    <tr class="noData">                           
        <td colspan="4">데이터가 없습니다.</td>             
    </tr>
{{/if}}

</script>