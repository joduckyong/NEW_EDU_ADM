<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">
$(function(){
	var baseInfo = {
			insertKey : "${common.baseType[0].key() }",
            updateKey : "${common.baseType[1].key() }",
            deleteKey : "${common.baseType[2].key() }",
            lUrl : "/ncts/mngr/edcComplMngr/mngrPackageRuleList.do",
            pop01 : "/ncts/mngr/edcComplMngr/mngrPackageListPopup.do"
	}	
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				courses     : {required       : ['교육과정']},
				packageRuleNm   : {required       : ['Rule명']},
				tdId   : {required       : ['선택된 강의']},
			}
		});
	}
	
	$.saveProc = function(){
		if($("#checkedCourses").val() != $("input[name='courses']:checked").val()) {
			alert("선택한 교육과정과 선택한 강의의 교육과정이 일치하지 않습니다.");
			return false;
		}
		
		if(!confirm("저장하시겠습니까?")) return;
		
        $.ajax({
            type: 'POST',
            url: "/ncts/mngr/edcComplMngr/mngrPackageRuleProc.do",
            data: $("#iForm").serialize(),
            dataType: "json",
            success: function(data) {
                alert(data.msg);
                if(data.success == "success") location.replace(baseInfo.lUrl);    
            }
        })		
	}
	
	$.searchAction = function(){
		with(document.sForm){
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
	
	$.selectPackageNo = function(obj){
		if(obj){
	    	$("#tdId").val(obj.checkedLectureId);
	        $("input[name=packageNo]").val(obj.checkedPackageNo);
	        $("input[name=checkedCourses]").val(obj.checkedCourses);
	    }
	}
	
	$.fn.onChangeEvt = function(){
		var _this = $(this);
		
		_this.on("click", function(){
			$("#courses").val($("input[name=courses]:checked").val());
			$.popAction.width = 1200;
            $.popAction.height = 600;
            $.popAction.target = "popup01";
            $.popAction.url = baseInfo.pop01;
            $.popAction.form = document.sForm;
            $.popAction.init();
		});
	}
	
	$.fn.goBackList = function(){
		$(this).on("click", function(){
			document.sForm.packageRuleNo.value = 0;
			$.searchAction();
		})
		
	}
	
	$.initView = function(){
		$("#listBtn").goBackList();
		$.setValidation();
		$("#saveBtn").saveBtnOnClickEvt();
		$("input[name=courses]").onChangeEvt();
	}
	
	$.initView(); 
})
</script>
		
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/ribbon.jsp" flush="false" />
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />
<!-- MAIN CONTENT -->
<div id="content">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/menuTitle.jsp" flush="false" />
	
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
				<div class="fL wp50">
					<ul class="searchAreaBox">
					</ul>
				</div>
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
					<jsp:param value="form"     name="formType"/>
					<jsp:param value="1,2"     name="buttonYn"/>
				</jsp:include>
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
                <input type="hidden" name="packageRuleNo" id="packageRuleNo" value='<c:out value="${result.PACKAGE_RULE_NO}"/>'>
                <input type="hidden" name="packageNo" id="packageNo" value='<c:out value="${result.PACKAGE_NO}"/>'>
                <input type="hidden" name="courses" id="courses" value="">
			</form>
		</div>
		<!-- Search 영역 끝 -->
        <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />
		
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<form name="iForm" id="iForm" method="post" class="smart-form" enctype="multipart/form-data">
                        <input type="hidden" name="packageRuleNo" value='<c:out value="${result.PACKAGE_RULE_NO}"/>'>
                        <input type="hidden" name="packageNo" value='<c:out value="${result.PACKAGE_NO}"/>'>
						<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="10%">
								<col width="20%">
								<col width="50%">
								<!-- <col width="23%">
								<col width="10%">
								<col width="23%"> -->
							</colgroup>
							<tbody>
								<tr>
                                    <th scope="row">교육과정</th>
                                    <td colspan="2">
                                        <div class="inline-group" id="divRadio">
                                            <c:forEach var="list" items="${codeMap}" varStatus="status">
					                            <label class="radio">
					                                   <input type="radio" name="courses" value="${list.CODE}" ${result.COURSES eq list.CODE? 'checked="checked"':''}><i></i>${list.CODE_NM}
					                            </label>
                                            </c:forEach>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Rule명</th>
                                    <td colspan="2">
                                        <label class="input w500 col">
                                            <input type="text" id="packageRuleNm" name="packageRuleNm" value="${result.PACKAGE_RULE_NM}">
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">선택된 강의</th>
                                    <td colspan="2">
                                    <label class="input col" style="width: 90%;">
                                    	<input type="text" id="tdId" name="tdId" value="${result.LECTURE_ID}" readonly>
                                    	<input type="hidden" name="checkedCourses" id="checkedCourses" value="${result.COURSES }">
                                    </label>
                                    </td>
                                   <!--  <td><button id="selLecDel" name="selLecDel">강의 지우기</button></td> -->
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