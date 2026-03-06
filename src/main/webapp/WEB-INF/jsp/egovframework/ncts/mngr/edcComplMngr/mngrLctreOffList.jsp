 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
.table-bordered .tr_clr_2{background-color:#FDE1B4}
#videoDiv button {
	float: right;
}

.selectTr {
	border: 2px solid red;
}

.videoP:focus {
	border: none;
}

</style>

<script type="text/javascript">
	$(function(){
		var excelPg = 0;	
	    var baseInfo = {
	            insertKey : "${common.baseType[0].key() }",
	            updateKey : "${common.baseType[1].key() }",
	            deleteKey : "${common.baseType[2].key() }",
	            lUrl : "${pageInfo.MENU_URL }",
	            //lUrl : "/ncts/mngr/edcComplMngr/mngrLctreOffList.do",
	            fUrl : "/ncts/mngr/edcComplMngr/mngrLctreOffForm.do",
	            dUrl : "/ncts/mngr/edcComplMngr/mngrDeleteOffLctre.do",
	            excel: "/ncts/mngr/edcComplMngr/lctreOffExcelDownload.do",
	            popup: "/ncts/mngr/edcComplMngr/mngrLctrePopup.do"
	    }
	    
	    $.dataDetail = function(index, obj){
	    	if($.isNullStr(index))document.sForm.lectureId.value = "";
	        else document.sForm.lectureId.value = index;
	    	if(!$.isNullStr(obj)) document.sForm.lectureIdOld.value = obj.lectureIdOlds;

	    	$.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/edcComplMngr/mngrLctreOffDetail.do",
	            data: $("#sForm").serialize(),
	            dataType: "json",
	            success: function(data) {
	            	var videoAt;
	            	if(data.de == undefined) {
	            		var param = {
	            			searchCondition1 : "${searchCondition1}" == "Y" ? "${searchCondition1}" : "",
	            			searchCondition2 : "${searchCondition2}" == "Y" ? "${searchCondition2}" : "",
	            		};
	            		$("#detailTable").handlerbarsCompile($("#detail-template"), param);
						videoAt = param.searchCondition1;
	            	} else {
						$("#detailTable").handlerbarsCompile($("#detail-template"), data.de);
	            		videoAt = data.de.VIDEO_AT;
	            	}
	            	
	                $.videoAtOnSettings(videoAt);
	                $(".videoRow").remove();
					$("#videoDiv").handlerbarsAppendCompile($("#video-list-template"), data.lectureList);
	                $("#iForm input[name='videoAt']").videoAtOnChangeEvt();
	            }
	        })
	    }
	    
	    $.fn.procBtnOnClickEvt = function(url, key, active){
	        var _this = $(this);
	        _this.on("click", function(){
	            if(baseInfo.deleteKey == key){
	                $.delAction(url, key, active, this);
	            }else{
	            	if(baseInfo.insertKey == key && $("#lecRegTr").length == 0) {
		            	$(".videoRow").remove();
		            	$(".videoDiv").hide();
	            	}
		            $.procAction(url, key);	
	            }
	        })
	    }
	    
	    $.procAction = function(pUrl, pKey){
	    	if(pKey == baseInfo.insertKey){
	    		if($("#lecRegTr").length == 0){
	    	        $("#lecReg").find("tr").removeClass("tr_clr_2");
                
	    	        var _form = "<tr class='tr_clr_2' style='height: 51px;' id='lecRegTr'>" +
                                "<td id='lecid'></td><td></td><td></td><td></td><td>"+
                                "<button class='btn btn-primary' name='delRow' type='button' style='padding: 7px 13px;'><i class='fa' title='행삭제'></i>행삭제</button></td></tr>";
                    
                    $("#lecReg").append(_form);  //id 변경 
                    
                    $.dataDetail();
	    		} else {
		    		if(document.iForm.lectureId.value){
		    			$.progressAction(baseInfo.insertKey);
	    			} else {
	            		alert("강의아이디를 입력해주세요.");
	            		document.iForm.lectureId.focus();
	            		return false;
	    			}
	    		}
	    	} else {
	    		if(!document.iForm.lectureId.value || $(".tr_clr_2 .invisible .index").val() == undefined){
	 				alert("기준강의를 새로 등록하는 경우 수정할 수 없습니다.");
	 				return false;
	    		}
	    		if(!confirm("저장하시겠습니까?")) return false;
	    		$.progressAction(baseInfo.updateKey);
	    	}	    	
	    }
	    
	    $.progressAction = function(key){
	    	if(!document.iForm.lectureId.value){
	    		alert("강의아이디를 입력해주세요.");
	    		document.iForm.lectureId.focus();
	    		return false;
	    	} else if(!document.iForm.lectureNm.value){
	    		alert("강의명을 입력해주세요.");
	    		document.iForm.lectureNm.focus();
	    		return false;
	    	} else if(!document.iForm.edcTime.value){
	    		alert("강의시간을 입력해주세요.");
	    		document.iForm.edcTime.focus();
	    		return false;
            } else if($(".courses:checked").length == 0){
	    		alert("교육과정을 입력해주세요.");
	    		return false;
            }
	    	
	    	var flag = true;
	    	var videoAt = $("#iForm input[name='videoAt']:checked").val();
	    	if($("#iForm input[name='videoImdtlAt']:checked").length == 1 && videoAt != "Y") {
	    		alert("즉시등록은 동영상 강의만 가능합니다.");
	    		return false;
	    	}
	    	else if(videoAt == "Y") {
	    		var excpAt = location.pathname == '/ncts/mngr/edcComplMngr/mngrLctreOffList.do' ? 'Y' : 'N';
	    		if(excpAt == "N" && $(".videoRow").length == 0) {
    				alert("동영상을 등록해주시기 바랍니다.");
    				return false;
	    		}
	    		if($("input[name='nonFdrm']:checked").val() == "Y") {
	    			alert("비정기교육은 동영상 강의 등록이 불가능합니다.");
	    			return false;
	    		}
	    		$(".videoRow").each(function(){
	    			var $element = $(this);
	    			var tempSeq = $element.find("input[name='tempSeq']").val();
	    			var lectureSeq = $element.find("input[name='lectureSeq']").val();
	    			
	    			if(tempSeq == "" && lectureSeq == "") {
	    				alert("동영상을 등록해주시기 바랍니다.");
	    				flag = false;
	    				return false;
	    			}
	    		})
	    	}
	    	
	    	if(flag) {
		    	document.sForm.procType.value = key;
		    	document.sForm.lectureId.value = document.iForm.lectureId.value;
	            document.sForm.lectureNm.value = document.iForm.lectureNm.value;
	            document.sForm.edcTime.value = document.iForm.edcTime.value;
	            document.sForm.nonFdrmYn.value = document.iForm.nonFdrm.checked ? document.iForm.nonFdrm.value : "";
	            /* document.sForm.courses00.value = document.iForm.courses00.checked ? document.iForm.courses00.value : "";
	            document.sForm.courses01.value = document.iForm.courses01.checked ? document.iForm.courses01.value : "";
	            document.sForm.courses02.value = document.iForm.courses02.checked ? document.iForm.courses02.value : "";
	            document.sForm.courses03.value = document.iForm.courses03.checked ? document.iForm.courses03.value : "";
	            document.sForm.courses04.value = document.iForm.courses04.checked ? document.iForm.courses04.value : "";
	            document.sForm.courses07.value = document.iForm.courses07.checked ? document.iForm.courses07.value : ""; */
	            document.sForm.courses.value = $("#iForm input[name='courses']:checked").length == 1 ? $("#iForm input[name='courses']:checked").val() : "";
	            document.sForm.videoAt.value = $("#iForm input[name='videoAt']:checked").val();
	            document.sForm.videoImdtlAt.value = document.iForm.videoImdtlAt.checked ? document.iForm.videoImdtlAt.value : "";
	            
	            var lectureId = $(".tr_clr_2 .index:checked").val() == undefined ? "" : $(".tr_clr_2 .index:checked").val();
	            if(lectureId == "" && $("#iForm input[name='videoAt']:checked").val() == "Y") {
		            var tempSeqList = [];
		    		$(".videoRow").each(function(){
		    			var $element = $(this);
		    			var tempSeq = $element.find("input[name='tempSeq']").val();
		    			tempSeqList.push(tempSeq);
		    		})	    
		    		document.sForm.tempSeq.value = tempSeqList;
	            }
	            
	            $.loadingBarStart();
	            
	            $.ajax({
	                type: 'POST',
	                url: "/ncts/mngr/edcComplMngr/mngrProgressOffLctre.do",
	                data: $("#sForm").serialize(),
	                dataType: "json",
	                success: function(data) {
	                    alert(data.msg);
	                    if(data.success == "success"){
	                        $.searchAction();
	                    }
					},
					complete: function() {
						$.loadingBarClose();
					}
	            })
	    	}
	    	
	    }
	    
	    $.delAction = function(pUrl, pKey, active, _thisObj){
	    	if(active){
	    		var activeyn = _thisObj.dataset.activeYn;
	    		//var activeyn = $("button[name=registReplcLec]").data("activeYn");
	            
	            if(activeyn == "Y")if(!confirm("비활성화 하시겠습니까?")) return false;
	            if(activeyn == "N")if(!confirm("활성화 하시겠습니까?")) return false;	
	            document.sForm.activeYn.value = activeyn;
	    	} else if(!confirm("삭제하시겠습니까?")) return false;
	    	
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
	    
	    $.fn.coursesOnClickEvt = function(){
	    	var _this = $(this);
	    	_this.on("click", ".courses", function(){
	    		var $this = $(this);
	    		if($this.is(":checked"))
	    			$this.closest("td").find("input[type='checkbox']").not($this).prop("checked", false);
	    	})
	    }
	    
	    $.setCookie = function(c_name,value){
		     var exdate=new Date();
		     var c_value=escape(value);
		     document.cookie=c_name + "=" + c_value + "; path=/";
		}
		 
		$.checkDownloadCheck = function(){
		     FILEDOWNLOAD_INTERVAL = setInterval(function() {
		          if (document.cookie.indexOf("fileDownloadToken=true") != -1) {
		             excelPg = 0;
		             clearInterval(FILEDOWNLOAD_INTERVAL);
		             $.loadingBarClose();
		           }
		     }, 500);
		}
		
		$.videoAtOnSettings = function(videoAt){
			if(videoAt == "Y") $("#videoDiv").show();
			else {
				//$(".videoRow").remove();
				$("#videoDiv").hide();
			}
		}
		
		$.fn.videoAtOnChangeEvt = function(){
			$(this).on("change", function(){
				$.videoAtOnSettings($(this).val());
			})
		}
		
		$.fn.videoDivBtnOnClickEvt = function(){
			$(this).on("click", function(){
				var $this = $(this);
				var rowLength = $(".videoRow").length+1;
				var $idx = $(".idx:checked");
				
				if($this.hasClass("plusBtn")) {
					var flag = true;
					$(".videoRow").each(function(){
						var $element = $(this);
						var eLectureSeq = $element.closest(".videoRow").find("input[name='lectureSeq']").val();
						var eTempSeq = $element.closest(".videoRow").find("input[name='tempSeq']").val();
						
						if(eLectureSeq == "" && eTempSeq == "") {
							alert("이전 동영상을 먼저 등록해주시기 바랍니다.");
							flag = false;
							return false;
						}
					})
					if(flag) $("#videoDiv").handlerbarsAppendCompile($("#video-row-template"), rowLength);
				}
				else if($this.hasClass("minusBtn")) {
					if($idx.length == 0) alert("항목을 선택해주세요.");
					else if($idx.length == 1) {
						if($idx.siblings("input[name='tempSeq']").val() != "" || $idx.siblings("input[name='lectureSeq']").val() != "") {
							$(".dim-layer").show();
							return false;
						}
						$idx.closest("div").remove();
						$.updateVideoRowSn();
					}
				}
			})
		}
		
		$.fn.videoRowPOnClickEvt = function(){
			$(this).on("click", ".videoP", function(){
				var $this = $(this);
				$(".videoP").removeClass("selectTr");
				$(".videoRow .idx").prop("checked", false);
				$this.addClass("selectTr");
				$this.siblings(".idx").prop("checked", true);
			})
		}	
		
		$.updateVideoRowSn = function(){
			$(".videoRow").each(function(idx){
				var $this = $(this);
				$this.find("span").html(++idx+"강");
				$this.attr("data-sn", idx);
				$this.data("sn", idx);
			})
		}
	    
		$.fn.addBtnOnClickEvt = function(){
			$(this).on("click", ".addBtn", function(){
	    		var $this = $(this);
	    		
	    		$this.siblings(".videoP").click();
	    		var lectureId = $(".tr_clr_2 .index:checked").val() == undefined ? "" : $(".tr_clr_2 .index:checked").val();
	    		var lectureSeq = $this.closest(".videoRow").find("input[name='lectureSeq']").val();
	    		var tempSeq = $this.closest(".videoRow").find("input[name='tempSeq']").val();
	    		
	    		document.nForm.pageType.value = lectureId != "" ? "" : "TEMP";
	    		document.nForm.lectureId.value = lectureId;
	    		document.nForm.lectureSn.value = $this.closest(".videoRow").data("sn");
	    		document.nForm.lectureSeq.value = lectureSeq;
	    		document.nForm.tempSeq.value = tempSeq;
	    		document.nForm.delTempSeq.value = '';
	    		
	    		if(lectureSeq != "" || tempSeq != "") document.nForm.procType.value = baseInfo.updateKey;
	    		else document.nForm.procType.value = baseInfo.insertKey;
	    		
	    		$.popAction.width = 1200;
				$.popAction.height = 550;
				$.popAction.target = "mngrLctrePopup";
				$.popAction.url = baseInfo.popup;
				$.popAction.form = document.nForm;
				$.popAction.init();
			})
		}	
		
		$.lectureOnlectChange = function(data){
			var lectureId = $(".tr_clr_2 .index:checked").val() == undefined ? "" : $(".tr_clr_2 .index:checked").val();
			
			var $selector = $(".videoRow[data-sn='"+data.sn+"']");
			$selector.find("input[name='tempSeq']").val(data.tempSeq);
			$selector.find("input[name='lectureSeq']").val(data.lectureSeq);
			$selector.find(".videoP").html("https://www.youtube.com/watch?v=" + data.youtubeId);
		}
		
		$.fn.confirmPopupBtnsOnClickEvt = function(){
			$(this).on("click", function(){
				var $this = $(this);
				if($this.attr("id") == "yBtn") {
					var $idx = $(".idx:checked");
		    		var lectureId = $(".tr_clr_2 .index:checked").val() == undefined ? "" : $(".tr_clr_2 .index:checked").val();
		    		var lectureSeq = $idx.closest(".videoRow").find("input[name='lectureSeq']").val();
		    		var lectureSn = $idx.closest(".videoRow").data("sn");
		    		var tempSeq = $idx.closest(".videoRow").find("input[name='tempSeq']").val();	
		    		
		    		if(tempSeq != "") {
		    			var delTempSeq = [];
		    			$(".videoRow").not($idx.closest(".videoRow")).each(function(){
		    				var $element = $(this);
		    				delTempSeq.push($element.find("input[name='tempSeq']").val());
		    			})
		    			
		    			document.nForm.delTempSeq.value = delTempSeq;
		    		}
					
		    		document.nForm.pageType.value = lectureId != "" ? "" : "TEMP";
		    		document.nForm.lectureId.value = lectureId;
		    		document.nForm.lectureSeq.value = lectureSeq;
		    		document.nForm.lectureSn.value = lectureSn;
		    		document.nForm.tempSeq.value = tempSeq;		
		    		document.nForm.procType.value = baseInfo.deleteKey;
					
		            $.ajax({
		                type: 'POST',
		                url: "/ncts/mngr/edcComplMngr/deleteLectureOnlect.do",
		                data: $("#nForm").serialize(),
		                dataType: "json",
		                success: function(data) {
		                    alert(data.msg);
		                    if(data.success == "success") {
								$(".idx:checked").closest("div").remove();
								$.updateVideoRowSn();
		                    }
		                }
		            })
					
				}
				
				$(".dim-layer").hide();
			})
		}
		
	    $.initView = function(){
	    	$.onClickTableTr();
	        $("#searchBtn").searchBtnOnClickEvt($.searchAction);
	        $("#saveBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.insertKey);
	        $("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
	        $("button[name=registReplcLec]").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey, 'active');
	        $("#delBtn").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey);
	        $(document).on("click", "#lecRegTr", function(){
	            $("tr").removeClass("tr_clr_2");
	            $("#lecRegTr").addClass("tr_clr_2");
	            $.dataDetail();
	        });
	        
	        $(document).on("click", "button[name=delRow]", function(){
	        	if($("#lecRegTr").length != 0){
	        	    $("#lecRegTr").remove();
	        	    $.searchAction();
	            } 
	        });
	        
	        $(document).on("keyup keypress", "input[name='lectureIdSub']", function(){
	        	var _this = $(this);
	        	_this.val(_this.val().replace(/\s+/g,""));
	        })
	        
	        $(document).on("keyup keypress", "input[name='edcTime']", function(){
	        	var _this = $(this);
	        	_this.val(_this.val().replace(/[^0-9]/g,""));
	        })
	        
	        $(document).on("keyup keypress", "#lectureId", function(){
	        	var _this = $(this);
	        	_this.val(_this.val().replace("|", ""));
	        })
	        
	        $("#detailTable").coursesOnClickEvt();
	        
	        $(".plusBtn, .minusBtn").videoDivBtnOnClickEvt();
	        $("body").addBtnOnClickEvt();
	        $("body").videoRowPOnClickEvt();
	        $(".dim-layer button").confirmPopupBtnsOnClickEvt();
	        
	        $(".excelDown").on("click", function(e){
				$("[name='excelFileNm']").val("기준강의등록_"+$.toDay());
				$("[name='excelPageNm']").val("mngrLctreOffList.xlsx");		        	
				excelPg = 1;
				with(document.sForm){
					target = "";
					action = baseInfo.excel;
					submit();
					
	                $.setCookie("fileDownloadToken","false"); 
	                $.loadingBarStart(e);
	                $.checkDownloadCheck();
	            }
	        });
	        
	        $("body").on("keydown", function(e){
		        $.loadingBarKeyDown(e, excelPg);
	        })
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
				<input type="hidden" name="excelFileNm" id="excelFileNm"  value="">
				<input type="hidden" name="excelPageNm" id="excelPageNm"  value="">            	
                <input type="hidden" name="lectureId" id="lectureId"  value="">
                <input type="hidden" name="lectureIdOld" id="lectureIdOld" value="">
                <input type="hidden" name="nonFdrmYn" id="nonFdrmYn" value="">
                <input type="hidden" name="edcTime" id="edcTime" value="">
                <input type="hidden" name="delYn" id="delYn" value="">
                <input type="hidden" name="activeYn" id="activeYn" value="">
                <input type="hidden" name="lectureNm" id="lectureNm"  value="">
                <input type="hidden" name="courses" id="courses"  value="">
                <input type="hidden" name="courses00" id="courses00"  value="">
                <input type="hidden" name="courses01" id="courses01"  value="">
                <input type="hidden" name="courses02" id="courses02"  value="">
                <input type="hidden" name="courses03" id="courses03"  value="">
                <input type="hidden" name="courses04" id="courses04"  value="">
                <input type="hidden" name="courses07" id="courses07"  value="">
                <input type="hidden" name="videoAt" id="videoAt"  value="">
                <input type="hidden" name="videoImdtlAt" id="videoImdtlAt"  value="">
                <input type="hidden" name="tempSeq" value="">

                <div class="fL wp70">
                    <ul class="searchAreaBox">
                        <li class="smart-form ml5">
                            <label class="label">교육과정</label>
                        </li>
                        <li class="w100">
                            <select id="sGubun1" name="sGubun1" class="form-control">
                                <option value="">선택</option>
                                <c:forEach var="list" items="${codeMap.DMH14 }" varStatus="idx">
                                    <c:if test="${(idx.index lt 5) or (idx.index eq 7) or (idx.index eq 8)}">
                                    	<c:if test="${not empty sGubun1 and sGubun1 eq list.CODE}">
                                    		<option value="${list.CODE }" ${sGubun1 eq list.CODE ? 'selected="selected"':'' }>${list.CODE_NM }</option>
                                    	</c:if>
                                    	<c:if test="${empty sGubun1 and sGubun1 ne list.CODE}">
                                    		<option value="${list.CODE }" ${param.sGubun1 eq list.CODE ? 'selected="selected"':'' }>${list.CODE_NM }</option>
                                    	</c:if>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </li>
                        
                        <li class="smart-form ml5">
							<label class="checkbox checkboxCenter col ml10 mt5">
								<input type="checkbox" id="searchCondition1" name="searchCondition1" value="Y" ${param.searchCondition1 eq 'Y' or searchCondition1 eq 'Y' ? 'checked="checked"':''}><i></i>
							</label>
							<span class="col ml50 mr5" style="padding-left: 0; margin-top: 8px;">동영상</span>                        
                        </li>
                        
                        <li class="smart-form ml5"><label class="label">기준강의코드</label></li>
                        <li class="w180 ml5">
                            <input id="searchKeyword2" name="searchKeyword2" class="form-control" value='<c:out value="${param.searchKeyword2}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">기준강의명</label></li>
                        <li class="w180 ml5">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'> 
                        </li>
                        
                        <li class="ml10">
                            <button class="btn btn-primary allSearchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
                        </li>
                    </ul>
                </div>
                <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
                    <jsp:param value="list"     name="formType"/>
                    <jsp:param value="1,2,3,4"     name="buttonYn"/>
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
							<col width="15%">
							<col width="30%">
							<col width="20%">
                            <col width="15%">
                            <col width="20%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>기준강의코드</th>
								<th>기준강의명</th>
								<th>교육과정</th>
								<th>강의생성일</th>
								<th>활성/비활성</th>
							</tr>
						</thead>
						<tbody id="lecReg">
							<c:if test="${empty list }">
								<tr ><td colspan="5">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list}" varStatus="idx">
								<tr>
									<td class="invisible">
									   <input type="checkbox" name="lectureId" class="index" value="${list.LECTURE_ID}">
									   <input type="hidden"  name="lectureIdOlds" value="${list.LECTURE_ID}">
									</td>
									<td>${list.LECTURE_ID}</td>
									<td>${list.LECTURE_NM}</td>
									<td>
										${list.COURSES_NM}
								            <%-- <c:if test="${idxx.index eq '0'}">
								                ${list.COURSES00 eq codelist.CODE ? codelist.CODE_NM : ""}
								            </c:if>
								            <c:if test="${idxx.index eq '1'}">
								                ${list.COURSES01 eq codelist.CODE ? codelist.CODE_NM : ""}
								            </c:if>
								            <c:if test="${idxx.index eq '2'}">
								                ${list.COURSES02 eq codelist.CODE ? codelist.CODE_NM : ""}
								            </c:if>
								            <c:if test="${idxx.index eq '3'}">
								                ${list.COURSES03 eq codelist.CODE ? codelist.CODE_NM : ""}
								            </c:if>
								            <c:if test="${idxx.index eq '4'}">
                                                ${list.COURSES04 eq codelist.CODE ? codelist.CODE_NM : ""}
                                            </c:if>
								            <c:if test="${idxx.index eq '7'}">
                                                ${list.COURSES07 eq codelist.CODE ? codelist.CODE_NM : ""}
                                            </c:if>
								            <c:if test="${idxx.index eq '10'}">
                                                ${list.COURSES10 eq codelist.CODE ? codelist.CODE_NM : ""}
                                            </c:if>
								        </c:forEach> --%>
									</td>
									<td>${list.FRST_REGIST_PNTTM}</td>
									<td><button class="btn btn-primary" name="registReplcLec" type="button" style="padding: 7px 13px;" data-lecture-id="${list.LECTURE_ID }" data-courses="${list.COURSES }" data-active-yn="${list.ACTIVE_YN}" ${pageInfo.INSERT_AT eq 'Y' ? '':'disabled'} }>
                                            <i class="fa" title="활성/비활성"></i><c:if test="${list.ACTIVE_YN eq 'N'}">비활성</c:if><c:if test="${list.ACTIVE_YN eq 'Y'}">활성</c:if>
                                        </button>
                                    </td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" />
				</article>
				<form name="iForm" id="iForm" method="post" class="smart-form">
					<article class="col-md-12 col-lg-6" style="width: 49%;">
						<table class="table table-bordered tb_type03">
							<colgroup>
								<col width="15%">
								<col width="35%">
								<col width="15%">
								<col width="17%">
								<col width="17%">
							</colgroup>
							<tbody id="detailTable">
								<tr><td colspan="6" class="textAlignCenter">항목을 선택해주세요.</td></tr>
							</tbody>
						</table>
						
						<!-- <div id="videoDiv">
							<div style="width: 100%; float: left; margin: 10px 0;">
						        <button class="btn btn-primary ml2 minusBtn" type="button"><i class="fa fa-minus"></i></button>
						        <button class="btn btn-primary ml2 plusBtn" type="button"><i class="fa fa-plus"></i></button>
							</div>		
						</div> -->
					</article>
				</form>
				<form name="nForm" id="nForm" method="post" class="smart-form">
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
                	<input type="hidden" name="lectureId" value="">
					<input type="hidden" name="lectureSn" value="">
					<input type="hidden" name="tempSeq" value="">
					<input type="hidden" name="lectureSeq" value="">                	
					<input type="hidden" name="pageType" value="">                	
					<input type="hidden" name="delTempSeq" value="">                	
				</form>
				<article class="col-md-12 col-lg-6 fR">
					<div id="videoDiv">
						<div style="width: 100%; float: left; margin: 10px 0;">
					        <button class="btn btn-primary ml2 minusBtn" type="button"><i class="fa fa-minus"></i></button>
					        <button class="btn btn-primary ml2 plusBtn" type="button"><i class="fa fa-plus"></i></button>
						</div>		
					</div>
				</article>
			</div>
			<!-- row 메뉴조회 끝 -->
		</div>
	</section>
	<!-- widget grid end -->
