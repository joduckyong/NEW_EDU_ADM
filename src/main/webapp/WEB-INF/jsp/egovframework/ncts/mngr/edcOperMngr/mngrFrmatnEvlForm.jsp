<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">

$(function(){
	// ckEditor Height 설정
	CKEDITOR.replace('examWransNoteList',{height : 200});
	
	var baseInfo = {
			insertKey : '<c:out value="${common.baseType[0].key() }"/>',
            updateKey : '<c:out value="${common.baseType[1].key() }"/>',
            deleteKey : '<c:out value="${common.baseType[2].key() }"/>',
            lUrl : "/ncts/mngr/edcOperMngr/mngrFrmatnEvlList.do",
            fUrl : "/ncts/mngr/edcOperMngr/mngrFrmatnEvlForm.do",
            dUrl : "/ncts/mngr/edcOperMngr/mngrDeleteFrmatnEvl.do",
	}	
	
	var formCount = 0;
	var count = 0;
	
	$.setValidation = function(){
		validator = $("#iForm").validate({
			ignore : "",
			rules: {
				lectureId               : {required       : ['강의명']},
				examNoList                  : {required       : ['형성평가번호']},
			}
		});
	}
	
	$.saveProc = function(){
		if(!confirm("저장하시겠습니까?")) return;
		
		var isCheck = true;
		
		$("[name^=iForm]").each(function(){
			var $this = $(this);
			if($this.find("input[name='correctAnswerList']:checked").length <= 0) {
				alert("정답을 체크해주시기 바랍니다.");
				isCheck = false;
				return false;
			}
		})
		
		if(isCheck) {
			var formIdx = 0;
			
			$.each(CKEDITOR.instances, function(i,v){
				if(1 < document.forms.length-4){
					$.makeSnapshot(document.iForm[formIdx], i);
					formIdx++;
				}else{
				    $.makeSnapshot(document.iForm, i);
				}
			})
			
	        if(!$('input[name=examSqno]').val()){
	            $('input[name=examSqno]').val(0);	
	        }
	        
	        $.beforSubmitRenameForModelAttribute();
	
	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/edcOperMngr/mngrProgressFrmatn.do",
	            data: $("form").serialize(),
	            dataType: "json",
	            success: function(data) {
	                if(data.success == "success"){
	                	alert(data.msg);
	                    if(data.success == "success") location.replace(baseInfo.lUrl);    
	                }
	            }
	        });  
		}
		
	}
	
	$.beforSubmitRenameForModelAttribute = function() {
        var itemNm = "";
        var itemNo = "";
        for(var i=0; i < document.forms.length - 4; i++){
        	if(i != 0){
        		$("#iForm"+i+" [name='reitemNm']").each(function(index){
        			if(itemNm){
        				itemNm += "|" + $(this).val();
        			}else{
        				itemNm = $(this).val();
        			}
        		});
        		
        		$("#iForm"+i+" [name='itemNmList']").val(itemNm);
        		
        		itemNm = "";
        		
        		$("#iForm"+i+" [name='itemNo']").each(function(index){
                    if(itemNo){
                    	itemNo += "|" + $(this).val();
                    }else{
                        itemNo = $(this).val();
                    }
                });
                
                $("#iForm"+i+" [name='itemNoList']").val(itemNo);
                
                itemNo = "";
        	} else{
        		$("#iForm [name='reitemNm']").each(function(index){
                    if(itemNm){
                    	itemNm += "|" + $(this).val();
                    }else{
                    	itemNm = $(this).val();
                    }
                });
        		
        		$("#iForm [name='itemNmList']").val(itemNm);

        		itemNm = "";
        		
        		$("#iForm [name='itemNo']").each(function(index){
                    if(itemNo){
                    	itemNo += "|" + $(this).val();
                    }else{
                        itemNo = $(this).val();
                    }
                });
                
                $("#iForm [name='itemNoList']").val(itemNo);
                
                itemNo = "";
        	}
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
	
	$.fn.addBtnOnClickEvt = function(){
        var _this = $(this);
        _this.on("click", function(){
        	formCount++;
        	count++;
        	var _form = $('<div class="fR mt5 mb5" id="delBtn'+formCount+'" name="delBtn">'+                          
                          '<label class="input col">'+
                          '<button class="btn btn-danger ml10 rowDelBtn" type="button" style="padding: 7px 13px;" data-type="table">'+
                          '<i class="fa fa-cut" title="삭제"></i>삭제'+
                          '</button>'+
                          '</label>'+
                          '</div>'+
        			      '<div class="row" id="addTag'+formCount+'">'+
        			      '<article class="col-md-12 col-lg-12">'+
        			      '<form name="iForm" id="iForm'+formCount+'" method="post" class="smart-form" enctype="multipart/form-data">'+
        			      '<input type="hidden" id="itemNmList'+formCount+'" name="itemNmList" value=">'+
        			      '<input type="hidden" id="itemNoList'+formCount+'" name="itemNoList" value=">'+
        			      '<input type="hidden" id="lectureId'+formCount+'" name="lectureId'+formCount+'" value=">'+
                          '<input type="hidden" id="examSqno'+formCount+'" name="examSqno'+formCount+'" value="">'+
                          '<table class="table table-bordered tb_type03">'+
                          '<colgroup><col width="10%"><col width="5%"><col width="10%"><col width="42%"><col width="10%"><col width="23%"></colgroup>'+
                          '<tbody><tr>'+
                          '<th scope="row">형성평가번호</th>'+
                          '<td><label class="input w15 col">'+
                          '<input type="text" id="examNoList'+formCount+'" name="examNoList" value="">'+
                          '</label>'+
                          '</td>'+
                          '<th scope="row">형성평가명</th>'+
                          '<td><label class="input w500 col">'+
                          '<input type="text" id="examNmList'+formCount+'" name="examNmList" value="">'+
                          '</label>'+
                          '</td>'+
                          '<th scope="row">항목유형</th>'+
                          '<td>'+
                          '<select id="examTypeCdList'+formCount+'" name="examTypeCdList" class="form-control w100" style="text-align-last:center;">'+
                          '<option value="">선택</option>'+
                          '<c:forEach var="codeMap" items="${codeMap }" varStatus="idx">'+
                          '<option value="<c:out value='${codeMap.CODE}'/>"><c:out value="${codeMap.CODE_NM }"/></option>'+
                          '</c:forEach>'+
                          '</select>'+
                          '</td>'+
                          '</tr>'+
                          '<tr>'+
                          '<th scope="row">형성평가<br/>오답설명 </th>'+
                          '<td colspan="5" class="board_contents">'+
                          '<textarea id="examWransNoteList'+count+'" name="examWransNoteList" class="part_long board_contents" style="width: 100%; min-width: 100%;"></textarea>'+
                          '</td>'+
                          '</tr>'+
                          '</tbody>'+
                          '</table>'+
                          '<table class="table table-bordered tb_type03" >'+
                          '<colgroup>'+
                          '<col width="10%">'+
                          '<col width="75%">'+
                          '<col width="5%">'+
                          '<col width="10%">'+
                          '</colgroup>'+
                          '<tbody id="seTable'+formCount+'">'+
                          '</tbody>'+
                          '</table>'+
        			      '</form></article></div>');
            $("#widget-grid").append(_form);
            
            CKEDITOR.replace('examWransNoteList'+count,{height : 200});
        })
    }
	
	$.fn.settingLectreNm = function(){
		var _this = $(this);
		_this.on("change", function(){
			$("#lectureId").val($("#sGubun").val());
		})
	}
	
	$.fn.addTag = function(){
		var _this = $(this);
		var correctAnswer ='<%= request.getAttribute("correctAnswer") %>';
		var reitemNm1 ='<%= request.getAttribute("reitemNm1") %>';
		var reitemNm2 ='<%= request.getAttribute("reitemNm2") %>';
		var reitemNm3 ='<%= request.getAttribute("reitemNm3") %>';
		var reitemNm4 ='<%= request.getAttribute("reitemNm4") %>';
		var reitemNm5 ='<%= request.getAttribute("reitemNm5") %>';
		var itemNo1 ='<%= request.getAttribute("itemNo1") %>';
		var itemNo2 ='<%= request.getAttribute("itemNo2") %>';
		var itemNo3 ='<%= request.getAttribute("itemNo3") %>';
		var itemNo4 ='<%= request.getAttribute("itemNo4") %>';
		var itemNo5 ='<%= request.getAttribute("itemNo5") %>';
		
		switch(_this.val()){
			case "01" : row = {row : 1, CORRECT_ANSWER : correctAnswer }
			            $("#seTable").handlerbarsCompile($("#seTable-template"), row);
			            $("#reitemNm").val(reitemNm1 !="null" ? reitemNm1 : "");
	                    $("#itemNo").val(itemNo1 !="null" ? itemNo1 : 0);
			    break;
			case "02" : row = {row : 2};
				        $("#seTable").handlerbarsCompile($("#seTable-template-row"), row);
				        $("#reitemNm1").val(reitemNm1 !="null" ? reitemNm1 : "");
				        $("#reitemNm2").val(reitemNm2 !="null" ? reitemNm2 : "");
                        $("#itemNo1").val(itemNo1 !="null" ? itemNo1 : 0);
                        $("#itemNo2").val(itemNo2 !="null" ? itemNo2 : 0);
			    break;
			case "03" : row = {row : 3}; 
				        $("#seTable").handlerbarsCompile($("#seTable-template-row"), row);
				        $("#reitemNm1").val(reitemNm1 !="null" ? reitemNm1 : "");
                        $("#reitemNm2").val(reitemNm2 !="null" ? reitemNm2 : "");
				        $("#reitemNm3").val(reitemNm3 !="null" ? reitemNm3 : "");
                        $("#itemNo1").val(itemNo1 !="null" ? itemNo1 : 0);
                        $("#itemNo2").val(itemNo2 !="null" ? itemNo2 : 0);
                        $("#itemNo3").val(itemNo3 !="null" ? itemNo3 : 0);
			    break;
			case "04" : row = {row : 4};  
				        $("#seTable").handlerbarsCompile($("#seTable-template-row"), row);
				        $("#reitemNm1").val(reitemNm1 !="null" ? reitemNm1 : "");
                        $("#reitemNm2").val(reitemNm2 !="null" ? reitemNm2 : "");
                        $("#reitemNm3").val(reitemNm3 !="null" ? reitemNm3 : "");
				        $("#reitemNm4").val(reitemNm4 !="null" ? reitemNm4 : "");
                        $("#itemNo1").val(itemNo1 !="null" ? itemNo1 : 0);
                        $("#itemNo2").val(itemNo2 !="null" ? itemNo2 : 0);
                        $("#itemNo3").val(itemNo3 !="null" ? itemNo3 : 0);
                        $("#itemNo4").val(itemNo4 !="null" ? itemNo4 : 0);
			    break;
			case "05" : row = {row : 5};  
				        $("#seTable").handlerbarsCompile($("#seTable-template-row"), row);
				        $("#reitemNm1").val(reitemNm1 !="null" ? reitemNm1 : "");
                        $("#reitemNm2").val(reitemNm2 !="null" ? reitemNm2 : "");
                        $("#reitemNm3").val(reitemNm3 !="null" ? reitemNm3 : "");
                        $("#reitemNm4").val(reitemNm4 !="null" ? reitemNm4 : "");
				        $("#reitemNm5").val(reitemNm5 !="null" ? reitemNm5 : "");
                        $("#itemNo1").val(itemNo1 !="null" ? itemNo1 : 0);
                        $("#itemNo2").val(itemNo2 !="null" ? itemNo2 : 0);
                        $("#itemNo3").val(itemNo3 !="null" ? itemNo3 : 0);
                        $("#itemNo4").val(itemNo4 !="null" ? itemNo4 : 0);
                        $("#itemNo5").val(itemNo5 !="null" ? itemNo5 : 0);
			    break;
			default : $("#seTable").handlerbarsCompile($("#seTable-empty"));
			    break;
		}
		
		if(_this.val() != "01") $("[name='correctAnswerList'][value=0"+ correctAnswer +"]").prop("checked", true);
	}
	
	$(document).on("change", "select[name='examTypeCdList']", function(){
		var getAttr = this.getAttribute("id");
        var tagNumber = getAttr.split("examTypeCdList");

        if(!tagNumber[1]){
        	$("#examTypeCdList").addTag();
        } else{
	        switch($(this).val()){
	            case "01" : $("#seTable"+tagNumber[1]).handlerbarsCompile($("#seTable-template"));
	                break;
	            case "02" : data = {row : 2, 
	            		            formCnt : tagNumber[1]};
	                        $("#seTable"+tagNumber[1]).handlerbarsCompile($("#seTable-template-row"), data);
	                break;
	            case "03" : data = {row : 3, 
	                                formCnt : tagNumber[1]};
	                        $("#seTable"+tagNumber[1]).handlerbarsCompile($("#seTable-template-row"), data);
	                break;
	            case "04" : data = {row : 4, 
	                                formCnt : tagNumber[1]}; 
	                        $("#seTable"+tagNumber[1]).handlerbarsCompile($("#seTable-template-row"), data);
	                break;
	            case "05" : data = {row : 5, 
	                                formCnt : tagNumber[1]};
	                        $("#seTable"+tagNumber[1]).handlerbarsCompile($("#seTable-template-row"), data);
	                break;
	            default : $("#seTable"+tagNumber[1]).handlerbarsCompile($("#seTable-empty"));
	                break;
	        }
        }
    });
	
	$(document).on("click", "div[name=delBtn]", function(){
		var getAttr = this.getAttribute("id");
		var tagNumber = getAttr.split("delBtn");
        var modiFormCnt = 1;
		
		this.remove();
			
        $("#addTag"+tagNumber[1]).remove();
        $("#examWransNoteList"+tagNumber[1]+"Snapshot").remove();
        
        CKEDITOR.remove(CKEDITOR.instances["examWransNoteList"+tagNumber[1]]);
        
        $("#examWransNoteList"+tagNumber[1]).remove();
        for(var i=1; i <= formCount; i++){
        	if($("#iForm"+i).length){
        		$("#iForm"+i).attr('id', 'iForm'+modiFormCnt);
        		$("#lectureId"+i).attr('id', 'lectureId'+modiFormCnt);
        		$("#examSqno"+i).attr('id', 'examSqno'+modiFormCnt);
        		$("#examNoList"+i).attr('id', 'examNoList'+modiFormCnt);
        		$("#examNmList"+i).attr('id', 'examNmList'+modiFormCnt);
        		$("#cke_examWransNoteList"+i).attr('id', 'cke_examWransNoteList'+modiFormCnt);
        		$("#seTable"+i).attr('id', 'seTable'+modiFormCnt);

        		modiFormCnt++;
        	}
        }
        
        formCount = modiFormCnt-1;
	});
	
	$.initView = function(){
		$.setValidation();
		$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
		$("#listBtn").goBackList($.searchAction);
		$("#saveBtn").saveBtnOnClickEvt();
		$("#examNoList").onlyNumber(5);
		$(".onlyNum").onlyNumber(4);
		$("#addBtn").addBtnOnClickEvt();
		$("#sGubun").settingLectreNm();
		
		$("#examTypeCdList").addTag();
		if($("input[name='procType']").val() == baseInfo.updateKey) $("#addBtn").hide();
	}
	
	$.makeSnapshot = function(form,name){
	    if($.isNull(form)) return;

	    var $form = $(form);
	    var objNm = name + 'Snapshot';
	    var selector = "#"+objNm;
	    
	    $form.find(selector).remove();
	    $form.append('<input type="hidden" id="'+objNm+'" name="examWransNoteListSnapshot">')
	        .find(selector).val(getSnapshot(name));
	        
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
				<input type="hidden" id="searchKeyword1" name="searchKeyword1" class="form-control" value="<c:out value='${param.searchKeyword1}'/>">
				<div class="fL wp50">
					<ul class="searchAreaBox">
					    <li class="smart-form ml5"><label class="label">강의명</label></li>
                        <li class="w150 ml5">
                            <select id="sGubun" name="sGubun" class="form-control" style="text-align-last:center;">
                                <option value="">선택</option>
                                    <c:forEach var="lecIdList" items="${lecIdList }" varStatus="idx">
                                        <option value="<c:out value='${lecIdList.LECTURE_ID}'/>" <c:out value="${result.LECTURE_ID eq lecIdList.LECTURE_ID ? 'selected=selected':'' }"/>><c:out value="${lecIdList.LECTURE_NM }"/></option>
                                    </c:forEach>
                            </select>
                        </li>
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
		
		<div class="content mb5">
			<!-- row 메뉴조회 시작 -->
			<div class="fR mt5 mb5">                                 
                <button class="btn btn-primary" id="addBtn" type="button" style="padding: 6px 12px; margin-right: 5px;" ><i class="fa fa-edit" title="추가"></i>추가</button>
            </div>
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<form name="iForm" id="iForm" method="post" class="smart-form" enctype="multipart/form-data">
						<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
						<input type="hidden" id="lectureId" name="lectureId" value="<c:out value='${result.LECTURE_ID}'/>">
						<input type="hidden" id="itemNmList" name="itemNmList" value="">
						<input type="hidden" id="itemNoList" name="itemNoList" value="">
						<input type="hidden" id="examSqno" name="examSqno" value="<c:out value='${result.EXAM_SQNO}'/>">
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="10%">
								<col width="5%">
								<col width="10%">
								<col width="42%">
								<col width="10%">
								<col width="23%">
							</colgroup>
							<tbody>
								<tr>
                                    <th scope="row">형성평가번호</th>
                                    <td><label class="input w15 col">
                                            <input type="text" id="examNoList" name="examNoList" value="<c:out value='${result.EXAM_NO}'/>">
                                        </label>
                                    </td>
                                    <th scope="row">형성평가명</th>
                                    <td><label class="input w500 col">
                                            <input type="text" id="examNmList" name="examNmList" value="<c:out value='${result.EXAM_NM}'/>">
                                        </label>
                                    </td>
                                    <th scope="row">항목유형</th>
                                    <td>
                                        <select id="examTypeCdList" name="examTypeCdList" class="form-control w100" style="text-align-last:center;">
                                            <option value="">선택</option>
                                                <c:forEach var="codeMap" items="${codeMap }" varStatus="idx">
                                                    <option value="<c:out value='${codeMap.CODE}'/>" <c:out value="${result.EXAM_TYPE_CD eq codeMap.CODE ? 'selected=selected':'' }"/>><c:out value="${codeMap.CODE_NM }"/></option>
                                                </c:forEach>
                                        </select>
                                    </td>
                                </tr>
								<tr>
									<th scope="row">형성평가<br/>오답설명 </th>
									<td colspan="5" class="board_contents">
										<textarea id="examWransNoteList" name="examWransNoteList" class="part_long board_contents" style="width: 100%; min-width: 100%;"><c:out value="${result.EXAM_WRANS_NOTE}"/></textarea>
									</td>
								</tr>
							</tbody>
						</table>
						<table class="table table-bordered tb_type03" >
						    <colgroup>
                                <col width="10%">
                                <col width="75%">
                                <col width="5%">
                                <col width="10%">
                            </colgroup>
                            <tbody id="seTable">
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
<script id="seTable-template" type="text/x-handlebars-template">
<tr>
    <th colspan="2">항목명</th>
    <th colspan="2">정답체크</th>
</tr>
<tr>
    <td colspan="2">
        <label class="input">
            <input id="reitemNm" type="text" name="reitemNm" style="width:100%"/>
            <input id="itemNo" type="hidden" name="itemNo" style="width:100%" value = 0/>
        </label>
    </td>
    <td colspan="2" style="text-align: center">
        <div class="inline-group col">
            <label class="radio">
                <input type="radio" value="01" name="correctAnswerList" {{#ifeq CORRECT_ANSWER 'O'}}checked= "checked"{{/ifeq}}><i></i>O
            </label>
            <label class="radio">
                <input type="radio" value="02" name="correctAnswerList"} {{#ifeq CORRECT_ANSWER 'X'}}checked= "checked"{{/ifeq}}><i></i>X
            </label>
        </div>
    </td>
</tr>
</script>
<script id="seTable-template-row" type="text/x-handlebars-template">
<tr>
    <th>항목번호</th>
    <th colspan="2">항목명</th>
    <th>정답체크</th>
</tr>
{{#ifge row 2 }}
<tr>
    <td style="text-align: center">1</td>
    <td colspan="2">
        <label class="input">
            <input id="reitemNm1" type="text" name="reitemNm" style="width:100%"/>
            <input id="itemNo1" type="hidden" name="itemNo" style="width:100%" value = 0/>
        </label>
    </td>
    <td>    <label class="radio">
                <input type="radio" value="01" name="correctAnswerList" ><i></i>&nbsp;
            </label>
    </td>
</tr>
<tr>
    <td style="text-align: center">2</td>
    <td colspan="2">
        <label class="input">
            <input id="reitemNm2" type="text" name="reitemNm" style="width:100%"/>
            <input id="itemNo2" type="hidden" name="itemNo" style="width:100%" value = 0/>
        </label>
    </td>
    <td>
        <label class="radio">
            <input type="radio" value="02" name="correctAnswerList" ><i></i>&nbsp;
        </label>
    </td>
</tr>
{{/ifge}}
{{#ifge row 3 }}
<tr>
    <td style="text-align: center">3</td>
    <td colspan="2">
        <label class="input">
            <input id="reitemNm3" type="text" name="reitemNm" style="width:100%"/>
            <input id="itemNo3" type="hidden" name="itemNo" style="width:100%" value = 0/>
        </label>
    </td>
    <td>
        <label class="radio">
            <input type="radio" value="03" name="correctAnswerList" ><i></i>&nbsp;
        </label>
    </td>
</tr>
{{/ifge}}
{{#ifge row 4 }}
<tr>
    <td style="text-align: center">4</td>
    <td colspan="2">
        <label class="input">
            <input id="reitemNm4" type="text" name="reitemNm" style="width:100%"/>
            <input id="itemNo4" type="hidden" name="itemNo" style="width:100%" value = 0/>
        </label>
    </td>
    <td>
        <label class="radio">
            <input type="radio" value="04" name="correctAnswerList" ><i></i>&nbsp;
        </label>
    </td>
</tr>
{{/ifge}}
{{#ifge row 5 }}
<tr>
    <td style="text-align: center">5</td>
    <td colspan="2">
        <label class="input">
            <input id="reitemNm5" type="text" name="reitemNm" style="width:100%"/>
            <input id="itemNo5" type="hidden" name="itemNo" style="width:100%" value = 0/>
        </label>
    </td>
    <td>
        <label class="radio">
            <input type="radio" value="05" name="correctAnswerList" ><i></i>&nbsp;
        </label>
    </td>
</tr>
{{/ifge}}
</script>
<script id="seTable-empty" type="text/x-handlebars-template">
</script>
<!-- END MAIN CONTENT -->