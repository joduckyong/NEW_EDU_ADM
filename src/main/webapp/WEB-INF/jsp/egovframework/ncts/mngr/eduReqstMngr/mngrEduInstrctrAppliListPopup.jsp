<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

$(function(){
	var baseInfo = {
			insertKey : "<c:out value='${common.baseType[0].key() }'/>",
			updateKey : "<c:out value='${common.baseType[1].key() }'/>",
			deleteKey : "<c:out value='${common.baseType[2].key() }'/>",
			lUrl : "/ncts/mngr/eduReqstMngr/mngrEduInstrctrAppliListPopup.do",
			fUrl : "/ncts/mngr/eduReqstMngr/mngrEduInstrctrAppliListPopup.do",
	}
	
	$.dataDetail = function(index, obj){
		if($.isNullStr(index)) return false;
		document.sForm.reqstSeq.value = index;
	}
	
	$.searchAction = function(){
		var no = 1;
        if(typeof(arguments[0]) != "undefined") no = arguments[0].pageNo;
        with(document.sForm){
            currentPageNo.value = no;
            action = baseInfo.lUrl;
            submit();
        }
    }
	
	$.fn.procBtnOnClickEvt = function(){
		var _this = $(this);
		
		_this.on("click", "button", function(){
			var $this = $(this);
			var yn = $this.data("yn");
			var form = document.sForm;
			var invisible = $this.closest("tr").find(".invisible");
			var key = "";
			var division = "";
			var type = "";
			var url = "";
			var msg = "반려";

			if($this.is(".approveBtn")) {
				if(yn == "Y") key = baseInfo.deleteKey;
				else key = baseInfo.insertKey;
				msg = "배정";
			}
			else if($this.is(".rejecteBtn")) {
				key = baseInfo.deleteKey;
				type = "del";
			}
			
			if(!confirm(msg+"하시겠습니까?")) return;
			
			form.instrctrNo.value =	$this.closest("tr").find(".invisible").find("input[name='userNo']").val();
			form.procType.value = key;
			
			if(form.reqstSeq.value == "") url = "/ncts/mngr/eduReqstMngr/tempInstrctrAsignProcess.do";
			else url = "/ncts/mngr/eduReqstMngr/instrctrAsignProcess.do";
			
			$.ajax({
				type: 'POST',
	            url: url,
	            data: $("#sForm").serialize(),
	            dataType: "json",
	            success: function(data) {
	            	if(data.rs.rs == "Y") {
	            		alert(msg+"되었습니다.");
	            		if(data.rs.tempKey != "") {
	            			$("#tempSeq").val(data.rs.tempKey);
	            			$("#boardType").val(data.rs.tempKey);
	            		}
		            	self.opener.$.selectInstrctr(invisible.find("input[name='userNm']").val(), $.checkUser(), $("input[name='instrctrDivision']").val(), type, data.rs.tempKey);
		            	$.searchAction();
	            	} else {
	            		alert("한 강의당 최대 10명까지 배정 가능합니다.");
	            	}
	            }
			})
		})
	}
	
	$.checkUser = function(){
		var str = "";
		var url = "/ncts/mngr/eduReqstMngr/selectInstrctrOriList.do";
		if($("#eduSeq").val() == "") url = "/ncts/mngr/eduReqstMngr/selectTempInstrctrList.do";
		
		$.ajax({
            type: 'POST',
            url: url,
            data: $("#sForm").serialize(),
            dataType: "json",
            async : false,
            success: function(data) {
            	var arr = [];
            	for(var i=0; i < data.rslist.length; i++){
            		arr.push(data.rslist[i].INSTRCTR_NO);
            	}
            	str = arr.join(",");
            }
        })
        return str;
	}
	
    $.fn.certCdListOnClickEvt = function(){
    	var _this = $(this);
    	_this.on("click", function(){
    		var $this = $(this);
    		var certCd = $this.data("certCd");
    		
    		document.sForm.certCd.value = certCd;
    		$.searchAction();
    	})
    }	
	
	$.initView = function(){
		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
		$("table").procBtnOnClickEvt();
		if($("#certCdList li.active").length == 0) {
			$("#certCdList li:first").addClass("active");
			$("#certCd").val($("#certCdList li.active").find("a").data("certCd"));
			self.opener.sForm.certCd.value = $("#certCdList li.active").find("a").data("certCd");
		}
		else if("${param.certCd}" == "") {
			$("#certCd").val($("#certCdList li.active").find("a").data("certCd"));
			self.opener.sForm.certCd.value = $("#certCdList li.active").find("a").data("certCd");
		}
		$("#certCdList a").certCdListOnClickEvt();
		$.checkUser();
	}
	
	$.initView();
})


