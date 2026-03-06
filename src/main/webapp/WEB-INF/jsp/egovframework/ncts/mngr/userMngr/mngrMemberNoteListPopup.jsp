<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
  .fClr:after {display: block;content: "";clear: both;}
  .fLeft {float: left;}
  .fRight {float: right;}
  .fa-times:before {content: "\f00d";font-size: 24px;color: #fff;}

  .popup-con * {margin: 0;padding: 0;box-sizing: border-box;}
  .popup-con {position: fixed;left: 50%;top: 50%;transform: translate(-50%, -50%);width: 530px; height: auto;text-align: center;box-shadow: 2px 2px 3px rgba(0, 0, 0, .1), -2px 2px 3px rgba(0, 0, 0, .1), 2px -1px 3px rgba(0, 0, 0, .1), -2px -1px 3px rgba(0, 0, 0, .1);}
  .popup-con .close_box {height: 30px;background: #57698e;}
  .popup-con .close_box p {margin-left: 10px;line-height: 30px;font-size: 14px;font-weight: bold;color: #fff;}
  .popup-con .close_box a {padding: 2px 8px;}
  .popup-con .text_box {width: 100%;border-bottom: 1px solid #9ca2a7;border-left: 1px solid #9ca2a7;border-right: 1px solid #9ca2a7;background-color:white;}
  .popup-con textarea {margin: 10px 0;padding: 5px;width: 510px;height: 120px;border: 1px solid #ccc;resize: none;}
  .popup-con button {margin-bottom: 10px;width: 65px;height: 32px;color: #fff;background: #3276b1;border: 1px solid #2c699d;border-radius: 2px;}
</style>
<script type="text/javascript">

$(function(){
	var baseInfo = {
			insertKey : "${common.baseType[0].key() }",
			updateKey : "${common.baseType[1].key() }",
			deleteKey : "${common.baseType[2].key() }",
			lUrl : "/ncts/mngr/userMngr/mngrMemberNoteListPopup.do",
			fUrl : "/ncts/mngr/userMngr/mngrMemberNoteProc.do",
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
	
    $.selectDataDetail = function(index){
        if($.isNullStr(index)) return false;
        document.sForm.noteSeq.value = index;
        $.ajax({
            type: 'POST',
            url: "/ncts/mngr/userMngr/selectMemberNoteDetail.do",
            data: $("#sForm").serialize(),
            dataType: "json",
            success: function(data) {
                if(data.success == "success"){
					$("#noteCn").val(data.rs.NOTE_CN);
                }
            }
        })
    }	
	
    $.fn.procBtnOnClickEvt = function(url, key){
        var _this = $(this);
        _this.on("click", function(){
        	
        	if(baseInfo.insertKey == key) {
        		document.noteForm.procType.value = key;
        		document.noteForm.noteSeq.value = '';
        		$("#noteCn").val("");
        		$("#notePopup").show();
        	}
        	else {
        		var $idx = $("input.index:checked");
        		if($idx.size() <= 0) {
        			alert("항목을 선택하시기 바랍니다.");
                    return false;
        		}
        		
        		if(baseInfo.updateKey == key) {
	        		document.noteForm.procType.value = key;
	        		document.noteForm.noteSeq.value = $idx.val();
	        		$.selectDataDetail($idx.val());
	        		$("#notePopup").show();
        		}
        		else if(baseInfo.deleteKey == key) {
        			document.sForm.procType.value = key;
	        		document.sForm.noteSeq.value = $idx.val();
        			$.procAction(url, "삭제하시겠습니까?");
        		}
        	}
        })
    }
    
    $.procAction = function(pUrl, msg){
        if(msg != undefined) if(!confirm(msg)) return false;
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
	
	
	$.initView = function(){
		$.onClickTableTr();
        $("#saveBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.insertKey);
        $("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
        $("#delBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.deleteKey);
        $("#addNoteBtn").addNoteBtnOnClick(document.sForm.procType.value);
	}
	
	$.initView();
})
</script>

<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/memberNotePopup.jsp" flush="false" />
<!-- MAIN CONTENT -->
<div id="content" class="popPage">
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post">
                <input type="hidden" name="userNo" id="userNo" value="${param.userNo }">
	        	<input type="hidden" name="noteSeq" id="noteSeq" value="">
	        	<input type="hidden" name="deptAllAuthorAt" value="<sec:authentication property="principal.deptAllAuthorAt"/>">
                <div class="fL wp70">
					<p style="font-size: 18px; margin-top: 5px;">${rs.USER_NM }(${rs.USER_ID })</p>					
				</div>
				<div class="fR wp30 dstrctHide" style="display: none;">
					<ul class="searchAreaBox fR">
						<li><button class="btn btn-primary ml2" type="button" id="saveBtn"><i class="fa fa-edit" title="등록"></i> 등록</button></li>
						<li><button class="btn btn-primary ml2" type="button" id="updBtn"><i class="fa fa-edit" title="수정"></i> 수정</button></li>
						<li><button class="btn btn-danger ml2"  type="button" id="delBtn"><i class="fa fa-cut" title="삭제"></i> 삭제</button></li>
					</ul>
				</div>
                <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
            </form>
		</div>		
		<!-- Search 영역 끝 -->	
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
					<div class="article_medical" id="pList">
						<table class="table table-bordered table-hover tb_type01 listtable" style="table-layout: fixed;">
							<colgroup>
								<col width="70%">
								<col width="15%">
								<col width="15%">
							</colgroup>
							
							<tbody id="targetTable">	
								<tr>
									<th>메모</th>
									<th>작성자</th>
									<th>작성일자</th>
								</tr>
								<c:if test="${empty rslist }">
									<tr class="noData">                           
										<td colspan="3">데이터가 없습니다.</td>             
									</tr>
								</c:if>
								<c:forEach var="rslist" items="${rslist }">
									<tr>
										<td class="invisible"><input type="checkbox" class="index" value="${rslist.NOTE_SEQ }"></td>
										<td style="word-wrap: break-word;">${rslist.NOTE_CN }</td>
										<td>${rslist.FRST_USER_NM}</td>
										<td>${rslist.FRST_REGIST_PNTTM}</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
						<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" />
					</div>
				</article>
			</div>
		</div>
	</section>
	<!-- widget grid end -->
</div>
<!-- END MAIN CONTENT -->
