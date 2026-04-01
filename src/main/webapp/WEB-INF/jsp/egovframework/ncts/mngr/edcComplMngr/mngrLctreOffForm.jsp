<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
.stopInput {
	margin: 15px;
}
.stopInput:first-child {
	margin-left: 0;
}
</style>

<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">

$(function(){
	// ckEditor Height 설정
	//CKEDITOR.replace('startGuide',{height : 200});
	CKEDITOR.replace('edcGoal',{height : 200});
	
	var baseInfo = {
			insertKey : "<c:out value='${common.baseType[0].key() }'/>",
            updateKey : "<c:out value='${common.baseType[1].key() }'/>",
            deleteKey : "<c:out value='${common.baseType[2].key() }'/>",
            lUrl : "/ncts/mngr/edcComplMngr/mngrLctreOffList.do",
            fUrl : "/ncts/mngr/edcComplMngr/mngrLctreOffForm.do",
            dUrl : "/ncts/mngr/edcComplMngr/mngrDeleteOffLctre.do",
            excel : "/ncts/mngr/edcComplMngr/mngrLctreDownload.do"
	}	
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				lectureNm               : {required       : ['강의명']},
			}
		});
	}
	
	$.saveProc = function(){
		if(!confirm("저장하시겠습니까?")) return;

		makeSnapshot(document.iForm, "edcGoal");

		$("#iForm").ajaxForm({
            type: 'POST',
            url: "/ncts/mngr/edcComplMngr/mngrProgressOffLctre.do",
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
	
	var $table = $("#stopTbody");
	var tr = "<tr></tr>";
	var td = "<td><label class='input w250 col stopInput'><input type='text' name='progrmComposition'></label></td>";
	
	$.fn.stopBtnClickEvt = function() {
		var _this = $(this);
		_this.on("click", function(){
			$table.append(tr);
			$table.find("tr:last-child()").append(td);
		})
	}
	
	$.selectDetail = function(){
        var stopVal = [];

        <c:forTokens items="${result.VIDEO_STOP_POINT}" delims=",|" var="stop">
        	stopVal.push('<c:out value="${stop}"/>');
		</c:forTokens>
		
        for(var i=0; i<stopVal.length; i++) {
           	if(i % 10 == 0) {
        		$table.append(tr);
           	}
           	$table.find("tr:last-child()").append(td);
        	$table.find("[name=progrmComposition]").eq(i).val(stopVal[i]);
        }
        
        var tdSize = $table.find("tr:last-child()").find("td").length;
        
        if(tdSize < 10) {
	        for(var i=tdSize; i<10; i++) {
	        	$table.find("tr:last-child()").append(td);
	        	$table.find("tr:last-child()").find("[name=progrmComposition]").eq(i).val("");
	        }
        }
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
	            			  $('#newImg').attr('style', 'display:""');
	            			  $('#newImg')[0].style.display = "";
	            			  $('#newImg').attr('src', e.target.result);
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
				$('img[name=modiImg]')[0].style.display = "none";
			}
		})
	}
	
	$.initView = function(){
		$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
		$("#listBtn").goBackList($.searchAction);
		$.setValidation();
		$("#saveBtn").saveBtnOnClickEvt();
		$("#progrmComposition").stopBtnClickEvt();
		$("#div_file_display11").removeImg();
		$("#div_file_display12").imgView();
		if('<c:out value="${common.baseType[1].key() }"/>'=='<c:out value="${common.procType}"/>') $.selectDetail();
		if($("input[name=lectureId]").is(":checked")) $("#divRadio input").not(":checked").attr("disabled", "disabled");
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
						<input type="hidden" name="atchFileId" value='<c:out value="${result.ATCH_FILE_ID}"/>'>
						
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
                                    <td colspan="3">
                                        <c:forEach var="list" items="${codeMap }" varStatus="idx">
                                            <label class="checkbox checkboxCenter col">
                                                <c:if test="${idx.index eq '0'}">
                                                    <input type="checkbox" name="courses0 <c:out value='${idx.index + 1}'/>" <c:out value="${result.COURSES eq list.CODE ? 'checked=checked':''}"/> value="<c:out value='${list.CODE }'/>"><i></i>
                                                </c:if>
                                                <c:if test="${idx.index eq '1'}">
                                                    <input type="checkbox" name="ourses0 <c:out value='${idx.index + 1}'/>" <c:out value="${result.COURSES eq list.CODE ? 'checked=checked':''}"/> value="<c:out value='${list.CODE }'/>"><i></i>
                                                </c:if>
                                                <c:if test="${idx.index eq '2'}">
                                                    <input type="checkbox" name="courses0 <c:out value='${idx.index + 1}'/>" <c:out value="${result.COURSES eq list.CODE ? 'checked=checked':''}"/> value="<c:out value='${list.CODE }'/>"><i></i>
                                                </c:if>
                                            </label>
                                            <span class="col mt7 ml30 mr5"><c:out value="${list.CODE_NM }"/></span>
                                        </c:forEach>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">기준과목코드 선택</th>
                                    <td colspan="3">
                                        <div class="inline-group" id="divRadio">
                                            <c:forEach var="list" items="${codeList}" varStatus="status">
					                            <label class="radio">
					                                <input type="radio" id="lectureId<c:out value='${status.index}'/>" name="lectureId" value="<c:out value='${list.CODE}'/>" <c:out value="${result.LECTURE_REPLC_ID eq list.CODE? 'checked=checked':''}"/>><i></i><c:out value="${list.CODE_NM}"/>
					                            </label>
                                            </c:forEach>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">강의시간</th>
                                    <td colspan="3">
                                        <label class="input w80 col">
                                            <input type="text" id="atnlcTime" name="atnlcTime" value="<c:out value='${result.ATNLC_TIME}'/>">
                                        </label>
                                    </td>
                                </tr>
								<tr>
                                    <th scope="row">교육목표 </th>
                                    <td colspan="5" class="board_contents">
                                        <textarea id="edcGoal" name="edcGoal" class="part_long board_contents" style="width: 100%; min-width: 100%;"><c:out value="${result.EDC_GOAL}"/></textarea>
                                    </td>
                                </tr>
								<tr>
                                    <th scope="row">프로그램구성 </th>
                                    <td colspan="5">
                                        <button class="btn btn-primary ml2 addBtn" id="progrmComposition" type="button">
                                            <i class="fa fa-plus-square" title="추가"></i> 추가
                                        </button>
                                        
                                        <table>
                                            <tbody id="stopTbody">
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">대표이미지 </th>
                                    <td colspan="5">
                                        <c:out value="${markup}" escapeXml="false"/>
                                        <c:set var="fileNm" value="<c:out value='${result.STRE_FILE_NM }'/>" />
                                            <c:if test="${not empty fileNm }">
                                                <img name="modiImg" src="/utl/web/imageSrc.do?path=mngr/<c:out value='${result.STRE_FILE_NM }'/>" width="240" height="135"/>
                                            </c:if>
                                                <img id="newImg" src="#" alt="your image" style="display:none" width="240" height="135"/>
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