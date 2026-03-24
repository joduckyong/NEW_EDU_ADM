 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
.cke_contents {
	min-height: 500px !important;
}
</style> 
 
<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">

	$(function(){
		// ckEditor Height 설정
	    CKEDITOR.replace('contents',{height : 150});
		
	    var baseInfo = {
	            insertKey : "<c:out value='${common.baseType[0].key() }'/>",
	            updateKey : "<c:out value='${common.baseType[1].key() }'/>",
	            deleteKey : "<c:out value='${common.baseType[2].key() }'/>",
	            lUrl : "/ncts/mngr/homeMngr/mngrOneOnOneList.do",
	            fUrl : "/ncts/mngr/homeMngr/mngrOneOnOneForm.do",
	            dUrl : "/ncts/mngr/homeMngr/mngrDeleteOneOnOne.do",
	            excel : "/ncts/mngr/homeMngr/mngrBbsManageDownload.do"
	    }
	    
	    $.dataDetail = function(index, obj){
	        if($.isNullStr(index)) return false;

	        document.sForm.bbsNo.value = index;
	        
	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/homeMngr/mngrOneOnOneDetail.do",
	            data: $("#sForm").serialize(),
	            dataType: "json",
	            success: function(data) {
	                if(data.success == "success"){
	                	$("#iFormBbsNo").val(data.de.BBS_NO);
	                	$("#iFormAnswerNo").val(data.de.ANSWER_NO);
	                	data.de.TITLE = data.de.TITLE.replace(/&apos;/g, "'").replace(/&quot;/g,'"').replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">"); 
	                    $("#detailTable").handlerbarsCompile($("#detail-template"), data.de);
	                		
	                	var text = "";
	                		
	                	if(data.de.ANSWER_CONTENT){
	                		var text = data.de.ANSWER_CONTENT.replace(/&apos;/g, "'").replace(/&quot;/g,'"').replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">"); 
	                	}

	                	CKEDITOR.instances.contents.setData(text);
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
	        
	        if($(".tr_clr_2").find("[name=answerNo]").val()){
	        	document.sForm.answerNo.value = $(".tr_clr_2").find("[name=answerNo]").val();
	        }
	        
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
	    
	    $.fn.oneOnOneSave = function(){
	    	var _this = $(this);
            _this.on("click", function(){
            //	if(!confirm("답변하시겠습니까?")) return false;
                makeSnapshot(document.iForm, "contents");
            	
                if(!$("input[name=contentsSnapshot]").val()){
                	alert("답변을 작성해 주십시오.");
                	
                	return false;
                }
                
                if(document.iForm.iFormAnswerNo.value){
                    document.iForm.procType.value = baseInfo.updateKey;
                } else {
                	document.iForm.iFormAnswerNo.value = 0;
                    document.iForm.procType.value = baseInfo.insertKey;
                }
                
                $("#iForm").ajaxForm({
                    type: 'POST',
                    url: "/ncts/mngr/homeMngr/mngrOneOnOneAnswer.do",
                    dataType: "json",
                    success: function(result) {
                        alert(result.msg);
                        if(result.success == "success") location.replace(baseInfo.lUrl);    
                    }
                });

                $("#iForm").submit();
            })
	    }
	    
	    $.fn.divisionOnChangeEvt = function(){
			$(this).on("change", function(){
				$.codeSettings();
			})
		}
	    
	    $.codeSettings = function(){
			$.ajax({
				type : "POST",
				url : "/ncts/mngr/homeMngr/selectInquiryCode.do",
				data : $("#sForm").serialize(),
				dataType: "json",
				success: function(data) {
					var codeList = data.codeList;
					var hideli = $("#hideli");
					var division2 = $("#hideli").find("select");
					var detailCd = '<c:out value="${param.sGubun3}"/>';
					
					if(codeList.length > 0) {
						hideli.show();
					} else {
						hideli.hide();
					}
					division2.html("");
					for(i in codeList) {
						division2.append("<option value="+codeList[i].CODE+">"+codeList[i].CODE_NM+"</option>");
						if(detailCd != "") {
							$(".division option").each(function(){
								var $this = $(this);
								if($this.val() == detailCd) $this.prop("selected", true);
							})
						}
					}
				}
			})
		}
	    
		$.fn.userDetailTdOnClickEvt = function(){
			$(this).on("click", function(){
				var $this = $(this);
				var userNo = $this.data("no");
				if(userNo == "") {
					alert("데이터가 없습니다.");
					return false;
				}
				document.userForm.userNo.value = userNo;
				$.popAction.width = 1200;
				$.popAction.height = 600;
				$.popAction.target = "selectEduMemberDetailPopup3";
				$.popAction.url = "/ncts/mngr/common/selectEduMemberDetailPopup.do";
				$.popAction.form = document.userForm;
				$.popAction.init();
			})
		}		    
	    
	    
	    $.initView = function(){
	        $.onClickTableTr();
	        $("#searchBtn").searchBtnOnClickEvt($.searchAction);
	        /* $("#saveBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.insertKey); */
	        $("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
	        $("#delBtn").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey);
	        $("#answerOneOnOne").oneOnOneSave();
	        $.codeSettings();
	        $("#division").divisionOnChangeEvt();
	        $(".userDetailTd").userDetailTdOnClickEvt();
	        
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
                <input type="hidden" name="answerNo" id="answerNo"  value="0">
                <div class="fL wp80">
                    <ul class="searchAreaBox">
                    	<li class="smart-form">
						    <label class="label">센터명</label>
						</li>
						<sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')">
							<li class="w150 mr5">
								<select name="centerCd" class="form-control">
									<option value="">전체</option>
									<c:forEach var="center" items="${centerList }" varStatus="idx">
										<c:if test="${center.DEPT_CD eq '10000000' or center.DEPT_CD eq '30000000' or center.DEPT_CD eq '50000000' or center.DEPT_CD eq '60000000' or center.DEPT_CD eq '70000000'}">
											<option value="<c:out value='${center.DEPT_CD }'/>" data-groupId="<c:out value='${center.GROUP_ID }'/>" <c:out value="${center.DEPT_CD eq param.centerCd ? 'selected=selected':'' }"/> ><c:out value="${center.DEPT_NM }"/></option>
										</c:if>
									</c:forEach>
								</select> <i></i>
							</li>
						</sec:authorize>
						<sec:authorize access="hasRole('ROLE_ADMIN') or hasRole('ROLE_USER')">
							<li class="smart-form mr5">
								<input type="hidden" name="centerCd" value="<sec:authentication property="principal.centerId"/>" >
								<label class="label"><sec:authentication property="principal.centerNm"/></label>
							</li>
						</sec:authorize>
						
                        <li class="smart-form"><label class="label">구분</label></li>
                        <li class="w100">
	                        <select name="sGubun2" id="division" class="form-control division">
	                            <option value="">선택</option>
	                            <option value="edu" <c:out value="${param.sGubun3 eq '01' or param.sGubun3 eq '02' ? 'selected' : '' }"/>>교육신청</option>
	                            <option value="user" <c:out value="${param.sGubun3 eq '03' or param.sGubun3 eq '04' ? 'selected' : '' }"/>>회원관리</option>
	                            <option value="instrctr" <c:out value="${param.sGubun3 eq '05' or param.sGubun3 eq '06' ? 'selected' : '' }"/>>강사관리</option>
	                            <option value="etc" <c:out value="${param.sGubun3 eq '07' ? 'selected' : '' }"/>>기타</option>
	                        </select>
                        </li>
                        <li class="smart-form ml5"></li>
                        <li class="w120" id="hideli" style="display:none !important">
                        	<td>
                                <select name="sGubun3" class="form-control division">
                                </select>
                            </td>
                        </li>
                        
                        <li class="smart-form ml5"><label class="label">답변여부</label></li>
                        <li class="w100">
                            <select id="sGubun1" name="sGubun1" class="form-control">
                                <option value="">전체</option>
                                <option value="N" <c:out value="${param.sGubun1 eq 'N' ? 'selected=selected':'' }"/>>답변대기</option>
                                <option value="Y" <c:out value="${param.sGubun1 eq 'Y' ? 'selected=selected':'' }"/>>답변완료</option>
                            </select>
                        </li>
                        <li class="smart-form ml5"><label class="label">작성자</label></li>
                        <li class="w100 ml5">
                            <input id="searchKeyword3" name="searchKeyword3" class="form-control" value='<c:out value="${param.searchKeyword3}"/>'> 
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
                
				<div class="fR wp20">
					<ul class="searchAreaBox fR">
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
							<col width="5%">
							<col width="10%">
							<col width="10%">
							<col width="15%">
							<col width="45%">
                            <col width="15%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>NO</th>
								<th>센터명</th>
								<th>구분</th>
								<th>작성자</th>
								<th>제목</th>
								<th>작성일</th>
								<!-- <th>기간(시작)</th>
								<th>기간(종료)</th>
								<th>활동내용</th> -->
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr><td colspan="6">데이터가 없습니다.</td></tr>
							</c:if>
							
							<c:forEach var="list" items="${list }" varStatus="idx">
								<tr>
									<td class="invisible">
										<input type="checkbox" class="index" value="${list.BBS_NO}">
									</td>
									
									<c:if test="${!empty list.ANSWER_CONTENT}">
										<td rowspan="2" style=""><c:out value="${paginationInfo.totalRecordCount - ((paginationInfo.currentPageNo-1) * paginationInfo.recordCountPerPage+ idx.index)}"/></td>
										<td rowspan="2" style=""><c:out value="${list.CENTER_NM}"/></td>
										<td rowspan="2" style="vertical-align:top;"><c:out value="${list.BBS_TYPE_CD_NM }"/></td>
										<td rowspan="2" style="vertical-align:top;" class="userDetailTd" data-no="<c:out value='${list.FRST_USER_NO }'/>"><c:out value="${list.USER_NM}"/></td>
									</c:if>
									<c:if test="${empty list.ANSWER_CONTENT}">
										<td><c:out value="${paginationInfo.totalRecordCount - ((paginationInfo.currentPageNo-1) * paginationInfo.recordCountPerPage+ idx.index)}"/></td>
										<td><c:out value="${list.CENTER_NM}"/></td>
                                        <td><c:out value="${list.BBS_TYPE_CD_NM }"/></td>
                                        <td class="userDetailTd" data-no="<c:out value='${list.FRST_USER_NO }'/>"><c:out value="${list.USER_NM}"/></td>
                                    </c:if>
									<td style="text-align:left"><p style="font-weight: bold;"><<c:out value="${list.BBS_TYPE_DETAIL_CD_NM }"/>></p><c:out value="${list.TITLE}"/></td>
									<td><c:out value="${list.FRST_REGIST_PNTTM}"/></td>
								</tr>
								<c:if test="${!empty list.ANSWER_CONTENT}">
									<tr>
									    <td class="invisible">
	                                        <input type="checkbox" class="index" value="<c:out value='${list.BBS_NO}'/>">
	                                        <input type="hidden" name="answerNo" value="<c:out value='${list.ANSWER_NO}'/>">
	                                    </td>
	                                    <td class="test" style="text-align:left; word-break:break-all;text-overflow:ellipsis; overflow:hidden;" nowrap>
	                                    	<img src="/images/iconmonstr-arrow-55-12.png" title="RE" style="width:auto;height:auto;float:left; margin-right:10px;">
		                                    <textarea readonly style="resize: none; width:80%; height:100px; border:none;" <c:out value="${pageInfo.INSERT_AT eq 'Y' ? '':'disabled'}"/>><c:out value='${list.ANSWER_CONTENT.replaceAll("\\\<.*?\\\>","").replaceAll("&nbsp;", " ")}' /></textarea>
	                                    </td>
	                                    <td><c:out value="${list.ANSWER_DATE}"/></td>
	                                </tr>
                                </c:if>
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
							<tr><td colspan="2" class="textAlignCenter">항목을 선택해주세요.</td></tr>
						</tbody>
					</table>
					
					

                    <form name="iForm" id="iForm" method="post">
                    	<c:if test="${pageInfo.INSERT_AT eq 'Y'}">
		                    <button type="button" class="btn btn-primary ml2 mb5" id="answerOneOnOne">
		                        <i class="fa fa-edit" title="1대1문의 댭변"></i>1대1 문의 답변하기
		                    </button>
		                </c:if>    
                        <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
                        <td><input id="iFormBbsNo" type="hidden" name="bbsNo">
                            <input id="iFormAnswerNo" type="hidden" name="answerNo" value="0">
                        </td>
                        <table class="table table-bordered table-hover tb_type01">
                            <!-- <colgroup>
                                <col width="7%">
                                <col width="8%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="20%">
                                <col width="20%">
                                <col width="15%">
                            </colgroup> -->
                            <tbody id="1on1Detail">
	                            <td class="board_contents">
									<textarea id="contents" name="contents" class="part_long board_contents" style="width: 100%; min-width: 100%;" <c:out value="${pageInfo.INSERT_AT eq 'Y' ? '':'disabled'}"/>><%-- ${list.ANSWER_CONTENT} --%></textarea>
	                            </td>
                            </tbody>
                        </table>
                    </form>
                    
				</article>
				
				<form name="userForm" id="userForm" method="post" class="smart-form">
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
					<input type="hidden" name="userNo" value="">
				</form>				
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
	<th scope="row">작성일</th>
	<td>{{FRST_REGIST_PNTTM}}</td>
</tr>
<tr>
	<th scope="row">제목</th>
	<td>{{TITLE}}</td>
</tr>
<tr>
    <th scope="row">내용</th>
    <td>{{safe CONTENTS}}</td>
</tr>
<tr>
    <th scope="row">첨부파일</th>
    <td>{{safe fileView}}</td>
</tr>

</script>