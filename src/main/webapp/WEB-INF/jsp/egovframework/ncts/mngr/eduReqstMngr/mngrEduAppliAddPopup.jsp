<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

$(function(){
	var baseInfo = {
			insertKey : "${common.baseType[0].key() }",
			updateKey : "${common.baseType[1].key() }",
			deleteKey : "${common.baseType[2].key() }",
			lUrl : "/ncts/mngr/selectMngrEduListPopup.do",
			sUrl : "/ncts/mngr/selectMngrEduListPopup.do",
			popup : "/ncts/mngr/eduReqstMngr/mngrEduAppliListPopup.do"
	}
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				nm               		: {required       : ['이름'], maxlength : ['20']},
				organization    		: {required       : ['소속'], maxlength : ['100']},
				/* position           		: {required       : ['직급'], maxlength : ['20']}, */
				tel           			: {required       : ['연락처'], maxlength : ['20']},
				birthday123           	: {required       : ['생년월일']},
				gender           		: {required       : ['성별']},
				email           		: {required       : ['이메일'], maxlength : ['100']},
				eduQualification01           	: {required       : ['자격']},
				eduSuportAreas01           		: {required       : ['재난심리지원 가능지역']},
			}
		});
	}
	
	$.fn.listBtnOnClickEvt = function(){
		var _this = $(this);
		_this.on("click", function(){
			_this=$(this);
 			$.popAction.width = 1200;
			$.popAction.height = 600;
			$.popAction.target = "mngrEduAppliListPopup";
			$.popAction.url = baseInfo.popup;
			$.popAction.form = document.sForm;
			$.popAction.init();
		})
	}
	
	$.dataDetail = function(index){
        if($.isNullStr(index)) return false;
        document.iForm.userNo.value = index;
        $.ajax({
            type: 'POST',
            url: "/ncts/mngr/userMngr/mngrMemberDetail.do",
            data: $("#iForm").serialize(),
            dataType: "json",
            success: function(data) {
                if(data.success == "success"){
                	var de = data.de;
                	var form = document.iForm;
                	form.userNo.value = de.USER_NO;
                    form.nm.value = de.USER_NM;
                    form.tel.value = de.USER_HP_NO;
                    form.birthday.value = de.USER_BIRTH_YMD;
                    form.email.value = de.USER_EMAIL;
                    form.organization.value = de.CURRENT_JOB_NM;
                    form.eduQualification01.value = de.LICENSE_CD;
                    form.eduSuportAreas01.value = de.ACTIVE_AREA_CD1;
                    form.eduSuportAreas02.value = de.ACTIVE_AREA_CD2;
                    $("#birthday123").val(de.USER_BIRTH_YMD);
                    $("input[name='gender']").each(function(){
                    	var $this = $(this);
                    	if($this.val() == de.USER_GENDER) $this.prop("checked", true);
                    	else $this.prop("checked", false);
                    		
                    })
                    
                    var $licenseCd = $("input[name='eduQualification01'][value='"+ de.LICENSE_CD +"']");
                    $("input[name='eduQualification01']").prop("checked", false);
                    $licenseCd.prop("checked", true);
                    $.licenseOnSettings($licenseCd, de.LICENSE18_NM);
                }
            }
        })
    }
	
	$.licenseOnSettings = function($licenseCd, licenseNm){
		var $licenseNm = $("input[name='eduQualificationDetail']");
		
		if($licenseCd.hasClass("open")) {
			$licenseNm.show();
			$licenseNm.prop("disabled", false);
			if(licenseNm != undefined) $licenseNm.val(licenseNm);
		} else {
			$licenseNm.hide();
			$licenseNm.val("");
			$licenseNm.prop("disabled", true);
		}
	}
	
	$.fn.phoneNumCheck = function(){
		var _this = $(this);
		_this.on("change keyup keypress", function(){
			_this = $(this);
	        _this.val(_this.val().replace("-",""));
	        
	        var phoneNum = _this.val().replace(/[^0-9]/g, "");
	        _this.val(phoneNum);
	        
	        var length = phoneNum.length;
	        var rs = "";
	        
	        if(9 <= length){
	            if(10 == length){
	                if(2 != Number(phoneNum.substr(0,2))){
	                    _this.val(phoneNum.substr(0, 3) + '-' + phoneNum.substr(3, 3) + '-' + phoneNum.substr(6));
	                }else{
	                    _this.val(phoneNum.substr(0, 2) + '-' + phoneNum.substr(2, 4) + '-' + phoneNum.substr(6));
	                }
	            }else{
	                if(2 != Number(phoneNum.substr(0,2))){
	                    _this.val(phoneNum.substr(0, 3) + '-' + phoneNum.substr(3, 4) + '-' + phoneNum.substr(7));
	                }else{
	                    _this.val(phoneNum.substr(0, 2) + '-' + phoneNum.substr(2, 3) + '-' + phoneNum.substr(5));
	                }
	            }
	        }
			
		})
    }
	
	$.fn.saveBtnOnClickEvt = function(){
		var _this = $(this);
		_this.on("click", function(){
			if(!$("#iForm").valid()) {
				validator.focusInvalid();
				return false;
			}
			else if(document.iForm.birthday.value.length == 0) {
				alert("생년월일을(를) 입력해주세요.");
				return false;
			}
			
			if(!confirm("저장하시겠습니까?")) return;
			
			$(".disabled").prop("disabled", false);
			$("#iForm").ajaxForm({
				type: 'POST',
				url: "/ncts/mngr/eduReqstMngr/mngrEduApplicantProcess.do",
				dataType: "json",
				success: function(result) {
					alert(result.msg);
					if(result.rs == "Y") {
						self.opener.location.reload();
						//self.opener.$.applicantChange();
						self.close();
					}
				}
	        });
	        $("#iForm").submit();
	        
	        if(msg != undefined) alert(msg);
		})
	}
	
	$.initView = function(){
		$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
		$.setValidation();
		$("input[name='procType']").val(baseInfo.insertKey);
		$("#tel").phoneNumCheck();
		$("#saveBtn").saveBtnOnClickEvt();
		$("#listBtn").listBtnOnClickEvt();
		$("#cancelBtn").click(function(){
			self.close();
		});
		$(".disabled").prop("disabled", true);
		
		$(".devQua").on("click", function(){
			$.licenseOnSettings($(this));
		})
		
	}
	
	$.initView();
})
</script>

