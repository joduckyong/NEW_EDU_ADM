<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
textarea {
	width: 100%; 
	border: 1px solid #bdbdbd;
	padding: 4px !important; 
	font-size: 13px; 
	color: #404040;
}
</style>

<script type="text/javascript">
$(function(){
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				lectureNm               : {required       : ['동영상 제목']},
				youtubeId               : {required       : ['동영상 아이디']},
				videoDuration           : {required       : ['동영상 시간']},
			}
		});
	}	
	
	var baseInfo = {
			insertKey : '<c:out value="${common.baseType[0].key() }"/>',
			updateKey : '<c:out value="${common.baseType[1].key() }"/>',
			deleteKey : '<c:out value="${common.baseType[2].key() }"/>',
			lUrl : "/ncts/mngr/edcComplMngr/mngrLctrePopup.do"
	}
	
	$.searchAction = function(){
		var no = 1;
        if(typeof(arguments[0]) != "undefined") no = arguments[0].pageNo;
        with(document.sForm){
            currentPageNo.value = no;
            action = baseInfo.lUrl;
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
	
	$.saveProc = function(){
		if(!confirm("저장하시겠습니까?")) return;
		
		var lectureId = self.opener.$(".tr_clr_2 .index:checked").val() == undefined ? "" : self.opener.$(".tr_clr_2 .index:checked").val();
		if($("#lectureId").val() != lectureId) {
			alert("추가된 동영상이 현재 기준강의코드와 일치하지 않습니다.");
			return false;
		}
		
		var seq = $("#pageType").val() == "TEMP" ? $("#tempSeq").val() : $("#lectureSeq").val();
		var procType;
		
		if(seq == "") procType = baseInfo.insertKey;
		else procType = baseInfo.updateKey;
		document.iForm.procType.value = procType;

		$("#iForm").ajaxForm({
            type: 'POST',
            url: "/ncts/mngr/edcComplMngr/lectureOnlectProc.do",
            dataType: "json",
            success: function(result) {
            	if(result.success == "success") {
	            	var data = {
	            			tempSeq : result.paramData.tempSeq,
	            			lectureSeq : result.paramData.lectureSeq,
	            			sn : $("#lectureSn").val(),
	            			lectureId : $("#lectureId").val(),
	            			youtubeId : $("#youtubeId").val()
	            	}
	            	self.opener.$.lectureOnlectChange(data);
	            	self.close();
            	}
            }
        });
		$("#iForm").submit();
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
	        	$('#blah')[0].style.display = "none";
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
	
	$.initView = function(){
		$.setValidation();
		$("#saveBtn").saveBtnOnClickEvt($.searchAction);
		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
		//$.lectureIdOnSetting();
		
		$("#youtubeId").checkHna();
		$("#videoDuration").keyUp();
		$("#videoDuration").onlyNum(5);
		$(".onlyNum").keyUp();
		$(".onlyNum").onlyNum(4);		
		$("#div_file_display11").removeImg();
		$("#div_file_display12").imgView();
		
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
          		<input type="hidden" name="pageType" id="pageType" value='<c:out value="${param.pageType }"/>'>
				<input type="hidden" name="lectureId" id="lectureId" value='<c:out value="${param.lectureId}"/>'>
				<input type="hidden" name="lectureSeq" id="lectureSeq" value='<c:out value="${param.lectureSeq}"/>'>
				<input type="hidden" name="tempSeq" id="tempSeq" value='<c:out value="${param.tempSeq}"/>'>
				<input type="hidden" name="lectureSn" id="lectureSn" value='<c:out value="${param.lectureSn}"/>'>
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
                 <div class="fR wp50">
					<ul class="searchAreaBox fR">
						<li><button class="btn btn-primary ml2" type="button" id="saveBtn"><i class="fa fa-edit" title="추가"></i>추가</button></li>
					</ul>
				</div>				
			</form>
		</div>
		<!-- Search 영역 끝 -->
	
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<form name="iForm" id="iForm" method="post" class="smart-form" enctype="multipart/form-data">
						<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						<input type="hidden" name="atchFileId" value='<c:out value="${result.ATCH_FILE_ID}"/>'>
		          		<input type="hidden" name="pageType" value='<c:out value="${param.pageType }"/>'>
						<input type="hidden" name="lectureId" value='<c:out value="${empty result.LECTURE_ID ? param.lectureId : result.LECTURE_ID}"/>'>
						<input type="hidden" name="lectureSeq" value='<c:out value="${param.lectureSeq}"/>'>
						<input type="hidden" name="tempSeq" value='<c:out value="${param.tempSeq}"/>'>
						<input type="hidden" name="lectureSn" value='<c:out value="${param.lectureSn}"/>'>
						
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
									<th scope="row">동영상<br>제목</th>
									<td>
										<label class="input w400 col">
											<input type="text" id="lectureNm" name="lectureNm" value='<c:out value="${result.LECTURE_NM}"/>'>
										</label>
									</td>	
                                    <th scope="row">동영상<br>시간</th>
                                    <td>
                                    	<label class="input w80 col">
                                            <input type="text" id="videoDuration" name="videoDuration" value='<c:out value="${result.ORG_DURATION}"/>'>
                                        </label>
                                        <span class="col mt7 ml5">초</span>
                                    </td>
                                    <th scope="row">동영상<br>아이디</th>
                                    <td colspan="3">
                                    	<label class="input w200 col">
                                            <input type="text" id="youtubeId" name="youtubeId" value='<c:out value="${result.YOUTUBE_ID}"/>'>
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">수강대상</th>
                                    <td>
                                    	<label class="input w400 col">
                                            <input type="text" id="atnlcTaget" name="atnlcTaget" value='<c:out value="${result.ATNLC_TAGET}"/>'>
                                        </label>
                                    </td>
                                    <th scope="row">수강형태</th>
                                    <td><label class="input w200 col">
                                            <input type="text" id="atnlcStle" name="atnlcStle" value='<c:out value="${result.ATNLC_STLE}"/>'>
                                        </label>
                                    </td>
                                    <th scope="row">수강시간</th>
                                    <td><label class="input w80 col">
                                            <input class="onlyNum" type="text" id="atnlcTime" name="atnlcTime" value='<c:out value="${result.ATNLC_TIME}"/>'>
                                        </label>
                                        <span class="col mt7 ml5">분</span>
                                    </td>
                                </tr>
                                
								<tr>
									<th scope="row">교육목표</th>
									<td colspan="5">
										<textarea id="edcGoal" name="edcGoal" class="part_long" cols="100" rows="5" ><c:out value="${result.EDC_GOAL}"/></textarea>
									</td>
								</tr>
								<tr>
                                    <th scope="row">프로그램<br>구성</th>
                                    <td colspan="5">
                                        <textarea id="progrmComposition" name="progrmComposition" class="part_long" cols="100" rows="5" ><c:out value="${result.PROGRM_COMPOSITION}"/></textarea>
                                    </td>
                                </tr>
								<tr>
                                    <th scope="row">대표이미지 </th>
                                    <td colspan="5">
										<c:out value="${markup }"/>
                                       	<img src="/utl/web/imageSrc.do?path=mngr/<c:out value='${result.STRE_FILE_NM }'/>" width="240" height="135" class="viewImg" style="display:'<c:out value="${not empty result.ATCH_FILE_ID ? 'block':'none'}"/>'">
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