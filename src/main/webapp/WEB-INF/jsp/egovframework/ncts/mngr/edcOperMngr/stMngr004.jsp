<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
	.jqstooltip { position: absolute;left: 0px;top: 0px;visibility: hidden;background: rgb(0, 0, 0) transparent;background-color: rgba(0,0,0,0.6);filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#99000000, endColorstr=#99000000);-ms-filter: "progid:DXImageTransform.Microsoft.gradient(startColorstr=#99000000, endColorstr=#99000000)";color: white;font: 10px arial, san serif;text-align: left;white-space: nowrap;padding: 5px;border: 1px solid white;z-index: 10000;}
	.jqsfield { color: white;font: 10px arial, san serif;text-align: left;}
	
	.edu_tbl2 {table-layout: fixed;font-size: 12px;}
	.edu_tbl2 thead th {background-color: #bfbfbf;}
	.edu_tbl2 thead th.yellow {background-color: #ffe69b;}
	.edu_tbl2 thead th.blue {background-color: #b3c6e7;}
	.edu_tbl2 thead th.red {background-color: #f8cbac;}
</style>

<script type="text/javascript">

$(function(){
	var baseInfo = {
			insertKey : '<c:out value="${common.baseType[0].key() }"/>',
			updateKey : '<c:out value="${common.baseType[1].key() }"/>',
			deleteKey : '<c:out value="${common.baseType[2].key() }"/>',
			lUrl : '${pageInfo.READ_AT eq 'Y' ? pageInfo.MENU_URL : pageInfo.MENU_DETAIL_URL   }',
			fUrl : '<c:out value="${pageInfo.MENU_DETAIL_URL }"/>',
			excel : "/ncts/mngr/edcOperMngr/statMngrOperExcelDownload.do",
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
	
	$.fn.excelDownOnClickEvt = function(){
		$(this).on("click", function(){
			$("[name='excelFileNm']").val("교육 운영 실적_"+$.toDay());
			$("[name='excelPageNm']").val("stMngr004.xlsx");
			with(document.sForm){
				target = "";
				action = baseInfo.excel;
				submit();
			}
		})
	}
	
    $.sumYearList = function(){
    	var tdIdx = $(".yearList:first td").length;
    	var tdValue = 0;
    	
    	for(var i=0; i<= tdIdx; i++) {
    		$(".yearList").each(function(idx){
    			tdValue += parseInt($(this).find("td:eq("+i+")").html());
    		})
    		
   			$("#resultRow td:eq("+ i +")").html(tdValue);
   			tdValue = 0;	
    	}
    }	
	
	$.initView = function(){
		$("#searchBtn").searchBtnOnClickEvt($.searchAction);
		$(".excelDown").excelDownOnClickEvt();
		$.sumYearList();
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
				<input type="hidden" name="excelFileNm">
				<input type="hidden" name="excelPageNm">
				<div class="fL wp70">			
					<ul class="searchAreaBox">
						<li class="smart-form">
						    <label class="label">센터명</label>
						</li>
						<sec:authorize access="hasRole('ROLE_MASTER') or hasRole('ROLE_SYSTEM')">
							<li class="w150 mr5">
								<select name="searchCondition3" class="form-control">
									<option value="">전체</option>
									<c:forEach var="center" items="${CenterList }" varStatus="idx">
										<option value='<c:out value="${center.DEPT_CD }"/>' data-groupId='<c:out value="${center.GROUP_ID }"/>' <c:out value="${center.DEPT_CD eq param.searchCondition3 ? 'selected=selected':'' }"/> ><c:out value="${center.DEPT_NM }"/></option>
									</c:forEach>
								</select> <i></i>
							</li>
						</sec:authorize>
						<sec:authorize access="hasRole('ROLE_ADMIN') or hasRole('ROLE_USER')">
							<li class="smart-form mr5">
								<input type="hidden" name="searchCondition3" value="<sec:authentication property="principal.centerId"/>" >
								<label class="label"><sec:authentication property="principal.centerNm"/></label>
							</li>
						</sec:authorize>					
						<li class="ml10">
							<button class="btn btn-primary searchReset" type="button" id="searchBtn"><i class="fa fa-search"></i> 검색</button>
						</li>
					</ul>
				</div>

				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/button.jsp" flush="false">
					<jsp:param value="list"     name="formType"/>
					<jsp:param value="1"     name="buttonYn"/>
				</jsp:include>
				<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/baseInput.jsp" flush="false" />
                 
			</form>
		</div>
		<!-- Search 영역 끝 -->
	<%-- ${sessionScope.userinfo.userNm } --%>
	<%-- <sec:authentication property="userNm"/> --%>
		<jsp:include page="/WEB-INF/jsp/egovframework/ncts/layout/mixin/tabmenu.jsp" flush="false" />
		
		<div class="content">
			<!-- row 메뉴조회 시작 -->
			<div class="row">
				<article class="col-md-12 col-lg-12">
				
					<table class="table table-bordered tb_type01 edu_tbl2">
						<colgroup>
							<col width="auto">
							<col width="2.2%">
							<col width="2.8%">
							<col width="2.2%">
							<col width="2.8%">
							<col width="2.2%">
							<col width="2.8%">
							<col width="2.2%">
							<col width="2.8%">
							<col width="2.2%">
							<col width="2.8%">
							<col width="2.2%">
							<col width="2.8%">
							<col width="2.2%">
							<col width="2.8%">
							<col width="2.2%">
							<col width="2.8%">
							<col width="2.2%">
							<col width="2.8%">
							<col width="2.2%">
							<col width="2.8%">
							<col width="2.2%">
							<col width="2.8%">
							<col width="2.2%">
							<col width="2.8%">
							<col width="2.2%">
							<col width="2.8%">
							<col width="2.2%">
							<col width="2.8%">
							<col width="2.2%">
							<col width="2.8%">
							<col width="2.2%">
							<col width="2.8%">
							<col width="2.2%">
							<col width="2.8%">
							<col width="2.2%">
							<col width="2.8%">
							<col width="2.2%">
							<col width="2.8%">
						</colgroup>
						<thead>
							<tr class="line1">
								<th scope="col" rowspan="3">구분</th>
								<th scope="col" colspan="12" class="yellow">정기교육</th>
								<th scope="col" colspan="6" class="blue">직무교육</th>
								<th scope="col" colspan="8" class="red">비정기교육</th>
								<th scope="col" colspan="10">과정별 실적급</th>
								<th scope="col" colspan="2" rowspan="2">총 합계</th>
							</tr>
							<tr>
								<th scope="col" colspan="2" class="yellow">일반과정</th>
								<th scope="col" colspan="2" class="yellow">초급과정</th>
								<th scope="col" colspan="2" class="yellow">중급과정</th>
								<th scope="col" colspan="2" class="yellow">고급과정</th>
								<th scope="col" colspan="2" class="yellow">강사과정</th>
								<th scope="col" colspan="2" class="yellow">정기교육 계</th>
								<th scope="col" colspan="2" class="blue">초급과정</th>
								<th scope="col" colspan="2" class="blue">중급과정</th>
								<th scope="col" colspan="2" class="blue">직무교육 계</th>
								<th scope="col" colspan="2" class="red">일반과정</th>
								<th scope="col" colspan="2" class="red">초급과정</th>
								<th scope="col" colspan="2" class="red">중급과정</th>
								<th scope="col" colspan="2" class="red">비정기교육 계</th>
								<th scope="col" colspan="2">일반과정</th>
								<th scope="col" colspan="2">초급과정</th>
								<th scope="col" colspan="2">중급과정</th>
								<th scope="col" colspan="2">고급과정</th>
								<th scope="col" colspan="2">강사과정</th>
							</tr>	
							<tr class="line3">
								<th scope="col" class="yellow">횟수(회)</th>
								<th scope="col" class="yellow">연인원(명)</th>
								<th scope="col" class="yellow">횟수(회)</th>
								<th scope="col" class="yellow">연인원(명)</th>
								<th scope="col" class="yellow">횟수(회)</th>
								<th scope="col" class="yellow">연인원(명)</th>
								<th scope="col" class="yellow">횟수(회)</th>
								<th scope="col" class="yellow">연인원(명)</th>
								<th scope="col" class="yellow">횟수(회)</th>
								<th scope="col" class="yellow">연인원(명)</th>
								<th scope="col" class="yellow">횟수(회)</th>
								<th scope="col" class="yellow">연인원(명)</th>
								<th scope="col" class="blue">횟수(회)</th>
								<th scope="col" class="blue">연인원(명)</th>
								<th scope="col" class="blue">횟수(회)</th>
								<th scope="col" class="blue">연인원(명)</th>
								<th scope="col" class="blue">횟수(회)</th>
								<th scope="col" class="blue">연인원(명)</th>
								<th scope="col" class="red">횟수(회)</th>
								<th scope="col" class="red">연인원(명)</th>
								<th scope="col" class="red">횟수(회)</th>
								<th scope="col" class="red">연인원(명)</th>
								<th scope="col" class="red">횟수(회)</th>
								<th scope="col" class="red">연인원(명)</th>
								<th scope="col" class="red">횟수(회)</th>
								<th scope="col" class="red">연인원(명)</th>
								<th scope="col">횟수(회)</th>
								<th scope="col">연인원(명)</th>
								<th scope="col">횟수(회)</th>
								<th scope="col">연인원(명)</th>
								<th scope="col">횟수(회)</th>
								<th scope="col">연인원(명)</th>
								<th scope="col">횟수(회)</th>
								<th scope="col">연인원(명)</th>
								<th scope="col">횟수(회)</th>
								<th scope="col">연인원(명)</th>
								<th scope="col">횟수(회)</th>
								<th scope="col">연인원(명)</th>
							</tr>
						</thead>
						<tbody>
							<tr id="resultRow">
								<th scope="row">누적</th>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
							<%-- <tr>
								<th scope="row">${yearEduList.result.GUBUN	   }</th>
								<td>${yearEduList.result.ALL_REQ00_CNT	   }</td>
								<td>${yearEduList.result.ALL_REQ00_NMPR    }</td>
								<td>${yearEduList.result.ALL_REQ01_CNT     }</td>
								<td>${yearEduList.result.ALL_REQ01_NMPR    }</td>
								<td>${yearEduList.result.ALL_REQ02_CNT     }</td>
								<td>${yearEduList.result.ALL_REQ02_NMPR    }</td>
								<td>${yearEduList.result.ALL_REQ03_CNT     }</td>
								<td>${yearEduList.result.ALL_REQ03_NMPR    }</td>
								<td>${yearEduList.result.ALL_REQ04_CNT     }</td>
								<td>${yearEduList.result.ALL_REQ04_NMPR    }</td>
								<td>${yearEduList.result.ALL_SUM_REQ_CNT   }</td>
								<td>${yearEduList.result.ALL_SUM_REQ_NMPR  }</td>
								<td>${yearEduList.result.ALL_DTY01_CNT     }</td>
								<td>${yearEduList.result.ALL_DTY01_NMPR    }</td>
								<td>${yearEduList.result.ALL_DTY02_CNT     }</td>
								<td>${yearEduList.result.ALL_DTY02_NMPR    }</td>
								<td>${yearEduList.result.ALL_SUM_DTY_CNT   }</td>
								<td>${yearEduList.result.ALL_SUM_DTY_NMPR  }</td>
								<td>${yearEduList.result.ALL_IRREQ00_CNT   }</td>
								<td>${yearEduList.result.ALL_IRREQ00_NMPR  }</td>
								<td>${yearEduList.result.ALL_IRREQ01_CNT   }</td>
								<td>${yearEduList.result.ALL_IRREQ01_NMPR  }</td>
								<td>${yearEduList.result.ALL_IRREQ02_CNT   }</td>
								<td>${yearEduList.result.ALL_IRREQ02_NMPR  }</td>
								<td>${yearEduList.result.ALL_SUM_IRREQ_CNT }</td>
								<td>${yearEduList.result.ALL_SUM_IRREQ_NMPR}</td>
								<td>${yearEduList.result.ALL_SUM_00_CNT    }</td>
								<td>${yearEduList.result.ALL_SUM_00_NMPR   }</td>
								<td>${yearEduList.result.ALL_SUM_01_CNT    }</td>
								<td>${yearEduList.result.ALL_SUM_01_NMPR   }</td>
								<td>${yearEduList.result.ALL_SUM_02_CNT    }</td>
								<td>${yearEduList.result.ALL_SUM_02_NMPR   }</td>
								<td>${yearEduList.result.ALL_SUM_03_CNT    }</td>
								<td>${yearEduList.result.ALL_SUM_03_NMPR   }</td>
								<td>${yearEduList.result.ALL_SUM_04_CNT    }</td>
								<td>${yearEduList.result.ALL_SUM_04_NMPR   }</td>
								<td>${yearEduList.result.ALL_SUM_CNT       }</td>
								<td>${yearEduList.result.ALL_SUM_NMPR      }</td>
							</tr> --%>
							<c:forEach var="list" items="${yearEduList.yearList }" varStatus="status">
								<tr class="yearList">
									<th scope="row"><c:out value="${list.EDU_YEAR }"/></th>
									<td><c:out value="${list.REQ00_CNT	    }"/></td>
									<td><c:out value="${list.REQ00_NMPR     }"/></td>
									<td><c:out value="${list.REQ01_CNT      }"/></td>
									<td><c:out value="${list.REQ01_NMPR     }"/></td>
									<td><c:out value="${list.REQ02_CNT      }"/></td>
									<td><c:out value="${list.REQ02_NMPR     }"/></td>
									<td><c:out value="${list.REQ03_CNT      }"/></td>
									<td><c:out value="${list.REQ03_NMPR     }"/></td>
									<td><c:out value="${list.REQ04_CNT      }"/></td>
									<td><c:out value="${list.REQ04_NMPR     }"/></td>
									<td><c:out value="${list.SUM_REQ_CNT    }"/></td>
									<td><c:out value="${list.SUM_REQ_NMPR   }"/></td>
									
									<td><c:out value="${list.DTY01_CNT      }"/></td>
									<td><c:out value="${list.DTY01_NMPR     }"/></td>
									<td><c:out value="${list.DTY02_CNT      }"/></td>
									<td><c:out value="${list.DTY02_NMPR     }"/></td>
									<td><c:out value="${list.SUM_DTY_CNT    }"/></td>
									<td><c:out value="${list.SUM_DTY_NMPR   }"/></td>
									
									<td><c:out value="${list.IRREQ00_CNT    }"/></td>
									<td><c:out value="${list.IRREQ00_NMPR   }"/></td>
									<td><c:out value="${list.IRREQ01_CNT    }"/></td>
									<td><c:out value="${list.IRREQ01_NMPR   }"/></td>
									<td><c:out value="${list.IRREQ02_CNT    }"/></td>
									<td><c:out value="${list.IRREQ02_NMPR	  }"/></td>									
									<td><c:out value="${list.SUM_IRREQ_CNT  }"/></td>
									<td><c:out value="${list.SUM_IRREQ_NMPR }"/></td>
									
									<td><c:out value="${list.REQ00_CNT  + list.IRREQ00_CNT  }"/></td>
									<td><c:out value="${list.REQ00_NMPR + list.IRREQ00_NMPR }"/></td>
									<td><c:out value="${list.REQ01_CNT  + list.IRREQ01_CNT  + list.DTY01_CNT    }"/></td>
									<td><c:out value="${list.REQ01_NMPR + list.IRREQ01_NMPR + list.DTY01_NMPR   }"/></td>
									<td><c:out value="${list.REQ02_CNT  + list.IRREQ02_CNT  + list.DTY02_CNT    }"/></td>
									<td><c:out value="${list.REQ02_NMPR + list.IRREQ02_NMPR + list.DTY02_NMPR   }"/></td>
									<td><c:out value="${list.REQ03_CNT  }"/></td>
									<td><c:out value="${list.REQ03_NMPR }"/></td>
									<td><c:out value="${list.REQ04_CNT  }"/></td>
									<td><c:out value="${list.REQ04_NMPR }"/></td>
									
									<td><c:out value="${list.SUM_REQ_CNT + list.SUM_IRREQ_CNT + list.SUM_DTY_CNT}"/></td>
									<td><c:out value="${list.SUM_REQ_NMPR + list.SUM_IRREQ_NMPR + list.SUM_DTY_NMPR}"/></td>
								</tr>		
							</c:forEach>
							<c:forEach var="list" items="${yearEduList.monthList }" varStatus="status">
								<tr class="monthList">
									<th scope="row"><c:out value="${list.CURRENT_YEAR }"/>년<br><c:out value="${list.EDU_MONTH }"/>월</th>
									<td><c:out value="${list.REQ00_CNT	}"/></td>	
									<td><c:out value="${list.REQ00_NMPR   }"/></td>
									<td><c:out value="${list.REQ01_CNT    }"/></td>
									<td><c:out value="${list.REQ01_NMPR   }"/></td>
									<td><c:out value="${list.REQ02_CNT    }"/></td>
									<td><c:out value="${list.REQ02_NMPR   }"/></td>
									<td><c:out value="${list.REQ03_CNT    }"/></td>
									<td><c:out value="${list.REQ03_NMPR   }"/></td>
									<td><c:out value="${list.REQ04_CNT    }"/></td>
									<td><c:out value="${list.REQ04_NMPR   }"/></td>
									<td><c:out value="${list.SUM_REQ_CNT    }"/></td>
									<td><c:out value="${list.SUM_REQ_NMPR   }"/></td>
									
									<td><c:out value="${list.DTY01_CNT    }"/></td>
									<td><c:out value="${list.DTY01_NMPR   }"/></td>
									<td><c:out value="${list.DTY02_CNT    }"/></td>
									<td><c:out value="${list.DTY02_NMPR   }"/></td>
									<td><c:out value="${list.SUM_DTY_CNT    }"/></td>
									<td><c:out value="${list.SUM_DTY_NMPR   }"/></td>
									
									<td><c:out value="${list.IRREQ00_CNT  }"/></td>
									<td><c:out value="${list.IRREQ00_NMPR }"/></td>
									<td><c:out value="${list.IRREQ01_CNT  }"/></td>
									<td><c:out value="${list.IRREQ01_NMPR }"/></td>
									<td><c:out value="${list.IRREQ02_CNT  }"/></td>
									<td><c:out value="${list.IRREQ02_NMPR	}"/></td>									
									<td><c:out value="${list.SUM_IRREQ_CNT    }"/></td>
									<td><c:out value="${list.SUM_IRREQ_NMPR   }"/></td>
									
									<td><c:out value="${list.REQ00_CNT  + list.IRREQ00_CNT  }"/></td>
									<td><c:out value="${list.REQ00_NMPR + list.IRREQ00_NMPR }"/></td>
									<td><c:out value="${list.REQ01_CNT  + list.IRREQ01_CNT  + list.DTY01_CNT    }"/></td>
									<td><c:out value="${list.REQ01_NMPR + list.IRREQ01_NMPR + list.DTY01_NMPR   }"/></td>
									<td><c:out value="${list.REQ02_CNT  + list.IRREQ02_CNT  + list.DTY02_CNT    }"/></td>
									<td><c:out value="${list.REQ02_NMPR + list.IRREQ02_NMPR + list.DTY02_NMPR   }"/></td>
									<td><c:out value="${list.REQ03_CNT  }"/></td>
									<td><c:out value="${list.REQ03_NMPR }"/></td>
									<td><c:out value="${list.REQ04_CNT  }"/></td>
									<td><c:out value="${list.REQ04_NMPR }"/></td>
									
									<td><c:out value="${list.SUM_REQ_CNT + list.SUM_IRREQ_CNT + list.SUM_DTY_CNT}"/></td>
									<td><c:out value="${list.SUM_REQ_NMPR + list.SUM_IRREQ_NMPR + list.SUM_DTY_NMPR}"/></td>
								</tr>		
							</c:forEach>
						</tbody>
					</table>
				</article>
			</div>
			<!-- row 메뉴조회 끝 -->
		</div>
	</section>
	<!-- widget grid end -->

</div>
<!-- END MAIN CONTENT -->