<!-- MAIN CONTENT -->
<div id="content" class="popPage">
	<!-- widget grid start -->
	<section id="widget-grid" class="">
	
		
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
                 <div class="fR wp50">
					<ul class="searchAreaBox fR">
						<li><button class="btn btn-primary ml2" type="button" id="listBtn"><i class="fa fa-edit" title="추가"></i>회원 리스트</button></li>
						<li><button class="btn btn-primary ml2" type="button" id="saveBtn"><i class="fa fa-edit" title="추가"></i>추가</button></li>
						<li><button class="btn btn-primary ml2" type="button" id="cancelBtn"><i class="fa fa-edit" title="닫기"></i>닫기</button></li>
					</ul>
				</div>
			</form>
		</div>
		<!-- Search 영역 끝 -->
	
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<div class="article_medical" id="pList" >
						<form name="iForm" id="iForm" method="post" class="smart-form" enctype="multipart/form-data">
							<input type="hidden" id="eduSeq" name="eduSeq" value='<c:out value="${common.eduSeq }"/>'>
							<input type="hidden" name="userNo" id="userNo"  value="">
							<input type="hidden" name="eduDivision" value="${param.eduDivision }">
							<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
							<table class="table table-bordered tb_type01">
								<colgroup>
									<col width="14.28%">
									<col width="14.28%">
		                            <col width="14.28%">
		                            <col width="14.28%">
		                            <col width="14.28%">
		                            <col width="14.28%">
		                            <col width="14.28%">
								</colgroup>
								<tbody>
									<tr>
										<th>이름</th>
										<td colspan="2">
											<label class="input w120 col">
												<input type="text" id="nm" name="nm" value="" readonly>
											</label>
										</td>
										<th>연락처</th>
										<td colspan="4">
											<label class="input w120 col">
												<input type="text" id="tel" name="tel" value="${result.TEL }" maxlength="13" readonly>
											</label>
										</td>
									</tr>
									<tr>
										<th>생년월일</th>
										<td colspan="2">
											<label class="input w120"><i class="icon-append fa fa-calendar"></i>
												<input type="text" id="birthday123" name="birthday" class="date inputcal" readonly>
											</label>
										</td>
										<th>소속</th>
										<td colspan="4">
											<label class="input w250 col">
												<input type="text" id="organization" name="organization" value="${result.ORGANIZATION }" maxlength="100">
											</label>
										</td>
									</tr>
									<tr>
										<th>직급</th>
										<td colspan="1">
											<label class="input w250 col">
												<input type="text" id="position" name="position" value="" maxlength="20">
											</label>
										</td>
										<%-- <th>교육대상 분류</th>
										<td colspan="4">
											<div class="inline-group col">
												<label class="radio">
													<input type="radio" value="01" name="eduTargetType" ${result.EDU_TARGET_TYPE eq '01' ? 'checked="checked"' :'' }><i></i>공무원
												</label>
												<label class="radio">
													<input type="radio" value="02" name="eduTargetType" ${result.EDU_TARGET_TYPE eq '02' ? 'checked="checked"' :'' }><i></i>비공무원
												</label>
											</div>  
										</td> --%>
									</tr>
									<tr>
										<th>이메일</th>
										<td colspan="2">
											<label class="input w250 col">
												<input type="text" id="email" name="email" value="${result.EMAIL }" readonly>
											</label>
										</td>
										<th>성별</th>
										<td colspan="4">
											<div class="inline-group col">
												<label class="radio">
													<input type="radio" value="M" name="gender" class="disabled"><i></i>남자
												</label>
												<label class="radio">
													<input type="radio" value="W" name="gender" class="disabled"><i></i>여자
												</label>
											</div>  
										</td>
									</tr>
									<%-- ${result.LICENSE_NM }
									<c:forEach var="cd" items="${codeMap.DMH18 }" varStatus="status">
										<tr>										
											<c:if test="${status.index eq '0'}">
												<th rowspan="6">자격</th>
											</c:if>
											
											<td colspan="2">
												<label class="checkbox checkboxCenter col">
													<input type="checkbox" class="devQua disabled" name="eduQualification01" ${result.LICENSE_CD eq cd.c1 ? 'checked="checked"':''} value="${cd.c1 }"><i></i>
												</label>
												<span class="col mt7 ml30">${cd.nm1 }</span>
											</td>
											<td colspan="2">
												<label class="checkbox checkboxCenter col">
													<input type="checkbox" class="devQua disabled" name="eduQualification01" ${result.LICENSE_CD eq cd.c2 ? 'checked="checked"':''} value="${cd.c2 }"><i></i>
												</label>
												<span class="col mt7 ml30">${cd.nm2 }</span>
											</td>
											<td colspan="2">
												<c:if test="${cd.c3 ne '' }">
													<label class="checkbox checkboxCenter col">
														<input type="checkbox" class="devQua disabled" name="eduQualification01" ${result.LICENSE_CD eq cd.c3 ? 'checked="checked"':''} value="${cd.c3 }"><i></i>
													</label>
												</c:if>
												<span class="col mt7 ml30">${cd.nm3 }</span>
											</td>
										</tr>
									</c:forEach> --%>
									
									<tr>
										<th rowspan="9">자격</th>
										<td colspan="2">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '01'? 'checked="checked"':''} value="01"><i></i>
											</label>
											<span class="col mt7 ml30">정신건강의학과 전문의</span>
										</td>
										<td colspan="5">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '02'? 'checked="checked"':''} value="02"><i></i>
											</label>
											<span class="col mt7 ml30">정신건강의학과 전공의</span>
										</td>
									</tr>
									
									<tr>
										<td colspan="2">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '20'? 'checked="checked"':''} value="20"><i></i>
											</label>
											<span class="col mt7 ml30">정신건강간호사 1급</span>
										</td>
										<td colspan="2">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '21'? 'checked="checked"':''} value="21"><i></i>
											</label>
											<span class="col mt7 ml30">정신건강간호사 2급</span>
										</td>										
										<td colspan="3">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '22'? 'checked="checked"':''} value="22"><i></i>
											</label>
											<span class="col mt7 ml30">정신건강임상심리사 1급</span>
										</td>
									</tr>
									
									<tr>
										<td colspan="2">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '23'? 'checked="checked"':''} value="23"><i></i>
											</label>
											<span class="col mt7 ml30">정신건강임상심리사 2급</span>
										</td>
										<td colspan="2">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '16'? 'checked="checked"':''} value="16"><i></i>
											</label>
											<span class="col mt7 ml30">정신건강사회복지사 1급</span>
										</td>		
										<td colspan="3">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '17'? 'checked="checked"':''} value="17"><i></i>
											</label>
											<span class="col mt7 ml30">정신건강사회복지사 2급</span>
										</td>																		
									</tr>
									
									<tr>
										<td colspan="2">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '30'? 'checked="checked"':''} value="30"><i></i>
											</label>
											<span class="col mt7 ml30">정신건강작업치료사 1급</span>
										</td>
										<td colspan="2">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '31'? 'checked="checked"':''} value="31"><i></i>
											</label>
											<span class="col mt7 ml30">정신건강작업치료사 2급</span>
										</td>		
										<td colspan="3">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '06'? 'checked="checked"':''} value="06"><i></i>
											</label>
											<span class="col mt7 ml30">정신전문간호사</span>
										</td>										
									</tr>
									
									<tr>
										<td colspan="2">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '08'? 'checked="checked"':''} value="08"><i></i>
											</label>
											<span class="col mt7 ml30">상담심리사 1급</span>
										</td>
										<%-- <td colspan="2">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '09'? 'checked="checked"':''} value="09"><i></i>
											</label>
											<span class="col mt7 ml30">상담심리사 2급</span>
										</td>	 --%>
										<td colspan="2">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '07'? 'checked="checked"':''} value="07"><i></i>
											</label>
											<span class="col mt7 ml30">임상심리전문가</span>
										</td>
										<td colspan="3">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '27'? 'checked="checked"':''} value="27"><i></i>
											</label>
											<span class="col mt7 ml30">전문상담사 1급</span>
										</td>		
									</tr>	
									
									<tr>
										<td colspan="2">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '28'? 'checked="checked"':''} value="28"><i></i>
											</label>
											<span class="col mt7 ml30">청소년상담사 1급</span>
										</td>		
										<td colspan="2">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '29'? 'checked="checked"':''} value="29"><i></i>
											</label>
											<span class="col mt7 ml30">청소년상담사 2급</span>
										</td>		
										<td colspan="3">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '18'? 'checked="checked"':''} value="18"><i></i>
											</label>
											<span class="col mt7 ml30">해당 없음 </span>
										</td>
									</tr>		
									<tr>
										<td colspan="7">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua open" name="eduQualification01" ${result.LICENSE_CD eq '19'? 'checked="checked"':''} value="19"><i></i>
											</label>
											<span class="col mt7 ml30">기타</span>
											<label class="input w150 col ml10">
												<input type="text" name="eduQualificationDetail" id="eduQualificationDetail" class="inp_text" value="${result.LICENSE18_NM }" style="display:none">
											</label>
										</td>
									</tr>																																	
																
									<%-- <tr>
										<td colspan="2">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '26'? 'checked="checked"':''} value="26"><i></i>
											</label>
											<span class="col mt7 ml30">전문 상담교사</span>
										</td>	
										<td colspan="2">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '24'? 'checked="checked"':''} value="24"><i></i>
											</label>
											<span class="col mt7 ml30">수련생</span>
										</td>
										<td colspan="3">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '05'? 'checked="checked"':''} value="05"><i></i>
											</label>
											<span class="col mt7 ml30">간호사</span>
										</td>																								
									</tr>	 --%>								
									
									<%-- <tr>
										<td colspan="2">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '25'? 'checked="checked"':''} value="25"><i></i>
											</label>
											<span class="col mt7 ml30">사회복지사</span>
										</td>
										<td colspan="2">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '32'? 'checked="checked"':''} value="32"><i></i>
											</label>
											<span class="col mt7 ml30">작업치료사</span>
										</td>
									</tr>
									<tr>
										<td colspan="7">
											<label class="checkbox checkboxCenter col">
												<input type="radio" class="devQua" name="eduQualification01" ${result.LICENSE_CD eq '18'? 'checked="checked"':''} value="18"><i></i>
											</label>
											<span class="col mt7 ml30">해당 없음 </span>
											<label class="input w120 col ml10">
												<input type="text" name="eduQualificationDetail" id="eduQualificationDetail" class="inp_text" value="${result.LICENSE18_NM }" style="display:none">
											</label>
										</td>
									</tr> --%>
									<tr>
										<th>재난심리지원<br>가능지역</th>
										<td colspan="3">
											<div class="fLeft">
												<label class="select col w150 mr5">
													<select class="select col disabled" name="eduSuportAreas01" id="area_fst">
														<option value="">1순위</option>
														<c:forEach var="cd" items="${codeMap.DMH07 }">
															<option value="${cd.CODE }" ${result.ACTIVE_AREA_CD1 eq cd.CODE ? 'selected' : '' }>${cd.CODE_NM}</option>
														</c:forEach>	
													</select> <i></i>
												</label>
											</div>
											<div class="fLeft">
												<label class="select col w150 mr5">
													<select class="select col disabled" name="eduSuportAreas02" id="area_sec">
														<option value="">2순위</option>
														<c:forEach var="cd" items="${codeMap.DMH07 }">
															<option value="${cd.CODE }" ${result.ACTIVE_AREA_CD2 eq cd.CODE ? 'selected' : '' }>${cd.CODE_NM}</option>
														</c:forEach>	
													</select> <i></i>
												</label>
											</div>	
										</td>
									</tr>
									<tr>
										<th scope="row">첨부파일 </th>
										<td colspan="6">
											${markup }
										</td>
									</tr>
								</tbody>
							</table>
						</form>
					</div>
				</article>
			</div>
			<!-- row 메뉴조회 끝 -->
		</div>
	</section>
	<!-- widget grid end -->

</div>
<!-- END MAIN CONTENT -->