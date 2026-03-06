<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

$(function(){
	var baseInfo = {
			insertKey : "${common.baseType[0].key() }",
			updateKey : "${common.baseType[1].key() }",
			deleteKey : "${common.baseType[2].key() }",
			lUrl : "/ncts/mngr/instrctrMngr/instrctrDetailPopup.do",
	}
	
    $.searchAction = function(){
        var no = 1;
        
        if(typeof(arguments[0]) != "undefined") no = arguments[0].pageNo;
        with(document.tabForm){
            currentPageNo.value = no;
            action = baseInfo.lUrl;
            target='';
            submit();
        }
    }	
	
	$.loadAreaOnSettings = function(){
		var $activeTab = $("#tabList .active a");
		$("#loadArea").load($activeTab.data("url"), $("#tabForm").serialize());
	}
	
	$.fn.tabListOnClickEvt = function(){
		$(this).on("click", function(){
			var $this = $(this);
			$("#tabList li").removeClass("active");
			$this.addClass("active");
			$("input[name='searchCondition2']").val($this.find("a").data("val"));
			$("#loadArea").load($this.find("a").data("url"), $("#tabForm").serialize());
		})
	}
	
    $.fn.instrctrList2ATagOnClickEvt = function(){
    	var _this = $(this);
    	_this.on("click", "#instrctrList2 a", function(){
    		var $this = $(this);
    		document.sForm.searchCondition1.value = $this.data("val");
    		$("#loadArea").load("/ncts/mngr/instrctrMngr/instrctrDetailPopup.do", $("#sForm").serialize());
    	})
    }	
	
	$.initView = function(){
		$.loadAreaOnSettings();
		$("#tabList li").tabListOnClickEvt();
		$("article").instrctrList2ATagOnClickEvt();
	}
	
	$.initView();
})
</script>


<!-- MAIN CONTENT -->
<div id="content" class="popPage">
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
        <form name="tabForm" id="tabForm" method="post">
        	<input type="hidden" name="userNo" id="userNo" value="${empty param.userNo ? param.instrctrNo : param.userNo }">
        	<input type="hidden" name="instrctrNo" id="instrctrNo" value="${empty param.instrctrNo ? param.userNo : param.instrctrNo }">
        	<input type="hidden" name="courses" value="04">
        	<input type="hidden" name="pageType" value="INSTRCTR">
        	<input type="hidden" name="searchCondition2" id="searchCondition2" value="${empty param.searchCondition2 ? '01' : param.searchCondition2 }">
			<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
		</form>
		<!-- Search 영역 끝 -->	
		<div class="tab-content">
			<div class="jarviswidget-sortable active" id="tabList">
				<ul class="nav nav-tabs" style="min-width:100%;">
					<li class="${empty param.searchCondition2 or param.searchCondition2 eq '01' ? 'active' : ''}"><a href="javascript:void(0);" data-val="01" data-url="/ncts/mngr/common/selectEduMemberDetailPopup.do">강사정보</a></li>
					<li class="${param.searchCondition2 eq '02' ? 'active' : ''}"><a href="javascript:void(0);" data-val="02" data-url="/ncts/mngr/instrctrMngr/instrctrDetailPopup.do">강사활동</a></li>
				</ul>
			</div>
		</div>					
		<div class="content" style="border:none;">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12" id="loadArea">
				</article>
			</div>
		</div>
	</section>
	<!-- widget grid end -->

</div>
<!-- END MAIN CONTENT -->
