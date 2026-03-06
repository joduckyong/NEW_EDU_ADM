
var currentYear = new Date().getFullYear();
currentYear=currentYear+20;
var validator;
var addrClass = "";

var upperFirstLetter = function(str){
    return str.charAt(0).toUpperCase() + str.slice(1);
}
var lowerFirstLetter = function(str){
    return str.charAt(0).toLowerCase() + str.slice(1);
}

var snakeToCamel=function(str){
    return str.toLowerCase().replace(/(\_[a-zA-z0-9])/g, function(arg){
        return arg.toUpperCase().replace('_','');
    });
}

var camelToSnake=function(str){
    return str.replace(/([A-Z])/g, function(arg){
        return "_"+arg.toLowerCase();
    }).toUpperCase();
}

var popUbiReport = function(){
	popWidth = 850;
	popHeight = 1000;
	var popWidth = parseInt(popWidth);
	var popHeight = parseInt(popHeight);
    var winHeight = screen.height;    // 현재창의 높이
    var winWidth  = screen.width;   // 현재창의 너비
	var winX = window.screenLeft;	// 현재창의 x좌표
	var winY = window.screenTop;	// 현재창의 y좌표

	var popX = winX + (winWidth - popWidth)/2; 
	var popY = winY + (winHeight - popHeight)/2;
	
	var popOption = "width = "+popWidth+"px,";
	   popOption += "height = "+popHeight+"px,";
	   popOption += "top = "+popY+"px,";
	   popOption += "left = "+popX+"px,";
	   popOption += "resizable = no,";
	   popOption += "status = no";
	
	window.open("about:blank", "DMHISReport", popOption);
	
	$("#ubiForm").attr("target", "DMHISReport");
	$("#ubiForm").attr("action", "/ubi4/ubi_popup.jsp");
	$("#ubiForm").submit();
}

$.showPopLayer = function(id){
	var obj = $('#'+id);
	var W = $(window).width();
	var H = $(window).height();
	var w = $(obj).width();
	var h = $(obj).height();
	$(obj).css({left:(W-w)/2, top:(H-h)/2});

	$('#'+id).parent().addClass("page_ing_wrap");
	obj.show();
}


$.closePopLayer = function(id) {
	var obj = $('#'+id);
	$('#'+id).parent().removeClass("page_ing_wrap");
	obj.hide(); 	
}

$.addSearchResetBtn = function() {
	var $search = $(".searchReset");
	if($search.size() == 0) return false;
	
	var $li = $('<li class="ml-1 ml5" />');
	var $button = $('<button class="btn btn-default" type="button"><i class="fa fa-trash-o" title="초기화"></i></button>');
	
	$li.append($button);
	
	$search.parent().after($li);
	
	$button.on("click", function(){
		var $box = $(".searchAreaBox");
		
		var inputs = $box.find("input");
		inputs.each(function(index, item){ item.value = ""; });
		
		var combos = $box.find("select");
		combos.each(function(index, item){ $(item).find("option:first").prop("selected",true) });
		
	})
}
$.addAllSearchResetBtn = function() {
	var $search = $(".allSearchReset");
	if($search.size() == 0) return false;
	
	var $li = $('<li class="ml-1 ml5" />');
	var $button = $('<button class="btn btn-default" type="button"><i class="fa fa-trash-o" title="초기화"></i></button>');
	
	$li.append($button);
	
	$search.parent().after($li);
	
	$button.on("click", function(){
		var $box = $(".searchAreaBox");
		
		var inputs = $box.find("input");
		inputs.each(function(index, item){ item.value = ""; item.checked = ""; });
		
		var combos = $box.find("select");
		combos.each(function(index, item){ $(item).find("option:first").prop("selected",true) });
		
	})
}

stringBuffer = function() {
	this.buffer = new Array();
	
	stringBuffer.prototype.append = function(str) {
		this.buffer[this.buffer.length] = str;
	};
	
	stringBuffer.prototype.toString = function() {
		return this.buffer.join("");
	}
	
}