</div>
<!-- END MAIN CONTENT -->

<div class="dim-layer" style="display: none;">
	<div class="dimBg"></div>	
	<div id="confirmPopup" class="popup-con">
		<div style="background: #d7d7d7; padding: 20px;">
			<p style="font-weight: bold; font-size: 20px;">주의 : 행 삭제 시 해당 강좌 내역도 삭제됩니다.</p>
		</div>
		<div class="fR" style="background: #d7d7d7; width: 100%; padding: 10px;">
            <button id="yBtn" type="button" style="border: none; background: #000; color: #fff;">확인</button>
            <button id="nBtn" type="button" style="border: none; background: #fff; color: #000;">취소</button>
		</div>
	</div>
</div>

<script id="detail-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">강의아이디 </th>
	<td><label class="input w200 col">
            <input type="text" id="lectureId" name="lectureIdSub" value="{{LECTURE_ID}}" maxlength="20">
        </label>
    </td>
    <th scope="row">교육과정</th>
    <td colspan="2">
        <c:forEach var="list" items="${codeMap.DMH14 }" varStatus="idx">
			<c:if test="${(idx.index lt 5) or (idx.index eq 7) or (idx.index eq 8)}">
				<c:if test="${not empty sGubun1 and sGubun1 eq list.CODE}">
					<input type="checkbox" name="courses" class="courses" value="${list.CODE }" checked="checked"><i></i>
                	${list.CODE_NM }
				</c:if>
				<c:if test="${empty sGubun1 and sGubun1 ne list.CODE}">
					<input type="checkbox" name="courses" class="courses" value="${list.CODE }" {{#ifeq COURSES '${list.CODE}'}}checked="checked"{{/ifeq}}><i></i>
               		${list.CODE_NM }
            	</c:if>
			</c:if>
        </c:forEach>
    </td>
</tr>
<tr>
	<th scope="row">강의명</th>
	<td><label class="input w200 col">
            <input type="text" name="lectureNm" value="{{LECTURE_NM}}">
        </label>
    </td>
    <th scope="row">강의생성일</th>
    <td colspan="2">
        {{FRST_REGIST_PNTTM}}
    </td>
</tr>
<tr>
    <th scope="row">강의시간</th>
    <td colspan="5">
        <div class="fL wp5">        
            <label class="input w200 col">
                <input type="text" name="edcTime" value="{{EDC_TIME}}">
            </label>
        </div>
        <div class="fL ml10 mt10"><p style="color:red;">*시간단위는 분으로 입력해 주십시오</p></div>
    </td>
</tr>
<tr>
    <th scope="row">비정기교육 여부</th>
    <td>
        <input type="checkbox" name="nonFdrm" {{#ifeq NON_FDRM 'Y'}}checked="checked"{{/ifeq}} value="Y"><i></i>
    </td>
    <th scope="row">동영상 활성화</th>
    <td>
		<div class="inline-group col">
			{{#ifeq searchCondition1 'Y'}}
				<label class="radio">
					<input type="radio" value="Y" name="videoAt" checked="checked"><i></i>Y
				</label>
				<label class="radio">
					<input type="radio" value="N" name="videoAt"><i></i>N
				</label>
				{{else}}
					<label class="radio">
						<input type="radio" value="Y" name="videoAt" {{#ifeq VIDEO_AT 'Y'}}checked="checked"{{/ifeq}}><i></i>Y
					</label>
					<label class="radio">
						<input type="radio" value="N" name="videoAt" {{#ifeq VIDEO_AT 'N'}}checked="checked"{{else}}{{#empty VIDEO_AT}}checked="checked"{{/empty}}{{/ifeq}}><i></i>N
					</label>
			{{/ifeq}}
		</div>
    </td>
    <td style="border-left: 1px solid;">
		<div class="inline-group col">
			{{#ifeq searchCondition2 'Y'}}
				<label class="checkbox">
					<input type="checkbox" value="Y" name="videoImdtlAt" checked="checked"><i></i>즉시등록
				</label>
				{{else}}
					<label class="checkbox">
						<input type="checkbox" value="Y" name="videoImdtlAt" {{#ifeq VIDEO_IMDTL_AT 'Y'}}checked="checked"{{/ifeq}}><i></i>즉시등록
					</label>
			{{/ifeq}}
		</div>
    </td>
</tr>
</script>

<script id="video-row-template" type="text/x-handlebars-template">
<div class="videoRow" style="width: 100%; float: left; margin: 5px 0;" data-sn="{{this}}">
	<input type="hidden" name="tempSeq" value="">
	<input type="hidden" name="lectureSeq" value="">

	<input type="radio" class="idx invisible" style="display: none;">
	<span style="margin: 0 15px 0 0; float: left; font-size: 18px; font-weight: bold; background: #3276b1; color: #fff; padding: 2px 8px;">{{this}}강</span>
	<p class="form-control fL videoP" style="width:80%;"></p>
	<button class="btn btn-primary addBtn" style="width: 10%;" type="button">추가</button>
</div>		
</script>
<script id="video-list-template" type="text/x-handlebars-template">
{{#each .}}
<div class="videoRow" style="width: 100%; float: left; margin: 5px 0;" data-sn="{{inc @key}}">
	<input type="hidden" name="tempSeq" value="">
	<input type="hidden" name="lectureSeq" value="{{LECTURE_SEQ}}">

	<input type="radio" class="idx invisible" style="display: none;">
	<span style="margin: 0 15px 0 0; float: left; font-size: 18px; font-weight: bold; background: #3276b1; color: #fff; padding: 2px 8px;">{{inc @key}}강</span>
	<p class="form-control fL videoP" style="width:80%;">https://www.youtube.com/watch?v={{YOUTUBE_ID}}</p>
	<button class="btn btn-primary addBtn" style="width: 10%;" type="button">추가</button>
</div>	
{{/each}}	
</script>