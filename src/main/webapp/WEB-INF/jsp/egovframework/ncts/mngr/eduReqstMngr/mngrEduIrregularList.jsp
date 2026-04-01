<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

$(function(){
	var trCnt = 0;
	var baseInfo = {
			insertKey : '<c:out value="${common.baseType[0].key() }"/>',
			updateKey : '<c:out value="${common.baseType[1].key() }"/>',
			deleteKey : '<c:out value="${common.baseType[2].key() }"/>',
			excel     : "/ncts/mngr/eduReqstMngr/nfdrmPlanExcelDownload.do",
			lUrl : "/ncts/mngr/eduReqstMngr/mngrEduIrregularList.do",
	}
	
	$.dataDetail = function(index, obj){
		if($.isNullStr(index)) return false;
		document.sForm.eduYear.value = index;
		if(obj){
			document.sForm.eduYearOld.value = obj.oldEduYear;
			document.sForm.centerCd.value = obj.centerCdVal;
		}
		$.ajax({
			type: 'POST',
			url: "/ncts/mngr/eduReqstMngr/selectNfdrmPlanDetail.do",
			data: $("#sForm").serialize(),
			dataType: "json",
			success: function(data) {
				if(data.success == "success"){
					if(data.rs){
						document.iForm.eduYear.value = data.rs.EDU_YEAR;
						document.iForm.jan.value = data.rs.JAN;
						document.iForm.feb.value = data.rs.FEB;
						document.iForm.mar.value = data.rs.MAR;
						document.iForm.apr.value = data.rs.APR;
						document.iForm.may.value = data.rs.MAY;
						document.iForm.jun.value = data.rs.JUN;
						document.iForm.jul.value = data.rs.JUL;
						document.iForm.aug.value = data.rs.AUG;
						document.iForm.sept.value = data.rs.SEPT;
						document.iForm.oct.value = data.rs.OCT;
						document.iForm.nov.value = data.rs.NOV;
						document.iForm.dec.value = data.rs.DEC;
						document.iForm.centerCd.value = data.rs.CENTER_CD;
						$("select[name='centerCd']").prop("disabled", true);
					} else {
						document.iForm.eduYear.value = "";
						document.iForm.jan.value = "";
						document.iForm.feb.value = "";
						document.iForm.mar.value = "";
						document.iForm.apr.value = "";
						document.iForm.may.value = "";
						document.iForm.jun.value = "";
						document.iForm.jul.value = "";
						document.iForm.aug.value = "";
						document.iForm.sept.value = "";
						document.iForm.oct.value = "";
						document.iForm.nov.value = "";
						document.iForm.dec.value = "";
						$("select[name='centerCd']").prop("disabled", false);
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
					document.sForm.eduSeq.value = $("input.index:checked").val();
				} 
			}else{
				document.sForm.eduSeq.value = "";
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
	
	$.searchAction = function(){
		var no = 1;
        if(typeof(arguments[0]) != "undefined") no = arguments[0].pageNo;
		var eduYearVal = document.sForm.eduYear.value ? document.sForm.eduYear.value : 0;
		var eduYearOldVal = document.sForm.eduYearOld.value ? document.sForm.eduYearOld.value : 0;
        with(document.sForm){
			eduYear.value = eduYearVal;
			eduYearOld.value = eduYearOldVal;
            currentPageNo.value = no;
            action = baseInfo.lUrl;
            target='';
            submit();
        }
	}
	
	$.fn.onClickEvt = function(){
		var _this = $(this);
		
		_this.on("click", function(){
			if(trCnt == 0){
				trCnt++;
				var _form = "<tr id='planRow' class='tr_clr_2' style='height: 35px;' id=''><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>"
				$("tr").removeClass("tr_clr_2");
				$("#tBody").append(_form);  //id 변경 
				$.dataDetail(0);	
			} else {
				alert("한 번에 하나의 계획만 추가하실 수 있습니다.");
			}
		})
	}
	
	$.fn.onClickSaveEvt = function(){
		var _this = $(this);
		
		_this.on("click", function(){
			var key;
			
			if($(".tr_clr_2").children(".invisible").children(".index").val()){
				key = baseInfo.updateKey;
				document.sForm.eduYearOld.value = $(".tr_clr_2").children(".invisible").children("#eduYearOld").val();
			} else {
				key = baseInfo.insertKey;
				document.sForm.eduYearOld.value = 0;
			}
			if(!confirm("저장하시겠습니까?")) return false;
			if(!document.iForm.eduYear.value){
                alert("연도는 필수 입력 값입니다. 연도를 입력해 주세요.");
                $("#ifeduYear").focus();
                return false;
            }
			if(!document.iForm.centerCd.value){
                alert("센터는 필수 입력 값입니다. 센터를 입력해 주세요.");
                $("#centerCd").focus();
                return false;
            }
			
			document.sForm.procType.value = key;
			document.sForm.eduYear.value = document.iForm.eduYear.value ? document.iForm.eduYear.value : 0;
			document.sForm.jan.value = document.iForm.jan.value ? document.iForm.jan.value : 0;
			document.sForm.feb.value = document.iForm.feb.value ? document.iForm.feb.value : 0;
			document.sForm.mar.value = document.iForm.mar.value ? document.iForm.mar.value : 0;
			document.sForm.apr.value = document.iForm.apr.value ? document.iForm.apr.value : 0;
			document.sForm.may.value = document.iForm.may.value ? document.iForm.may.value : 0;
			document.sForm.jun.value = document.iForm.jun.value ? document.iForm.jun.value : 0;
			document.sForm.jul.value = document.iForm.jul.value ? document.iForm.jul.value : 0;
			document.sForm.aug.value = document.iForm.aug.value ? document.iForm.aug.value : 0;
			document.sForm.sept.value =document.iForm.sept.value ? document.iForm.sept.value : 0;
			document.sForm.oct.value = document.iForm.oct.value ? document.iForm.oct.value : 0;
			document.sForm.nov.value = document.iForm.nov.value ? document.iForm.nov.value : 0;
			document.sForm.dec.value = document.iForm.dec.value ? document.iForm.dec.value : 0;
			document.sForm.centerCd.value = document.iForm.centerCd.value ? document.iForm.centerCd.value : '';
            
            $.ajax({
                type: 'POST',
                url: "/ncts/mngr/eduReqstMngr/updateNfdrmPlan.do",
                data: $("#sForm").serialize(),
                dataType: "json",
                success: function(data) {
                    alert(data.msg);
                    if(data.success == "success"){
                        $.searchAction();
                    }
                }
            });
		})
	}
	
	$.initView = function(){
		$.onClickTableTr();
		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
		$("#btnSave").onClickSaveEvt();
		$("#addBtn").onClickEvt();
		$(document).on("click", "#planRow", function(){
            $("tr").removeClass("tr_clr_2");
            $("#planRow").addClass("tr_clr_2");
            $.dataDetail(0);
        });
		$(".excelDown").on("click", function(){
			$("[name='excelFileNm']").val("비정기교육계획관리_"+$.toDay());
			$("[name='excelPageNm']").val("nfdrmPlanYearList.xlsx");
            with(document.sForm){
                target = "";
                action = baseInfo.excel;
                submit();
            }
        });
		$(".onlyNum").onlyNumber(2);
		$("input[name=eduYear]").onlyNumber(4);
		if('<c:out value="${pageInfo.INSERT_AT}"/>' != "Y") $("#btnSave").hide();
	}
	
	$.initView();
})
</script>

		
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/ribbon.jsp" flush="false" />

<c:set var="yearStart" value="2021" />
<c:set var="today" value="<%=new java.util.Date()%>" />
<c:set var="currentYear"><fmt:formatDate value='${today}' pattern="yyyy"/></c:set>
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
				<input type="hidden" name="eduYear" id="eduYear"  value="">
				<input type="hidden" name="eduYearOld" value="">
				<input name="jan" type="hidden" value="0" style="width:100px; text-align:center;">
				<input name="feb" type="hidden" value="0">
				<input name="mar" type="hidden" value="0">
				<input name="apr" type="hidden" value="0">
				<input name="may" type="hidden" value="0">
				<input name="jun" type="hidden" value="0">
				<input name="jul" type="hidden" value="0">
				<input name="aug" type="hidden" value="0">
				<input name="sept" type="hidden" value="0">
				<input name="oct" type="hidden" value="0">
				<input name="nov" type="hidden" value="0">
				<input name="dec" type="hidden" value="0">
				<input name="centerCd" type="hidden" value="">
				<div class="fL wp50">
					<ul class="searchAreaBox">
						<li class="smart-form">
						    <label class="label">센터명</label>
						</li>
						<sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')">
							<li class="w150 mr5">
								<select name="sGubun2" class="form-control">
									<option value="">전체</option>
									<c:forEach var="center" items="${centerList }" varStatus="idx">
										<option value='<c:out value="${center.DEPT_CD }"/>' data-groupId='<c:out value="${center.GROUP_ID }"/>' <c:out value="${center.DEPT_CD eq param.sGubun2 ? 'selected=selected':'' }"/>><c:out value="${center.DEPT_NM }"/></option>
									</c:forEach>
								</select> <i></i>
							</li>
						</sec:authorize>
						<sec:authorize access="hasRole('ROLE_ADMIN') or hasRole('ROLE_USER')">
							<li class="smart-form mr5">
								<input type="hidden" name="sGubun2" value="<sec:authentication property="principal.centerId"/>" >
								<label class="label"><sec:authentication property="principal.centerNm"/></label>
							</li>
						</sec:authorize>					
					
						<li class="smart-form">
						    <label class="label">연도</label>
						</li>
						<li class="w150 ml5">
                            <select id="sGubun" name="sGubun" class="form-control" style="text-align-last:center;">
                                <option value="">선택</option>
									<c:forEach begin="${yearStart }" end="${currentYear+10 }" var="result" step="1">
										<option value='<c:out value="${result}"/>' <c:out value="${result == param.sGubun ? 'selected': ''}"/>><c:out value="${result}" /></option>
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
					<jsp:param value="1,5"     name="buttonYn"/>
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
							<col width="18%">
							<col width="10%">
							
							<col width="6%">
							<col width="6%">
							<col width="6%">
							<col width="6%">
							<col width="6%">
							<col width="6%">
							<col width="6%">
							<col width="6%">
							<col width="6%">
							<col width="6%">
							<col width="6%">
							<col width="6%">
						</colgroup>
						<thead>
							<tr>
								<th rowspan="2">센터명</th>
								<th rowspan="2">연도</th>
								<th colspan="12">월별</th>
							</tr>
							<tr>
                                <th>1월</th>
                                <th>2월</th>
                                <th>3월</th>
                                <th>4월</th>
                                <th>5월</th>
                                <th>6월</th>
                                <th>7월</th>
                                <th>8월</th>
                                <th>9월</th>
                                <th>10월</th>
                                <th>11월</th>
                                <th>12월</th>
                            </tr>
						</thead>
						<tbody id="tBody">
						    <c:if test="${empty list }">
								<tr><td colspan="14">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="rlist" items="${list}" varStatus="idx">
								<tr>
									<td class="invisible">
										<input type="checkbox" class="index" value='<c:out value="${rlist.EDU_YEAR }"/>'>
										<input type="hidden" id="eduYearOld" name="oldEduYear" class="" value='<c:out value="${rlist.EDU_YEAR }"/>'>
										<input type="hidden" id="centerCdVal" name="centerCdVal" value='<c:out value="${rlist.CENTER_CD }"/>'>
									</td> <!-- 년도 -->
									<td><c:out value="${rlist.CENTER_NM}"/></td> <!-- 년도 -->
									<td><c:out value="${rlist.EDU_YEAR}"/></td> <!-- 년도 -->
									<td><c:out value="${rlist.JAN}"/></td> <!-- 1 -->
									<td><c:out value="${rlist.FEB}"/></td> <!-- 3 -->
									<td><c:out value="${rlist.MAR}"/></td> <!-- 3 -->
									<td><c:out value="${rlist.APR}"/></td> <!-- 4 -->
									<td><c:out value="${rlist.MAY}"/></td> <!-- 5 -->
									<td><c:out value="${rlist.JUN}"/></td> <!-- 6 -->
									<td><c:out value="${rlist.JUL}"/></td> <!-- 7 -->
									<td><c:out value="${rlist.AUG}"/></td> <!-- 8 -->
									<td><c:out value="${rlist.SEPT}"/></td> <!-- 9 -->
									<td><c:out value="${rlist.OCT}"/></td> <!-- 10 -->
									<td><c:out value="${rlist.NOV}"/></td> <!-- 11 -->
									<td><c:out value="${rlist.DEC}"/></td> <!-- 12 -->
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
							<col width="14%">
							<col width="14%">
							<col width="14%">
							<col width="14%">
							<col width="14%">
							<col width="14%">
						</colgroup>
						<tbody id="detailTable">
						  <form name="iForm" id="iForm" method="post" class="smart-form">
							<!-- <tr><td colspan="6" class="textAlignCenter">항목을 선택해주세요.</td></tr> -->
								<tr>
								    <th>센터</th>
	                            	<td colspan="2">
										<sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')">
											<select id="centerCd" name="centerCd" class="form-control" style="text-align-last:center; height:29px;">
												<option value="">선택</option>
												<c:forEach var="center" items="${centerList }" varStatus="idx">
													<option value='<c:out value="${center.DEPT_CD }"/>' data-groupId='<c:out value="${center.GROUP_ID }"/>' <c:out value="${center.DEPT_CD eq rs.CENTER_CD ? 'selected=selected':'' }"/>><c:out value="${center.DEPT_NM }"/></option>
												</c:forEach>
											</select> <i></i>
										</sec:authorize>
										<sec:authorize access="hasRole('ROLE_ADMIN') or hasRole('ROLE_USER')">
											<input type="hidden" name="centerCd" value="<sec:authentication property="principal.centerId"/>" >
											<sec:authentication property="principal.centerNm"/>
										</sec:authorize>	                           		
	                            	</td>	
	                            								    
								    <th>연도</th>
								    <td colspan="2">
			                            <select id="ifeduYear" name="eduYear" class="form-control" style="text-align-last:center; height:29px;">
			                                <option value="">선택</option>
												<c:forEach begin="${yearStart }" end="${currentYear+10 }" var="result" step="1">
													<option value='<c:out value="${result}"/>'><c:out value="${result}" /></option>
												</c:forEach> 			                                	
			                            </select>								    
								    </td> <!-- 년도 -->
								    
								    <td>
								    	<c:if test="${pageInfo.INSERT_AT eq 'Y' }">
								    		<div class="fR wp5"><button class="btn btn-primary" type="button" id="addBtn"><i class="fa fa-edit" title="추가"></i> 추가</button></ul></div>
								    	</c:if>
								    </td>
								</tr>
								<tr><th rowspan="4">월</th>
	                                <th>1월</th>
	                                <th>2월</th>
	                                <th>3월</th>
	                                <th>4월</th>
	                                <th>5월</th>
	                                <th>6월</th>
	                            </tr>
	                            <tr>
	                                <td><input class="onlyNum" name="jan" type="text" value="" style="width:100px; text-align:center;" maxlength="2"></td>
	                                <td><input class="onlyNum" name="feb" type="text" value="" style="width:100px; text-align:center;" maxlength="2"></td>
	                                <td><input class="onlyNum" name="mar" type="text" value="" style="width:100px; text-align:center;" maxlength="2"></td>
	                                <td><input class="onlyNum" name="apr" type="text" value="" style="width:100px; text-align:center;" maxlength="2"></td>
	                                <td><input class="onlyNum" name="may" type="text" value="" style="width:100px; text-align:center;" maxlength="2"></td>
	                                <td><input class="onlyNum" name="jun" type="text" value="" style="width:100px; text-align:center;" maxlength="2"></td>
	                            </tr>
	                            <tr><th>7월</th>
	                                <th>8월</th>
	                                <th>9월</th>
	                                <th>10월</th>
	                                <th>11월</th>
	                                <th>12월</th>
	                            </tr>
	                            <tr>
	                                <td><input class="onlyNum" name="jul" type="text" value="" style="width:100px; text-align:center;" maxlength="2"></td>
	                                <td><input class="onlyNum" name="aug" type="text" value="" style="width:100px; text-align:center;" maxlength="2"></td>
	                                <td><input class="onlyNum" name="sept" type="text" value="" style="width:100px; text-align:center;" maxlength="2"></td>
	                                <td><input class="onlyNum" name="oct" type="text" value="" style="width:100px; text-align:center;" maxlength="2"></td>
	                                <td><input class="onlyNum" name="nov" type="text" value="" style="width:100px; text-align:center;" maxlength="2"></td>
	                                <td><input class="onlyNum" name="dec" type="text" value="" style="width:100px; text-align:center;" maxlength="2"></td>
	                            </tr>
	                            <%-- <tr>
	                            	<th>센터</th>
	                            	<td colspan="6">
										<sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')">
											<label class="select col w150 mr5">
												<select id="centerCd" name="centerCd">
													<option value="">선택</option>
													<c:forEach var="center" items="${centerList }" varStatus="idx">
														<option value="${center.DEPT_CD }" data-groupId="${center.GROUP_ID }" ${center.DEPT_CD eq rs.CENTER_CD ? 'selected="selected"':'' } >${center.DEPT_NM }</option>
													</c:forEach>
												</select> <i></i>
											</label>
										</sec:authorize>
										<sec:authorize access="hasRole('ROLE_ADMIN') or hasRole('ROLE_USER')">
											<input type="hidden" name="centerCd" value="<sec:authentication property="principal.centerId"/>" >
											<sec:authentication property="principal.centerNm"/>
										</sec:authorize>	                           		
	                            	</td>
	                            </tr>	 --%>
                            </form>
						</tbody>
					</table>
					<!-- <table class="table table-bordered table-hover tb_type01">
						<colgroup>
							<col width="10%">
							<col width="12%">
							<col width="15%">
							<col width="15%">
							<col width="10%">
							<col width="10%">
							<col width="*">
						</colgroup>
						<tbody id="applicantTable">							
							
						</tbody>
					</table> -->
				</article>
			</div>
			<!-- row 메뉴조회 끝 -->
		</div>
	</section>
	<!-- widget grid end -->

</div>
<!-- END MAIN CONTENT -->
