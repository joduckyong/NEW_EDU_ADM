 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>

.checkbox input {
	position: absolute;
	left: 11px;
	display: block;
	width: 17px;
	height: 17px;
	outline: 0;
	border : 1px solid #999;
	background: #FFF
}

.content {
	border: none !important;
}
</style>
<script type="text/javascript">
$(function(){
    var baseInfo = {
            insertKey : '<c:out value="${common.baseType[0].key() }"/>',
            updateKey : '<c:out value="${common.baseType[1].key() }"/>',
            deleteKey : '<c:out value="${common.baseType[2].key() }"/>',
            lUrl : "/ncts/mngr/mail/memberListPopup.do",
    }
    
    $.searchAction = function(){
        var no = 1;
        $("input[name='userNoArr']").val(userNoArr);
        $("input[name='userNoNotInArr']").val(notInArr);
        if(typeof(arguments[0]) != "undefined") no = arguments[0].pageNo;
        with(document.sForm){
            currentPageNo.value = no;
            action = baseInfo.lUrl;
            target='';
            submit();
        }
    }
    
    var userNoArr = '<c:out value="${param.userNoArr}"/>' == "" ? [] : '<c:out value="${param.userNoArr}"/>';
    var notInArr = '<c:out value="${param.userNoNotInArr}"/>' == "" ? [] : '<c:out value="${param.userNoNotInArr}"/>';
    
    $.fn.checkboxOnClickEvt = function(){
    	$(this).on("click", function(){
    		var $this = $(this);
    		var $allCheck = $("#listAllCheck:checked");
    		if(typeof userNoArr == "string") userNoArr = userNoArr.split(",");
    		if(typeof notInArr == "string") notInArr = notInArr.split(",");
    		
    		if($this.is(":checked")) {
    			if($this.hasClass("listAllCheck")) {
    				$("table input[type='checkbox']").prop("checked", true);
    				//$("table input[type='checkbox']").prop("checked", true).prop("disabled", true);
    				userNoArr = [];
    				notInArr = [];
    				
    				$(".choiceCnt").html($(".totalCnt").html());
    			}
    			else if($this.hasClass("pageAllCheck")) {
    				$("tbody input[type='checkbox']").prop("checked", true);
    				
    				$("tbody input[type='checkbox']").each(function(){
    					var $element = $(this);
    					var arrIndex;
	    				
	    				if($allCheck.length == 1) {
							arrIndex = notInArr.indexOf($element.val());
							if(arrIndex != -1) {
								notInArr.splice(arrIndex, $element.length);
								$(".choiceCnt").html(Number($(".choiceCnt").html())+$element.length);
							}
	    				}
	    				
	    				else if($allCheck.length != 1) {
	    					arrIndex = userNoArr.indexOf($element.val());
							if(arrIndex == -1) {
								userNoArr[userNoArr.length] = $element.val();
								$(".choiceCnt").html(Number($(".choiceCnt").html())+$element.length);
							}
	    				}
    				})
    				
    			}
    			else {
    				var arrIndex;
    				if($allCheck.length == 1) {
    					arrIndex = notInArr.indexOf($this.val());
						if(arrIndex != -1) {
							notInArr.splice(arrIndex, $this.length);
							$(".choiceCnt").html(Number($(".choiceCnt").html())+$this.length);
						}
    				}
    				else if($allCheck.length != 1) {
    					arrIndex = userNoArr.indexOf($this.val());
    					if(arrIndex == -1) {
    						userNoArr[userNoArr.length] = $this.val();
    						$(".choiceCnt").html(Number($(".choiceCnt").html())+$this.length);
    					}
    				}
    			}
    		}
    		
    		else {
    			if($this.hasClass("listAllCheck")) {
    				$("table input[type='checkbox']").prop("checked", false);
    				userNoArr = [];
    				notInArr = [];
    				$(".choiceCnt").html("0");
    				//$("table input[type='checkbox']").prop("checked", false).prop("disabled", false);
    			}
    			
    			else if($this.hasClass("pageAllCheck")) {
    				$("tbody input[type='checkbox']").prop("checked", false);
    				
    				$("tbody input[type='checkbox']").each(function(){
    					var $element = $(this);
    					var arrIndex;
    					
	    				if($allCheck.length == 1) {
							arrIndex = notInArr.indexOf($element.val());
							if(arrIndex == -1) {
								notInArr[notInArr.length] = $element.val(); 
								$(".choiceCnt").html(Number($(".choiceCnt").html())-$element.length);
							}
	    				}
	    				else if($allCheck.length != 1) {
							arrIndex = userNoArr.indexOf($element.val());
							if(arrIndex != -1) {
								userNoArr.splice(arrIndex, $element.length);
								$(".choiceCnt").html(Number($(".choiceCnt").html())-$element.length);
							}
	    				}
    				})
    			}
    			
    			else {
    				var arrIndex;
    				if($allCheck.length == 1) {
    					arrIndex = notInArr.indexOf($this.val());
    					if(arrIndex == -1) {
    						notInArr[notInArr.length] = $this.val();
    						$(".choiceCnt").html(Number($(".choiceCnt").html())-$this.length);
    					}
    				}
    				else if($allCheck.length != 1) {
    					arrIndex = userNoArr.indexOf($this.val());
    					if(arrIndex != -1) {
    						userNoArr.splice(arrIndex, $this.length);
    						$(".choiceCnt").html(Number($(".choiceCnt").html())-$this.length);
    					}
    				}
    				
/*     				if($allCheck.length == 1) {
    					
    					
    					notInArr.forEach(function(num, idx){ 
	    					if(num == $this.val()) userNoArr.splice(idx, $this.length);
	    				})
    				}
    				else if($allCheck.length != 1) {
    					userNoArr.forEach(function(num, idx){ 
	    					if(num == $this.val()) userNoArr.splice(idx, $this.length);
	    				})
    				} */
    			}
    		}
    		
    	})
    }
    
    $.checkboxOnSettings = function(){
    	if(typeof userNoArr == "string") userNoArr = userNoArr.split(",");
    	if(typeof notInArr == "string") notInArr = notInArr.split(",");
    	
    	var listAllCheck = '<c:out value="${param.listAllCheck}"/>';
    	if(listAllCheck == "Y") {
    		$("table input[type='checkbox']").prop("checked", true);
    		
    		notInArr.forEach(function(num){
    	    	$(".userCheckbox input[value='"+ num +"']").prop("checked", false);
    		})
    	} 
    	else {
	    	userNoArr.forEach(function(num){
		    	$(".userCheckbox input[value='"+ num +"']").prop("checked", true);
			})
    	}
		
		if($("#listAllCheck:checked").length == 1) $(".choiceCnt").html(Number($(".totalCnt").html())-notInArr.length);
		else $(".choiceCnt").html(userNoArr.length);
    }
    
    $.fn.choiceBtnOnClickEvt = function(){
    	$(this).on("click", function(){
    		userNoArr.forEach(function(num, idx){
				if(num == "") userNoArr.splice(idx, 1);
			})
    		notInArr.forEach(function(num, idx){
				if(num == "") notInArr.splice(idx, 1);
			})
			
			if(userNoArr.length == 0 && $("#listAllCheck:checked").length == 0) {
				alert("수신자를 선택해주세요.");
				return false;
			}
			$("input[name='userNoArr']").val(userNoArr);
			$("input[name='userNoNotInArr']").val(notInArr);
			
			$.saveProc();
    	})
    }
    
    $.fn.allChoiceBtnOnClickEvt = function(){
    	$(this).on("click", function(){
    		var $this = $(this);
    		
			$this.toggleClass("btn-danger btn-success");
			
			if($this.data("status") == "Y") $this.data("status", "N");
			else $this.data("status", "Y");
			
			$("#listAllCheck").click();
			
    	})
    }
    
    $.fn.resetBtnOnClickEvt = function(){
    	$(this).on("click", function(){
    		var $this = $(this);
    		var inputs = $(".resetUl input");
    		inputs.each(function(index, item){ item.value = ""; });
    		
    		/* var combos = $box.find("select");
    		combos.each(function(index, item){ $(item).find("option:first").prop("selected",true) }); */
    	})    	
    }  
    
	$.saveProc = function(){
		if(!confirm("선택하시겠습니까?")) return false;
		var obj = {};
		
		obj.lastUserNo = $("input[name='lastUserNo']").val();
		obj.userNoArr = $("input[name='userNoArr']").val();
		obj.userNoNotInArr = $("input[name='userNoNotInArr']").val();
		obj.listAllCheck = $("input[name='listAllCheck']:checked").val();
		obj.choiceCnt = $(".choiceCnt").html();
		
		self.opener.$.choiceUserList(obj);
		self.close();
		
	}    
    
    $.initView = function(){
        $("#searchBtn").searchBtnOnClickEvt($.searchAction);
        $("#choiceBtn").choiceBtnOnClickEvt();
        $("#allChoiceBtn").allChoiceBtnOnClickEvt();
        $("input[type='checkbox']").checkboxOnClickEvt();
        $(".resetBtn").resetBtnOnClickEvt();
        $.checkboxOnSettings();
    }
    
    $.initView();
})
</script>
		