</script>

<!-- MAIN CONTENT -->
<div id="content" class="popPage">
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<div class="search">
			<form name="sForm" id="sForm" method="post">
				<input type="hidden" id="eduSeq" name="eduSeq" value='<c:out value="${empty param.eduSeq ? param.reqstSeq : param.eduSeq }"/>' />
				<input type="hidden" id="reqstSeq" name="reqstSeq" value='<c:out value="${empty param.eduSeq ? param.reqstSeq : param.eduSeq }"/>' />
				<input type="hidden" id="tempSeq" name="tempSeq" value='<c:out value="${param.tempSeq}"/>'>
				<input type="hidden" id="boardType" name="boardType" value='<c:out value="${param.tempSeq}"/>'>
				<%-- <input type="hidden" name="sGubun1" value='<c:out value="${param.sGubun1}"/>'> --%>
				<input type="hidden" name="eduDivision" value='<c:out value="${param.eduDivision}"/>'>
				<input type="hidden" id="sGubun2" name="sGubun2" value='<c:out value="${param.instrctrDivision}"/>'>
				<input type="hidden" id="instrctrDivision" name="instrctrDivision" value='<c:out value="${param.instrctrDivision}"/>'>
				<input type="hidden" id="instrctrNo" name="instrctrNo" value='<c:out value="${param.instrctrNo}"/>'>
				<input type="hidden" id="pageType" name="pageType" value='<c:out value="${param.pageType}"/>'>
				<input type="hidden" id="certCd" name="certCd" value='<c:out value="${param.certCd}"/>'>
				<input type="hidden" id="lectureId" name="lectureId" value='<c:out value="${param.lectureId}"/>'>
				<div class="fL wp50">
					<ul class="searchAreaBox">
						<li class="smart-form ml5">
						    <label class="label">아이디</label>
						</li>
						<li class="w150">
							<input type="text" id="searchKeyword3" name="searchKeyword3" value='<c:out value="${param.searchKeyword3}"/>' class="form-control">
						</li>					
						<li class="smart-form ml5">
						    <label class="label">이름</label>
						</li>
						<li class="w150">
							<input type="text" id="searchKeyword4" name="searchKeyword4" value='<c:out value="${param.searchKeyword4}"/>' class="form-control">
						</li>
						<li class="ml10">
							<button class="btn btn-primary searchReset" id="searchBtn" type="button"><i class="fa fa-search"></i> 검색</button>
						</li>
					</ul>	
				</div>
				<!-- <div class="fR wp50">
					<ul class="searchAreaBox fR">
						<li><button class="btn btn-primary ml2" type="button" id="selectBtn"><i class="fa fa-edit" title="저장"></i>저장</button></li>
					</ul>
				</div> -->
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
			</form>
		</div>
		<!-- Search 영역 끝 -->	
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<c:if test="${param.pageType eq 'dtyEdu' }">
						<div class="tab-content">
							<div class="jarviswidget-sortable active" id="certCdList">
								<ul class="nav nav-tabs" style="min-width:100%;">
									<c:forEach var="code" items="${lectureIds }" varStatus="idx">
										<c:if test="${code.VIDEO_AT ne 'Y' }">
											<li class="<c:out value='${(param.certCd eq code.LECTURE_ID) or (empty param.certCd and idx.first) ? "active":""}'/>"><a href="javascript:void(0);" data-cert-cd="<c:out value='${code.LECTURE_ID }'/>"><c:out value="${code.LECTURE_ID }"/></a></li>
										</c:if>
									</c:forEach>
								</ul>
							</div>
						</div>				
					</c:if>
					<div class="article_medical" id="pList" >
						<table class="table table-bordered tb_type01 listtable">
							<colgroup>
								<col width="10%">
								<col width="15%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="15%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
							</colgroup>
							<thead>
								<tr>
									<th class="invisible"></th>
									<th>아이디</th>
									<th>이메일</th>
									<th>이름</th>
									<th>연락처</th>
									<th>회원등급</th>
									<th>세부등급</th>
									<th>강사등급</th>
									<th>배정</th>
									<th>반려</th>
								</tr>
							</thead>
							<tbody>
								<c:if test="${empty list }">
									<tr><td colspan="10">데이터가 없습니다.</td></tr>
								</c:if>
								<c:forEach var="list" items="${list }" varStatus="idx"> 
									<tr>
										<td class="invisible">
											<input type="hidden" name="userNo" value="<c:out value='${list.USER_NO }'/>">
											<input type="hidden" name="userNm" value="<c:out value='${list.USER_NM }'/>">
											<input type="hidden" name="detailGradeCd" value="<c:out value='${list.DETAIL_GRADE_CD }'/>">
										</td>
										<td><c:out value="${list.USER_ID}"/></td>
										<td><c:out value="${list.USER_EMAIL}"/></td>
										<td><c:out value="${list.USER_NM}"/></td>
										<td><c:out value="${list.USER_HP_NO}"/></td>
										<td><c:out value="${list.GRADE_CD_NM}"/></td>
										<td><c:out value="${list.DETAIL_GRADE_CD_NM}"/></td>
										<td><c:out value="${list.INSTRCTR_DETAIL_GRADE_CD_NM}"/></td>
										<td>
											<c:choose>
												<%-- 글 update --%>
												<c:when test="${not empty (empty param.eduSeq ? param.reqstSeq : param.eduSeq) }">
													<c:if test="${list.DCSN_YN eq 'S' }">
														<button class="btn btn-primary ml2 approveBtn" type="button" data-yn="<c:out value='${list.DCSN_YN }'/>" style="background: #ff7804; border-color:#ff7804;">
															<i class="fa fa-edit" title="승인"></i>승인
														</button>													
													</c:if>
													<c:if test="${list.DCSN_YN eq '' or list.DCSN_YN eq 'F' or empty list.DCSN_YN}">
														<button class="btn btn-primary ml2 approveBtn" type="button" data-yn="<c:out value='${list.DCSN_YN }'/>">
															<i class="fa fa-edit" title="배정"></i>배정
														</button>
													</c:if>
													<c:if test="${list.DCSN_YN eq 'Y' }">
														<c:if test="${param.pageType eq 'dtyEdu' and empty param.certCd }">
														</c:if>
														<c:choose>
															<c:when test="${list.INSTRCTR_DIVISION eq param.instrctrDivision and list.CERT_CD eq (empty param.certCd?'':param.certCd)}">
																배정됨
															</c:when>
															<c:otherwise>
																마감
															</c:otherwise>
														</c:choose>
													</c:if>
												</c:when>
												
												<%-- 글 insert --%>
												<c:otherwise>
													<c:choose>
														<c:when test="${list.INSTRCTR_DIVISION eq 'N' }">
															<button class="btn btn-primary ml2 approveBtn" type="button" data-yn="${list.DCSN_YN }">
																<i class="fa fa-edit" title="배정E"></i>배정
															</button>
														</c:when>
														<c:when test="${list.INSTRCTR_DIVISION eq param.instrctrDivision and list.CERT_CD eq (empty param.certCd?'':param.certCd) }">
															배정됨
														</c:when>
														<c:otherwise>
															마감<c:out value="${list.INSTRCTR_DIVISION }"/>"{param.instrctrDivision }"/><br><c:out value="${list.CERT_CD }"/><br><c:out value="${param.certCd }"/>
														</c:otherwise>
													</c:choose>
												</c:otherwise>												
											</c:choose>											
										</td>
										
										<td>
											<c:choose>
												<%-- update --%>
												<c:when test="${not empty (empty param.eduSeq ? param.reqstSeq : param.eduSeq) }">
													<c:if test="${list.INSTRCTR_DIVISION eq 'M' and list.DCSN_YN eq 'F' }">
														반려됨
													</c:if>
													<c:if test="${list.INSTRCTR_DIVISION eq param.instrctrDivision and list.CERT_CD eq (empty param.certCd?'':param.certCd) }">
														<c:if test="${list.DCSN_YN eq 'Y' }">
															<button class="btn btn-danger ml2 rejecteBtn" type="button" data-yn="<c:out value='${list.DCSN_YN }'/>">
																<i class="fa fa-edit" title="반려"></i> 반려
															</button>
														</c:if>
														<c:if test="${list.DCSN_YN eq 'F' }">
															반려됨
														</c:if>
													</c:if>
												</c:when>
												<%-- insert --%>
												<c:otherwise>
													<c:if test="${list.INSTRCTR_DIVISION eq param.instrctrDivision and list.CERT_CD eq (empty param.certCd?'':param.certCd) }">
														<button class="btn btn-danger ml2 rejecteBtn" type="button" data-yn="<c:out value='${list.DCSN_YN }'/>">
															<i class="fa fa-edit" title="반려E"></i> 반려
														</button>													
													</c:if>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" />
					</div>
				</article>
			</div>
			
		</div>
	</section>
	<!-- widget grid end -->

</div>
<!-- END MAIN CONTENT -->