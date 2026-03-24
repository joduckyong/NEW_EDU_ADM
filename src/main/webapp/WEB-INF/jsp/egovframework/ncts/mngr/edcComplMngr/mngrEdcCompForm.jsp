<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">

$(function(){
	// ckEditor Height 설정
	var baseInfo = {
			insertKey : '<c:out value="${common.baseType[0].key() }"/>',
            updateKey : '<c:out value="${common.baseType[1].key() }"/>',
            deleteKey : '<c:out value="${common.baseType[2].key() }"/>',
            lUrl : "/ncts/mngr/edcComplMngr/mngrEdcCompList.do",
            /* fUrl : "/ncts/mngr/mngrMemberForm.do",
            dUrl : "/ncts/mngr/mngrDeleteMember.do" */
	}	
	
	$.setValidation = function(){
        validator = $("#iForm").validate({
            ignore : "",
            rules: {serialNum   : {required       : ['연번']},
                    userNm      : {required       : ['이름']},
                    userHpNo    : {required       : ['연락처']},
                    issueDt     : {required       : ['발급일']},
                    edcTime     : {required       : ['교육시간']},
                    workshpNm   : {required       : ['워크샵명']},
                    certCd      : {required       : ['교육명']},
                    opertnInstt : {required       : ['시행기관']}
                   }
        });
    }
	
	$.saveProc = function(){
		if(!confirm("저장하시겠습니까?")) return;
		if(!$('input[name=edcIssueNo]').val())$('input[name=edcIssueNo]').val(0)
		
		$("#userHpNo").val($("#userHpNo").val().replaceAll("-",""));
		
		$("#iForm").ajaxForm({
			type: 'POST',
			url: "/ncts/mngr/userMngr/mngrEdcCompProc.do",
			dataType: "json",
			success: function(result){
				
				alert(result.msg);
				if(result.success == "success") location.replace("/ncts/mngr/mngrEdcCompList.do");	
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
	
	$("#jobCd").change(function(){
		if($('#jobCd').val() == '08'){
			$('#jobEtcNm').attr("disabled", false);
		} else {
			$('#jobEtcNm').attr("disabled", true);
		}
	})
	
	$.fn.onChange = function(){
		var _this = $(this);
		
		_this.on("change keyup paste", function(){
			if (window.event) // IE코드
	            var code = window.event.keyCode;
	        else // 타브라우저
	            var code = event.which;
			
			var v = $(this).val();
	        _this.val(v.replace(/[^0-9\-]/gi,''));
	        
	        if(13 < v.length){
	        	_this.val(v.substr(0,13));
	        }
			$("#userHpNo").phNoChange();
		})
	};
	
	$.fn.phNoChange = function(){
		var _this = $(this);
		
		_this.val(_this.val().replaceAll("-", ""));

        if(9 <= _this.val().length){
            if(10 ==_this.val().length){
                if(2 != Number(_this.val().substr(0,2))){
                    _this.val(_this.val().substr(0, 3) + '-' + _this.val().substr(3, 3) + '-' + _this.val().substr(6));
                }else{
                    _this.val( _this.val().substr(0, 2) + '-' + _this.val().substr(2, 4) + '-' + _this.val().substr(6));
                }
            }else{
                if(2 != Number(_this.val().substr(0,2))){
                    _this.val(_this.val().substr(0, 3) + '-' + _this.val().substr(3, 4) + '-' + _this.val().substr(7));
                }else{
                    _this.val( _this.val().substr(0, 2) + '-' + _this.val().substr(2, 3) + '-' + _this.val().substr(5));
                }
            }
        }
	}
	
	
	$.initView = function(){
		$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
		$("#listBtn").goBackList($.searchAction);
		$.setValidation();
		$("#saveBtn").saveBtnOnClickEvt();
		$("#jobSel").change();
		$("#jobCd").change();
		$("#userHpNo").onChange();
		$("#userHpNo").phNoChange();
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
				<div class="fL wp50">
					<ul class="searchAreaBox">
					</ul>
				</div>
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
					<jsp:param value="form"     name="formType"/>
					<jsp:param value="1,2"     name="buttonYn"/>
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
					<form name="iForm" id="iForm" method="post" class="smart-form">
					    <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						<input type="hidden" name="edcIssueNo" value='<c:out value="${result.EDC_ISSUE_NO}"/>'>
						<input type="hidden" id="centerCd" name="centerCd" value="<sec:authentication property="principal.centerId"/>" >
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="15%">
								<col width="30%">
								<col width="15%">
								<col width="*">
								<col width="15%">
								<col width="*">
							</colgroup>
							<tbody>
								 <tr>
						            <th>연번 </th>
						            <td colspan = "6">
										<label class="input w250 col">
											<input type="text" id="serialNum" name="serialNum" value='<c:out value="${result.SERIAL_NUM}"/>'>
										</label>
						            </td>
						          </tr>
						          <tr>
                                    <th>이름</th>
                                    <td>
                                        <label class="input w250 col">
                                            <input type="text" id="userNm" name="userNm" value='<c:out value="${result.USER_NM }"/>'>
                                        </label>
                                    </td>
                                    <th>생년월일</th>
                                    <td colspan = "3">
                                        <label class="input w250 col"> <i class="icon-append fa fa-calendar"></i>
                                            <input type="text" class="date inputcal" id="userBirthYmd" name="userBirthYmd" value='<c:out value="${result.USER_BIRTH_YMD}"/>'>
                                        </label>
                                    </td>
                                  </tr>
						          <tr>
                                    <th>이메일</th>
                                    <td>
                                        <label class="input w250 col">
                                            <input type="text" id="userEmail" name="userEmail" value='<c:out value="${result.USER_EMAIL }"/>'>
                                        </label>
                                    </td>
                                    <th>연락처</th>
                                    <td colspan = "3">
                                        <label class="input w250 col">
                                            <input type="text" id="userHpNo" name="userHpNo" value='<c:out value="${result.USER_HP_NO }"/>'>
                                        </label>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th>소속 </th>
                                    <td colspan = "6">
                                        <label class="input w250 col">
                                            <input type="text" id="userPsitn" name="userPsitn" value='<c:out value="${result.USER_PSITN}"/>'>
                                        </label>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th>발급일</th>
                                    <td>
                                        <label class="input w250 col"><i class="icon-append fa fa-calendar"></i>
                                            <input type="text" class="date inputcal" id="issueDt" name="issueDt" value='<c:out value="${result.ISSUE_DT}"/>'/>
                                        </label>
                                    </td>
                                    <th>교육시간</th>
                                    <td colspan = "3">
                                        <label class="input w250 col">
                                            <input type="text" id="edcTime" name="edcTime" value='<c:out value="${result.EDC_TIME}"/>'>
                                        </label>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th>워크샵명</th>
                                    <td>
                                        <label class="input w250 col">
                                            <input type="text" id="workshpNm" name="workshpNm" value='<c:out value="${result.WORKSHP_NM }"/>'>
                                        </label>
                                    </td>
                                    <th>교육명</th>
                                    
                                    <td colspan = "3">
                                        <label class="select w150 col">
                                            <select id="certCd" name="certCd">
                                                <option value="">선택</option>
                                                <c:forEach var="list" items="${codeMap.DMH12 }" varStatus="idx">
                                                    <option value='<c:out value="${list.CODE }"/>' <c:out value="${result.CERT_CD eq list.CODE ? 'selected=selected':'' }"/>><c:out value="${list.CODE_NM }"/></option>
                                                </c:forEach>
                                            </select> <i></i>
                                        </label>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th>직업</th>
                                    <td>
                                        <label class="input w250 col">
                                            <input type="text" id="userJob" name="userJob" value='<c:out value="${result.USER_JOB }"/>'>
                                        </label>
                                    </td>
                                    <th>지역</th>
                                    <td colspan = "3">
                                        <label class="select w150 col">
                                            <select id="userAreaCd" name="userAreaCd">
                                                <option value="">선택</option>
                                                <c:forEach var="list" items="${codeMap.DMH07 }" varStatus="idx">
                                                    <option value='<c:out value="${list.CODE }"/>' <c:out value="${result.USER_AREA_CD eq list.CODE ? 'selected=selected':'' }"/>><c:out value="${list.CODE_NM }"/></option>
                                                </c:forEach>
                                            </select> <i></i>
                                        </label>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th>진행팀 </th>
                                    <td colspan = "6">
                                        <label class="input w250 col">
                                            <input type="text" id="progrsTeam" name="progrsTeam" value='<c:out value="${result.PROGRS_TEAM}"/>'>
                                        </label>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th>시행기관 </th>
                                    <td colspan = "6">
                                        <label class="input w250 col">
                                            <input type="text" id="opertnInstt" name="opertnInstt" value='<c:out value="${result.OPERTN_INSTT}"/>'>
                                        </label>
                                    </td>
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