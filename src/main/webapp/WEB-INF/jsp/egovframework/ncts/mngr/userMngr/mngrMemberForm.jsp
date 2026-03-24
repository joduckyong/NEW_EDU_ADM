<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">

$(function(){
	// ckEditor Height 설정
	var baseInfo = {
			insertKey : "<c:out value='${common.baseType[0].key() }'/>",
            updateKey : "<c:out value='${common.baseType[1].key() }'/>",
            deleteKey : "<c:out value='${common.baseType[2].key() }'/>",
            lUrl : "/ncts/mngr/userMngr/mngrMemberList.do",
            fUrl : "/ncts/mngr/userMngr/mngrMemberForm.do",
            dUrl : "/ncts/mngr/userMngr/mngrDeleteMember.do"
	}	
	
	$.setValidation = function(){
        validator = $("#iForm").validate({
            ignore : "",
            rules: {
            		userId       : {required       : ['아이디']},
            		userEmail       : {required       : ['이메일']},
                    /* userPw          : {required       : ['비밀번호']}, */
                    gradeCd         : {required       : ['등급코드']},
                    detailGradeCd         : {required       : ['세부등급']},
                    userNm          : {required       : ['이름']},
                    userBirthYmd    : {required       : ['생년월일']},
                    /* jobCd           : {required       : ['직업코드']}, */
                    activeAreaCd1    : {required       : ['활동지역코드']},
                    userHpNo        : {required       : ['전화번호']},
                   }
        });
    }
	
	$.saveProc = function(){
		var idchk = true;
		var emailchk = true;
		
		if($("#idChk").length > 0) idchk = $.idEmailChkBtnOnClickEvt($("#idChk"), "N");
		if($("#emailChk").length > 0) emailchk = $.idEmailChkBtnOnClickEvt($("#emailChk"), "N");
		if(idchk && emailchk) {
			if(!confirm("저장하시겠습니까?")) return;
			if($("#userHpNo").val($("#userHpNo").val().replaceAll("-","")));
			if(!document.sForm.userNo.value)document.sForm.userNo.value = 0;
			if(!document.iForm.userNo.value)document.iForm.userNo.value = 0;
			
			var updateData = new FormData($('#iForm')[0]);
	
			var complVal = "";
			var certVal = "";
			
			for(var i = 0; i < $("select[name=certComplCd]").length; i++){
				if(i != 0){
	            	complVal += '|';
	            }
	            complVal += $("select[name=certComplCd]").eq(i).val();
			}
			$("input[name='certComplCdList']").val(complVal);
			
			/* $("select[name=certComplCd]").each(function(idx){
	            if(idx != 0){
	            	complVal += ',';
	            }
	            complVal += $(this).val();
	        }); */
			
			$("input[name=certCd]").each(function(idx){
	            if(idx != 0){
	            	certVal += '|';
	            }
	            certVal += $(this).val();
	        });
	        $("input[name='certCdList']").val(certVal);
	        
			$("#iForm").ajaxForm({
				type: 'POST',
				url: "/ncts/mngr/userMngr/mngrProc.do",
				processData: false,
				contentType: false,
				dataType: "json",
				success: function(result){
					
					alert(result.msg);
					if(result.success == "success") location.replace("/ncts/mngr/userMngr/mngrMemberList.do");	
				}
	        });
	
	        $("#iForm").submit();
		} 
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
	
	$.fn.phoneCheck = function(){
		var _this = $(this);
		var inputVal = _this.val();
		_this.val(inputVal.replaceAll("-",""));

		
		_this.on("keydown", function(event){
			if (window.event) // IE코드
		        var code = window.event.keyCode;
		    else // 타브라우저
		        var code = event.which;
			
			
			console.log(code);
		    if ((code > 34 && code < 41) || 
		    	(code > 47 && code < 58) || 
		    	(code > 95 && code < 106) || 
		    	code == 8 || 
		    	code == 9 || 
		    	code == 13 || 
		    	code == 46 
		    ){
		    	window.event.returnValue = true;
		        return;
		    }
		    
	    	event.preventDefault(); 
		}).on("keyup", function(event){
			var $this = $(this);
			var inputVal = parseInt($this.val()); 
			if($this.hasClass("hh") && inputVal > 23){
				alert("00~23로 입력해주세요.")
				$this.val("");
			}else if($this.hasClass("mm") && inputVal > 59){
				alert("00~59로 입력해주세요.")
				$this.val("");
			}else{
				if (window.event) // IE코드
			        var code = window.event.keyCode;
			    else // 타브라우저
			        var code = event.which;
				
				if(code == 229){
			    	$(this).val("");
			    	alert("한글 입력은 불가능합니다.")
				}
				
				return false;
			}
		})
		
		_this.on("change keyup keypress", function(){
			var $this = $(this);
			
			$this.val($this.val().replace("-",""));
			
		    var phoneNum = $this.val().replace(/[^0-9]/g, "");
		    $this.val(phoneNum);
		    
		    var length = phoneNum.length;
		    var rs = "";
		    
		    if(9 <= length){
		        if(10 == length){
		            if(2 != Number(phoneNum.substr(0,2))){
		            	$this.val(phoneNum.substr(0, 3) + '-' + phoneNum.substr(3, 3) + '-' + phoneNum.substr(6));
		            }else{
		            	$this.val(phoneNum.substr(0, 2) + '-' + phoneNum.substr(2, 4) + '-' + phoneNum.substr(6));
		            }
		        }else{
		            if(2 != Number(phoneNum.substr(0,2))){
		            	$this.val(phoneNum.substr(0, 3) + '-' + phoneNum.substr(3, 4) + '-' + phoneNum.substr(7));
		            }else{
		            	$this.val(phoneNum.substr(0, 2) + '-' + phoneNum.substr(2, 3) + '-' + phoneNum.substr(5));
		            }
		        }
		    }
		})
	}

	$.getSeDetail = function(){
        if(!document.sForm.userNo.value){
        	document.sForm.userNo.value = 0;
        } 
        
        $.ajax({
            type: 'POST',
            url: "/ncts/mngr/userMngr/selecSeDetail.do",
            data: $("#sForm").serialize(),
            dataType: "json",
            success: function(data) {
                if(data.success == "success"){
                    $("#seTable").handlerbarsCompile($("#se-template"), data.se);
                }
            }
        })
	}
	
	$("#jobCd").change(function(){
		if($('#jobCd').val() == '08'){
			$('#jobEtcNm').attr("disabled", false);
			$('#jobEtcNm').show();
		} else {
			$('#jobEtcNm').attr("disabled", true);
			$('#jobEtcNm').hide();
		}
	});
	
	$.idEmailChkBtnOnClickEvt = function($this, type){
		var objId = $this.prop("id");
		var obj = $this.prev().find("input");
		var objVal = obj.val();
		var objTitle = $this.data("title");
		var idVal, emailVal;
		var result = false;
		
		if(objId == "idChk") {
			if(objVal.replaceAll(" ", "").length == 0) {
				alert(objTitle + "을(를) 입력해주세요.");
				obj.focus();
				return false;
			}
			else if(!/^(?=.*?[a-z])[A-Za-z+0-9+]{4,12}$/.test(objVal)){
				alert("아이디는 영문자 또는 영문자,숫자 조합 4~12자리로 입력해주세요.");
				obj.focus();
				return false;
			}
			idVal = objVal;
		}
		else {
			if(objVal.replaceAll(" ", "").length == 0) {
				alert(objTitle + "을(를) 입력해주세요.");
				obj.focus();
				return false;
			}
			emailVal = objVal;
		}
		
		$.ajax({
			type : 'POST',
			url  : "/ncts/mngr/userMngr/selectIdEmailChk.do",
			data : {
				"userId" : idVal,
				"userEmail" : emailVal,
				"userNo" : $("input[name='userNo']").val(),
				"<c:out value='${_csrf.parameterName}'/>" : "<c:out value='${_csrf.token}'/>"
			},
			dataType: "json",
			async : false,
			success : function(data) {
				if(data.success == "success") {
					var infoChk = data.infoChk;
					var chkCnt = infoChk.CNT;
					if(chkCnt >= 1) {
						alert("중복된 "+ objTitle +" 입니다.");
						obj.focus();
						
						result = false;
					} else result = true;
				}
			}
		})	
		
		return result;
	}		
	
	$.fn.hanCheck = function(){
		var _this = $(this);
		_this.on("keyup", function(){
			var pattern = /[^\ㄱ-ㅎ|ㅏ-ㅣ|가-힣|a-zA-Z]/g;
			this.value = this.value.replace(pattern, '');
		})
	}
	
	$.initView = function(){
		$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
		$("#listBtn").goBackList($.searchAction);
		$.setValidation();
		$("#saveBtn").saveBtnOnClickEvt();
		$("#jobCd").change();
		$("#userHpNo").phoneCheck();
		$.getSeDetail();
		$("#userNm").hanCheck();
		if(0 != $("#userNo").val()) $(".trPwd").show();
		/* $("body").notePopupBtnOnClickEvt();
		$("body").notePopupBtnsOnClickEvt(baseInfo.updateKey); */
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
          		<input type="hidden" name="userNo" id="userNo"  value="<c:out value='${result.USER_NO }'/>">
          		<input type="hidden" name="userEmail" value="<c:out value='${result.USER_EMAIL }'/>">
          		<input type="hidden" name="userNm" value="<c:out value='${result.USER_NM }'/>">
				<input type="hidden" id="searchKeyword1" name="searchKeyword1" value="<c:out value='${param.searchKeyword1}'/>"/>
				<input type="hidden" id="searchKeyword2" name="searchKeyword2" value="<c:out value='${param.searchKeyword2}'/>"/>
				<input type="hidden" id="searchKeyword3" name="searchKeyword3" value="<c:out value='${param.searchKeyword3}'/>"/>
				<input type="hidden" id="searchKeyword4" name="searchKeyword4" value="<c:out value='${param.searchKeyword4}'/>"/>
				<input type="hidden" id="sGubun" name="sGubun" value="<c:out value='${param.sGubun}'/>"/>
				<input type="hidden" id="sGubun1" name="sGubun1" value="<c:out value='${param.sGubun1}'/>"/>
				<input type="hidden" id="sGubun4" name="sGubun4" value="<c:out value='${param.sGubun4}'/>"/>
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
		
		<form method="post" name="nForm" id="nForm">
			<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
			<input type="hidden" name="userNo" value="<c:out value='${result.USER_NO }'/>" >
<%-- 			<div id="notePopup" class="popup-con-d" style="display:none">
				<div class="close_box fClr" style="text-align:left;">
				</div>
		        <div class="tit_box fClr">
		        	<p class="tit fLeft">주강사구분</p>
		        	<label>
			        	<input type="checkbox" id="pfatGradeAt" name="pfatGradeAt" value="Y" ${result.PFAT_GRADE_AT eq 'Y'? 'checked':''}>
			        	<span class="col mt7 ml5 mr20">PFAT주강사</span>
		        	</label>
		        	<label>
			        	<input type="checkbox" id="pmptGradeAt" name="pmptGradeAt" value="Y" ${result.PMPT_GRADE_AT eq 'Y'? 'checked':''}>
			        	<span class="col mt7 ml5 mr20">PM+T주강사</span>
		        	</label>
		        	<label>
			        	<input type="checkbox" id="sprtGradeAt" name="sprtGradeAt" value="Y" ${result.SPRT_GRADE_AT eq 'Y'? 'checked':''}>
			        	<span class="col mt7 ml5 mr20">SPRT주강사</span>
		        	</label>
		        	
		        	<p class="tit fLeft">준강사구분</p>
		        	<label>
			        	<input type="checkbox" id="pfatAiGradeAt" name="pfatAiGradeAt" value="Y" ${result.PFAT_AI_GRADE_AT eq 'Y'? 'checked':''}>
			        	<span class="col mt7 ml5 mr20">PFAT준강사</span>
		        	</label>
		        	<label>
			        	<input type="checkbox" id="pmptAiGradeAt" name="pmptAiGradeAt" value="Y" ${result.PMPT_AI_GRADE_AT eq 'Y'? 'checked':''}>
			        	<span class="col mt7 ml5 mr20">PM+T준강사</span>
		        	</label>
		        	<label>
			        	<input type="checkbox" id="sprtAiGradeAt" name="sprtAiGradeAt" value="Y" ${result.SPRT_AI_GRADE_AT eq 'Y'? 'checked':''}>
			        	<span class="col mt7 ml5 mr20">SPRT준강사</span>
		        	</label>
		            <textarea name="note" id="note" cols="30" rows="10" placeholder="비고">${result.NOTE }</textarea>
		            
					<div class="btn_box fClr">
						<button type="button" class="fCenter" id="noteProcBtn">등록</button>
						<button type="button" class="fCenter close_popup">닫기</button>
					</div>		            
		        </div>
			</div> --%>
		</form>		
		
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<form name="iForm" id="iForm" method="post" class="smart-form" enctype="multipart/form-data">
					    <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						<input type="hidden" name="userNo" value="<c:out value='${result.USER_NO}'/>">
						<input type="hidden" id="currentJobNm" name="currentJobNm" value="<c:out value='${result.CURRENT_JOB_NM}'/>"/>
						<input type="hidden" id="centerCd" name="centerCd" value="<sec:authentication property="principal.centerId"/>" >
						<input type="hidden" name="certCdList">
						<input type="hidden" name="certComplCdList">
						<input type="hidden" name="atchFileId" value='<c:out value="${result.ATCH_FILE_ID }"/>'>
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="10%">
								<col width="22%">
								<col width="10%">
								<col width="25%">
								<col width="10%">
								<col width="23%">
							</colgroup>
							<tbody>
								<tr>
									<th>아이디</th>
									<td colspan="6">
										<c:if test="${empty result.USER_ID}">
											<label class="input w250 col">
												<input type="text" id="userId" name="userId" value="">
											</label>	
											<input type="hidden" id="idChk" name="idChk" value="" data-title="아이디">
											<!-- <label class="input col ml5">
												<button class="btn btn-primary" type="button" id="idChkBtn"><i class="fa fa-search"></i> 중복체크</button>
											</label> -->
										</c:if>
										<c:if test="${not empty result.USER_ID}">
											<c:out value="${result.USER_ID}"/>
										</c:if>
									</td>
								</tr>
								<tr>
						            <th>이메일 </th>
						            <td colspan="6">
										<label class="input w250 col">
											<input type="text" id="userEmail" name="userEmail" value="<c:out value='${result.USER_EMAIL}'/>">
										</label>
										<c:if test="${not empty result.USER_EMAIL}">
											<input type="hidden" id="emailChk" name="emailChk" value="" data-title="이메일">
										</c:if>	
										<%-- <span class="col mt7 mr5" style="color : red">(잠깐!! 혹시 관리자 계정의 이메일 주소가 아닌가요?)</span> --%>
						            </td>
								</tr>
								<tr>
						            <th>회원등급</th>
						            <td>
						            	<label class="select w150 col">
											<select id="gradeCd" name="gradeCd">
											    <option value="">선택</option>
											    <c:forEach var="list" items="${codeMap.DMH03 }" varStatus="idx">
                                                    <option value="<c:out value='${list.CODE }'/>" <c:out value="${result.GRADE_CD eq list.CODE ? 'selected=selected':'' }"/>><c:out value="${list.CODE_NM }"/></option>
                                                </c:forEach>
                                            </select> <i></i>
										</label>
									</td>
						            <th>세부등급</th>
						            <td>
						            	<label class="select w150 col">
                                            <select id="detailGradeCd" name="detailGradeCd">
                                                <c:forEach var="list" items="${codeMap.DMH23 }" varStatus="idx">
                                                    <option value="<c:out value='${list.CODE }'/>" <c:out value="${result.DETAIL_GRADE_CD eq list.CODE ? 'selected=selected':'' }"/>>
	                                                    <c:out value="${list.CODE_NM }"/>
                                                    </option>
                                                </c:forEach>
                                            </select> <i></i>
                                        </label>
						            </td>
						            <th>강사등급</th>
						            <td>
						            	<label class="select w150 col">
                                            <select id="instrctrDetailGradeCd" name="instrctrDetailGradeCd">
                                                <option value="99">선택</option>
                                                <c:forEach var="list" items="${codeMap.DMH24 }" varStatus="idx">
                                                    <option value="<c:out value='${list.CODE }'/>" <c:out value="${result.INSTRCTR_DETAIL_GRADE_CD eq list.CODE ? 'selected=selected':'' }"/>>
															<c:out value="${list.CODE_NM }"/>
                                                    </option>
                                                </c:forEach>
                                            </select> <i></i>
                                        </label>
                                        <%-- <c:if test="${not empty result }">
                                  			<button type="button" class="btn btn-default ml2 mb5" id="notePopupBtn">
  												<i class="fa fa-search"></i>상세
											</button>
										</c:if>	 --%>
						            </td>	
						          </tr>
						        <tr>
                                    <th>이름</th>
                                    <td>
                                        <label class="input w250 col">
                                            <input type="text" id="userNm" name="userNm" value="<c:out value='${result.USER_NM}'/>">
                                        </label>
                                    </td>
                                    <th>생년월일</th>
                                    <td colspan = "3">
                                        <label class="input w250 col"> <i class="icon-append fa fa-calendar"></i>
                                            <input type="text" class="date inputcal" id="userBirthYmd" name="userBirthYmd" value="<c:out value='${result.USER_BIRTH_YMD}'/>" <c:out value="${not empty result.USER_BIRTH_YMD ? 'readonly':''  }"/>/>
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>활동지역</th>
                                    <td>
                                        <label class="select w150 col ">
                                            <select id="activeAreaCd1" name="activeAreaCd1">
                                                <option value="">선택</option>
                                                <c:forEach var="list" items="${codeMap.DMH07 }" varStatus="idx">
                                                    <option value="<c:out value='${list.CODE }'/>" <c:out value="${result.ACTIVE_AREA_CD1 eq list.CODE ? 'selected=selected':'' }"/>><c:out value="${list.CODE_NM }"/></option>
                                                </c:forEach>
                                            </select> <i></i>
                                        </label>
                                        <label class="select w150 col ml10">
                                            <select id="activeAreaCd2" name="activeAreaCd2">
                                                <option value="">선택</option>
                                                <c:forEach var="list" items="${codeMap.DMH07 }" varStatus="idx">
                                                    <option value="<c:out value='${list.CODE }'/>" <c:out value="${result.ACTIVE_AREA_CD2 eq list.CODE ? 'selected=selected':'' }"/>><c:out value="${list.CODE_NM }"/></option>
                                                </c:forEach>
                                            </select> <i></i>
                                        </label>
                                    </td>
                                    <c:choose>
	                                    <c:when test="${ common.procType eq common.baseType[1].key()  }">
	                              	     	<th>전화번호</th>
	                                    	<td>
	                                   	    	<label class="input w250 col">
	                                    	        <input type="text" id="userHpNo" name="userHpNo" value="<c:out value='${result.USER_HP_NO }'/>" maxlength="13" >
	                                    	    </label>
	                                    	</td>
	                                    	<th>첨부파일</th>
                                   	 		<td>
												<c:out value="${markup }"/>
						            		</td>	
	                                    </c:when>
	                                    <c:otherwise>
	                                    	<th>전화번호</th>
	                                    	<td colspan = "3">
	                                   	    	<label class="input w250 col">
	                                    	        <input type="text" id="userHpNo" name="userHpNo" value="<c:out value='${result.USER_HP_NO }'/>" maxlength="13" >
	                                    	    </label>
	                                    	</td>
	                                    </c:otherwise>
                                    </c:choose>
                                </tr>
							</tbody>
						</table>
						
						<c:if test="${ common.procType eq common.baseType[1].key()  }">
							<table class="table table-bordered table-hover tb_type01">
								<div class="fL wp50">
									<span class="col mt7 mr5"><b>P:이수 , T:시간부족, F:미이수</b></span>
								</div>
								<colgroup>
								<col width="9%">
								<col width="12%">
								<col width="12%">
								<col width="9%">
								<col width="12%">
								<col width="12%">
								<col width="9%">
								<col width="12%">
								<col width="12%">
							</colgroup>
							
								<tbody id="seTable">							
								</tbody>
							</table>
						</c:if>
					</form>
				</article>
				
			</div>
			<!-- row 메뉴조회 끝 -->
		</div>
	</section>
	<!-- widget grid end -->

</div>
<!-- END MAIN CONTENT -->

<script id="se-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">기준강의명</th>
	<th scope="row">수강여부</th>
    <th scope="row">이수일</th>
    <th scope="row">기준강의명</th>
    <th scope="row">수강여부</th>
    <th scope="row">이수일</th>
    <th scope="row">기준강의명</th>
    <th scope="row">수강여부</th>
    <th scope="row">이수일</th>
</tr>

{{#if .}}
{{#each .}}
<tr>
    <td bgcolor={{#ifnoteq ACTIVE_YN1 'Y'}}"#d2c0a4"{{/ifnoteq}}>{{LECTURE_NM1}}</td>
    <td><label class="select w150 col">
			<input type="hidden" name="certCd" value="{{CERT_CD1}}">
			<select id="" name="certComplCd">
				<option value="F">선택</option>
				<option value="P" {{#ifeq CERT_COMPLETED_CD1 'P'}}selected="selected"{{/ifeq}}>P</option>
				<option value="T" {{#ifeq CERT_COMPLETED_CD1 'T'}}selected="selected"{{/ifeq}}>T</option>
				<option value="F" {{#ifeq CERT_COMPLETED_CD1 'F'}}selected="selected"{{/ifeq}}>F</option>
			</select> <i></i>
		</label>
	</td>
    <td>{{ISSUE_DT1}}</td>
    <td bgcolor={{#ifnoteq ACTIVE_YN2 'Y'}}"#d2c0a4"{{/ifnoteq}}>{{LECTURE_NM2}}</td>
    <td><label class="select w150 col">
			<input type="hidden" name="certCd" value="{{CERT_CD2}}">
			<select id="" name="certComplCd">
				<option value="F">선택</option>
				<option value="P" {{#ifeq CERT_COMPLETED_CD2 'P'}}selected="selected"{{/ifeq}}>P</option>
				<option value="T" {{#ifeq CERT_COMPLETED_CD2 'T'}}selected="selected"{{/ifeq}}>T</option>
				<option value="F" {{#ifeq CERT_COMPLETED_CD2 'F'}}selected="selected"{{/ifeq}}>F</option>
			</select> <i></i>
		</label>
	</td>
    <td>{{ISSUE_DT2}}</td>
	<td bgcolor={{#ifnoteq CERT_CD3 ''}}{{#ifnoteq ACTIVE_YN3 'Y'}}"#d2c0a4"{{/ifnoteq}}{{/ifnoteq}}>{{LECTURE_NM3}}</td>
    <td>{{#ifnoteq CERT_CD3 ''}}
        <label class="select w150 col">
			<input type="hidden" name="certCd" value="{{CERT_CD3}}">
			<select id="" name="certComplCd">
				<option value="F">선택</option>
				<option value="P" {{#ifeq CERT_COMPLETED_CD3 'P'}}selected="selected"{{/ifeq}}>P</option>
				<option value="T" {{#ifeq CERT_COMPLETED_CD3 'T'}}selected="selected"{{/ifeq}}>T</option>
				<option value="F" {{#ifeq CERT_COMPLETED_CD3 'F'}}selected="selected"{{/ifeq}}>F</option>
			</select> <i></i>
		</label>
        {{/ifnoteq}}
	</td>
    <td>{{ISSUE_DT3}}</td>
</tr>
{{/each}}
{{else}}
    <tr class="noData">                           
        <td colspan="9">데이터가 없습니다.</td>             
    </tr>
{{/if}}

</script>