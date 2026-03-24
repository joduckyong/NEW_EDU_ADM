<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

	$(function(){
		var excelPg = 0;
	    var baseInfo = {
	            insertKey : '<c:out value="${common.baseType[0].key() }"/>',
	            updateKey : '<c:out value="${common.baseType[1].key() }"/>',
	            deleteKey : '<c:out value="${common.baseType[2].key() }"/>',
	            lUrl : "/ncts/mngr/eduReqstMngr/mngrEdcReqstList.do",
	            fUrl : "/ncts/mngr/eduReqstMngr/mngrEdcReqstForm.do",
	            dUrl : "/ncts/mngr/eduReqstMngr/mngrEduReqstProcess.do",
	            excel : "/ncts/mngr/eduReqstMngr/mngrEdcRequsetApplicantDownload.do",
	            pop01 : "/ncts/mngr/eduReqstMngr/mngrEdcRequsetUpdateCenterListPopup.do",
	    }
	    
	    $.dataDetail = function(index, status){
	        if($.isNullStr(index)) return false;
	        document.sForm.reqstSeq.value = index;
	        reqstSeq = index;
	        $.ajax({
	            type: 'POST',
	            url: "/ncts/mngr/eduReqstMngr/mngrEdcReqstDetail.do",
	            data: $("#sForm").serialize(),
	            dataType: "json",
	            success: function(data) {
	                if(data.success == "success"){
	                	if(status == "nonUserBtn") $("#applicantTable").handlerbarsCompile($("#non-applicant-template"), data.rslist2);
	                	else $("#applicantTable").handlerbarsCompile($("#applicant-template"), data.rslist);
	                    $("#detailTable").handlerbarsCompile($("#detail-template"), data.de);
	                    document.ubiForm.instrctrNo.value = data.de.REGST_INSTRCTR_NO;
	                    document.ubiForm.actStatus.value = data.de.INSTRCTR_ACT_STATUS;
	                    $(".userDetailTd").userDetailTdOnClickEvt();
	                }
	            }
	        })
	    }
	    
	    $.fn.procBtnOnClickEvt = function(url, key){
	        var _this = $(this);
	        _this.on("click", function(){
	            if(baseInfo.insertKey != key){
	                if($("input.index:checked").size() <= 0) {
	                    alert("항목을 선택하시기 바랍니다.");
	                    return false;
	                }else{
	                    document.sForm.reqstSeq.value = $("input.index:checked").val();
	                } 
	            }else{
	               document.sForm.reqstSeq.value = "";
	            }
	            
	            if(baseInfo.deleteKey == key){
	                $.delAction(url, key);
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
	    
	    $.delAction = function(pUrl, pKey){
	        if(!confirm("삭제하시겠습니까?")) return false;
	        document.sForm.procType.value = pKey;
	        var updateData = new FormData($('#sForm')[0]);
	        $.ajax({
	            type: 'POST',
	            url: pUrl,
	            data: new FormData($('#sForm')[0]),
	            processData: false,
				contentType: false,
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
	    
	    $.fn.appliAddRowBtnOnClickEvt = function(){
			var _this = $(this);
			_this.on("click", function(){
				_this=$(this);
				$(".noData").remove();
				$("#applicantTable tr:last").handlerbarsAfterCompile($("#applicant-add-template"));
			})
		}
	    
	    $.fn.instrctrListBtnOnClickEvt = function(){
			var _this = $(this);
			_this.on("click", function(){
				_this=$(this);
				
				var division = "";
				if(_this.prop("id") == "instrctrListBtn") division = "I";
				else division = "S";
				
				document.sForm.reqstSeq.value = $("input.index:checked").val();
				document.sForm.instrctrDivision.value = division;
				document.sForm.sGubun2.value = division;
	 			$.popAction.width = 1200;
				$.popAction.height = 600;
				$.popAction.target = "popup01";
				$.popAction.url = '/ncts/mngr/eduReqstMngr/mngrEduReqstListPopup.do';
				$.popAction.form = document.sForm;
				$.popAction.init();
			})
		}
	    
	    $.fn.appliBtnOnClickEvt = function(pKey){
	    	var _this = $(this);
			_this.on("click", function(){
				var isChk = true;
				
				if($(".idx:checked").length == 0) {
					 alert("항목을 선택하시기 바랍니다.");
	                 return false;
				} else {
					if(baseInfo.insertKey == pKey) {
						if($(".idx:checked").data("seq") != undefined) {
							alert("기존 데이터는 수정할 수 없습니다.");
							return false;
						} else {
							if(!confirm("저장하시겠습니까?")) return false;
							$(".idx:checked").each(function(i){
								var $elements1 = $(this);
								isChk = $.validationCheck($elements1);
								if(isChk) {
									$.beforSubmitRenameForModelAttribute($elements1, i)
								}
							})
						}
					} else if(baseInfo.deleteKey == pKey) {
						if(!confirm("삭제하시겠습니까?")) return false;
						if($(".idx:checked").data("seq") != undefined) {
							$(".idx:checked").each(function(i){
								var $elements2 = $(this);
								$.beforSubmitRenameForModelAttribute($elements2, i);
							})
						} else {
							$(".idx:checked").closest("tr").remove();
							return false;
						}
					}
				}
				if(isChk) {
					document.iForm.procType.value = pKey;
					document.iForm.eduSeq.value = $(".index:checked").val();
					document.iForm.courses.value = $(".index:checked").data("courses");
					$.ajax({
						type: 'POST',
						url: "/ncts/mngr/eduReqstMngr/mngrEduReqstApplicantProcess.do",
						data: $("#iForm").serialize(),
						dataType: "json",
						success: function(data) {
							alert(data.msg);
							if(data.success == "success"){
								$.dataDetail(reqstSeq);
							}
						}
					});
				}
			})
		}
	    
	    $.fn.applStatOnClickEvt = function(){
	    	var _this = $(this);
	    	_this.on("click",".applStatBtn", function(){
	    		var $this = $(this);
	    		var applStat = $this.data("applStat");
	    		
	    		if(applStat == "Y") if(!confirm("불참으로 변경하시겠습니까?")) return false;
	    		if(applStat == "F") if(!confirm("참석으로 변경하시겠습니까?")) return false;
	    		document.iForm.appliSeq.value = $(this).closest("tr").find(".idx").data("seq");
	    		$("input[name='applStat']").val(applStat);
	    		document.iForm.procType.value = baseInfo.updateKey;
	    		
		        $.ajax({
		            type: 'POST',
		            url: "/ncts/mngr/eduReqstMngr/mngrEduReqstApplicantProcess.do",
		            data: $("#iForm").serialize(),
		            dataType: "json",
		            success: function(data) {
		                alert(data.msg);
		                if(data.success == "success"){
		                	$.dataDetail(reqstSeq);
		                    //$.searchAction();
		                }
		            }
		        });
	    	})
	    }
	    
	    $.beforSubmitRenameForModelAttribute = function(e, index) {
	    	var tr = e.closest("tr");
			tr.find("input[name='applicantList.appliSeq']").attr("name","applicantList["+index+"].appliSeq");
			tr.find("input[name='applicantList.userNm']").attr("name","applicantList["+index+"].userNm");
			tr.find("input[name='applicantList.userId']").attr("name","applicantList["+index+"].userId");
			tr.find("input[name='applicantList.userOrg']").attr("name","applicantList["+index+"].userOrg");
			tr.find("input[name='applicantList.userHp']").attr("name","applicantList["+index+"].userHp");
			tr.find("input[name='applicantList.userEmail']").attr("name","applicantList["+index+"].userEmail");
			tr.find("input[name='applicantList.eduQualification']").attr("name","applicantList["+index+"].eduQualification");
			tr.find("input[name='applicantList.applStat']").attr("name","applicantList["+index+"].applStat");
			
			return tr;
		}
	    
	    $.fn.inputCheck = function(){
	    	$(this).on("change keyup keypress", "input", function(){
	    		var $this = $(this);
	    		var name = $this.prop("name");
	    		
	    		if(name.match("userHp") != null) $.phoneNumCheck($this);
	    		if(name.match("userId") != null) $this.val($this.val().replace(/[^a-zA-Z0-9]/g,""));
	    	})
	    }
	    
	    $.validationCheck = function(_this) {
	    	var isChk = true;
	    	_this.closest("tr").find("input[type='text']").each(function(i){
	    		var $this = $(this);
	    		var name = $this.prop("name");

	    		if(!(name.match("userHp") == null && name.match("userNm") == null && name.match("userId") == null)) {
		    		if($this.val().length == 0){
		    			alert("값을 입력해주세요.");
		    			$this.focus();
		    			isChk = false;
		    			return false;
		    		}
				}
	    	})
	    	return isChk;
	    }
	    
	    $.phoneNumCheck = function(_this){
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
	    }
	    
	    $.fn.ubiFormBtnOnClickEvt = function(){
			var _this = $(this);
			_this.on("click", function(){
				var $this = $(this);
				if($("input[name='actStatus']").val() == "Y") {
					document.ubiForm.reqstSeq.value = $("input.index:checked").val();
					popUbiReport();
				} else {
					alert("작성된 강사 보고서가 없습니다.");
				}
			})
		}
	    
	    $.alppyAt = function(val){
	    	var msg;
	    	if("Y" == val){
	    		msg = "비정기교육을 승인하시겠습니까?";
	    	} else if("F" == val){
	    		msg = "비정기교육을 반려하시겠습니까?";
	    	}
	    	
	    	if(!confirm(msg))return false;
	    	  
	    	document.sForm.procType.value = baseInfo.updateKey;
	    	document.sForm.applyAt.value = val;

            $.ajax({
                type: 'POST',
                url: "/ncts/mngr/eduReqstMngr/updateApplAtProcess.do",
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
	    
	    $.instrctrOthbcYn = function(val){
	    	var msg;
	    	
	    	if($(".index:checked").data("apply") == "Y") {
		    	if("Y" == val){
		    		msg = "강사모집을 공개하시겠습니까?";
		    	} else if("N" == val){
		    		msg = "강사모집을 비공개하시겠습니까?";
		    	}
		    	
	    		if(!confirm(msg))return false;
	    	  
	            $.ajax({
	                type: 'POST',
	                url: "/ncts/mngr/eduReqstMngr/mngrEduReqstProcess.do",
	                data			: {
						"reqstSeq" : $("#reqstSeq").val(),
						"procType" : baseInfo.updateKey,
						"instrctrOthbcYn" : val,
						'<c:out value="${_csrf.parameterName}"/>' : '<c:out value="${_csrf.token}"/>'
					},
	                dataType: "json",
	                success: function(data) {
	                    alert(data.msg);
	                    if(data.success == "success"){
	                        $.searchAction();
	                    }
	                }
	            });  
	    	} else {
	    		alert("비정기교육 승인 후 변경 가능합니다.");
	    	}
	    }
	    
		$.fn.complBtnOnClickEvt = function(){
			var _this = $(this);
			
			_this.on("click", function(){
				if($(".idx:checked").length == 0) {
					 alert("항목을 선택하시기 바랍니다.");
	                 return false;
				} else {
					if(!confirm("여러개를 하면, 잘못 처리한 이수증은 다시 되돌릴수가 없으니 신중하시길 바랍니다. 이수 처리 하시겠습니까?")) return false;
					var complVal = "";
					var userNo = "";
					var userId = "";
					var userNm = "";
					var userOrg = "";
					var userHp = "";
					$("input:checkbox[name=complCheck]:checked").each(function(idx){
						var $this = $(this);
						var isChk = true;
						
						if($this.data("applStat") != "Y" || $this.data("userNo") == "") {
							alert("참석하지 않은 회원 또는 비회원은 이수처리 할 수 없습니다.");
							isChk = false;
							complVal = "";
							return false;
						}
						
						if(isChk) {
				            if(idx != 0){
				            	complVal += ',';
				            	userNo += ',';
				            	userId += ',';
				            	userNm += ',';
				            	userOrg += ',';
				            	userHp += ',';
				            }
				            complVal += $(this).data("seq");
				            userNo += $(this).data("userNo");
				            userId += $(this).data("id");
				            userNm += $(this).data("nm");
				            userOrg += $(this).data("org");
				            userHp += $(this).data("hp");
						}
			        });
					if(complVal){
						$.loadingBarStart();
						document.sForm.complProcUser.value = complVal;
						//document.sForm.userNo.value = userNo;
						document.sForm.userOrg.value = userOrg;
						document.sForm.userId.value = userId;
						document.sForm.userNm.value = userNm;
						document.sForm.userHp.value = userHp;
						document.sForm.procType.value = baseInfo.updateKey;
						document.sForm.reqstSeq.value = $(".tr_clr_2").children(".invisible").children(".index").val();
						document.sForm.courses.value = $(".tr_clr_2").children(".invisible").children(".index").data("courses");
							
						$.ajax({
							type: 'POST',
							url: "/ncts/mngr/eduReqstMngr/updateReqstComplProgress.do",
							data: $("#sForm").serialize(),
							dataType: "json",
							success: function(data) {
								alert(data.msg);
								if(data.success == "success"){
									$.dataDetail(reqstSeq);
									document.sForm.complProcUser.value = '0';
									document.sForm.userNo.value = '0';
									document.sForm.userOrg.value = '';
									document.sForm.userId.value = '';
									document.sForm.userNm.value = '';
									document.sForm.userHp.value = '';
								}
							},
							error: function(request,status,error) {
								alert(data.msg);
							},
							complete: function() {
								$.loadingBarClose();
							}				
						})
					}
				}
				
			});
		}
		
		$.fn.appliListBtnOnClickEvt = function(){
			var _this = $(this);
			_this.on("click", function(){
				var $this = $(this);
				var id = $this.prop("id");
				$.dataDetail($(".index:checked").val(), id);
				if(id == "nonUserBtn") {
					$this.html("회원리스트");
					$this.prop("id","userBtn");
				}
				else {
					$this.html("비회원리스트");
					$this.prop("id","nonUserBtn");
				}
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
	    
		$.fn.userDetailTdOnClickEvt = function(){
			$(this).on("click", function(){
				var $this = $(this);
				var userNo = $this.data("no");
				if(userNo == "") {
					alert("데이터가 없습니다.");
					return false;
				}
				document.userForm.userNo.value = userNo;
				$.popAction.width = 1200;
				$.popAction.height = 600;
				$.popAction.target = "selectEduMemberDetailPopup2";
				$.popAction.url = "/ncts/mngr/common/selectEduMemberDetailPopup.do";
				$.popAction.form = document.userForm;
				$.popAction.init();
			})
		}		
		
	    $.fn.updateDetailBtnOnClickEvt = function(){
	    	$(this).on("click", "#updateDetailBtn", function(){
	    		var $this = $(this);
	    		document.sForm.eduSeq.value = document.sForm.reqstSeq.value;
	    		$.popAction.width = 1200;
				$.popAction.height = 600;
				$.popAction.target = "mngrEdcRequsetUpdateCenterListPopup";
				$.popAction.url = baseInfo.pop01;
				$.popAction.form = document.sForm;
				$.popAction.init();
	    	})
	    }		
	    
	    $.initView = function(){
	        $.onClickTableTr();
	        $("#searchBtn").searchBtnOnClickEvt($.searchAction);
	        $("#saveBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.insertKey);
	        $("#updBtn").procBtnOnClickEvt(baseInfo.fUrl, baseInfo.updateKey);
	        $("#delBtn").procBtnOnClickEvt(baseInfo.dUrl, baseInfo.deleteKey);
	        $("#appliAddRowBtn").appliAddRowBtnOnClickEvt();
	        $("#appliAddBtn").appliBtnOnClickEvt(baseInfo.insertKey);
	        $("#appliDelBtn").appliBtnOnClickEvt(baseInfo.deleteKey);
	        $(".instrctrListBtn").instrctrListBtnOnClickEvt();
	        $("#complBtn").complBtnOnClickEvt(baseInfo.updateKey);
	        $(".appliListBtn").appliListBtnOnClickEvt();
	        $("#applicantTable").applStatOnClickEvt();
	        $("#applicantTable").inputCheck();
	        $(document).on("change", "#allCheck", function(){
				var _this = $(this);
				var $tbody = _this.parents("tbody");
				
				if($tbody.find(".addTr").length > 0) {
					if(_this.is(":checked")) $tbody.find(".addTr input[type='checkbox']").prop("checked", true);
					else $tbody.find("input[type='checkbox']").prop("checked", false);
					
				} else {
					if(_this.is(":checked")){
						$("input:checkbox[name=complCheck]").each(function(){
							var $this = $(this);
							if($this.data("applStat") == "Y" && $this.data("userNo") != "")
								$this.prop('checked', true);
			            });
					} else{
						$("input:checkbox[name=complCheck]").each(function(){
							$(this).prop('checked', false);
						});
					}
				}
			});
	        $(".reportDown").ubiFormBtnOnClickEvt();
	        $(".excelDown").on("click", function(){
	        	var _this = $(this);
	        	var url = $("input.index:checked").next(".file_wrap");
	        	
	        	if(url.length == 0) alert("업로드 된 파일이 없습니다.");
	        	else {
	        		url = url.find("a").prop("href");
	        		location.href = url;
	        	}
	        });
	        $(".excelDownInfo").on("click", function(e){
				var $this = $(this);
				
				$("[name='excelFileNm']").val("비정기교육관리 연락처명단_"+$.toDay());
				$("[name='excelPageNm']").val("mngrEdcRequestApplicantInfoList.xlsx");
				excelPg = 1;
				with(document.sForm){
					target = "";
					action = baseInfo.excel;
					eduSeq.value = $("input.index:checked").val();
					submit();
					
					$.setCookie("fileDownloadToken","false");
	                $.loadingBarStart(e);
	                $.checkDownloadCheck();
				}
			});
	        
	        $("body").on("keydown", function(e){
		        $.loadingBarKeyDown(e, excelPg);
	        })
	        
	        $(document).on("click", "button[name=applAt]", function(){
	        	var _this = $(this);
	        	$.alppyAt(_this.data("applAt"));
	        });
	        $(document).on("click", "button[name=instrctrOthbcYn]", function(){
	        	var _this = $(this);
	        	$.instrctrOthbcYn(_this.data("instrctrOthbc"));
	        });
	        
	        $("body").updateDetailBtnOnClickEvt();
	    }
	    
	    $.initView();
	})
</script>

		
<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/ribbon.jsp" flush="false" />
<form id="ubiForm" name="ubiForm" method="post">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
	<input type="hidden" id="ubi_jrt" name="jrf" value="INSTRCTR_R001.jrf" />
	<input type="hidden" name="reqstSeq" value="" />
	<input type="hidden" name="instrctrNo" value="" />
	<input type="hidden" name="actStatus" value="" />
	<input type="hidden" name="eduDivision" value="02" />
</form>

<!-- MAIN CONTENT -->
<div id="content">
	<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/menuTitle.jsp" flush="false" />
	
	<!-- widget grid start -->
	<section id="widget-grid" class="">
		<!-- Search 영역 시작 -->
		<div class="search">
          	<form name="sForm" id="sForm" method="post" enctype="multipart/form-data">
				<input type="hidden" name="excelFileNm" id="excelFileNm"  value="">
				<input type="hidden" name="excelPageNm" id="excelPageNm"  value="">          	
                <input type="hidden" name="reqstSeq" id="reqstSeq" value="0">
                <input type="hidden" name="eduSeq" id="eduSeq" value="0">
                <input type="hidden" name="applyAt" id="applyAt" value="">
                <input type="hidden" name="complYn" id="complYn" value="">
                <input type="hidden" name="instrctrDivision" value="" />
				<input type="hidden" name="sGubun2" value="" />
				<input type="hidden" name="instrctrOthbcYn" id="instrctrOthbcYn" value="" />
				<input type="hidden" name="complProcUser" id="complProcUser"  value="">
				<input type="hidden" name="userOrg" id="userOrg"  value="">
				<input type="hidden" name="userId" id="userId"  value="">
				<input type="hidden" name="userNm" id="userNm"  value="">
				<input type="hidden" name="userNo" id="userNo"  value="0">
				<input type="hidden" name="userHp" id="userHp"  value="">
				<input type="hidden" name="courses" id="courses"  value="">
				<input type="hidden" name="eduDivision" id="eduDivision"  value="02">
                <div class="fL wp70">
                    <ul class="searchAreaBox">
						<li class="smart-form">
						    <label class="label">센터명</label>
						</li>
						<sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')">
							<li class="w150 mr5">
								<select name="centerCd" class="form-control">
									<option value="">전체</option>
									<c:forEach var="center" items="${centerList }" varStatus="idx">
										<option value='<c:out value="${center.DEPT_CD }"/>' data-groupId='<c:out value="${center.GROUP_ID }"/>' <c:out value="${center.DEPT_CD eq param.centerCd ? 'selected=selected':'' }"/>><c:out value="${center.DEPT_NM }"/></option>
									</c:forEach>
								</select> <i></i>
							</li>
						</sec:authorize>
						<sec:authorize access="hasRole('ROLE_ADMIN') or hasRole('ROLE_USER')">
							<li class="smart-form mr5">
								<input type="hidden" name="centerCd" value="<sec:authentication property="principal.centerId"/>" >
								<label class="label"><sec:authentication property="principal.centerNm"/></label>
							</li>
						</sec:authorize>                    
                    
                        <li class="smart-form"><label class="label">요청기관명</label></li>
                        <li class="w200 ml5">
                            <input id="searchKeyword1" name="searchKeyword1" class="form-control" value='<c:out value="${param.searchKeyword1}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">요청교육</label></li>
                        <li class="w200 ml5">
                            <input id="searchKeyword5" name="searchKeyword5" class="form-control" value='<c:out value="${param.searchKeyword5}"/>'> 
                        </li>
                        <li class="smart-form ml5"><label class="label">담당자명</label></li>
                        <li class="w80 ml5">
                            <input id="searchKeyword2" name="searchKeyword2" class="form-control" value='<c:out value="${param.searchKeyword2}"/>'> 
                        </li>
                        <li class="ml10">
                            <button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
                        </li>
                    </ul>
                </div>
                <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
                    <jsp:param value="list"     name="formType"/>
                    <jsp:param value="2,3"     name="buttonYn"/>
                </jsp:include>
                <jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
            </form>
		</div>
		<!-- Search 영역 끝 -->
		
		<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />
		
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-5">
					<table class="table table-bordered tb_type01 listtable">
						<colgroup>
							<col width="auto%">
							<col width="13%">
							<col width="12%">
							<col width="6%">
                            <col width="10%">
                            <col width="10%">
                            <col width="8%">
                            <col width="5%">
                            <col width="8%">
                            <col width="6%">
						</colgroup>
						<thead>
							<tr>
								<th class="invisible"></th>
								<th>센터명</th>
								<th>요청기관명</th>
								<th>요청교육</th>
								<th>교육 일시</th>
								<th>담당자명</th>
								<th>연락처<br>(휴대전화)</th>
								<th>대상</th>
								<th>인원</th>
								<th>등록일</th>
								<th>승인<br>여부</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty list }">
								<tr><td colspan="9">데이터가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="list" items="${list }" varStatus="idx">
								<tr>
									<td class="invisible">
										<input type="checkbox" class="index" value='<c:out value="${list.REQST_SEQ}"/>' data-apply='<c:out value="${list.APPLY_AT }"/>' data-courses='<c:out value="${list.COURSES }"/>'>
										<c:out value="${list.fileView}"/>
										<%-- <input type="hidden" name = "searchLectureSq" value="${list.LECTURE_SQ}"> --%>
									</td>
									<td><c:out value="${list.CENTER_NM }"/></td>
									<%-- <td>${!empty list.DIST_MANAGE_NM ? list.DIST_MANAGE_NM : '전체'  }</td> --%>
									<td><c:out value="${list.REQST_INSTT}"/></td>
									<td><c:out value="${empty list.REQST_EDUCATION_TXT ? list.REQST_EDUCATION : list.REQST_EDUCATION_TXT}"/>
									<%-- ,${list.REQST_EDUCATION}, ${list.REQST_EDUCATION_TXT} --%></td>
									<td><c:out value="${list.START_DATE}"/>~<br><c:out value="${list.END_DATE}"/><br><c:out value="${list.START_TIME}"/>~<c:out value="${list.END_TIME}"/></td>
									<td><c:out value="${list.REQST_CHARGER  }"/></td>
									<td><c:out value="${list.REQST_HP_NO}"/></td>
									<td><c:out value="${list.REQST_TARGET }"/></td>
									<td><c:out value="${list.REQST_NMPR }"/></td>
									<td><c:out value="${list.REGIST_PNTTM }"/></td>
									<td><c:out value="${list.APPLY_AT }"/></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/pageinfo.jsp" flush="false" />
				</article>
				
				<article class="col-md-12 col-lg-7">
					<table class="table table-bordered tb_type03">
						<colgroup>
							<col width="20%">
							<col width="30%">
							<col width="20%">
							<col width="30%">
						</colgroup>
						<tbody id="detailTable">
							<tr><td colspan="6" class="textAlignCenter">항목을 선택해주세요.</td></tr>
						</tbody>
					</table>
					
					<c:if test="${not empty list }">
						<c:if test="${pageInfo.INSERT_AT eq 'Y'}">
							<button type="button" class="btn btn-primary ml2 mb5 instrctrListBtn" id="instrctrListBtn">
								<i class="fa fa-edit" title="주강사 배정"></i>주강사 배정
							</button>
							<button type="button" class="btn btn-primary ml2 mb5 instrctrListBtn" id="copInstrctrListBtn">
								<i class="fa fa-edit" title="준강사 배정"></i>준강사 배정
							</button>
						</c:if>
						<c:if test="${pageInfo.EXCEL_AT eq 'Y'}">
							<button type="button" class="btn btn-default ml2 mb5 excelDown" id="">
								<i class="fa fa-print" title="교육증빙자료"></i> 교육증빙자료
							</button>		
						</c:if>
						<c:if test="${pageInfo.REPORT_AT eq 'Y'}">
							<button type="button" class="btn btn-default ml2 mb5 reportDown" id="">
								<i class="fa fa-print" title="강사 보고서"></i> 강사 보고서
							</button>
						</c:if>							
						<c:if test="${pageInfo.INSERT_AT eq 'Y'}">
							<button type="button" class="btn btn-primary ml2 mb5" id="appliAddRowBtn">
								<i class="fa fa-edit" title="추가"></i>추가
							</button>						
							<button type="button" class="btn btn-danger ml2 mb5" id="appliDelBtn">
								<i class="fa fa-edit" title="삭제"></i>삭제
							</button>						
							<button type="button" class="btn btn-primary ml2 mb5" id="appliAddBtn">
								<i class="fa fa-edit" title="저장"></i>저장
							</button>						
							<button type="button" class="btn btn-primary ml2 mb5" id="complBtn">
								<i class="fa fa-edit" title="이수"></i>이수
							</button>		
						</c:if>				
						<!-- <button type="button" class="btn btn-danger ml2 mb5 appliListBtn" id="nonUserBtn">
							<i class="fa fa-edit" title="비회원리스트"></i>비회원리스트
						</button>	 -->	
						<c:if test="${pageInfo.EXCEL_AT eq 'Y'}">				
							<button type="button" class="btn btn-default ml2 mb5 excelDownInfo" id="">
								<i class="fa fa-print" title="연락처 명단" data-title="연락처 명단"></i> 연락처 명단
							</button>						
						</c:if>
						<form name="iForm" id="iForm" method="post" class="smart-form">
							<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
							<input type="hidden" name="courses">
							<input type="hidden" name="appliSeq">
							<input type="hidden" name="eduSeq" >
							<input type="hidden" name="userNm" >
							<input type="hidden" name="userId" >
							<input type="hidden" name="userOrg">
							<input type="hidden" name="userHp" >
							<input type="hidden" name="userEmail" >
							<input type="hidden" name="eduQualification">
							<input type="hidden" name="applStat">
							<table class="table table-bordered table-hover tb_type01">
								<colgroup>
									<col width="7%">
									<col width="8%">
									<col width="9%">
									<col width="9%">
									<col width="10%">
									<col width="12%">
									<col width="auto">
									<col width="13%">
									<col width="10%">
									<col width="10%">
								</colgroup>
								
								<tbody id="applicantTable">	
								</tbody>
							</table>
						</form>
					</c:if>		
				</article>
				<form name="userForm" id="userForm" method="post" class="smart-form">
					<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
					<input type="hidden" name="userNo" value="">
				</form>		
							
			</div>
			<!-- row 메뉴조회 끝 -->
		</div>
	</section>
	<!-- widget grid end -->

</div>
<!-- END MAIN CONTENT -->

<script id="detail-template" type="text/x-handlebars-template">
<tr>
	<th scope="row">요청기관명 </th>
	<td colspan="3">{{REQST_INSTT}}</td>
</tr>
<tr>
	<th scope="row">요청지역</th>
	<td colspan="3">{{REQST_ADDRESS_NM}}</td>
</tr>
<tr>
	<th scope="row">대상</th>
	<td>{{REQST_TARGET}}</td>
    <th scope="row">인원</th>
    <td>{{REQST_NMPR}}</td>
</tr>
<tr>
	<th scope="row">요청교육</th>
	<td colspan="5">
    	{{REQST_EDUCATION_TXT}}
	</td>
</tr>
<tr>
	<th scope="row">교육일시</th>
	<td>{{START_DATE}}{{#notempty END_DATE}}~{{END_DATE}}{{/notempty}}<br/> {{START_TIME}} ~ {{END_TIME}}</td>
	<th scope="row">캘린더노출여부</th>
	<td>{{#ifeq CALENDAR_YN 'Y'}}Y{{/ifeq}}</td>
</tr>
<tr>
    <th scope="row">담당자명</th>
    <td>{{REQST_CHARGER}}</td>
    <th scope="row">강사명</th>
    <td>{{REGST_INSTRCTR_NM}}</td>
</tr>
<tr>
	<th scope="row">연락처(기관)</th>
	<td>{{REQST_PHONE_NO}}</td>
    <th scope="row">연락처(휴대전화)</th>
    <td>{{REQST_HP_NO}}</td>
</tr>
<tr>
    <th scope="row">이메일</th>
    <td colspan="3">{{REQST_EMAIL}}</td>
</tr>
<tr>
    <th scope="row">기타</th>
    <td colspan="3">{{REQST_ETC}}</td>
</tr>
<tr>
    <th scope="row">작성일시</th>
    <td colspan="3">{{REGIST_PNTTM}}</td>
</tr>
<tr>
    <th scope="row">승인여부</th>
    <td>{{APPLY_AT}}</td>
    <th>승인/반려</th>
    <td>
        <button class="btn btn-primary applStatBtn" name="applAt" type="button" style="padding: 7px 13px;" data-appl-at="Y" <c:out value="${pageInfo.INSERT_AT eq 'Y' ? '':'disabled'}"/>>
            <i class="fa" title="승인"></i>승인
        </button>
        <button class="btn btn-danger applStatBtn" name="applAt" type="button" style="padding: 7px 13px;" data-appl-at="F" <c:out value="${pageInfo.INSERT_AT eq 'Y' ? '':'disabled'}"/>>
            <i class="fa" title="반려"></i>반려
        </button>
    </td>
</tr>
<tr>
    <th scope="row">강사모집여부</th>
    <td>{{INSTRCTR_OTHBC_YN}}</td>
    <th>공개/비공개</th>
    <td>
    	<button class="btn btn-primary instrctrOthbcBtn" name="instrctrOthbcYn" type="button" style="padding: 7px 13px;" data-instrctr-othbc="Y" <c:out value="${pageInfo.INSERT_AT eq 'Y' ? '':'disabled'}"/>>
        	<i class="fa" title="공개"></i>공개
        </button>
        <button class="btn btn-danger instrctrOthbcBtn" name="instrctrOthbcYn" type="button" style="padding: 7px 13px;" data-instrctr-othbc="N" <c:out value="${pageInfo.INSERT_AT eq 'Y' ? '':'disabled'}"/>>
        	<i class="fa" title="비공개"></i>비공개
        </button>
    </td>
</tr>
<tr>
	<th scope="row">강사모집기간</th>
	<td colspan="5">
		{{#notempty INSTRCTR_START_DE}} {{INSTRCTR_START_DE}} {{INSTRCTR_START_HH}}:{{INSTRCTR_START_MM}} ~ {{INSTRCTR_END_DE}} {{INSTRCTR_END_HH}}:{{INSTRCTR_END_MM}}{{/notempty}}
	</td>
</tr>
<tr>
	<th scope="row">센터명</th>
	<td colspan="5">
		{{CENTER_NM}}
		<c:if test="${userinfo.deptAllAuthorAt eq 'Y' }">
			{{#ifnoteq CENTER_CNT "0"}}
				<button type="button" class="btn btn-default ml2 mb5" id="updateDetailBtn">
	    			<i class="fa fa-search" title="변경내역"></i>변경내역
				</button>
			{{/ifnoteq}}
		</c:if>
	</td>
</tr>
<sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')">
<tr>
	<th scope="row">참고사항</th>
	<td colspan="5">
		{{#ifnoteq fileView ""}}
			{{#ifnoteq REFER_MATTER_MEMO ""}}
				{{safe fileView}}
			 	<div style="border-top: 2px solid #d2d2d2; margin: 10px 0;"></div>
			{{/ifnoteq}}
		{{/ifnoteq}}
		{{#ifeq REFER_MATTER_MEMO ""}}
			{{safe fileView}}
		{{/ifeq}}
			{{safe REFER_MATTER_MEMO}}
	</td>
</tr>
</sec:authorize>
</div>
</script>
<script id="applicant-add-template" type="text/x-handlebars-template">
	<tr class="addTr">
		<input type="hidden" name="applicantList.eduSeq" class="w80">
		<td class="w50"><input type="checkbox" class="idx"></td>
		<td></td>
		<td><label class="input w60"><input type="text" name="applicantList.userNm" class="w60" maxlength="40"></label></td>
		<td><label class="input w60"><input type="text" name="applicantList.userId" class="w60" maxlength="20"></label></td>
		<td><label class="input w100"><input type="text" name="applicantList.userOrg" class="w100" maxlength="200"></label></td>
		<td><label class="input w110"><input type="text" name="applicantList.userHp" class="w100" maxlength="13"></label></td>
		<td><label class="input w30"><!-- <input type="text" name="applicantList.userEmail" class="w100" maxlength="100"> --></label></td>
		<td><label class="input w110"><input type="text" name="applicantList.eduQualification" class="w110" maxlength="100"></label></td>
		<td><input type="hidden" name="applicantList.applStat" value="Y">참석</td>
		<td><input type="hidden" name="applicantList.complYn" value="N">미이수</td>
	</tr>
</script>
<script id="applicant-template" type="text/x-handlebars-template">
<tr>
	<th><input type="checkbox" id="allCheck"></th>
	<th>No</th>
	<th>성명</th>
	<th>아이디</th>
	<th>소속</th>
	<th>휴대폰 번호</th>
	<th>이메일</th>
	<th>전문자격</th>
	<th>참석여부</th>
	<th>이수여부</th>
</tr>
{{#if .}}
{{#each .}}
	<tr>
    	<td><input type="checkbox" name="complCheck" class="idx" data-seq="{{APPLI_SEQ}}" data-user-no="{{USER_NO}}" data-org="{{USER_ORG}}" data-id="{{USER_ID}}" data-nm="{{USER_NM}}" data-hp="{{USER_HP}}" data-appl-stat="{{APPL_STAT}}"></td>
		<td>{{inc @key}}</td>
		<td class="userDetailTd" data-no={{USER_NO}}>{{USER_NM}}</td>
		<td>{{USER_ID}}</td>
		<td>{{USER_ORG}}</td>
		<td>{{USER_HP}}</td>
		<td>{{USER_EMAIL}}</td>
		<td>{{EDU_QUALIFICATION}}</td>
		<td>
			{{#empty USER_NO}}
				<button class="btn btn-danger" name="applStat" type="button" style="padding: 7px 13px;" data-appl-stat="{{APPL_STAT}}">
                  <i class="fa" title="ID없음"></i>ID없음
            	</button>
			{{/empty}}
			{{#notempty USER_NO}}
         		{{#ifeq APPL_STAT "Y"}}
            		<button class="btn btn-primary applStatBtn" name="applStat" type="button" style="padding: 7px 13px;" data-appl-stat="{{APPL_STAT}}" <c:out value="${pageInfo.INSERT_AT eq 'Y' ? '':'disabled'}"/>>
                  		<i class="fa" title="참석"></i>참석
            		</button>
         		{{/ifeq}}
         		{{#ifeq APPL_STAT "F"}}
            		<button class="btn btn-danger applStatBtn" name="applStat" type="button" style="padding: 7px 13px;" data-appl-stat="{{APPL_STAT}}" <c:out value="${pageInfo.INSERT_AT eq 'Y' ? '':'disabled'}"/>>
                  		<i class="fa" title="불참"></i>불참
            		</button>
         		{{/ifeq}}
         		{{#ifeq APPL_STAT "N"}}
		 			취소{{#notempty CANCEL_DATE}}({{CANCEL_DATE}}){{/notempty}}
         		{{/ifeq}}
				{{#ifeq APPL_STAT "I"}}
					<button class="btn btn-danger" name="applStat" type="button" style="padding: 7px 13px;" data-appl-stat="{{APPL_STAT}}">
                  		<i class="fa" title="등급미달"></i>등급미달
            		</button>
				{{/ifeq}}
			{{/notempty}}
        </td>
		<td>
        	{{#ifeq COMPL_YN "Y"}}
	          	이수
         	{{/ifeq}}
         	{{#ifnoteq COMPL_YN "Y"}}
				미이수
         	{{/ifnoteq}}
        </td>
		<input type="hidden" name="applicantList.appliSeq" value="{{APPLI_SEQ}}">
		<input type="hidden" name="applicantList.eduSeq" value="">
		<input type="hidden" name="applicantList.userNm" value="{{USER_NM}}">
		<input type="hidden" name="applicantList.userId" value="{{USER_ID}}">
		<input type="hidden" name="applicantList.userOrg" value="{{USER_ORG}}">
		<input type="hidden" name="applicantList.userHp" value="{{USER_HP}}">
		<input type="hidden" name="applicantList.userEmail" value="{{USER_EMAIL}}">
		<input type="hidden" name="applicantList.eduQualification" value="{{EDU_QUALIFICATION}}">
		<input type="hidden" name="applicantList.applStat" value="{{APPL_STAT}}">
	</tr>
{{/each}}
{{else}}
	<tr class="noData">                           
		<td colspan="10">신청자가 없습니다.</td>             
	</tr>
{{/if}}
</script>

<script id="non-applicant-template" type="text/x-handlebars-template">
<tr>
	<th>선택</th>
	<th>No</th>
	<th>성명</th>
	<th>아이디</th>
	<th>소속</th>
	<th>휴대폰 번호</th>
	<th>이메일</th>
	<th>전문자격</th>
	<th>상태</th>
</tr>
{{#if .}}
{{#each .}}
	<tr>
    	<td><input type="checkbox" name="complCheck" class="idx" data-seq="{{APPLI_SEQ}}" data-user-no="{{USER_NO}}"></td>
		<td>{{inc @key}}</td>
		<td>{{USER_NM}}</td>
		<td>{{USER_ID}}</td>
		<td>{{USER_ORG}}</td>
		<td>{{USER_HP}}</td>
		<td>{{USER_EMAIL}}</td>
		<td>{{EDU_QUALIFICATION}}</td>
		<td>
         {{#ifeq APPL_STAT "R"}}
			ID없음
         {{/ifeq}}
         {{#ifeq APPL_STAT "N"}}
		 	취소{{#notempty CANCEL_DATE}}({{CANCEL_DATE}}){{/notempty}}
         {{/ifeq}}
         {{#ifeq APPL_STAT "F"}}
		 	반려됨
         {{/ifeq}}
        </td>
		<input type="hidden" name="applicantList.appliSeq" value="{{APPLI_SEQ}}">
		<input type="hidden" name="applicantList.eduSeq" value="">
		<input type="hidden" name="applicantList.userNm" value="{{USER_NM}}">
		<input type="hidden" name="applicantList.userId" value="{{USER_ID}}">
		<input type="hidden" name="applicantList.userOrg" value="{{USER_ORG}}">
		<input type="hidden" name="applicantList.userHp" value="{{USER_HP}}">
		<input type="hidden" name="applicantList.userEmail" value="{{USER_EMAIL}}">
		<input type="hidden" name="applicantList.eduQualification" value="{{EDU_QUALIFICATION}}">
		<input type="hidden" name="applicantList.applStat" value="{{APPL_STAT}}">
	</tr>
{{/each}}
{{else}}
	<tr class="noData">                           
		<td colspan="10">신청자가 없습니다.</td>             
	</tr>
{{/if}}
</script>