$.extend({
	isNull : function(obj){
		return (( typeof(obj) == "undefined") || ( obj == null ) );
	},
	isNullStr : function(value){
		return ( ($.isNull(value)) || value.length == 0);
	},
	linkPage : function(no){
		$.searchAction({"pageNo" : no});
	},
	buttonToggle : function(session, creuser){
		if("system".indexOf(session) == -1){
			if(session == creuser){
				$("#updBtn").show();
				$("#delBtn").show();
			}else{
				$("#updBtn").hide()
				$("#delBtn").hide();
			}
		}
	},
	curCSS : function(element, prop, val){
		return $(element).css(prop, val);
	},
	setTabMove : function(obj){
		if(obj){
			var form = document.tabMoveForm;
			for(var key in obj){
				var element = $(form).find("input[name='"+key+"']");
				if(element.size() > 0) element.val(obj[key])
				else $(form).append('<input type="hidden" name="'+ key +'" value="'+obj[key]+'">')
			}
		}
	},
	popAction : {
		width  : null,
		height : null,
		target : null,
		form   : null,
		url    : null,
		init   : function(){
			if(!this.width){
				console.log("width 값 누락");
				return false;
			}else if(!this.height){
				console.log("height 값 누락");
				return false;
			}else if(!this.target){
				console.log("target 값 누락");
				return false;
			}else if(!this.form){
				console.log("form 값 누락");
				return false;
			}else if(!this.url){
				console.log("url 값 누락");
				return false;
			}
			
			var popWidth = parseInt(this.width);
			var popHeight = parseInt(this.height);
		    var winHeight = screen.height;    // 현재창의 높이
		    var winWidth  = screen.width;   // 현재창의 너비
			var winX = window.screenLeft;	// 현재창의 x좌표
			var winY = window.screenTop;	// 현재창의 y좌표

			var popX = winX + (winWidth - popWidth)/2; 
			var popY = winY + (winHeight - popHeight)/2;
			
			var popOption = "width = "+popWidth+"px,";
			   popOption += "height = "+popHeight+"px,";
			   popOption += "top = "+popY+"px,";
			   popOption += "left = "+popX+"px,";
			   popOption += "resizable = no,";
			   popOption += "status = no,";
			   popOption += "scrollbars = yes";
			
			var openpop = window.open('about:blank', this.target, popOption);
			   
			$(this.form).attr("target", this.target);
			$(this.form).attr("action", this.url);
			$(this.form).submit();
			
			return openpop;
		}
	},
	hiddenObj : function($selector){
		var $hidden = $selector.parent().find("[type='hidden']");
		var obj = new Object();
		if($hidden.size() > 0){
			$hidden.each(function(){
				obj[$(this).attr("name")] = $(this).val(); 
			})	
		}
		
		return obj;
	},
	getRealAge : function(day){
		var date = new Date();
		var cyear = date.getFullYear();
		var cmonth = ("0" + (date.getMonth() + 1)).slice(-2);
		var cday = ("0" + date.getDate()).slice(-2);
		
		var year = day.substring(0,4);
		var month = day.substring(5,7);
		var day = day.substring(8,10);
		
		var old = parseInt(cyear)  - parseInt(year);
		if(month * 100 + day > cmonth * 100 + cday){
			old--;
		}
		
		return old;
		
	},
	toDay : function(){
		var now = new Date();

		var year= now.getFullYear();
		var mon = (now.getMonth()+1)>9 ? ''+(now.getMonth()+1) : '0'+(now.getMonth()+1);
		var day = now.getDate()>9 ? ''+now.getDate() : '0'+now.getDate();
		        
		var chan_val = year + mon +  day;
		
		return chan_val;
	}
})