<!-- MAIN CONTENT -->
<div id="content" class="popPage">
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<form name="sForm" id="sForm" method="post">
			<input type="hidden" name="lastUserNo" value='<c:out value="${lastUserNo.LAST_USER_NO }"/>'>
			<input type="hidden" name="userNoArr" value='<c:out value="${param.userNoArr }"/>'>
			<input type="hidden" name="userNoNotInArr" value='<c:out value="${param.userNoNotInArr }"/>'>
			<div class="fL wp80" style="margin-bottom:5px;">
	            <ul class="searchAreaBox resetUl">
	            	<li class="smart-form"><label class="label">아이디</label></li>
	                <li class="w100 ml5">
	                    <input id="sGubun2" name="sGubun2" class="form-control" value='<c:out value="${param.sGubun2}"/>'> 
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
	                
					<li class="ml10">
						<button class="btn btn-primary searchResetBtn" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
					</li>
					<li class="ml-1 ml5">
						<button class="btn btn-default resetBtn" type="button"><i class="fa fa-trash-o" title="초기화"></i></button>
					</li>		                
	        	</ul>
	        </div>	 
	        <div class="fR" style="margin-bottom:5px;">
	        	<ul class="searchAreaBox">
	        		<%-- <li class="ml10">
			        	<label class="checkbox checkboxCenter col" style="width:auto !important; height:0 !important; ">
			        		<input type="checkbox" id="listAllCheck" class="listAllCheck" name="listAllCheck" value="Y" ${param.listAllCheck eq 'Y' ? 'checked':'' }>
			        	</label>
			        	<span class="col mt10 ml20">전체선택</span>
	        		</li> --%>
	        		<li class="ml10">
		        		<input type="checkbox" id="listAllCheck" class="listAllCheck" name="listAllCheck" value="Y" <c:out value="${param.listAllCheck eq 'Y' ? 'checked':'' }"/> style="display:none;">
			        	<button class="btn <c:out value="${param.listAllCheck eq 'Y' ? 'btn-success':'btn-danger' }"/>" type="button" id="allChoiceBtn" data-status='<c:out value="${param.listAllCheck eq 'Y' ? 'Y':'N' }"/>'><i class="fa fa-check"></i> 전체선택</button>
	        		</li>
	        		<li class="ml10">
			        	<button class="btn btn-primary" type="button" id="choiceBtn"><i class="fa fa-check"></i> 선택</button>
	        		</li>
	        	</ul>
	        </div>       
            <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
        </form>
		<!-- Search 영역 끝 -->
		
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<table class="table table-bordered tb_type01 listtable">
						<colgroup>
							<col width="10%">
							<col width="10%">
							<col width="20%">
							<col width="10%">
                            <col width="20%">
                            <col width="15%">
                            <col width="15%">
                            
						</colgroup>
						<thead>
							<tr>
								<th class=""><label class="checkbox checkboxCenter col"><input type="checkbox" class="pageAllCheck" value=""></label></th>
								<th>아이디</th>
								<th>이메일</th>
								<th>이름</th>
								<th>연락처</th>
								<th>회원등급</th>
								<th>세부등급</th>
							</tr>
						</thead>
						<tbody>
							<div class="tRight" style="margin: 0 2px 5px 0;">선택 : <span class="choiceCnt">0</span>명 / 전체 : <span class="totalCnt"><c:out value="${totalCnt }"/></span>명</div>
							<c:if test="${empty rslist }">
								<tr><td colspan="7">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${rslist }" varStatus="idx">
								<tr>
									<td class="userCheckbox">
										<label class="checkbox checkboxCenter col"><input type="checkbox" class="index" value='<c:out value="${list.USER_NO}"/>'></label>
									</td>
									<%-- <td>${!empty list.DIST_MANAGE_NM ? list.DIST_MANAGE_NM : '전체'  }</td> --%>
									<td><c:out value="${list.USER_ID}"/></td>
									<td><c:out value="${list.USER_EMAIL}"/></td>
									<td><c:out value="${list.USER_NM}"/></td>
									<td><c:out value="${list.USER_HP_NO}"/></td>
									<td><c:out value="${list.GRADE_CD_NM}"/></td>
									<td><c:out value="${list.DETAIL_GRADE_CD_NM}"/></td>
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

