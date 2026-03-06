<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">


$(function(){
	var baseInfo = {
			insertKey : "${common.baseType[0].key() }",
			updateKey : "${common.baseType[1].key() }",
			deleteKey : "${common.baseType[2].key() }",
			lUrl : "/ncts/cmm/sys/code/codeList.do",
			fUrl : "/ncts/cmm/sys/code/codeForm.do",
			dUrl : "/ncts/cmm/sys/code/codeProcess.do"
	}
	
	$.dataDetail = function(index){
		if($.isNullStr(index)) return false;
		document.sForm.codeId.value = index;
	}
	
	$.fn.procBtnOnClickEvt = function(url, key){
		var _this = $(this);
		_this.on("click", function(){
			if(baseInfo.insertKey != key){
				if($("input.index:checked").size() <= 0) {
					alert("항목을 선택하시기 바랍니다.");
					return false;
				}else{
					document.sForm.codeId.value = $("input.index:checked").val();
				} 
			}else{
				document.sForm.codeId.value = "";
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
	
	$.fn.codeIdTdOnClickEvt = function(){
		$(this).on("click", function(){
			var codeIdVal = $(this).closest("tr").find(".index").val();
			with(document.sForm){
	            searchKeyword2.value = codeIdVal;
	            action = "/ncts/cmm/sys/code/codeDetailList.do";
				target='';
	            submit();
	        }
		})
	}	
	
	
	$.initView = function(){
		$.onClickTableTr();
		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
		$("#saveBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.insertKey);
		$("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
		$("#delBtn").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey);
		$(".codeIdTd").codeIdTdOnClickEvt();
	}
	
	$.initView();
})
</script>

		
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/ribbon.jsp" flush="false" />

<!-- MAIN CONTENT -->
<div id="content">

	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/menuTitle.jsp" flush="false" />
	
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
				<input type="hidden" name="codeId" id="codeId"  value="">
				<input type="hidden" name="searchKeyword2" id="searchKeyword2"  value="">
				<div class="fL wp50">
					<ul class="searchAreaBox">
						<li class="smart-form">
						    <label class="label">코드</label>
						</li>
						<li class="w150">
							<input type="text" id="searchKeyword3" name="searchKeyword3" value="${param.searchKeyword3}" class="form-control">
						</li>
						<li class="smart-form">
						    <label class="label">코드명</label>
						</li>
						<li class="w150">
							<input type="text" id="searchKeyword1" name="searchKeyword1" value="${param.searchKeyword1}" class="form-control">
						</li>
						<li class="ml10">
							<button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
						</li>
					</ul>
				</div>
				
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
					<jsp:param value="list"     name="formType"/>
					<jsp:param value="1,2,3,4"     name="buttonYn"/>
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
							<col width="33%">
							<col width="33%">
                            <col width="*">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>코드ID</th>
								<th>코드명</th>
								<th>사용유무</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty rslist }">
								<tr ><td colspan="3">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${rslist }" varStatus="idx">
								<tr>
									<td class="invisible"><input type="checkbox" class="index" value="${list.CODE_ID }"></td>
									<td class="codeIdTd">${list.CODE_ID }</td>
									<td>${list.CODE_ID_NM }</td>
									<td>${list.USE_YN }</td>
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