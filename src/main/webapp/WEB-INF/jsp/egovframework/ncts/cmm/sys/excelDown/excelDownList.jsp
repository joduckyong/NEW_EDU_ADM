<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

$(function(){
	var excelPg = 0;
	var baseInfo = {
			insertKey : "${common.baseType[0].key() }",
			updateKey : "${common.baseType[1].key() }",
			deleteKey : "${common.baseType[2].key() }",
			lUrl : "/ncts/cmm/sys/excelDown/excelDownList.do",
			fUrl : "/ncts/cmm/sys/excelDown/excelDownForm.do",
			dUrl : "/ncts/cmm/sys/excelDown/deleteExcelDown.do",
			excel : "/ncts/cmm/sys/excelDown/excelDownload.do"
	}
	
	$.fn.procBtnOnClickEvt = function(url, key){	
		var _this = $(this);
		_this.on("click", function(){
			if(baseInfo.insertKey != key){
				if($("input.index:checked").size() <= 0) {
					alert("항목을 선택하시기 바랍니다.");
					return false;
				}else{
					document.sForm.excelSeq.value = $(".tr_clr_2 input.index:checked").val();
				}
			}else{
				document.sForm.excelSeq.value = "";
			}
			if(baseInfo.deleteKey == key){
				$.delAction(url, key);
			}else{
				$.procAction(url, key);	
			}
		})
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
            target = '';
            action = baseInfo.lUrl;
            submit();
        }
	}
  
	$.procAction = function(pUrl, pKey){
        with(document.sForm){
            procType.value = pKey;
            action = pUrl;
            submit();
        }
    }
	
	$.initView = function(){
		$.onClickTableTr();
		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
		$("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
        $("#delBtn").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey);
		$(".excelDown").on("click", function(){
			$("[name='excelFileNm']").val("다운로드 사유목록 "+$.toDay());
			$("[name='excelPageNm']").val("excelDownLoad.xlsx");
			with(document.sForm){
				target = "";
				action = baseInfo.excel;
				submit();
			}
		});
		$("#sGubun").change(function(){
        	if($(this).val()== 1){
        		$(".selectDate").css("display","none");
        		$(".selectMonth").css("display","none");
        		$(".selectYear").css("display","block");
        	}else if($(this).val()== 2){
        		$(".selectYear").css("display","block");
        		$(".selectMonth").css("display","block");
        		$(".selectDate").css("display","none");
        	}
        });
		if($("#sGubun").val()== 1){
			$(".selectDate").css("display","none");
    		$(".selectMonth").css("display","none");
    		$(".selectYear").css("display","block");
		}else if($("#sGubun").val()== 2){
			$(".selectYear").css("display","block");
    		$(".selectMonth").css("display","block");
    		$(".selectDate").css("display","none");
		}
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
          		<input type="hidden" name="excelFileNm">
				<input type="hidden" name="excelPageNm">
				<input type="hidden" id="excelSeq" name="excelSeq" value="">
				<div class="fL wp70">
					<ul class="searchAreaBox">
						<li class="smart-form">
						    <label class="label">구분</label>
						</li>
						<li class="w90">
							<select id="sGubun" name="sGubun" class="form-control">
								<option value="">선택</option>
								<option value="01" ${param.sGubun eq '01' ?'selected="selected"':'' }>연도별</option>
								<option value="02" ${param.sGubun eq '02' ?'selected="selected"':'' }>월별</option>
							</select> <i></i>
						</li>
						<div class="selectYear" style="display:none">
	                        <li class="ml5 mr5">
	                            <select id="sYear" name="sYear" class="form-control">
	                                <option value="">연도선택</option>
	                                <c:forEach var="year" items="${cal.year }">
										<option value="${year }" ${param.sYear eq year?'selected="selected"':'' } >${year }</option>
									</c:forEach>
	                            </select> <i></i>
	                        </li>
                        </div>
                        <div class="selectMonth" style="display:none">
	                        <li class="ml5" id="sMon">
								<select id="sMonth" name="sMonth" class="form-control">
									<option value="">선택</option>
									<c:forEach var="month" items="${cal.month }">
										<option value="${month }" ${param.sMonth eq month?'selected="selected"':'' } >${month }월</option>
									</c:forEach>
								</select> <i></i>
	                        </li>
                        </div>
                        
						<li class="ml10">
							<button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
						</li>
					</ul>
				</div>
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
					<jsp:param value="list"     name="formType"/>
					<jsp:param value="1,2,3"     name="buttonYn"/>
				</jsp:include>
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
			</form>
		</div>
		<!-- Search 영역 끝 -->
	
		<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />
		
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<table class="table table-bordered tb_type01 listtable">
						<colgroup>
							<col width="25%">
							<col width="auto">
							<col width="15%">
							<col width="15%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>메뉴명</th>
								<th>다운로드사유</th>
								<th>성명</th>
								<th>다운로드 날짜</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty rslist }">
								<tr><td colspan="10">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${rslist }" varStatus="idx">
								<tr>
									<td class="invisible"><input type="checkbox" class="index" value="${list.EXCEL_SEQ }"></td>
									<td>${list.MENU_NM }</td>
									<td>${list.EXCEL_CN1 }</td>
									<td>${list.FRST_USER_NM }</td>
									<td>${list.REGIST_DATE }</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" />
				</article>
			</div>
			<!-- row 메뉴조회 끝 -->
		</div>
	</section>
	<!-- widget grid end -->

</div>
<!-- END MAIN CONTENT -->