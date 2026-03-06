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
			excel : "/ncts/stat/common/statExcelDownload.do"
	}
	
	$.searchAction = function(){
		$.loadingBarStart();
		var no = 1;
        if(typeof(arguments[0]) != "undefined") no = arguments[0].pageNo;
        with(document.sForm){
            currentPageNo.value = no;
            action = baseInfo.lUrl;
			target='';
            submit();
        }
	}
	
	$.fn.saveBtnOnClickEvt = function(){ 
		var _this = $(this);
		_this.on("click", function(){
			if(!$("#iForm").valid()) {
				validator.focusInvalid();
				return false;
			}
			$.saveProc();	
		})
	}
	
	$.saveProc = function(){
		if(!confirm("저장하시겠습니까?")) return;
		
		$("#iForm").ajaxForm({
			type: 'POST',
			url: "/ncts/cmm/sys/excelDown/updateExcelDown.do",
			dataType: "json",
			success: function(result) {
				alert(result.msg);
				if(result.success == "success") location.replace(baseInfo.lUrl);	
			}
        });
        $("#iForm").submit();	
	}
	
	$.initView = function(){
		$("#saveBtn").saveBtnOnClickEvt();
		$("#listBtn").goBackList($.searchAction);
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
          		<input type="hidden" id="excelSeq" name="excelSeq" value="${result.EXCEL_SEQ}"/>
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
					<jsp:param value="form"     name="formType"/>
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
					<form name="iForm" id="iForm" method="post" class="smart-form" enctype="multipart/form-data">
					<input type="hidden" id="excelSeq" name="excelSeq" value="${result.EXCEL_SEQ}"/>
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
					<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="33.3%">
								<col width="33.3%">
								<col width="33.3%">
							</colgroup>
							<tbody>
								<tr>
									<th>메뉴명</th>
									<td colspan="2">${result.MENU_NM}</td>
								</tr>
								<tr>
									<th>다운로드 사유</th>
									<td colspan="2">
										<textarea id="excelCn1" name="excelCn1" rows="5" cols="33">${result.EXCEL_CN1 }</textarea>
									</td>
								</tr>
								<tr>
									<th>다운로드 날짜</th>
									<td colspan="2">${result.REGIST_DATE }</td>
								</tr>
							</tbody>
						</table>
					</form>	
				</article>
			</div>
			<!-- row 메뉴조회 끝 -->
		</div>
	</section>
	<!-- widget grid end -->

</div>
<!-- END MAIN CONTENT -->