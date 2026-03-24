<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String dummynow = new java.text.SimpleDateFormat("yyyyMMddHHmmssSSS").format(new java.util.Date());
%>
<!-- css -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
<link rel="stylesheet" href="/css/egovframework/edu/common.css?v=<%=dummynow%>">
<script type="text/javascript" src="/js/egovframework/jquery.cookie.js"></script>
<style>

 div#pop-up {
   display: none;
   position: absolute;
   width: 140px;
   padding: 10px;
   background: #eeeeee;
   color: #000000;
   border: 1px solid #1a1a1a;
   font-size: 65%;
 }
 
 div#pop-up2 {
   display: none;
   position: absolute;
   width: 140px;
   padding: 10px;
   background: #eeeeee;
   color: #000000;
   border: 1px solid #1a1a1a;
   font-size: 65%;
 }
 
 div#pop-up3 {
   display: none;
   position: absolute;
   width: 140px;
   padding: 10px;
   background: #eeeeee;
   color: #000000;
   border: 1px solid #1a1a1a;
   font-size: 65%;
 }
 
 div#pop-up4 {
   display: none;
   position: absolute;
   width: 140px;
   padding: 10px;
   background: #eeeeee;
   color: #000000;
   border: 1px solid #1a1a1a;
   font-size: 65%;
 }