(function($){
	$.fn.telChk = function(){
		var _this = $(this);
		_this.on("change", function(){
			var $this = $(this);
			var tel = $this.val();
			tel = tel.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
			$this.val(tel);
		})
	}
	$.fn.openLayer = function(data,callback){
		var $this = $(this);
		
		if($this.parent().hasClass("page_ing_wrap")) $this.unwrap();
		$this.wrap("<div class='page_ing_wrap' />");
		if(typeof callback == "function") callback(data);
		
		var W = $(window).width();
		var H = $(window).height();
		var w = $this.width();
		var h = $this.height();
		$this.css({left:(W-w)/2, top:(H-h)/2});
		
		$(".closeLayer").off().on("click", function(){
			$this.unwrap();
		})
	}
	
	$.fn.openLayerEdit = function(data,callback){
		var $this = $(this);
		
		if($this.parent().hasClass("page_ing_wrap")) $this.unwrap();
		$this.wrap("<div class='page_ing_wrap' />");
		if(typeof callback == "function") callback(data);
		
		$(".closeLayer").off().on("click", function(){
			$this.unwrap();
			$("#layerDetailTable").empty();
		})
	}
	
	$.fn.searchBtnOnClickEvt = function(callback){
		var _this = $(this);
		_this.on("click", function(){
			if(typeof callback == "function") callback(); 
		})
	}
	
	$.fn.goBackList = function(callback){
		var _this = $(this);
		_this.on("click", function(){
			if(typeof callback == "function") callback(); 
		})
	}
	
	$.ajaxSetup({
		beforeSend : function(jqXHR) {
            jqXHR.setRequestHeader("AJAX", true);
        },
        complete: function() {
        	if(window.sessionTimer) {
        		window.sessionTimer.reset();
        	}
        },
		error : function(request,status,error){
			if(typeof $.afterSubmitRemoveRule != "undefined") $.afterSubmitRemoveRule();
			if(typeof $.afterSubmitRenameForView != "undefined") $.afterSubmitRenameForView();
			
			if(request.status == 901){
				alert("권한이 없습니다.");
				location.href = "/ncts/login/egovLoginForm.do"
			}else if(request.status == 403 || request.status == 401){ 
				alert("세션이 만료되었습니다.\n로그인을 하시기 바랍니다.");
				location.href = "/ncts/login/egovLoginForm.do"
			}else{
				alert("시스템에러\n관리자에게 문의하세요.");
			}  
		}
	})
	
	$.regValidation = function(){
		$.validator.setDefaults({
		    onkeyup:false,
		    onclick:false,
		    onfocusout:false,
		    showErrors:function(errorMap, errorList){
		        if(this.numberOfInvalids()) {
		            alert(errorList[0].message);
		        }
		    }
		});
		
		$.validator.classRuleSettings = {};
		
		$.addValidation();
	}
	
	$.addValidation = function(){
		jQuery.extend(jQuery.validator.messages, {
			required:"{0}을(를) 입력해주세요.",
			number:"{0}는(은) 숫자만 입력할 수 있습니다.",
		});
		
		jQuery.validator.addMethod('selectcheck', function (value, element, params) {
	        return (value != "");
	    }, jQuery.validator.format("{0}을(를) 선택해주세요."));
		jQuery.validator.addMethod('errorMsg', function (value, element, params) {
	        return (value != "");
	    }, jQuery.validator.format("{0}"));
		jQuery.extend(jQuery.validator.messages, {
			minlength:"{0}자리 이상 입력하세요.",
			maxlength :"{0}자리 이하로 입력하세요."
		});
	}
	
	$.detailHtmlReplace = function(obj){
  	  var $this = $(obj);
  	  
  	  var htmlList = $this.html(); 
          htmlList = htmlList.replace(/&lt;/gi, "<");
          htmlList = htmlList.replace(/&gt;/gi, ">");
          
      $this.html(htmlList);
      $this.find("img").css("width","100%");
    }
	
	$.onClickTableTr = function(){
		var $listtable = $(".listtable > tbody > tr");
		
		$listtable.on("click", function(){
			var $this = $(this);
			var $body = $this.parent();
			var $chkbox = $this.find("td.invisible:first > input[type=checkbox]");
			var $hidden = $this.find("td.invisible:first > input[type=hidden]");
			var $tr = $this.closest('tr');
			var obj = {};  
			
			$body.find('input[type=checkbox]').each(function(){ $(this).prop("checked", false); })
			$body.find('tr').each(function(){ $(this).removeClass("tr_clr_2"); })
			
			if($chkbox.is(":checked")){
				$chkbox.prop("checked", false);
				$tr.removeClass("tr_clr_2");
			}else{
				if($hidden.size() > 0){
					$hidden.each(function(){
						obj[$(this).attr("name")] = $(this).val(); 
					})	
				}
				
				$chkbox.prop("checked", true);
				$tr.addClass("tr_clr_2");
				if(typeof $.dataDetail != "undefined" ) $.dataDetail($chkbox.val(), obj);
			}
		})
		
		$listtable.find("td.invisible:first > input[type=checkbox]").prop("checked", false);
		
		$listtable.on("dblclick", function(){
			if(typeof $.dblClickEvt != "undefined" ) $.dblClickEvt();
		})
		
	}
	
	$.onClickTableTr2 = function(){
		var $listtable = $(".listtable2 > tbody > tr");
		
		$listtable.on("click", function(){
			var $this = $(this);
			var $body = $this.parent();
			var $chkbox = $this.find("td.invisible:first > input[type=checkbox]");
			var $hidden = $this.find("td.invisible:first > input[type=hidden]");
			var $tr = $this.closest('tr');
			var obj = {};  
			var $trCheck = $(".listtable2 > tbody > tr").not($this).find(".index:checked");
			var noCheckLength = $("#detailTable .noCheck").length;
			
			if($trCheck.length > 0) {
				$trCheck.prop("checked", false);
				$trCheck.closest("tr").removeClass("tr_clr_2");
			}
			if(noCheckLength > 0) $chkbox.prop("checked", false);
			
			if($chkbox.is(":checked")){
				$chkbox.prop("checked", false);
				$tr.removeClass("tr_clr_2");
				$.dataDetail('');					
			}else{
				if($hidden.size() > 0){
					$hidden.each(function(){
						obj[$(this).attr("name")] = $(this).val(); 
					})	
				}
				
				$chkbox.prop("checked", true);
				$tr.addClass("tr_clr_2");
				if(typeof $.dataDetail != "undefined" ) $.dataDetail($chkbox.val(), obj);
			}
		})
		
		$listtable.find("td.invisible:first > input[type=checkbox]").prop("checked", false);
	}		
	
	$.logoutEvtHandler = function(){
		$("#logoutBtn").on("click", function(e){
			e.preventDefault();
			
			$("#logoutForm").ajaxForm({
				type: 'POST',
				url: "/ncts/login/logoutRequest.do",
				dataType: "json",
				success: function(data) {
					if(data.result == "success") {
						location.href = data.targetUrl;
					} else {
						alert(data.msg);
						return;
					}
				}
				
			});
			$("#logoutForm").submit();
		})
	}
	
	$.fn.readonly = function(options){
		var $form = $(this);
		with(options){
			if(basekey !== paramkey) return; 
			var op = tags;
			$.each(op, function(key, val){
				var $obj = $form.find("[name="+key+"]");
				$.each(val, function(key, val){
					if(key === "className" ) key = "class";
					$obj.attr(key, val);
				})
			})
			
		}
	}
	
	$.fn.subMenuHref = function(){
		$(this).find("a").on("click", function(){
			var $this = $(this);
			var url = $this.data("url");
			with(document.tabMoveForm){
				action = url;
				submit();
			}
		})
	}
	
	$.fn.addrOpenPopup = function(){
		$(this).on("click", function(){
			if($(this).hasClass("addr1")) addrClass = "addr1";
			else if($(this).hasClass("addr2")) addrClass = "addr2";
			else addrClass = "addr";
			// 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(http://www.juso.go.kr/addrlink/addrLinkUrl.do)를 호출하게 됩니다.
		    var pop = window.open("/ncts/cmm/addr/jusoPopup.do","pop","width=570,height=420, scrollbars=yes, resizable=yes");
		 	// 모바일 웹인 경우, 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(http://www.juso.go.kr/addrlink/addrMobileLinkUrl.do)를 호출하게 됩니다.
		    //var pop = window.open("/popup/jusoPopup.jsp","pop","scrollbars=yes, resizable=yes");
		})
	}
	
	$.fn.onlyNumber = function(max){
		var _this = $(this);
		_this.css("IME-MODE","disabled");
		_this.attr("maxlength", max == undefined ? 1 : max );
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
	}
	$.fn.onlyPassword = function(){
		var _this = $(this);
		_this.on("keyup change", function(){
			var $this = $(this);
			var pw = $this.val();
			$this.val(pw.replace(/ /gi, ''));
		})
	}
	
	$.loadingBarStart = function(event){
    	var msglayer = "<div class='page_ing_wrap' id='loadingpop01'><div class='page_ing'><img src='/images/egovframework/loading.gif' alt='화면 로딩중'></div></div>";
    	$("body").append(msglayer);  
    	$('#loadingpop01').show();
    }
	
	$.loadingBarClose = function(){
    	$('#loadingpop01').hide();
		$('#loadingpop01').remove();   
    }
	
	$.loadingBarKeyDown = function(event, excelPg){
		if(excelPg != 0){
       		var keyCode = event.keyCode;
	       	if((event.ctrlKey == true && (keyCode == 78 || keyCode == 82)) || keyCode == 116 || keyCode == 27) {
	    		event.keyCode = 0;
	    		event.cancelBubble = true;
	    		event.returnValue = false;
	    		event.preventDefault();
	    		$("body").contextmenu(function(){
	    			return false;
	    		})
	    	} 
       	} else {
	   		event.cancelBubble = false;
	   		event.returnValue = true;
	   		$("body").contextmenu(function(){
	   			return true;
	   		})
       	}
	}
	
	$.pageLoadingBarStart = function(event){
		var msglayer = "<div class='page_ing_wrap' id='loadingpop01'><div class='page_ing'><img src='/images/egovframework/loading.gif' alt='화면 로딩중'></div></div>";
		$("body").append(msglayer);  
		$('#loadingpop01').show();
		loadingSt = 1;
	}
	
	$.pageLoadingBarClose = function(){
		$('#loadingpop01').hide();
		$('#loadingpop01').remove();
		loadingSt = 0;
	}
	$.pageLoadingBarKeyDown = function(event, loadingSt){
		if(loadingSt != 0){
       		var keyCode = event.keyCode;
	       	if((event.ctrlKey == true && (keyCode == 78 || keyCode == 82)) || keyCode == 116 || keyCode == 27) {
	    		event.keyCode = 0;
	    		event.cancelBubble = true;
	    		event.returnValue = false;
	    		event.preventDefault();
	    		$("body").contextmenu(function(){
	    			return false;
	    		})
	    	} 
       	} else {
	   		event.cancelBubble = false;
	   		event.returnValue = true;
	   		$("body").contextmenu(function(){
	   			return true;
	   		})
       	}
	}	

	$.fn.downInsertBtnOnClick = function(key){
		$(this).on("click", function(e){
			var drForm = document.drForm;
			var excelCn1 = $("#excelCn1").val().replaceAll(" ", "");
			
			if(excelCn1.length == 0) {
				alert("다운로드 사유를 작성해주세요.");
				return false;
			}
			
			drForm.procType.value = key;
			$.ajax({
				type: 'POST',
				url : "/ncts/cmm/sys/excelDown/insertExcelResn.do",
				data: $("#drForm").serialize(),
				dataType: "json",
				async : false,
				success: function(data) {
					if(data.success == "success") {
						drForm.excelCn1.value = "";
						$("#downPopup").hide();
						$.excelDownload(e);
					}
					else alert("저장 실패");
				}
			});
			
		})
	}
	$.fn.addNoteBtnOnClick = function(){
		$(this).on("click", function(){
			var noteForm = document.noteForm;
			var noteCd = $("#noteCn").val().replaceAll(" ", "");
			
			if(noteCn.length == 0) {
				alert("메모를 작성해주세요.");
				return false;
			}
			
			$.ajax({
				type: 'POST',
				url : "/ncts/mngr/userMngr/mngrMemberNoteProc.do",
				data: $("#noteForm").serialize(),
				dataType: "json",
				async : false,
				success: function(data) {
					if(data.success == "success") location.reload();
					else alert("저장 실패");
				}
			});
			
		})
	}
	
	$.hideEvt = function(){
		$("#downPopup .closeBox").on("click", function(){
			$(this).closest("#downPopup").hide();
		})
		$("#notePopup .closeBox").on("click", function(){
			$(this).closest("#notePopup").hide();
		})
		$(".closeBtn").on("click", function(){
			$("#layer2").closest(".dim-layer").hide();
		})
	}
	
	$.deptAllAuthorAtOnSetting = function(){
		var deptAllAuthorAt = $("input[name='deptAllAuthorAt']").val();
		if(deptAllAuthorAt == "Y") $(".dstrctHide").show();
	}
	
	$.noteDataOnSettings = function(data){
		var instrctrGrade = [
		      { id: "#pfatGradeCd", value: data.de.PFAT_GRADE_CD },
		      { id: "#pmptGradeCd", value: data.de.PMPT_GRADE_CD },
		      { id: "#sprtGradeCd", value: data.de.SPRT_GRADE_CD },
		      { id: "#mpgtGradeCd", value: data.de.MPGT_GRADE_CD }
	    ];		
		instrctrGrade.forEach(function(item) {
			if(item.value == "99") $(item.id).find("option").attr("selected", false);
			else $(item.id).find("option[value='"+ item.value +"']").attr("selected", true);
		})		
		
		var instrctrResult = [
              { id: "#pfatInstrctrResult", value: data.de.PFAT_INSTRCTR_RESULT },
              { id: "#pmptInstrctrResult", value: data.de.PMPT_INSTRCTR_RESULT },
              { id: "#sprtInstrctrResult", value: data.de.SPRT_INSTRCTR_RESULT },
              { id: "#mpgtInstrctrResult", value: data.de.MPGT_INSTRCTR_RESULT }
		];		
		instrctrResult.forEach(function(item) {
			var $select = $(item.id).find("option[value='"+ item.value +"']");
			$select.attr("selected", true);
			if($select.data("changeAt") == "Y") $select.siblings("option[data-other='']").remove();
			else $select.siblings("option").remove();
		})
		$("#note").val(data.de.NOTE);
			document.nForm.userNo.value = data.de.USER_NO;
		}
	
    $.instrctrResultBackgroundOnSettings = function() {
    	$(".instrctrResult").each(function(){
    		var $this = $(this);
    		var result = $this.data("result"); 
	    	var bColor;
	    	if(result == "01") {
	    		bColor = "#cce1f4";
	    		$this.prop("disabled", true);
	    	}
	    	else if(result == "02") {
	    		bColor = "#fbe3d6";
	    		$this.prop("disabled", false);
	    	}
	    	else if(result == "03") {
	    		bColor = "#d9f2d0";
	    		$this.prop("disabled", false);
	    	}
	    	else if(result == "99") {
	    		bColor = "none";
	    		$this.prop("disabled", true);
	    	}
	    	
	    	if($("input[name='deptAllAuthorAt']").val() != "Y") $this.prop("disabled", true);
	    	$this.css("background", bColor);
    	})
    }	
	
	/*$.fn.notePopupBtnOnClickEvt = function(){
		$(this).on("click", "#notePopupBtn", function(){
			var $this = $(this);
			$("#notePopup").show();
		})
	}
	
	$.fn.notePopupBtnsOnClickEvt = function(pKey){
		$(this).on("click", "#notePopup button", function(){
			var $this = $(this);
			if($this.prop("id") == "noteProcBtn") {
				document.nForm.procType.value = pKey;
				$.ajax({
					type: 'POST',
					data : $("#nForm").serialize(),
					url: "/ncts/mngr/userMngr/updateMngrMemberNote.do",
					dataType: "json",
					success: function(result) {
						if(result.success == "success") {
							alert(result.msg);
							$("#notePopup").hide();
						}
					}
		        });
				
			} else $("#notePopup").hide();
		})
	}	*/
	
	$.instrctrDetailViewOnSettings = function(userId){
		var disabledAt;
		disabledAt = userId == "master" || userId == "theit01" || userId == "loryhj117" || userId == "hihihi99"  ? false : true;
		$(".instrctrSelect").prop("disabled", disabledAt);
		
//		disabledAt = userId == "master" || userId == "jhk0128" || userId == "sxnminjae" || userId == "min0326" || userId == "sooyoung2" || userId == "lasol81" || userId == "love3042"
		disabledAt = userId == "master" || userId == "theit01" || userId == "tnsdlfdl88" || userId == "loryhj117" || userId == "jhu0826" || userId == "hihihi99" || userId == "min0326"
			       ? false : true;
		$("#packageAuthAt").prop("disabled", disabledAt);
	}
	
	$.fn.instrctrSelectOnChangeEvt = function(pKey, userNo){
		$(this).on("change",  function(){
			var $this = $(this);
			//if($this.prop("id") == "noteProcBtn") {
			var nForm = document.nForm;
			nForm.pfatGradeCd.value = $("#pfatGradeCd").val();
			nForm.sprtGradeCd.value = $("#sprtGradeCd").val();
			nForm.pmptGradeCd.value = $("#pmptGradeCd").val();
			nForm.mpgtGradeCd.value = $("#mpgtGradeCd").val();
			nForm.procType.value = pKey;
			nForm.userNo.value = userNo;
				
			$.ajax({
				type: 'POST',
				data : $("#nForm").serialize(),
				url: "/ncts/mngr/userMngr/updateMngrMemberNote.do",
				dataType: "json",
				success: function(result) {
					if(result.success == "success") {
						$("#layer2").closest(".dim-layer").show();
						/*alert(result.msg);
						$("#notePopup").hide();*/
					}
				}
			});
		})
	}
	
	$.fn.instrctrInputOnChangeEvt = function(pKey, userNo){
		$(this).userDatePicker({
			onSelect : function(){
				var today = moment(new Date());
				var todayDate = today.format("YYYY.MM.DD");
				if($(this).val() != "" && $(this).val() > todayDate && $(this).length != 10) {
					alert("정확한 날짜를 입력해주세요.");
					$(this).val("");
					$(this).next("input").val("");
				}else{
					var $this = $(this);
					var nForm = document.nForm;
					nForm.pfatInstrctrEntrstDe.value = $("#pfatInstrctrEntrstDe").val();
					nForm.sprtInstrctrEntrstDe.value = $("#sprtInstrctrEntrstDe").val();
					nForm.pmptInstrctrEntrstDe.value = $("#pmptInstrctrEntrstDe").val();
					nForm.mpgtInstrctrEntrstDe.value = $("#mpgtInstrctrEntrstDe").val();
					nForm.procType.value = pKey;
					nForm.userNo.value = userNo;
							
					$.ajax({
						type: 'POST',
						data : $("#nForm").serialize(),
						url: "/ncts/mngr/userMngr/updateMngrMemberEntrstDe.do",
						dataType: "json",
						success: function(result) {
							if(result.success == "success") {
								$("#layer2").closest(".dim-layer").show();
								
							}	
						}
					});
				}
			}
		});
	}
	
	$.fn.packageAuthAtOnChangeEvt = function(pKey, userNo){
		$(this).on("change", function(){
			var $this = $(this);
			var nForm = document.nForm;
			nForm.packageAuthAt.value = $("#packageAuthAt").val();
			nForm.procType.value = pKey;
			nForm.userNo.value = userNo;
				
			$.ajax({
				type: 'POST',
				data : $("#nForm").serialize(),
				url: "/ncts/mngr/userMngr/updateMngrMemberPackageAuthAt.do",
				dataType: "json",
				success: function(result) {
					if(result.success == "success") {
						$("#layer2").closest(".dim-layer").show();
						/*alert(result.msg);
						$("#notePopup").hide();*/
					}
				}
			});			
		})
	}	
	
	$.fn.instrctrResultOnChangeEvt = function(pKey, userNo){
		$(this).on("change",  function(){
			var $this = $(this);
			var nForm = document.nForm;
			nForm.instrctrGubun.value = $this.data("gubun");
			nForm.orgInstrctrStatus.value = $this.data("result");
			nForm.instrctrStatus.value = $this.find("option:selected").val();
			nForm.procType.value = pKey;
			nForm.userNo.value = userNo;
			
			$.ajax({
				type: 'POST',
				data : $("#nForm").serialize(),
				url: "/ncts/mngr/instrctrMngr/insertInstrctrStatus.do",
				dataType: "json",
				success: function(result) {
					if(result.success == "success") {
						$("#layer2").closest(".dim-layer").show();
						var changeVal = $this.find("option:selected").val();
						$this.attr("data-result", changeVal);
						$this.data("result", changeVal);
						$.instrctrResultBackgroundOnSettings();
						/*alert(result.msg);
						$("#notePopup").hide();*/
					}
				}
			});
		})
	}	
	
    $.fn.pwControlOnClickEvt = function(){
    	$(this).on("click", function(){
    		var $this = $(this);
    		if($this.hasClass("pw_off")) {
    			$this.addClass("pw_show");
    			$this.removeClass("pw_off");
    			$this.closest("td").find("input").prop("type", "password");
    		} else {
    			$this.addClass("pw_off");
    			$this.removeClass("pw_show");
    			$this.closest("td").find("input").prop("type", "text");
    		}
    	})
    }		
	
	$.fn.initGpkiBtnOnClickEvt = function(){
		var _this = $(this);
		_this.on("click", function(){
			if(!confirm("인증서를 초기화 하시겠습니까?")) return;
			var $this = $(this);
			
			$.ajax({
				type			: "POST",
				url				: "/ncts/gpik/initGpki.do",
				data			: $('#iForm').serialize(),
				dataType		: 'json',
				success			: function(result) {
					alert(result.msg);
				}
			});
		})
	}	
	
	$.init = function(){
		$.logoutEvtHandler();
		$.regValidation();
		$("#menuSubTabList").subMenuHref();
		$.addSearchResetBtn();
		$.addAllSearchResetBtn();
		$(".pwControl").pwControlOnClickEvt();
		$(".pw").onlyPassword();
		$("#initGpki").initGpkiBtnOnClickEvt();
	}	
	
	$(function(){
		$.init();
		$.hideEvt();
		$.deptAllAuthorAtOnSetting();
		$("#div_file_pack1 button").css("width", "auto");
	})
	
}(jQuery))




