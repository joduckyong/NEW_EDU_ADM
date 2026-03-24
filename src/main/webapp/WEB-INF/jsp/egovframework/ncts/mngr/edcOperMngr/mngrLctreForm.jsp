<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
.stopInput {
	margin: 15px;
}
.stopInput:first-child {
	margin-left: 0;
}
textarea {
	border-color: #BDBDBD;
	font-size: 13px;
	padding: 5px 0 5px 3px !important;
}
</style>

<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">

$(function(){
	// ckEditor Height 설정
	CKEDITOR.replace('startGuide',{height : 200});
	CKEDITOR.replace('failGuide',{height : 200});
	
	var baseInfo = {
			insertKey : "<c:out value='${common.baseType[0].key() }'/>",
            updateKey : "<c:out value='${common.baseType[1].key() }'/>",
            deleteKey : "<c:out value='${common.baseType[2].key() }'/>",
            lUrl : "/ncts/mngr/edcOperMngr/mngrLctreList.do",
            fUrl : "/ncts/mngr/edcOperMngr/mngrLctreForm.do",
            dUrl : "/ncts/mngr/edcOperMngr/mngrDeleteLctre.do",
            excel : "/ncts/mngr/edcOperMngr/mngrLctreDownload.do"
	}	
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				lectureNm               : {required       : ['강의명']},
				youtubeId               : {required       : ['동영상 아이디']},
				videoDuration               : {required       : ['동영상 시간']},
				videoWidth               : {required       : ['동영상 가로 사이즈']},
				videoHeight               : {required       : ['동영상 세로 사이즈']},
			}
		});
	}
	
	$.saveProc = function(){
		if(!confirm("저장하시겠습니까?")) return;
		
		/* if(!$('input[name=lctreSeq]').val())$('input[name=lctreSeq]').val(0) */
		makeSnapshot(document.iForm, "startGuide");
		makeSnapshot(document.iForm, "failGuide");
		
		$("#iForm").ajaxForm({
			type: 'POST',
			url: "/ncts/mngr/edcOperMngr/mngrProgressLctre.do",
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
	
	$.fn.keyUp = function(){
		var num = $(this);
		num.css("IME-MODE","disabled");
		num.on("keyup", function(){
			$(this).val($(this).val().replace(/[^0-9]/g,""));
			if(this.value == "0"){
	            alert("0부터 입력할 수 없습니다.");
	            this.value = "";
	            return false;
	        }
		})
    }
	
	var $table = $("#stopTbody");
	var tr = "<tr></tr>";
	var td = "<td><label class='input w80 col stopInput'><input type='text' name='videoStopPoint'></label></td>";
	
	$.fn.stopBtnClickEvt = function() {
		var _this = $(this);
		_this.on("click", function(){
			$table.append(tr);
			for(var i=0; i<10; i++) {
				$table.find("tr:last-child()").append(td);
			}
		})
	}
	
	$.selectDetail = function(){
        var stopVal = [];

        <c:forTokens items="${result.VIDEO_STOP_POINT}" delims=",|" var="stop">
        	stopVal.push("<c:out value='${stop}'/>");
		</c:forTokens>
		
        for(var i=0; i<stopVal.length; i++) {
           	if(i % 10 == 0) {
        		$table.append(tr);
           	}
           	$table.find("tr:last-child()").append(td);
        	$table.find("[name=videoStopPoint]").eq(i).val(stopVal[i]);
        }
        
        var tdSize = $table.find("tr:last-child()").find("td").length;
        
        if(tdSize < 10) {
	        for(var i=tdSize; i<10; i++) {
	        	$table.find("tr:last-child()").append(td);
	        	$table.find("tr:last-child()").find("[name=videoStopPoint]").eq(i).val("");
	        }
        }
	}
	
	$.fn.stopTextKeyUpEvt = function(){
		var _this = $(this);
		_this.on("keyup paste", ".stopInput [type=text]", function(){
			var $this = $(this);
			var inputVal = $this.val().replace(/[^0-9]/g, "");
			$this.val(inputVal);
		})
	}
	
	$.fn.checkHna = function(){
        $(this).on("change keyup keypress", function(){
			var v = $(this).val();
			$(this).val(v.replace(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/gi,''));
        })
    }
	
	$.fn.onlyNum = function(max){
		var _this = $(this);
		_this.css("IME-MODE","disabled");
		_this.attr("maxlength", max == undefined ? 1 : max );
		_this.on("keydown", function(event){
			if (window.event) // IE코드
		        var code = window.event.keyCode;
		    else // 타브라우저
		        var code = event.which;
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
		}).on("change keyup keypress", function(event){
			var $this = $(this);
			var inputVal = parseInt($this.val()); 
			if($this.hasClass("hh") && inputVal > 23){
				alert("00~23로 입력해주세요.")
				$this.val("");
			}else if($this.hasClass("mm") && inputVal > 59){
				alert("00~59로 입력해주세요.")
				$this.val("");
			}else{
				var v = $(this).val();
				$(this).val(v.replace(/[^0-9]/gi,''));				
			}
			
		})
	}	
	
	$.fn.imgView = function(){
		var img = $(this);
		img.on("change", function(event){
	        var f_name = document.getElementById("file_input_file1").value;
	        if( f_name.length != 0 ) {
                if( !f_name.toLowerCase().match(/\.(gif|jpg|png)$/i) ) {
	        	    alert("이미지 파일만 선택할 수 있습니다.");
	                $("#file_input_file1").val("");
	            } else {
	            	$('img[name=modiImg]').remove()
	            	
	            	var files = $("#file_input_file1")[0].files;
	            	var fileArr = Array.prototype.slice.call(files);
	            	
	            	fileArr.forEach(function(f){
	            		  var reader = new FileReader();
	            		  reader.onload = function(e){
	            			  $('.viewImg').attr('style', 'display:""');
	            			  $('.viewImg').attr('src', e.target.result);
	            		  }
	            	reader.readAsDataURL(f);
	            	})
	            }
	        } else {
	        	$('#blah')[0].style.display = "none"
	        }
		})
	}
	
	$.fn.removeImg = function(){
		var _this = $(this);
		
		_this.on("click", function(e){
			if(_this[0].innerText == "Attach File"){
				$('.viewImg')[0].style.display = "none";
			}
		})
	}
	
	$.fn.eduCoursesCheckboxOnChangeEvt = function(){
		$(this).on("change", function(){
			var display = $("input[name='courses00']:checked").length == 1 ? "none" : "";
			$(".guide").css("display", display);
		})
	}
	
	$.initView = function(){
		$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
		$("#listBtn").goBackList($.searchAction);
		$.setValidation();
		$("#saveBtn").saveBtnOnClickEvt();
		$("#videoDuration").keyUp();
		$("#videoDuration").onlyNum(5);
		$(".onlyNum").keyUp();
		$(".onlyNum").onlyNum(4);
		$("#videoStopBtn").stopBtnClickEvt();
		$("#stopTbody").stopTextKeyUpEvt();
		$("#youtubeId").checkHna();
		$("#div_file_display11").removeImg();
		$("#div_file_display12").imgView();
		if("${common.baseType[1].key() }"=="${common.procType}") $.selectDetail();
		$(".eduCourses input[type='checkbox']").eduCoursesCheckboxOnChangeEvt();
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
				<input type="hidden" id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'>
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
					<form name="iForm" id="iForm" method="post" class="smart-form" enctype="multipart/form-data">
						<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						<input type="hidden" id="lectureId" name="lectureId" value="<c:out value='${result.LECTURE_ID}'/>">
						<input type="hidden" name="atchFileId" value="<c:out value='${result.ATCH_FILE_ID}'/>">
						
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="10%">
								<col width="24%">
								<col width="10%">
								<col width="23%">
								<col width="10%">
								<col width="23%">
							</colgroup>
							<tbody>
								<tr>
                                    <th scope="row">강의명</th>
                                    <td><label class="input w200 col">
                                            <input type="text" id="lectureNm" name="lectureNm" value="<c:out value='${result.LECTURE_NM}'/>">
                                        </label>
                                    </td>
                                    <th scope="row">교육과정</th>
                                    <td><c:forEach var="list" items="${codeMap }" varStatus="idx">
                                            <label class="checkbox checkboxCenter col eduCourses">
                                                <c:if test="${idx.index eq '0'}">
                                                    <input type="checkbox" name="courses0<c:out value='${idx.index}'/>" <c:out value="${result.COURSES00 eq list.CODE ? 'checked=checked':''}"/> value="<c:out value='${list.CODE }'/>"><i></i>
                                                </c:if>
                                                <c:if test="${idx.index eq '1'}">
                                                    <input type="checkbox" name="courses0<c:out value='${idx.index}'/>" <c:out value="${result.COURSES01 eq list.CODE ? 'checked=checked':''}"/> value="<c:out value='${list.CODE }'/>"><i></i>
                                                </c:if>
                                                <c:if test="${idx.index eq '2'}">
                                                    <input type="checkbox" name="courses0<c:out value='${idx.index}'/>" <c:out value="${result.COURSES02 eq list.CODE ? 'checked=checked':''}"/> value="<c:out value='${list.CODE }'/>"><i></i>
                                                </c:if>
                                                <c:if test="${idx.index eq '3'}">
                                                    <input type="checkbox" name="courses0<c:out value='${idx.index}'/>" <c:out value="${result.COURSES03 eq list.CODE ? 'checked=checked':''}"/> value="<c:out value='${list.CODE }'/>"><i></i>
                                                </c:if>
                                            </label>
                                            <c:if test="${idx.index eq '0' or idx.index eq '1' or idx.index eq '2' or idx.index eq '3'}">
                                            	<span class="col mt7 ml30 mr5"><c:out value="${list.CODE_NM }"/></span>
                                            </c:if>
                                        </c:forEach>
                                    </td>
                                    <th scope="row">동영상 아이디</th>
                                    <td><label class="input w200 col">
                                            <input type="text" id="youtubeId" name="youtubeId" value="<c:out value='${result.YOUTUBE_ID}'/>">
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">동영상 시간</th>
                                    <td><label class="input w80 col">
                                            <input type="text" id="videoDuration" name="videoDuration" value="<c:out value='${result.ORG_DURATION}'/>">
                                        </label>
                                        <span class="col mt7 ml5">초</span>
                                    </td>
                                    <th scope="row">동영상 가로 사이즈</th>
                                    <td><label class="input w80 col">
                                            <input class="onlyNum" type="text" id="videoWidth" name="videoWidth" value="<c:out value='${result.VIDEO_WIDTH}'/>">
                                        </label>
                                        <span class="col mt7 ml5">px</span>
                                    </td>
                                    <th scope="row">동영상 세로 사이즈</th>
                                    <td><label class="input w80 col">
                                            <input class="onlyNum" type="text" id="videoHeight" name="videoHeight" value="<c:out value='${result.VIDEO_HEIGHT}'/>">
                                        </label>
                                        <span class="col mt7 ml5">px</span>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <th scope="row">수강대상</th>
                                    <td>
                                    	<label class="input w400 col">
                                            <input type="text" id="atnlcTaget" name="atnlcTaget" value="<c:out value='${result.ATNLC_TAGET}'/>">
                                        </label>
                                    </td>
                                    <th scope="row">수강형태</th>
                                    <td><label class="input w200 col">
                                            <input type="text" id="atnlcStle" name="atnlcStle" value="<c:out value='${result.ATNLC_STLE}'/>">
                                        </label>
                                    </td>
                                    <th scope="row">수강시간</th>
                                    <td><label class="input w80 col">
                                            <input class="onlyNum" type="text" id="atnlcTime" name="atnlcTime" value="<c:out value='${result.ATNLC_TIME}'/>">
                                        </label>
                                        <span class="col mt7 ml5">분</span>
                                    </td>
                                </tr>
                                
								<tr>
									<th scope="row">교육목표</th>
									<td colspan="5" class="">
										<textarea id="edcGoal" name="edcGoal" class="part_long " style="width: 100%;" cols="100" rows="5" ><c:out value="${result.EDC_GOAL}"/></textarea>
									</td>
								</tr>
								<tr>
                                    <th scope="row">프로그램 구성</th>
                                    <td colspan="5" class="">
                                        <textarea id="progrmComposition" name="progrmComposition" class="part_long " style="width: 100%;" cols="100" rows="5" ><c:out value="${result.PROGRM_COMPOSITION}"/></textarea>
                                    </td>
                                </tr>
                                
								<tr class="guide" style="${result.COURSES00 eq '00' ? 'display:none':''}">
									<th scope="row">형성평가<br/>시작안내 </th>
									<td colspan="5" class="board_contents">
										<textarea id="startGuide" name="startGuide" class="part_long board_contents" style="width: 100%; min-width: 100%;"><c:out value="${result.START_GUIDE}"/></textarea>
									</td>
								</tr>
								<tr class="guide" style="${result.COURSES00 eq '00' ? 'display:none':''}">
                                    <th scope="row">형성평가<br/>실패안내 </th>
                                    <td colspan="5" class="board_contents">
                                        <textarea id="failGuide" name="failGuide" class="part_long board_contents" style="width: 100%; min-width: 100%;"><c:out value="${result.FAIL_GUIDE}"/></textarea>
                                    </td>
                                </tr>
								<!-- <tr>
                                    <th scope="row">동영상 정지시간 </th>
                                    <td colspan="5">
                                    	<button class="btn btn-primary ml2 addBtn" id="videoStopBtn" type="button">
										    <i class="fa fa-plus-square" title="추가"></i> 추가
										</button>
										
										<table>
											<tbody id="stopTbody">
											</tbody>
										</table>
                                    </td>
                                </tr> -->
								<tr>
                                    <th scope="row">대표이미지 </th>
                                    <td colspan="5">
                                        <c:out value="${markup }"/>
                                        <img src="/utl/web/imageSrc.do?path=mngr/<c:out value='${result.STRE_FILE_NM }'/>" width="240" height="135" class="viewImg" style="display:${not empty result.ATCH_FILE_ID ? 'block':'none'};"/>
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