</style>
<script type="text/javascript">
$(function(){
	var excelPg = 0;	
	$.fn.noticeOnClickEvt = function(){
		$(this).on("click", function(){
			var $this = $(this);
			
			var seq = $this.find(".notice").data("seq");
			location.href = 'https://edu.nct.go.kr/notice/noticeDetail.do?bbsNo=' + seq;
		})
	}
	
	$.fn.visitUserDownOnClickEvt = function(e){
		$(this).on("click", function(){
			if($("#searchCondition1").val() == "") {
				alert("연도를 선택해주세요.");
				$("#searchCondition1").focus();
				return false;
			}
			
			excelPg = 1;
	        with(document.sForm){
	            target = "";
	            action = '/ncts/eduVisitUserDownload.do';
	            submit();
	        }
	        $.setCookie("fileDownloadToken","false");
            $.loadingBarStart(e);
            $.checkDownloadCheck();
	    });
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
    
    $.fn.searchCondition2OnChangeEvt = function(){
    	$(this).on("change", function(){
	        with(document.sForm){
	            target = "";
	            searchCondition2.value = $(this).val();
	            action = '/ncts/egovNctsMain.do';
	            submit();
	        }
    	})
    }
	
	$.initView = function(){
		$("#main").css("margin-left","0");
		//$(".noticeDetail").noticeOnClickEvt();
		$("#visitUserDown").visitUserDownOnClickEvt();
		$("body").on("keydown", function(e){
	        $.loadingBarKeyDown(e, excelPg);
        })
        
        $(".mainClose").click(function(){
			var close_today = $("#close_today").is(":checked");
			if(close_today){
				$.cookie('close_today', 'Y', { expires: 1 });	
			}
			$(".pop_area").hide();
		})
		
		var c = $.cookie('close_today');
		if(c == "Y"){
			$(".pop_area").hide();
		}else{
			$(".pop_area").show();	
			$( '.pop_area' ).draggable();
		}
		
		$("#searchCondition2").searchCondition2OnChangeEvt();
	}
	
	
	$.initView();
	
   	$('.sheet_wrap .trigger').hover(function(e) {
     	$('div#pop-up').show();
   	}, function() {
     	$('div#pop-up').hide();
   	});

   	$('.sheet_wrap .trigger').mousemove(function(e) {
     	$("div#pop-up").css('top','134px').css('left','819px');
   	});
   
	$('.sheet_wrap .trigger2').hover(function(e) {
	  	$('div#pop-up2').show();
	}, function() {
	  	$('div#pop-up2').hide();
	});

	$('.sheet_wrap .trigger2').mousemove(function(e) {
	  $("div#pop-up2").css('top','176px').css('left','819px');
	});
	
	$('.sheet_wrap .trigger3').hover(function(e) {
		$('div#pop-up3').show();
	}, function() {
	  	$('div#pop-up3').hide();
	});

	$('.sheet_wrap .trigger3').mousemove(function(e) {
	  	$("div#pop-up3").css('top','202px').css('left','819px');
	});
	
	$('.sheet_wrap .trigger4').hover(function(e) {
		$('div#pop-up4').show();
	}, function() {
		$('div#pop-up4').hide();
	});
	
	$('.sheet_wrap .trigger4').mousemove(function(e) {
		$("div#pop-up4").css('top','99px').css('left','819px');
	});
})
</script>	

<%-- <!-- MAIN CONTENT -->
<div id="content">

	<a href="/ncts/cmm/sys/menu/menuList.do">ddddddddddddddd</a>
	<sec:authentication property="principal.userNm"/>
	
	<sec:authorize access="hasRole('ROLE_MASTER')">
	ROLE_MASTER
	</sec:authorize>
	<sec:authorize access="hasRole('ROLE_SYSTEM')">
	ROLE_SYSTEM
	</sec:authorize>
	<sec:authorize access="hasRole('ROLE_ADMIN')">
	ROLE_ADMIN
	</sec:authorize>
	<sec:authorize access="hasRole('ROLE_USER')">
	ROLE_USER
	</sec:authorize>
</div>
<!-- END MAIN CONTENT --> --%>
<!-- container -->
<div class="container">
	<div class="content" id="content">
	
		 <!-- <div class="pop_area pop_event" style="display: none; width:600px; cursor: pointer;position: absolute; left: 600px; z-index:1000;">
            <div class="pop_box event_box">
                <div class="pop_con">
                    <div class="con">
                        <p>
						  <img src="/images/popup/230509 긴급팝업.png" alt="230509긴급점검 안내" style="width:100%">
						</p>
                    </div>
					<div class="pop_foot" style="background-color: black; padding: 5px;">
						<p class="fClr">
							<input type="checkbox" id="close_today" style="margin-left: 10px;left:0;top: -2px;width: auto;height: auto;">
							<label for="close_today" style="color: white;">오늘 하루 그만보기</label>
							<a class="mainClose" href="javascript:void(0);">닫기</a>
							<button type="button" class="btn_close close mainClose" style="margin-right: 10px;"><img src="/images/btn/btn_close.png" alt="팝업창 닫기"></button>
						</p>
					</div>
                </div> 
            </div>
        </div>  -->
        
		<form name="sForm" id="sForm" method="post">
			<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
			<input type="hidden" name="searchCondition2">
		</form>        
        
		<div class="edu_main fClr">
			<div class="edu_left fLeft">
				<ul class="status_list">
					<li class="fClr">
						<div class="sheet_wrap icon fLeft">
							<a href="javascript:;" class="icon01"></a> 
							<h2>홈페이지<br>현황</h2>
						</div>
						<div class="sheet_wrap sheet01 fLeft">
							<h3><span>&middot; </span>회원</h3>
							<p><span class="part">가입</span><input type="text" class="inpA" value="<c:out value='${homeUser.JOIN_USER }'/>" readonly=""></p>
							<p><span class="part">인증</span><input type="text" class="inpA" value="<c:out value='${homeUser.CRTFC_Y_USER }'/>" readonly="">&nbsp; &nbsp;/&nbsp; &nbsp;<input type="text" class="inpA" value="<c:out value='${homeUser.ALL_USER }'/>" readonly=""></p>
							<%-- <p><span class="part">온라인</span><input type="text" class="inpA" value="${homeUser.ONLINE_USER }" readonly=""></p> --%>
							
							<div class="footnote">
								<span class="mgl50">인증수</span>
								<span class="mgl20">총회원수</span>
							</div>							
						</div>
						<div class="sheet_wrap sheet02 fLeft">
							<h3><span>&middot; </span>방문자</h3>
							<p><span class="part trigger4">일일</span><input type="text" class="inpA" value="<c:out value='${visitUser.TODAY}'/>" style="width:70px;" readonly=""></p>
							<p><span class="part trigger">주간</span><input type="text" class="inpA" value="<c:out value='${visitUser.WEEK}'/>" style="width:70px;" readonly=""></p>
							<p><span class="part trigger2">월간</span><input type="text" class="inpA" value="<c:out value='${visitUser.MONTH}'/>" style="width:70px;" readonly=""></p>
							<p><span class="part trigger3">누적</span><input type="text" class="inpA" value="<c:out value='${visitUser.TOTAL}'/>" style="width:70px;" readonly=""></p>
							<%-- <p>
								<form name="sForm" id="sForm" method="post">
									<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
									<button type="button" id="visitUserDown" class="mt10">방문자 다운로드</button>
									<select id="searchCondition1" name="searchCondition1" class="form-control">
			                            <option value="">연도선택</option>
			                            <jsp:useBean id="now" class="java.util.Date" />
			                            <fmt:formatDate value="${now}" pattern="yyyy" var="yearEnd"/>
			                            <c:forEach begin="2021" end="${yearEnd}" var="result" step="1">
											<option value="<c:out value="${result}" />" ${param.searchCondition1 eq result ? 'selected' : '' }><c:out value="${result}" /></option>
										</c:forEach>
			                        </select>
								</form>
	                        </p> --%>
						</div>
						<div class="sheet_wrap sheet02 fLeft">
							<h3><span>&middot; </span>수료자</h3>
							<p><span class="part">초급</span><input type="text" class="inpA" value="<c:out value='${homeUser.LOW}'/>" readonly=""></p>
							<p><span class="part">중급</span><input type="text" class="inpA" value="<c:out value='${homeUser.MID}'/>" readonly=""></p>
							<p><span class="part">고급</span><input type="text" class="inpA" value="<c:out value='${homeUser.HIGH}'/>" readonly=""></p>
							<p><span class="part">준강사</span><input type="text" class="inpA" value="<c:out value='${homeUser.ASSIST_INSTRCTR}'/>" readonly=""></p>
							<p><span class="part">강사</span><input type="text" class="inpA" value="<c:out value='${homeUser.INSTRCTR}'/>" readonly=""></p>
						</div>
						
						<div class="sheet_wrap sheet01 fLeft">
							<h3><span>&middot; </span>강사현황</h3>
							<div class="h_note">
								<span class="mgl40">위촉강사</span>
								<span class="mgl20">준강사</span>
							</div>
							<p><span class="part">PFA</span><input type="text" value="<c:out value='${instrctrUser.PFAT_GRADE_00}'/>" readonly=""><input type="text" class="inpA mgl20" value="<c:out value='${instrctrUser.PFAT_GRADE_01}'/>" readonly=""></p>
							<p><span class="part">PM+</span><input type="text" value="<c:out value='${instrctrUser.PMPT_GRADE_00}'/>" readonly=""><input type="text" class="inpA mgl20" value="<c:out value='${instrctrUser.PMPT_GRADE_01}'/>" readonly=""></p>
							<p><span class="part">SPR</span><input type="text" value="<c:out value='${instrctrUser.SPRT_GRADE_00}'/>" readonly=""><input type="text" class="inpA mgl20" value="<c:out value='${instrctrUser.SPRT_GRADE_01}'/>" readonly=""></p>
							<p><span class="part">MPG</span><input type="text" value="<c:out value='${instrctrUser.MPGT_GRADE_00}'/>" readonly=""><input type="text" class="inpA mgl20" value="<c:out value='${instrctrUser.MPGT_GRADE_01}'/>" readonly=""></p>
						</div>						
					</li>
					<li class="fClr fLeft">
						<div class="sheet_wrap icon fLeft">
							<a href="javascript:;" class="icon02"></a> 
							<h2>교육실적</h2>
							<c:if test="${userinfo.deptAllAuthorAt eq 'Y' }">
								<select id="searchCondition2" name="searchCondition2">
									<option value="">전체</option> 
									<c:forEach var="list" items="${centerList}" varStatus="idx">
										<option value="<c:out value='${list.DEPT_CD }'/>" <c:out value="${param.searchCondition2 eq list.DEPT_CD ? 'selected':'' }"/>><c:out value="${list.DEPT_NM }"/></option>
									</c:forEach>
								</select>
							</c:if>
							<c:if test="${userinfo.deptAllAuthorAt ne 'Y' }">
								<input type="hidden" name="searchCondition2" value="<c:out value='${paginationInfo.centerCd }'/>">
							</c:if>
						</div>
						<div class="sheet_wrap sheet03 fLeft">
							<table class="edu_tbl">
								<colgroup>
									<col style="width: auto;">
									<col style="width: 18%;">
									<col style="width: 18%;">
									<col style="width: 18%;">
									<col style="width: 18%;">
									<col style="width: 18%;">
								</colgroup>
								<thead>
									<tr>
										<th>과정</th>
										<th>일반</th>
										<th>초급</th>
										<th>중급</th>
										<th>고급</th>
										<!-- <th>준강사</th> -->
										<th>강사</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<th>진행</th>
										<td><input type="text" class="inpA" value="<c:out value='${selectEduProgress.ALL_GNRL_TOTAL_CNT}'/>" readonly=""></td>
										<td><input type="text" class="inpA" value="<c:out value='${selectEduProgress.ALL_LOW_TOTAL_CNT}'/>" readonly=""></td>
										<td><input type="text" class="inpA" value="<c:out value='${selectEduProgress.ALL_MID_TOTAL_CNT}'/>" readonly=""></td>
										<td><input type="text" class="inpA" value="<c:out value='${selectEduProgress.ALL_HIGH_TOTAL_CNT}'/>" readonly=""></td>
										<%-- <td><input type="text" class="inpA" value="${selectEduProgress.ALL_INSTRCTR_S_TOTAL_CNT}" readonly=""></td> --%>
										<td><input type="text" class="inpA" value="<c:out value='${selectEduProgress.ALL_INSTRCTR_I_TOTAL_CNT}'/>" readonly=""></td>
									</tr>
									<tr>
										<th>누적</th>
										<td><input type="text" class="inpA" value="<c:out value='${selectEduTotal.ALL_GNRL_TOTAL_CNT}'/>" readonly=""></td>
										<td><input type="text" class="inpA" value="<c:out value='${selectEduTotal.ALL_LOW_TOTAL_CNT}'/>" readonly=""></td>
										<td><input type="text" class="inpA" value="<c:out value='${selectEduTotal.ALL_MID_TOTAL_CNT}'/>" readonly=""></td>
										<td><input type="text" class="inpA" value="<c:out value='${selectEduTotal.ALL_HIGH_TOTAL_CNT}'/>" readonly=""></td>
										<%-- <td><input type="text" class="inpA" value="${selectEduTotal.ALL_INSTRCTR_S_TOTAL_CNT}" readonly=""></td> --%>
										<td><input type="text" class="inpA" value="<c:out value='${selectEduTotal.ALL_INSTRCTR_I_TOTAL_CNT}'/>" readonly=""></td>
									</tr>
									<tr>
										<th>실인원</th>
										<td><input type="text" class="inpA" value="<c:out value='${selectApplicantTotal.ALL_GNRL_TOTAL_APLI_CNT}'/>" readonly=""></td>
										<td><input type="text" class="inpA" value="<c:out value='${selectApplicantTotal.ALL_LOW_TOTAL_APLI_CNT}'/>" readonly=""></td>
										<td><input type="text" class="inpA" value="<c:out value='${selectApplicantTotal.ALL_MID_TOTAL_APLI_CNT}'/>" readonly=""></td>
										<td><input type="text" class="inpA" value="<c:out value='${selectApplicantTotal.ALL_HIGH_TOTAL_APLI_CNT}'/>" readonly=""></td>
										<%-- <td><input type="text" class="inpA" value="${selectApplicantTotal.ALL_INSTRCTR_S_TOTAL_APLI_CNT}" readonly=""></td> --%>
										<td><input type="text" class="inpA" value="<c:out value='${selectApplicantTotal.ALL_INSTRCTR_I_TOTAL_APLI_CNT}'/>" readonly=""></td>
									</tr>
									<tr>
										<th>연인원</th>
										<td><input type="text" class="inpA" value="<c:out value='${selectApplicant.ALL_GNRL_TOTAL_APLI_CNT}'/>" readonly=""></td>
										<td><input type="text" class="inpA" value="<c:out value='${selectApplicant.ALL_LOW_TOTAL_APLI_CNT}'/>" readonly=""></td>
										<td><input type="text" class="inpA" value="<c:out value='${selectApplicant.ALL_MID_TOTAL_APLI_CNT}'/>" readonly=""></td>
										<td><input type="text" class="inpA" value="<c:out value='${selectApplicant.ALL_HIGH_TOTAL_APLI_CNT}'/>" readonly=""></td>
										<%-- <td><input type="text" class="inpA" value="${selectApplicant.ALL_INSTRCTR_S_TOTAL_APLI_CNT}" readonly=""></td> --%>
										<td><input type="text" class="inpA" value="<c:out value='${selectApplicant.ALL_INSTRCTR_I_TOTAL_APLI_CNT}'/>" readonly=""></td>
									</tr>
								</tbody>
							</table>
							<!--div class="dashed01"></div>
							<div class="dashed02"></div-->
						</div>
					</li>
				</ul>
			</div>
			<div class="edu_right fRight">
				<div class="right_wrap">
					<div class="reseve_box">
						<h2>상담실 <span>예약정보</span>
							<!--a href="javascript:;">+</a-->
						</h2>
						<div class="rsv_info">
							<p class="user">
								<span class="img"><img src="/images/egovframework/people.png" alt="나의 프로필 이미지"></span>
								<strong class="name"><sec:authentication property="principal.userNm"/></strong>
								님 반갑습니다.
							</p>
							<ul class="rsv_list">
								<li>
									<c:if test="${not empty mainSche.RESE_CODE_TXT}">
										<span class="date"><c:out value="${mainSche.FRST_REGIST_PNTTM}"/></span>
										<span class="time"><c:out value="${mainSche.RESE_BEGIN_TIME_HOUR}"/> : <c:out value="${mainSche.RESE_BEGIN_TIME_MIN}"/> ~ <c:out value="${mainSche.RESE_END_TIME_HOUR}"/> : <c:out value="${mainSche.RESE_END_TIME_MIN}"/></span>
										<span class="location"><c:out value="${mainSche.RESE_CODE_TXT}"/></span>
										<c:if test="${empty mainSche.RESE_CODE_TXT}"><li></li></c:if>
									</c:if>
								</li>
							</ul>
						</div>
					</div>

					<div class="ask_box fClr">
						<div class="icon_wrap fLeft">
							<a href="/ncts/mngr/homeMngr/mngrOneOnOneList.do" class="icon03"></a>
							<h3><span class="red">1</span>대<span class="red">1</span> 문의</h3>
						</div>
						<div class="part_wrap fLeft">
							<p>미처리<input type="text" class="inpA" value="<c:out value='${oneOnOne.WAITING }'/>" readonly=""></p>
						</div>
						<div class="part_wrap fLeft">
							<p>처리완료<input type="text" class="inpA" value="<c:out value='${oneOnOne.COMPLETE }'/>" readonly=""></p>
						</div>
						<div class="part_wrap fLeft">
							<p>누계<input type="text" class="inpA" value="<c:out value='${oneOnOne.TOTAL }'/>" readonly=""></p>
						</div>
					</div>
					
					<div class="notice_list">
						<h2>공지사항<a href="/ncts/mngr/homeMngr/mngrBbsNoticeList.do">+</a></h2>
						<ul>
							<c:forEach var="list" items="${mainNoticeList}" varStatus="idx">
								<li class="noticeDetail">
									<!-- <a href="javascript:void(0);"> -->
									<a href="/ncts/mngr/homeMngr/mngrBbsNoticeList.do">
										<span class="notice" data-seq = "<c:out value='${list.BBS_NO }'/>">[공지]</span><c:out value="${list.TITLE}"/>
									</a>
									<span class="date"><c:out value="${list.FRST_REGIST_PNTTM}"/></span>
								</li>
							</c:forEach>
						</ul>
					</div>
				</div>
			</div>
		</div>
        
	</div>
</div><!-- //content -->

	<div id="pop-up">
       <p>
                      매주 월요일~일요일 기준
      </p>
    </div>
    <div id="pop-up2">
       <p>
                      매달 1일~말일 기준
      </p>
    </div>
    <div id="pop-up3">
       <p>
                       교육관리시스템 오픈일로부터 기준
      </p>
    </div>
    <div id="pop-up4">
       <p>
                       당일 0시 ~ 23시 59분 기준
      </p>
    </div>
        
        