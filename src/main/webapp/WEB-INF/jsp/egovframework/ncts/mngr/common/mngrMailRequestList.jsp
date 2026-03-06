<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

$(function(){
	var loadingSt = 0;
	var baseInfo = {
		insertKey : "${common.baseType[0].key() }",
		updateKey : "${common.baseType[1].key() }",
		deleteKey : "${common.baseType[2].key() }",
		lUrl : "/ncts/mngr/mail/mngrMailRequestList.do",
		fUrl : "/ncts/mngr/mail/mngrMemberMailForm.do",
		dUrl : "/ncts/mngr/mail/updateMailRequest.do",
	}
	
	$.dataDetail = function(index){
		if(document.sForm.requestId.value != index) $("#currentPageNo").val("1");
		if($.isNullStr(index)) return false;
		document.sForm.requestId.value = index;
		document.vForm.requestId.value = index;
		$.ajax({
			type : "POST",
			url: "/ncts/mngr/mail/mngrMailRequestDetail.do",
			data : $("#sForm").serialize(),
			dataType : "json",
			success: function(data) {
				if(data.success == "success"){
					$("#detailTable").handlerbarsCompile($("#detail-template"), data.rs);
					
					var $searchBox = $(".respondSearch .searchAreaBox");
					$searchBox.find("input[type='text']").val("");
					$searchBox.find("select").val("");
					$searchBox.find("li").not(".respondSearchLi").remove();
					$("li#respondSearchLi").handlerbarsBeforeCompile($("#respond-template"), data.rs);
					$(".respondSearch, .respondProcBtn").removeClass("invisible");
				}
			},
		})
		
		var pageNo = $("#currentPageNo").val();
		if(pageNo == undefined) pageNo = "1";
		
		$.ajax({
			type : "GET",
			url: "/ncts/mngr/mail/selectMngrMailStatusList.do",
			data: {
				"requestId" : $("#requestId").val(),
				"currentPageNo" : pageNo,
				"${_csrf.parameterName}" : "${_csrf.token}"
			},
			dataType : "html",
			contentType: "text/html;charset=UTF-8",
			success: function(result) {
				var substring = result.substring(result.indexOf('<form'), result.indexOf('</body>'));
				$("#targetList").html(substring);
			},
		})
	}
	
	$.dataDetail2 = function(index){
		var indexElement = $(".tr_clr_2 input[value="+index+"]");
		if($.isNullStr(index)) return false;
		document.vForm.requestId.value = index;
		
		var pageNo = $("#currentPageNo").val();
		if(pageNo == undefined) pageNo = "1";
		
		document.vForm.currentPageNo.value = pageNo;
		
		$.ajax({
			type : "GET",
			url: "/ncts/mngr/mail/selectMngrMailStatusList.do",
			data: $("#vForm").serialize(),
			dataType : "html",
			contentType: "text/html;charset=UTF-8",
			success: function(result) {
				var substring = result.substring(result.indexOf('<form'), result.indexOf('</body>'));
				$("#targetList").html(substring);
			},
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
					document.sForm.requestId.value = $("input.index:checked").val();
				} 
			}else{
				document.sForm.requestId.value = "";
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
			target = '';
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
	
	$.fn.targetPagingBtnOnClickEvt = function(){
		$(this).on("click", "#targetList .pagination a", function(){
			var $this = $(this);
			$.dataDetail($("input.index:checked").val());
		})
	}
	
	$.fn.closeBtnOnClickEvt = function(){
		$(this).on("click", "#closeBtn", function(){
			var $this = $(this);
			var reloadYn = $("#layer2").data("reloadYn");

			if($this.parents("#layer1").length == "1") {
				$("#layer1").html("");
				$("#layer1").hide();
			} else {
				if(reloadYn == "Y") $.searchAction();
				else $("#layer2").hide();
			}
		})
	}
	
	$.extend({
		linkPage2 : function(no){
			$("#currentPageNo").val(no);
		}
	})
	
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
	
    $.addSearchResetBtnControl = function() {
    	var $search = $(".searchResetBtn");
    	if($search.size() == 0) return false;
    	
    	var $li = $('<li class="ml-1 ml5" />');
    	var $button = $('<button class="btn btn-default resetBtn" type="button"><i class="fa fa-trash-o" title="초기화"></i></button>');
    	
    	$li.append($button);
    	
    	$search.parent().after($li);
    	
    	$(".resetBtn").on("click", function(){
    		var $this = $(this);
    		var $box = $this.closest(".searchAreaBox");
    		
    		var inputs = $box.find("input");
    		inputs.each(function(index, item){ item.value = ""; });
    		
    		var combos = $box.find("select");
    		combos.each(function(index, item){ $(item).find("option:first").prop("selected",true) });
    		
    	})
    }
    	
	
	$.fn.updateStatusBtnOnClickEvt = function(){
		$(this).on("click", function(){
			$.pageLoadingBarStart();
			$.ajax({
				type : "POST",
				url: "/ncts/mngr/mail/updateMailStatusList.do",
				data : $("#sForm").serialize(),
				dataType : "json",
				success: function(data) {
					if(data.success == "success"){
						$.pageLoadingBarClose();
						alert("업데이트 되었습니다.");
					}
				},
			})
		})
	}
	
	$.fn.targetPagingBtnOnClickEvt = function(){
		$(this).on("click", "#targetList .pagination a, .respondSearchBtn", function(){
			var $this = $(this);
			$.dataDetail2($("input.index:checked").val());
		})
	}
	
	
	$.initView = function(){
		$.onClickTableTr();
		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
		$("#saveBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.insertKey);
		$("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
		$("#delBtn").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey);
		$("body").closeBtnOnClickEvt();
		$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
		$("body").targetPagingBtnOnClickEvt();
		
        $("body").on("keydown", function(e){
	        $.pageLoadingBarKeyDown(e, loadingSt);
        })
        $.addSearchResetBtnControl();
    	$("body").targetPagingBtnOnClickEvt();
        $("#updateStatusBtn").updateStatusBtnOnClickEvt();
	}
	
	$.initView();
})
</script>

		
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/ribbon.jsp" flush="false" />

<!-- MAIN CONTENT -->
<div id="content">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/menuTitle.jsp" flush="false" />
	<form name="pForm" id="pForm" method="post">
		<div id="layer1" class="popup-con" style="display:none;">
		</div>
		<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
	</form>
	
	<div id="layer2" class="popup-con" style="display:none;">
	</div>
	
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
          		<input type="hidden" name="pageType" value="MEMBER">
				<input type="hidden" name="requestId" id="requestId" value="">
				<div class="fL wp75">
					<ul class="searchAreaBox">
                        <li class="smart-form ml5"><label class="label">글 제목</label></li>
                        <li class="w150 ml5">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'> 
                        </li>
                        <li class="ml10">
                            <button class="btn btn-primary searchResetBtn" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
                        </li>					
					</ul>
				</div>
				
				<div class="fR wp25">
					<ul class="searchAreaBox fR">
						<%-- <c:if test="${paginationInfo.userId eq 'master' or paginationInfo.userId eq 'bkahn7' or paginationInfo.userId eq 'jjuk79' or paginationInfo.userId eq 'kangmin24'}">
							<li><button type="button" class="btn btn-default ml2 mb5 excelDown" id="registExcelDown" data-title="발송 등록 대상자 리스트"><i class="fa fa-print" title="엑셀다운로드"></i> 엑셀다운로드</button></li>
						</c:if> --%>
						<li><button class="btn btn-primary ml2" type="button" id="updateStatusBtn"><i class="fa fa-refresh" title="업데이트"></i> 메일 상태 업데이트</button></li>
						<li><button class="btn btn-primary ml2" type="button" id="saveBtn"><i class="fa fa-edit" title="등록"></i> 등록</button></li>
						<li><button class="btn btn-primary ml2" type="button" id="updBtn"><i class="fa fa-edit" title="수정"></i> 수정</button></li>
						<li><button class="btn btn-danger ml2" type="button" id="delBtn"><i class="fa fa-cut" title="삭제"></i> 삭제</button></li>
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
							<col width="10%">
							<col width="auto%">
							<col width="20%">
							<col width="10%">
							<col width="10%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>no</th>
								<th>글 제목</th>
								<th>메일 제목</th>
								<th>발송인원</th>
								<th>등록자</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty requestList }">
								<tr><td colspan="5">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${requestList }" varStatus="status">
								<tr class="tr_clr_2">
									<td class="invisible"><input type="checkbox" class="index" value="${list.REQUEST_ID }"></td>
									<td>${paginationInfo.totalRecordCount - ((paginationInfo.currentPageNo-1) * paginationInfo.recordCountPerPage+ status.index)}</td>
									<td>${list.REQUEST_SUBJECT }</td>
									<td>${list.MAIL_TITLE }</td>
									<td>${list.MAIL_SENDER_CNT}</td>
									<td>${list.FRST_USER_NM }</td>
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
							<tr><td colspan="4" class="textAlignCenter">항목을 선택해주세요.</td></tr>
						</tbody>
					</table>
					
			        <form name="vForm" id="vForm" method="post">
						<div class="search respondSearch invisible">
			          		<input type="hidden" name="requestId" value="">
							<input type="hidden" name="currentPageNo" id="currentPageNo" value='<c:out value="${pagination.currentPageNo}"/>'>
							<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
							<input type="hidden" name="procType" value="${common.procType }">
							<div class="fL wp85">
								<ul class="searchAreaBox">
									<li class="ml10 respondSearchLi" id="respondSearchLi">
										<button class="btn btn-primary searchResetBtn respondSearchBtn" type="button"><i class="fa fa-search"></i> 검색</button>
									</li>
									<li class="ml-1 ml5 respondSearchLi">
										<button class="btn btn-default resetBtn" type="button"><i class="fa fa-trash-o" title="초기화"></i></button>
									</li>									
								</ul>
								
							</div>
						</div>					
					</form>
					<div id="targetList">
					</div>
					
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
	<th>글 제목</th>
	<td colspan="4" class="tb_word">{{REQUEST_SUBJECT}}</td>
</tr>
<tr>
	<th>발송자 <br>메일 주소</th>
	<td colspan="4" class="tb_word">{{MAIL_SENDER_ADDRESS}}</td>
</tr>
<tr>
	<th>발송자 이름</th>
	<td colspan="4" class="tb_word">{{MAIL_SENDER_NAME}}</td>
</tr>
<tr>
	<th>메일 제목</th>
	<td colspan="4">{{MAIL_TITLE}}</td>
</tr>

<tr>
	<th>메일 내용</th>
	<td colspan="4" class="board_contents">{{safe MAIL_BODY}}</td>
</tr>
<tr>
	<th scope="row">첨부파일</th>
	<td colspan="4">{{safe fileView}}</td>
</tr>
<tr>
	<th scope="row">발송인원</th>
	<td colspan="4">{{MAIL_SENDER_CNT}}명</td>
</tr>
<tr>
	<th scope="row">등록일시</th>
	<td>{{FRST_REGIST_PNTTM}}</td>
	<th scope="row">등록자</th>
	<td>{{FRST_USER_NM}}</td>
</tr>

</script>

<script id="respond-template" type="text/x-handlebars-template">
	<li class="smart-form ml5">
		<label class="label">아이디</label>
	</li>
	<li class="w100">
		<input type="text" id="searchKeyword2" name="searchKeyword2" class="form-control" value="{{searchKeyword2}}">
	</li>
	<li class="smart-form ml5">
		<label class="label">이름</label>
	</li>
	<li class="w100">
		<input type="text" id="searchKeyword3" name="searchKeyword3" class="form-control" value="{{searchKeyword3}}">
	</li>
	
	<li class="smart-form ml5">
		<label class="label">이메일</label>
	</li>
	<li class="w120">
		<input type="text" id="searchKeyword4" name="searchKeyword4" class="form-control" value="{{searchKeyword4}}">
	</li>
	
	<li class="ml5 w100">
		<select class="form-control" name="searchCondition1">
			<option value="">전체</option>
			<option value="P" ${searchCondition1 eq 'P' ? "selected" : "" }>P(발송준비중)</option>
			<option value="R" ${searchCondition1 eq 'R' ? "selected" : "" }>R(발송준비)</option>
			<option value="I" ${searchCondition1 eq 'I' ? "selected" : "" }>I(발송중)</option>
			<option value="S" ${searchCondition1 eq 'S' ? "selected" : "" }>S(발송성공)</option>
			<option value="F" ${searchCondition1 eq 'F' ? "selected" : "" }>F(발송실패)</option>
			<option value="U" ${searchCondition1 eq 'U' ? "selected" : "" }>U(수신거부)</option>
			<option value="C" ${searchCondition1 eq 'C' ? "selected" : "" }>C(발송취소)</option>
			<option value="PF" ${searchCondition1 eq 'PF' ? "selected" : "" }>PE(일부실패)</option>
		</select>
	</li>
</script>
