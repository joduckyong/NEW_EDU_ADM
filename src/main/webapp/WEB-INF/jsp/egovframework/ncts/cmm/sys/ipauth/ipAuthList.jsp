<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
$(function(){
	var baseInfo = {
			insertKey : "<c:out value='${common.baseType[0].key() }'/>",
			updateKey : "<c:out value='${common.baseType[1].key() }'/>",
			deleteKey : "<c:out value='${common.baseType[2].key() }'/>",
			lUrl : "/ncts/cmm/sys/ipauth/ipAuthList.do",
			fUrl : "/ncts/cmm/sys/ipauth/ipAuthForm.do",
			dUrl : "/ncts/cmm/sys/ipauth/authipProcess.do"
	}
	
	$.fn.procBtnOnClickEvt = function(url, key){		
		var _this = $(this);
		_this.on("click", function(){
			if(baseInfo.insertKey != key){
				if($("input.index:checked").size() <= 0) {
					alert("항목을 선택하시기 바랍니다.");
					return false;
				}else{
					document.sForm.ipAdress.value = $(".tr_clr_2 input.index:checked").val();
				}
			}else{
				document.sForm.ipAdress.value = "";
			}			
			if(baseInfo.deleteKey == key){
				document.sForm.ipAdress.value = $this.data("ipAdress");
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
	
	$.fn.deleteBtnOnClickEvt = function(){
		var _this = $(this);
		_this.on("click", function(){
			debugger;
			var $this = $(this);
			document.sForm.ipAdress.value = $this.data("ipAdress");
			if(!confirm("삭제하시겠습니까?")) return false;
			$.ajax({
				type: 'POST',
				url: "/ncts/cmm/sys/ipauth/authipDelete.do",
				data: $("#sForm").serialize(),
				dataType: "json",
				success: function(data) {
					if(data.success == "success"){
						location.href = "/ncts/cmm/sys/ipauth/ipAuthList.do";
					}
				}
			});
		})
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

	
	 $("#btnUseY").click(function(){
		 $.ajax({
				type: 'POST',
				url: '/ncts/cmm/sys/ipauth/ipChkYtoN.do',
				data: $("#sForm").serialize(),
				dataType: "json",
				success: function(data) {
					if(data.success == "success"){
						location.href = "/ncts/cmm/sys/ipauth/ipAuthList.do";
					}
				}
			});
		});
	 
	 $("#btnUseN").click(function(){
		 $.ajax({
				type: 'POST',
				url: '/ncts/cmm/sys/ipauth/ipChkNtoY.do',
				data: $("#sForm").serialize(),
				dataType: "json",
				success: function(data) {
					if(data.success == "success"){
						location.href = "/ncts/cmm/sys/ipauth/ipAuthList.do";
					}
				}
			});
		});
	
	$.initView = function(){
		$.onClickTableTr();
		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
		$("#saveBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.insertKey);
		$("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
		$(".delBtn").deleteBtnOnClickEvt();
		
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
          		<input type="hidden" id="ipAdress" name="ipAdress" value="">
				<div class="fL wp50">
					<ul class="searchAreaBox">
						<li class="smart-form ml5">
						    <label class="label">IP주소</label>
						</li>
						<li>
							<label class="select col w180">
								<input type="text" id="searchKeyword1" name="searchKeyword1" value="<c:out value='${param.searchKeyword1}'/>" class="form-control">
							</label>
						</li>
						<li class="smart-form ml5">
						    <label class="label">기관명</label>
						</li>
						<li>
							<label class="select col w120">
								<input type="text" id="searchKeyword2" name="searchKeyword2" value="<c:out value='${param.searchKeyword2}'/>" class="form-control">
							</label>
						</li>
						<li class="ml10">
							<button class="btn btn-primary searchReset" id="searchBtn" type="button"><i class="fa fa-search"></i> 검색</button>
						</li>
					</ul>
				</div>
				<div class="fR">
					<ul class="searchAreaBox">
						<li>
							<c:choose>
					         	<c:when test="${use ne 'Y' }">
					         		<input type="hidden" id="ipUseable" value="N">
					         		<button class="btn btn-danger ml2" type="button" id="btnUseN">
										<i class="fa fa-times-circle-o"></i>IP차단중
									</button>
					         	</c:when>
					         	<c:when test="${use eq 'Y' }">
					         		<input type="hidden" id="ipUseable" value="Y">
					         		<button class="btn btn-secondary ml2" type="button" id="btnUseY" style="border: 1px solid darkgray;">
										<i class="fa fa-times-circle-o"></i> IP허용중
									</button>
					         	</c:when>
					         </c:choose> 
						</li>
					</ul>
				</div>
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
					<jsp:param value="list"     name="formType"/>
					<jsp:param value="1,3,4"     name="buttonYn"/>
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
					<c:choose>
						<c:when test="${use eq 'N' or use ne 'Y' }">
							<p class="notice" style="padding: 20px;">
								현재 상태는 <strong>IP차단중</strong> 상태입니다.<br><strong>IP차단중</strong>상태일 경우 등록된 IP에서만 접근이 가능합니다.
							</p>
						</c:when>
						<c:when test="${use eq 'Y' }">
							<p class="notice" style="padding: 20px;">
								현재 상태는 <strong>IP허용중</strong> 상태입니다.<br><strong>IP허용중</strong>상태일 경우 모든 IP에서 접근이 가능합니다.
							</p>
						</c:when>
					</c:choose> 
					<table class="table table-bordered tb_type01 listtable">
						<colgroup>
							<col width="11.11%">
							<col width="11.11%">
							<col width="11.11%">
                            <col width="11.11%">
                            <col width="11.11%">
							<col width="11.11%">
							<col width="11.11%">
                            <col width="11.11%">
                            <col width="11.11%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>IP주소</th>
								<th>IP사용기관</th>
								<th>IP사용사유</th>
								<th>사용여부</th>
								<th>등록자</th>
								<th>등록일자</th>
								<th>수정자</th>
								<th>수정일자</th>
								<th>삭제</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty rslist }">
								<tr ><td colspan="9">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${rslist }" varStatus="idx">
								<tr>
									<td class="invisible"><input type="checkbox" class="index" value="<c:out value='${list.IP_ADRESS }'/>"></td>
									<td><c:out value="${list.IP_ADRESS }"/></td>
									<td><c:out value="${list.IP_USE_AGENCY }"/></td>
									<td><c:out value="${list.IP_USE_REASON }"/></td>
									<td><c:out value="${list.USE_YN }"/></td>
									<td><c:out value="${list.CRE_USER }"/></td>
									<td><c:out value="${list.CRE_DATE }"/></td>
									<td><c:out value="${list.UPD_USER }"/></td>
									<td><c:out value="${list.UPD_DATE }"/></td>
									<td>
										<button class="delBtn btn btn-danger ml2" type="button" id="delBtn" data-ip-adress="<c:out value='${list.IP_ADRESS }'/>">
											<i class="fa fa-cut" title="삭제"></i> 삭제
										</button>
									</td>
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