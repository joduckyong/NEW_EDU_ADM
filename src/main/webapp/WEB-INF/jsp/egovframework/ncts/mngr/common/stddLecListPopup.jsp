<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
$(function(){
	var baseInfo = {
			insertKey : "${common.baseType[0].key() }",
			updateKey : "${common.baseType[1].key() }",
			deleteKey : "${common.baseType[2].key() }",
			lUrl : "/ncts/mngr/common/stddLecListPopup.do",
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
	
	$.fn.saveBtnOnClickEvt = function(){
		var _this = $(this);
        _this.on("click", function(){
            var obj = new Object();
            var checkedLecture = "";

            $("input[type=checkbox]:checked").each(function(idx){
            	if(idx != 0) {
            		checkedLecture += '|';
                }
            	checkedLecture += $(this).val();
            })
          
            self.opener.$.selectLecture(checkedLecture);
            self.close();
        })
	}
	
	$.lectureIdOnSetting = function(){
		var lectureId = "${param.lectureId}" != "" ? "${param.lectureId}".split("|") : "";
		if(lectureId != "") {
			for(var i in lectureId) {
               	$(".devQua").each(function(idx){
               		var $this = $(this);
	               	if($this.val() == lectureId[i].replace(" ","")) {
	               		$this.prop("checked", true);
	               	}
               	})
			}
		}
	}
	
	$.initView = function(){
		$("#saveBtn").saveBtnOnClickEvt($.searchAction);
		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
		$.lectureIdOnSetting();
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
          		<input type="hidden" name="pageType" id="pageType" value="${param.pageType }">
				<input type="hidden" name="lectureId" id="lectureId" value="${param.lectureId}">
				<div class="fL wp90">
                    <ul class="searchAreaBox">
                    	<li class="smart-form ml5">
                            <label class="label">기준강의코드</label>
                        </li>
                        <li class="w150 ml5">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'>
                        </li>
                        <li class="smart-form ml5"><label class="label">강의명</label></li>
                        <li class="w150 ml5">
                            <input id="searchKeyword2" name="searchKeyword2" class="form-control" value='<c:out value="${param.searchKeyword2}"/>'>
                        </li>
                        <li class="smart-form ml5"><label class="label">교육과정</label></li>
                        <li class="w100" ml5>
                            <select id="sGubun" name="sGubun" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap }" varStatus="idx">
                                	<c:if test="${idx.index ne 0 }">
                                		<c:if test="${param.pageType ne 'PACKAGE'}">
                                			<c:if test="${idx.index lt 5}">
		                                		<c:if test="${empty param.courses }">
			                                   		<option value="${list.CODE }" ${param.sGubun eq list.CODE ? 'selected':'' }>${list.CODE_NM }</option>
		                                		</c:if>
		                                		<c:if test="${!empty param.courses }">
			                                   		<option value="${list.CODE }" ${param.courses eq list.CODE ? 'selected':'' }>${list.CODE_NM }</option>
		                                		</c:if>                                		
                                			</c:if>
                                		</c:if>
                                		<c:if test="${param.pageType eq 'PACKAGE'}">
                                			<c:if test="${idx.index lt 5 or idx.index eq 8}">
		                                		<c:if test="${empty param.courses }">
			                                   		<option value="${list.CODE }" ${param.sGubun eq list.CODE ? 'selected':'' }>${list.CODE_NM }</option>
		                                		</c:if>
		                                		<c:if test="${!empty param.courses }">
			                                   		<option value="${list.CODE }" ${param.courses eq list.CODE ? 'selected':'' }>${list.CODE_NM }</option>
		                                		</c:if>                                		
	                                		</c:if>                                		
                                		</c:if>
                                	</c:if>
                                </c:forEach>
                            </select>
                        </li>
                        
                        <li class="smart-form ml5">
							<label class="checkbox checkboxCenter col ml10 mt5">
								<input type="checkbox" id="sGubun1" name="sGubun1" value="Y" ${param.sGubun1 eq 'Y' ? 'checked="checked"':''}><i></i>
							</label>
							<span class="col ml50 mr5" style="padding-left: 0; margin-top: 8px;">동영상</span>                        
                        </li>                        
                        
                        <li class="ml10">
                            <button class="btn btn-primary allSearchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
                        </li>
                    </ul>
                </div>
				<div class="fR wp10">
					<ul class="searchAreaBox fR">
						<li>
							<button class="btn btn-primary m12" type="button" id="saveBtn"><i class="fa"></i> 확인</button>
						</li>
					</ul>
				</div>
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
			</form>
		</div>
		<!-- Search 영역 끝 -->
	
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<div class="article_medical" id="pList" >
						<table class="table table-bordered tb_type01 listtable">
							<colgroup>
								<col width="5%">
								<col width="10%">
								<col width="30%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
							</colgroup>
							<thead>
								<tr>
									<th class="invisible"></th>
									<th>선택</th>
									<th>기준강의코드</th>
									<th>강의명</th>
									<th>교육과정</th>
									<%-- <th>동영상 활성화</th> --%>
									<th>수강형태</th>
									<th>강의등록일</th>
								</tr>
							</thead>
							<tbody>
								<c:if test="${empty list }">
									<tr ><td colspan="6">데이터가 없습니다.</td></tr>
								</c:if>
								<c:forEach var="list" items="${list }" varStatus="idx">
									<c:if test="${list.COURSES ne '00' and list.COURSES ne ''}">
										<c:if test="${param.pageType ne 'PACKAGE' }">
											<c:if test="${list.VIDEO_AT ne 'Y'}">
												<c:if test="${list.COURSES lt 5}">
													<tr>
														<td class="invisible">
															<input type="checkbox" name="checkLecId" class="index" value="${list.LECTURE_ID }">
															<input type="hidden" name="centerCd" value="${list.LECTURE_REPLC_ID }">
															<input type="hidden" name="grupNm" value="${list.LECTURE_NM }">
															<input type="hidden" name="progrmType" value="${list.COURSES }">
															<input type="hidden" name="progrmSeq" value="${list.FRST_REGIST_PNTTM }">
														</td>
														<td><input type="checkbox" class="devQua" value="${list.LECTURE_ID }"></td>
														<td>${list.LECTURE_ID }</td>
														<td>${list.LECTURE_NM }</td>
														<td>${list.COURSES_NM}</td>
														<td>${list.ATNLC_STLE }</td>
														<td>${list.FRST_REGIST_PNTTM}</td>
													</tr>
												</c:if>
											</c:if>
										</c:if>
										<c:if test="${param.pageType eq 'PACKAGE' }">
											<tr>
												<td class="invisible">
													<input type="checkbox" name="checkLecId" class="index" value="${list.LECTURE_ID }">
													<input type="hidden" name="centerCd" value="${list.LECTURE_REPLC_ID }">
													<input type="hidden" name="grupNm" value="${list.LECTURE_NM }">
													<input type="hidden" name="progrmType" value="${list.COURSES }">
													<input type="hidden" name="progrmSeq" value="${list.FRST_REGIST_PNTTM }">
												</td>
												<td><input type="checkbox" class="devQua" value="${list.LECTURE_ID }"></td>
												<td>${list.LECTURE_ID }</td>
												<td>${list.LECTURE_NM }</td>
												<td>${list.COURSES_NM}</td>
												<td>${list.ATNLC_STLE }</td>
												<td>${list.FRST_REGIST_PNTTM}</td>
											</tr>
										</c:if>
									</c:if>
								</c:forEach>
							</tbody>
						</table>
					<%-- <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" /> --%>
					</div>
				</article>
			</div>
		</div>
	</section>
	<!-- widget grid end -->
</div>
<!-- END MAIN CONTENT -->

<script id="tr-template2" type="text/x-handlebars-template">
<tr ><td colspan="6">데이터가 없습니다.</td></tr>
</script>