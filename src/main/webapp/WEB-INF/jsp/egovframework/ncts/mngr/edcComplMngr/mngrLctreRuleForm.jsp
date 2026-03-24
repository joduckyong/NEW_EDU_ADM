<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">
$(function(){
	var baseInfo = {
			insertKey : '<c:out value="${common.baseType[0].key() }"/>',
            updateKey : '<c:out value="${common.baseType[1].key() }"/>',
            deleteKey : '<c:out value="${common.baseType[2].key() }"/>',
            lUrl : "/ncts/mngr/edcComplMngr/mngrLctreRuleList.do",
            pop01 : "/ncts/mngr/common/stddLecListPopup.do"
	}	
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				courses     : {required       : ['교육과정']},
				lectureNm   : {required       : ['강의명']},
				tdId   : {required       : ['선택된 강의']},
			}
		});
	}
	
	$.saveProc = function(){
		if(!confirm("저장하시겠습니까?")) return;
		if(!$("#ruleNo").val())$("#ruleNo").val(0);
		
		$("#iForm").ajaxForm({
            type: 'POST',
            url: "/ncts/mngr/edcComplMngr/mngrProgressRuleLctre.do",
            dataType: "json",
            success: function(result) {
                alert(result.msg);
                if(result.success == "success") location.replace(baseInfo.lUrl);    
            }
        });
		
		$("#iForm").submit();
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
	
	$.selectLecture = function(obj){
		var oldTxt = ""
		
		if(obj){
	    	$("#tdId").val(obj);
	        $("input[name=lectureId]").val(obj);
	    }
		
		/* if(obj){
			if($("#tdId").val()){
	            oldTxt = $("#tdId").val();
	            obj = oldTxt + ', ' + obj;
	        } 
	        if(obj){
	            $("#tdId").val(obj);
	            $("input[name=lectureId]").val(obj);
	        }	
		} */
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
			document.sForm.ruleNo.value = 0;
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
                <input name="courses" id="courses" type="hidden" value=""/>
                <input type="hidden" name="ruleNo" value='<c:out value="${result.RULE_NO }"/>'>
                <input type="hidden" id="lectureId" name="lectureId" value='<c:out value="${result.LECTURE_ID}"/>'>
			</form>
		</div>
		<!-- Search 영역 끝 -->
        <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />
		
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<form name="iForm" id="iForm" method="post" class="smart-form" enctype="multipart/form-data">
                        <input type="hidden" id="lectureId" name="lectureId" value='<c:out value="${result.LECTURE_ID}"/>'>
                        <input type="hidden" id="ruleNo" name="ruleNo" value='<c:out value="${result.RULE_NO}"/>'>
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
                                    	<%-- <label class="select w150 col">
                                            <select id="courses" name="courses">
                                                <option value="" >선택</option>
                                                <c:forEach var="list" items="${codeMap}" varStatus="idx">
                                                    <option value="${list.CODE}" ${result.COURSES eq list.CODE_NM ? 'selected="selected"':''}>${list.CODE_NM }</option>
                                                </c:forEach>
                                            </select> <i></i>
                                        </label> --%>
                                        <div class="inline-group" id="divRadio">
                                            <c:forEach var="list" items="${codeMap}" varStatus="status">
                                            	<c:if test="${status.index ne 0}">
						                            <label class="radio">
						                                <c:if test="${status.index lt 5}">
						                                   <input type="radio" name="courses" value='<c:out value="${list.CODE}"/>' <c:out value="${result.COURSES eq list.CODE? 'checked=checked':''}"/>><i></i><c:out value="${list.CODE_NM}"/>
						                                </c:if>
						                            </label>
					                            </c:if>
                                            </c:forEach>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">강의명</th>
                                    <td colspan="2">
                                        <label class="input w500 col">
                                            <input type="text" id="lectureNm" name="lectureNm" value='<c:out value="${result.LECTURE_NM}"/>'>
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">선택된 강의</th>
                                    <td colspan="2">
                                    <label class="input w500 col">
                                    	<input type="text" id="tdId" name="tdId" value='<c:out value="${result.LECTURE_ID}"/>' readonly>
                                    <%-- <td colspan="5" id="tdId">${result.LECTURE_ID}</td> --%>
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