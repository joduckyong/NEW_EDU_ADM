 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
#detailTable img {width:100% !important; height: auto !important;}
</style> 
 
<script type="text/JavaScript" src="<c:url value='/html/com/cmm/utl/ckeditor/ckeditor.js' />?<c:out value='${currentTimeMillis}'/>"></script>
<script type="text/JavaScript" src="<c:url value='/js/egovframework/ckeditFun.js' />"></script>
<script type="text/javascript">
$(function(){
	// ckEditor Height 설정
    CKEDITOR.replace('contents',{height : 150});
	
	var baseInfo = {
			insertKey : "<c:out value='${common.baseType[0].key() }'/>",
            updateKey : "<c:out value='${common.baseType[1].key() }'/>",
            deleteKey : "<c:out value='${common.baseType[2].key() }'/>",
            lUrl : "/ncts/mngr/cmptMngr/mngrCmptReqstList.do",
            pUrl : "/ncts/mngr/cmptMngr/mngrCmptReqstForm.do",
            dUrl : "/ncts/mngr/cmptMngr/deleteCmptReqst.do",
            uUrl : "/ncts/mngr/cmptMngr/updateReflctYn.do",
	}
    
    $.dataDetail = function(index){
		if($.isNullStr(index)) return false;
		document.sForm.cmptSeq.value = index;

    	$.ajax({
            type: 'POST',
            url: "/ncts/mngr/cmptMngr/mngrCmptReqstDetail.do",
            data: $("#sForm").serialize(),
            dataType: "json",
            success: function(data) {
            	if(data.success == "success"){	
                	var text = data.de.CMPT_REQST_CONTENTS_ANSWER;
                	$("#iFormcmptSeq").val(data.de.CMPT_SEQ);
                    CKEDITOR.instances.contents.setData(text);
                    
                    if(data.de.ANSWER_CONFIRM_AT == "Y") $("#answerConfirmAt").prop("checked", true);
                    else $("#answerConfirmAt").prop("checked", false);
                	$("#detailTable").handlerbarsCompile($("#detail-template"), data.de);
                    
            	}
            }
        })
    }
	
    $.fn.procBtnOnClickEvt = function(url, key, active){
		var _this = $(this);
		_this.on("click", function(){
			if(baseInfo.insertKey != key){
				if($("input.index:checked").size() <= 0) {
					alert("항목을 선택하시기 바랍니다.");
					return false;
				}else{
					document.sForm.cmptSeq.value = $("input.index:checked").val();
				}
			}else{
				document.sForm.cmptSeq.value = "";
			}
			
			if(baseInfo.deleteKey == key){
				$.delAction(url, key, active, this);
			}else{
				$.procAction(url, key);	
			}
		})
	}
    
    $.procAction = function(pUrl, pKey){
		with(document.sForm){
			procType.value = pKey;
			action = pUrl;
			target='';
			submit();
		}
	}
    
    $.delAction = function(pUrl, pKey, active, _thisObj){
    	if(active){
    		var reflctYn = _thisObj.dataset.reflctYn;
    		
            if(reflctYn == "Y")if(!confirm("미반영 처리하시겠습니까?")) return false;	
            if(reflctYn == "N")if(!confirm("반영 처리하시겠습니까?")) return false;	
            document.sForm.reflctYn.value = reflctYn;
    	} else {
    		if(!confirm("삭제하시겠습니까?")) return false;
    	}
    	
        document.sForm.procType.value = pKey;
        
        $.ajax({
            type: 'POST',
            url: pUrl,
            data: $("#sForm").serialize(),
            dataType: "json",
            success: function(data) {
                alert(data.msg);
                if(data.success == "success"){
                    $.searchAction();
                }
            }
        });
    }
    
    $.sFormAjax = function(pUrl){
    	$.ajax({
            type: 'POST',
            url: pUrl,
            data: $("#sForm").serialize(),
            dataType: "json",
            success: function(data) {
                alert(data.msg);
                if(data.success == "success"){
                    $.searchAction();
                }
            }
        });
    }
    
    $.searchAction = function(){
        var no = 1;
        
        if(typeof(arguments[0]) != "undefined") no = arguments[0].pageNo;
        
        with(document.sForm){
            currentPageNo.value = no;
            action = baseInfo.lUrl;
            target='';
            submit();
        }
    }
    
    $.fn.answerSave = function(){
        var _this = $(this);
        _this.on("click", function(){
        //  if(!confirm("답변하시겠습니까?")) return false;
            makeSnapshot(document.iForm, "contents");
            
            if(!$("input[name=contentsSnapshot]").val()){
                alert("답변을 작성해 주십시오.");
                
                return false;
            }
            
            if(document.iForm.iFormcmptSeq.value){
                document.iForm.procType.value = baseInfo.updateKey;
            }
            
            $("#iForm").ajaxForm({
                type: 'POST',
                url: "/ncts/mngr/cmptMngr/mngrCmptAnswer.do",
                dataType: "json",
                success: function(result) {
                    alert(result.msg);
                    if(result.success == "success") location.replace(baseInfo.lUrl);
                }
            });

            $("#iForm").submit();
        })
    }
    
    $.fn.updateAnswerConfirmAt = function(){
        var _this = $(this);
        _this.on("click", function(){
        	document.iForm.procType.value = baseInfo.updateKey;
            $("#iForm").ajaxForm({
                type: 'POST',
                url: "/ncts/mngr/cmptMngr/mngrCmptConfirmAt.do",
                dataType: "json",
                success: function(result) {
                    alert(result.msg);
                    if(result.success == "success") location.replace(baseInfo.lUrl);
                }
            });

            $("#iForm").submit();
        })
    }
    
    $.initView = function(){
    	$.onClickTableTr();
    	$(".inputcal").each(function(){ $(this).userDatePicker({ yearRange : '1900:'+currentYear}); });
        $("#searchBtn").searchBtnOnClickEvt($.searchAction);
		$("#saveBtn").procBtnOnClickEvt(baseInfo.pUrl, baseInfo.insertKey);
		$("#updBtn").procBtnOnClickEvt(baseInfo.pUrl, baseInfo.updateKey);
		$("#delBtn").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey);
        $("button[name=reflctBtn]").procBtnOnClickEvt(baseInfo.uUrl, baseInfo.deleteKey, 'active');
        $("#answerBtn").answerSave();
        $("#answerConfirmAt").updateAnswerConfirmAt();
        $("#sGubun").change(function(){
        	if($(this).val()== 1){
        		$(".selectDate").css("display","none");
        		$(".selectMonth").css("display","none");
        		$(".selectYear").css("display","block");
        		$(".selectPeriod").css("display","none");
        	}else if($(this).val()== 2){
        		$(".selectYear").css("display","block");
        		$(".selectMonth").css("display","block");
        		$(".selectDate").css("display","none");
        		$(".selectPeriod").css("display","none");        		
        	} else if($(this).val()== 3){
        		$(".selectYear").css("display","none");
        		$(".selectDate").css("display","block");
        		$(".selectMonth").css("display","none");
        		$(".selectPeriod").css("display","none");
        	} else if($(this).val()== 4) {
        		$(".selectYear").css("display","none");
        		$(".selectDate").css("display","none");
        		$(".selectMonth").css("display","none");
	    		$(".selectPeriod").css("display","block");
        	}
        });
		if($("#sGubun").val()== 1){
			$(".selectDate").css("display","none");
    		$(".selectMonth").css("display","none");
    		$(".selectYear").css("display","block");
    		$(".selectPeriod").css("display","none");
		}else if($("#sGubun").val()== 2){
			$(".selectYear").css("display","block");
    		$(".selectMonth").css("display","block");
    		$(".selectDate").css("display","none");
    		$(".selectPeriod").css("display","none");
		}else if($("#sGubun").val()== 3){
			$(".selectYear").css("display","none");
    		$(".selectDate").css("display","block");
    		$(".selectMonth").css("display","none");
    		$(".selectPeriod").css("display","none");
		}else if($("#sGubun").val()== 4){
			$(".selectYear").css("display","none");
    		$(".selectDate").css("display","none");
    		$(".selectMonth").css("display","none");
    		$(".selectPeriod").css("display","block");
		}
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
                <input type="hidden" name="cmptSeq" id="cmptSeq"  value="">
                <input type="hidden" name="cmptSeqOld" id="cmptSeqOld" value="">
                <input type="hidden" name="reflctYn" id="reflctYn" value="">
                <input type="hidden" name="reflctYmd" value="">
                <input type="hidden" name="reflctHH" value="">
                <input type="hidden" name="reflctMM" value="">
                <div class="fL wp70">
                    <ul class="searchAreaBox">
                        <%-- <li class="smart-form ml5">
                            <label class="label">작성자</label>
                        </li>
                        <li class="w100">
                            <select id="sGubun1" name="sGubun1" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap }" varStatus="idx">
                                    <c:if test="${idx.index gt 0}">
                                        <c:if test="${idx.index lt 5}">
                                            <option value="${list.CODE }" ${param.sGubun1 eq list.CODE ? 'selected="selected"':'' }>${list.CODE_NM }</option>
                                        </c:if>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </li> --%>
                        <li class="smart-form ml5"><label class="label">일자 </label></li>
                        <li class="w100">
						<select id="sGubun" name="sGubun" class="form-control">
							<option value="">선택</option>
						    <option value="01" <c:out value="${param.sGubun eq '01' ?'selected=selected':'' }"/>>연도별</option>
							<option value="02" <c:out value="${param.sGubun eq '02' ?'selected=selected':'' }"/>>월별</option>
							<option value="03" <c:out value="${param.sGubun eq '03' ?'selected=selected':'' }"/>>연도기간별</option>
							<%-- <option value="04" ${param.sGubun eq '04' ?'selected="selected"':'' }>기간별</option> --%>
						</select>
						</li>
						<div class="selectYear" style="display:none">
	                        <li class="ml2 mr2">
	                            <select id="sYear" name="sYear" class="form-control">
	                                <option value="">연도선택</option>
	                                <c:forEach var="year" items="${cal.year }">
										<option value="<c:out value='${year }'/>" <c:out value="${param.sYear eq year?'selected=selected':'' }"/> ><c:out value="${year }"/></option>
									</c:forEach>
	                            </select> <i></i>
	                        </li>
						</div>
						<div class="selectMonth" style="display:none">
							<li class="ml5" id="sMon">
							<select id="sMonth" name="sMonth" class="form-control">
								<option value="">선택</option>
								<c:forEach var="month" items="${cal.month }">
									<option value="<c:out value='${month }'/>" <c:out value="${param.sMonth eq month?'selected=selected':'' }"/> ><c:out value="${month }"/>월</option>
								</c:forEach>
							</select> <i></i>
                        </li>
						</div>
                        <div class="selectDate" style="display:none">
	                        <li class="ml2 mr2">
	                            <select id="sDate01" name="sDate01" class="form-control">
	                                <option value="">연도선택</option>
	                                <c:forEach var="year" items="${cal.year }">
										<option value="<c:out value='${year }'/>" <c:out value="${param.sDate01 eq year?'selected=selected':'' }"/> ><c:out value="${year }"/></option>
									</c:forEach>
	                            </select> <i></i>
	                        </li>
	                        <li class="mt7">
	                            <label class="label">-</label>
	                        </li>
	                        <li class="ml2 mr2">
	                            <select id="sDate02" name="sDate02" class="form-control">
	                                <option value="">연도선택</option>
	                                <c:forEach var="year" items="${cal.year }">
										<option value="<c:out value='${year }'/>" <c:out value="${param.sDate02 eq year?'selected=selected':'' }"/> ><c:out value="${year }"/></option>
									</c:forEach>
	                            </select> <i></i>
	                        </li>
                        </div>
                        <%-- <div class="selectPeriod" style="display:none">
	  						<li class="smart-form ml5">
	                            <label class="input w120"> <i class="icon-append fa fa-calendar"></i>
	                                <input type="text" class="date inputcal sDate" id="sDate03" name="sDate03" value="${param.sDate03 }" data-name="시작일"/>
	                            </label>
	                        </li>
	                        
	                        <li class="ml5 mr5 mt7">
	                            <label class="label">-</label>
	                        </li>
	                        	                        
							<li class="smart-form ml5">
	                            <label class="input w120"> <i class="icon-append fa fa-calendar"></i>
	                                <input type="text" class="date inputcal sDate" id="sDate04" name="sDate04" value="${param.sDate04 }" data-name="종료일"/>
	                            </label>
	                        </li>
						</div>	 --%>
                        <li class="smart-form ml5"><label class="label">요청사항 </label></li>
                        <li class="w180">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">작성자</label></li>
                        <li class="w100">
                            <input id="searchKeyword2" name="searchKeyword2" class="form-control" value='<c:out value="${param.searchKeyword2}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">반영여부</label></li>
                        <li class="w100">
                           <select id="searchKeyword3" name="searchKeyword3" class="form-control">
                                <option value="">선택</option>
                                <option value="Y" <c:out value="${param.searchKeyword3 eq 'Y' ? 'selected=selected':'' }"/>>반영</option>
                                <option value="N" <c:out value="${param.searchKeyword3 eq 'N' ? 'selected=selected':'' }"/>>미반영</option>
                            </select>
                        </li>
                        <li class="ml10">
                            <button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
                        </li>
                    </ul>
                </div>
                <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
                    <jsp:param value="list"     name="formType"/>
                    <jsp:param value="2,3,4"     name="buttonYn"/>
                </jsp:include>
                <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
            </form>
		</div>
		<!-- Search 영역 끝 -->
	
		<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />
		
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-6">
					<table class="table table-bordered tb_type01 listtable">
						<colgroup>
							<col width="5%">
							<col width="20%">
							<col width="10%">
							<col width="auto;">
                            <col width="18%">
                            <col width="10%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>NO</th>
								<th>요청일자</th>
								<th>작성자</th>
								<th>요청사항</th>
								<th>반영여부</th>
								<th>답변확인<br>요청여부</th>
							</tr>
						</thead>
						<tbody id="lecReg">
							<c:if test="${empty list }">
								<tr ><td colspan="6">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list}" varStatus="idx">
								<tr>
									<td class="invisible">
									   <input type="checkbox" name="cmptSeq" class="index" value="<c:out value='${list.CMPT_SEQ}'/>">
									   <input type="hidden"  name="cmptSeqOlds" value="<c:out value='${list.CMPT_SEQ}'/>">
									</td>
									<td><c:out value="${paginationInfo.totalRecordCount - ((paginationInfo.currentPageNo-1) * paginationInfo.recordCountPerPage+ idx.index)}"/></td>
									<td>
										<c:out value="${list.CMPT_REQST_YMD}"/> (<c:out value="${list.DAY }"/>) <c:out value="${list.CMPT_REQST_HH}"/> : <c:out value="${list.CMPT_REQST_MM}"/>
									</td>
									<td><c:out value="${list.USER_NM}"/></td>
									<td><c:out value="${list.CMPT_REQST_TITLE}"/></td>
									<td>
										<button class="btn <c:out value="${list.REFLCT_YN eq 'Y'? 'btn-primary' : 'btn-danger' }"/> id="test<c:out value='${idx }'/>" name="reflctBtn" type="button" style="padding: 7px 13px;" data-cmpt-seq="<c:out value='${list.CMPT_SEQ }'/>" data-reflct-yn="<c:out value='${list.REFLCT_YN}'/>" <c:out value="${pageInfo.INSERT_AT eq 'Y' ? '':'disabled'}"/>>
                                            <i class="fa" title="반영/미반영"></i><c:if test="${list.REFLCT_YN eq 'Y'}">반영</c:if><c:if test="${list.REFLCT_YN ne 'Y'}">미반영</c:if>
                                        </button>
                                        <c:if test="${list.REFLCT_YN eq 'Y' and not empty list.REFLCT_YMD }">
                                        	(<c:out value="${list.REFLCT_YMD}"/> <c:out value="${list.REFLCT_HH }"/>:<c:out value="${list.REFLCT_MM }"/>)
                                        </c:if>
                                    </td>
                                    <td>
                                    	<c:if test="${list.ANSWER_CONFIRM_AT eq 'Y'}">
	                                    	<button class="btn btn-warning" type="button" style="padding: 7px 10px;">확인요청</button>
                                    	</c:if>
                                    </td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" />
				</article>
				<article class="col-md-12 col-lg-6" style="width: 49%;">
					<table class="table table-bordered tb_type03">
						<colgroup>
							<col width="25%">
							<col width="75%">
						</colgroup>
						<tbody id="detailTable">
							<tr><td colspan="2" class="textAlignCenter">항목을 선택해주세요.</td></tr>
						</tbody>
					</table>
				<form name="iForm" id="iForm" method="post" class="smart-form">
					<c:if test="${pageInfo.INSERT_AT eq 'Y'}">
						<c:if test="${userinfo.userId eq 'master' }">
							<label class="checkbox checkboxCenter col ml10 mt5">
								<input type="checkbox" id="answerConfirmAt" name="answerConfirmAt" value="Y" <c:out value="${result.ANSWER_CONFIRM_AT eq 'Y' ? 'checked=checked':''}"/>><i></i>
							</label>
							<span class="col mt7 ml50 mr5">답변확인요청</span>
						</c:if>		                    
						<button type="button" class="btn btn-primary ml2 mb5" id="answerBtn">
	                        <i class="fa fa-edit" title="댭변등록"></i> 답변등록
	                    </button>
                    </c:if>
                    <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
                    <td><input id="iFormcmptSeq" type="hidden" name="cmptSeq"></td>
                    <table class="table table-bordered table-hover tb_type01">
                        <!-- <colgroup>
                            <col width="7%">
                            <col width="8%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="20%">
                            <col width="20%">
                            <col width="15%">
                        </colgroup> -->
                        <tbody id="1on1Detail">
                            <td class="">
                                <textarea id="contents" name="contents" class="part_long " style="width: 100%; min-width: 100%;" <c:out value="${pageInfo.INSERT_AT eq 'Y' ? '' : 'disabled'}"/>><%-- <c:out value="${list.ANSWER_CONTENT}"/> --%></textarea>
                            </td>
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

<script id="detail-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">제목</th>
	<td>{{CMPT_REQST_TITLE}}</td>
</tr>
<tr>
	<th scope="row">요청일자</th>
	<td>{{CMPT_REQST_YMD}} ({{DAY}}) {{CMPT_REQST_HH}} : {{CMPT_REQST_MM}}</td>
</tr>
<tr>
    <th scope="row">내용</th>
    <td class="board_contents">{{safe CMPT_REQST_CONTENTS}}</td>
</tr>
<tr>
	<th scope="row">첨부파일</th>
	<td>
		{{safe fileView}}
	</td>
</tr>
</script>