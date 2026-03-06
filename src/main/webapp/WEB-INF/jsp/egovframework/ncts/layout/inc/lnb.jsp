<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% 
	String nowUrl = request.getRequestURI().toUpperCase(); 
	int k = nowUrl.lastIndexOf("/");
	nowUrl = nowUrl.substring(k + 1, nowUrl.length()).replace(".JSP","");
	request.setAttribute("nowUrl", nowUrl);
	
	
%>
		<!-- Left panel : Navigation area -->
		<aside id="left-panel">
			<!-- start user info -->
			<div class="login-info">
				<span>
					<a href="javascript:showPopLayer('pass');">
						<span style="margin-top:3px; color:#dfe9fb">
							<i class="fa fa-user mt2 mr2 ml6" title="비밀번호변경" style="color:#2c4269; font-size:14px"></i>
							<sec:authentication property="principal.userNm"/> 님
						</span>
						
					</a>
					
				</span>
			</div>
			<!-- end user info -->

			<nav>
	            <ul>
	            	<c:set var="isParent" value="false" />
					<c:set var="isChild"  value="false" />
					<c:forEach var="left" items="${leftmenu}" varStatus="idx">
						
						<c:if test="${(fn:substring(left.MENU_CD, 0, 5)) ne '11002'
									   and (fn:substring(left.MENU_CD, 0, 5)) ne '11011'
									   and (fn:substring(left.MENU_CD, 0, 5)) ne '11012'
									   and (fn:substring(left.MENU_CD, 0, 5)) ne '11004'
									   and (fn:substring(left.MENU_CD, 0, 5)) ne '11013'
									   and (fn:substring(left.MENU_CD, 0, 5)) ne '11003'
									   and (fn:substring(left.MENU_CD, 0, 5)) ne '11014'
									   and ((fn:substring(left.MENU_CD, 0, 5) eq fn:substring(pageInfo.MENU_CD, 0, 5)) or (fn:substring(pageInfo.PARENT_CD, 0, 3) eq '900')) 
						}">
							<c:choose>
								<c:when test="${left.MENU_DEPTH eq 2 }">
									<c:if test="${isChild}">
										<c:set var="isChild"  value="false" />
										</ul></li>
									</c:if>
									<c:set var="isParent" value="true" />
									<li class="">
									<a href="#" title="Dashboard">
										<c:choose>
											<c:when test="${left.MENU_CD eq '90010000'}"><i class="fa fa-fw fa-desktop"></i><%-- 사이트관리 --%></c:when>
											<c:when test="${left.MENU_CD eq '90020000'}"><i class="fa fa-group"></i><%-- 조직관리 --%></c:when>
											<c:when test="${left.MENU_CD eq '90030000'}"><i class="fa fa-star-o"></i><%-- 권한관리 --%></c:when>
											<c:when test="${left.MENU_CD eq '90040000'}"><i class="fa fa-bar-chart-o"></i><%-- 평가관리 --%></c:when>
											<c:when test="${left.MENU_CD eq '90050000'}"><i class="fa fa fa-history"></i><%-- 로그관리 --%></c:when>
											<c:when test="${left.MENU_CD eq '90060000'}"><i class="fa fa-question-circle" ></i><%-- Q&A --%></c:when>
											<c:when test="${left.MENU_CD eq '110010000'}"><i class="fa fa-fw fa-clipboard"></i><%-- 강사관리 --%></c:when>
											<c:when test="${left.MENU_CD eq '110020000'}"><i class="fa fa-fw fa-check-square-o"></i><%-- 교육신청관리 --%></c:when>
											<c:when test="${left.MENU_CD eq '110030000'}"><i class="fa fa-fw fa-sliders"></i><%-- 교육운영관리 --%></c:when>
											<c:when test="${left.MENU_CD eq '110040000'}"><i class="fa fa-fw fa-graduation-cap"></i><%-- 교육이수관리 --%></c:when>
											<c:when test="${left.MENU_CD eq '110050000'}"><i class="fa fa-fw fa-desktop"></i><%-- 홈페이지관리 --%></c:when>
											<c:when test="${left.MENU_CD eq '110060000'}"><i class="fa fa-fw fa-user"></i><%-- 회원관리 --%></c:when>											
											<c:when test="${left.MENU_CD eq '110080000'}"><i class="fa fa-bell"></i><%-- 전산요청관리 --%></c:when>	
											<c:when test="${left.MENU_CD eq '110090000'}"><i class="fa fa-bar-chart"></i><%-- 조회/통계 --%></c:when>	
											<c:when test="${left.MENU_CD eq '110100000'}"><i class="fa fa-envelope"></i><%-- 메일 --%></c:when>	
											<c:when test="${left.MENU_CD eq '110110000'}"><i class="fa fa-star"></i><%-- 자격심사 --%></c:when>	
											<c:when test="${left.MENU_CD eq '110120000'}"><i class="fa fa-fw fa-check-square-o"></i><%-- 직무교육관리 --%></c:when>
											<c:when test="${left.MENU_CD eq '110130000'}"><i class="fa fa-fw fa-graduation-cap"></i><%-- 직무이수관리 --%></c:when>
											<c:when test="${left.MENU_CD eq '110140000'}"><i class="fa fa-fw fa-graduation-cap"></i><%-- 직무동영상관리 --%></c:when>
											<c:otherwise><i class="fa fa-lg fa-fw fa-th-list"></i></c:otherwise>
										</c:choose>
										<span class="menu-item-parent">${left.MENU_NM }</span>
									</a>			
								</c:when>
								<c:when test="${left.MENU_DEPTH eq 3 }">
									<c:if test="${isParent}">
										<c:set var="isParent" value="false" />
										<ul>
									</c:if>
									<c:set var="isChild"  value="true" />
									<li <c:if test="${pageInfo.PARENT_CD eq left.MENU_CD }">class="active"</c:if>><a href="/ncts/middle/${left.MENU_CD}.do" title="리스트"><span class="menu-item-parent">${left.MENU_NM }</span></a></li>
									
								</c:when>
							</c:choose>
						</c:if>
						
						
						<c:set var="PAGE_MENU_CD" value="${fn:substring(pageInfo.MENU_CD, 0, 5) }" />
						<c:choose>
							<c:when test="${(fn:substring(left.MENU_CD, 0, 5)) eq '11002'}">
								<c:if test="${(fn:substring(left.MENU_CD, 0, 5) eq PAGE_MENU_CD) or (PAGE_MENU_CD eq '11011') or (PAGE_MENU_CD eq '11012')}">
									<c:choose>
										<c:when test="${left.MENU_DEPTH eq 2}">
											<c:if test="${isChild}">
												<c:set var="isChild"  value="false" />
												</ul></li>
											</c:if>
											<c:set var="isParent" value="true" />
											<li class="">
											<a href="#" title="Dashboard">
												<c:choose>
													<c:when test="${left.MENU_CD eq '110020000'}"><i class="fa fa-fw fa-check-square-o"></i><%-- 교육신청관리 --%></c:when>
													<c:when test="${left.MENU_CD eq '110110000'}"><i class="fa fa-star"></i><%-- 자격심사 --%></c:when>	
													<c:when test="${left.MENU_CD eq '110120000'}"><i class="fa fa-fw fa-check-square-o"></i><%-- 직무교육관리 --%></c:when>
													<c:otherwise><i class="fa fa-lg fa-fw fa-th-list"></i></c:otherwise>
												</c:choose>
												<span class="menu-item-parent">${left.MENU_NM }</span>
											</a>			
										</c:when>
										<c:when test="${left.MENU_DEPTH eq 3}">
											<c:if test="${isParent}">
												<c:set var="isParent" value="false" />
												<ul>
											</c:if>
											<c:set var="isChild"  value="true" />
											<li <c:if test="${pageInfo.PARENT_CD eq left.MENU_CD }">class="active"</c:if>><a href="/ncts/middle/${left.MENU_CD}.do" title="리스트"><span class="menu-item-parent">${left.MENU_NM }</span></a></li>
										</c:when>
									</c:choose>

								</c:if>
							</c:when>
							
							<c:when test="${(fn:substring(left.MENU_CD, 0, 5)) eq '11011'}">
								<c:if test="${(fn:substring(left.MENU_CD, 0, 5) eq PAGE_MENU_CD) or (PAGE_MENU_CD eq '11002') or (PAGE_MENU_CD eq '11012')}">
									<c:choose>
										<c:when test="${left.MENU_DEPTH eq 2 }">
											<c:if test="${isChild}">
												<c:set var="isChild"  value="false" />
												</ul></li>
											</c:if>
											<c:set var="isParent" value="true" />
											<li class="">
											<a href="#" title="Dashboard">
												<c:choose>
													<c:when test="${left.MENU_CD eq '110020000'}"><i class="fa fa-fw fa-check-square-o"></i><%-- 교육신청관리 --%></c:when>
													<c:when test="${left.MENU_CD eq '110110000'}"><i class="fa fa-star"></i><%-- 자격심사 --%></c:when>	
													<c:when test="${left.MENU_CD eq '110120000'}"><i class="fa fa-fw fa-check-square-o"></i><%-- 직무교육관리 --%></c:when>													
													<c:otherwise><i class="fa fa-lg fa-fw fa-th-list"></i></c:otherwise>
												</c:choose>
												<span class="menu-item-parent">${left.MENU_NM }</span>
											</a>			
										</c:when>
										<c:when test="${left.MENU_DEPTH eq 3}">
											<c:if test="${isParent}">
												<c:set var="isParent" value="false" />
												<ul>
											</c:if>
											<c:set var="isChild"  value="true" />
											<li <c:if test="${pageInfo.PARENT_CD eq left.MENU_CD }">class="active"</c:if>><a href="/ncts/middle/${left.MENU_CD}.do" title="리스트"><span class="menu-item-parent">${left.MENU_NM }</span></a></li>
										</c:when>
									</c:choose>									
								</c:if>
							</c:when>
							
							<c:when test="${(fn:substring(left.MENU_CD, 0, 5)) eq '11012'}">
								<c:if test="${(fn:substring(left.MENU_CD, 0, 5) eq PAGE_MENU_CD) or (PAGE_MENU_CD eq '11002') or (PAGE_MENU_CD eq '11011')}">
									<c:choose>
										<c:when test="${left.MENU_DEPTH eq 2 }">
											<c:if test="${isChild}">
												<c:set var="isChild"  value="false" />
												</ul></li>
											</c:if>
											<c:set var="isParent" value="true" />
											<li class="">
											<a href="#" title="Dashboard">
												<c:choose>
													<c:when test="${left.MENU_CD eq '110020000'}"><i class="fa fa-fw fa-check-square-o"></i><%-- 교육신청관리 --%></c:when>
													<c:when test="${left.MENU_CD eq '110110000'}"><i class="fa fa-star"></i><%-- 자격심사 --%></c:when>	
													<c:when test="${left.MENU_CD eq '110120000'}"><i class="fa fa-fw fa-check-square-o"></i><%-- 직무교육관리 --%></c:when>													
													<c:otherwise><i class="fa fa-lg fa-fw fa-th-list"></i></c:otherwise>
												</c:choose>
												<span class="menu-item-parent">${left.MENU_NM }</span>
											</a>			
										</c:when>
										<c:when test="${left.MENU_DEPTH eq 3}">
											<c:if test="${isParent}">
												<c:set var="isParent" value="false" />
												<ul>
											</c:if>
											<c:set var="isChild"  value="true" />
											<li <c:if test="${pageInfo.PARENT_CD eq left.MENU_CD }">class="active"</c:if>><a href="/ncts/middle/${left.MENU_CD}.do" title="리스트"><span class="menu-item-parent">${left.MENU_NM }</span></a></li>
										</c:when>
									</c:choose>									
								</c:if>
							</c:when>
							
							<c:when test="${(fn:substring(left.MENU_CD, 0, 5)) eq '11004'}">
								<c:if test="${(fn:substring(left.MENU_CD, 0, 5) eq PAGE_MENU_CD) or (PAGE_MENU_CD eq '11013')}">
									<c:choose>
										<c:when test="${left.MENU_DEPTH eq 2 }">
											<c:if test="${isChild}">
												<c:set var="isChild"  value="false" />
												</ul></li>
											</c:if>
											<c:set var="isParent" value="true" />
											<li class="">
											<a href="#" title="Dashboard">
												<c:choose>
													<c:when test="${left.MENU_CD eq '110040000'}"><i class="fa fa-fw fa-graduation-cap"></i><%-- 교육이수관리 --%></c:when>												
													<c:when test="${left.MENU_CD eq '110130000'}"><i class="fa fa-fw fa-graduation-cap"></i><%-- 직무교육관리 --%></c:when>													
													<c:otherwise><i class="fa fa-lg fa-fw fa-th-list"></i></c:otherwise>
												</c:choose>
												<span class="menu-item-parent">${left.MENU_NM }</span>
											</a>			
										</c:when>
										<c:when test="${left.MENU_DEPTH eq 3}">
											<c:if test="${isParent}">
												<c:set var="isParent" value="false" />
												<ul>
											</c:if>
											<c:set var="isChild"  value="true" />
											<li <c:if test="${pageInfo.PARENT_CD eq left.MENU_CD }">class="active"</c:if>><a href="/ncts/middle/${left.MENU_CD}.do" title="리스트"><span class="menu-item-parent">${left.MENU_NM }</span></a></li>
										</c:when>
									</c:choose>									
								</c:if>
							</c:when>
							<c:when test="${(fn:substring(left.MENU_CD, 0, 5)) eq '11013'}">
								<c:if test="${(fn:substring(left.MENU_CD, 0, 5) eq PAGE_MENU_CD) or (PAGE_MENU_CD eq '11004')}">
									<c:choose>
										<c:when test="${left.MENU_DEPTH eq 2 }">
											<c:if test="${isChild}">
												<c:set var="isChild"  value="false" />
												</ul></li>
											</c:if>
											<c:set var="isParent" value="true" />
											<li class="">
											<a href="#" title="Dashboard">
												<c:choose>
													<c:when test="${left.MENU_CD eq '110040000'}"><i class="fa fa-fw fa-graduation-cap"></i><%-- 교육이수관리 --%></c:when>												
													<c:when test="${left.MENU_CD eq '110130000'}"><i class="fa fa-fw fa-graduation-cap"></i><%-- 직무교육관리 --%></c:when>													
													<c:otherwise><i class="fa fa-lg fa-fw fa-th-list"></i></c:otherwise>
												</c:choose>
												<span class="menu-item-parent">${left.MENU_NM }</span>
											</a>			
										</c:when>
										<c:when test="${left.MENU_DEPTH eq 3}">
											<c:if test="${isParent}">
												<c:set var="isParent" value="false" />
												<ul>
											</c:if>
											<c:set var="isChild"  value="true" />
											<li <c:if test="${pageInfo.PARENT_CD eq left.MENU_CD }">class="active"</c:if>><a href="/ncts/middle/${left.MENU_CD}.do" title="리스트"><span class="menu-item-parent">${left.MENU_NM }</span></a></li>
										</c:when>
									</c:choose>									
								</c:if>
							</c:when>
							
							<c:when test="${(fn:substring(left.MENU_CD, 0, 5)) eq '11003'}">
								<c:if test="${(fn:substring(left.MENU_CD, 0, 5) eq PAGE_MENU_CD) or (PAGE_MENU_CD eq '11014')}">
									<c:choose>
										<c:when test="${left.MENU_DEPTH eq 2 }">
											<c:if test="${isChild}">
												<c:set var="isChild"  value="false" />
												</ul></li>
											</c:if>
											<c:set var="isParent" value="true" />
											<li class="">
											<a href="#" title="Dashboard">
												<c:choose>
													<c:when test="${left.MENU_CD eq '110030000'}"><i class="fa fa-fw fa-sliders"></i><%-- 교육운영관리 --%></c:when>
													<c:when test="${left.MENU_CD eq '110140000'}"><i class="fa fa-fw fa-graduation-cap"></i><%-- 직무동영상관리 --%></c:when>												
													<c:otherwise><i class="fa fa-lg fa-fw fa-th-list"></i></c:otherwise>
												</c:choose>
												<span class="menu-item-parent">${left.MENU_NM }</span>
											</a>			
										</c:when>
										<c:when test="${left.MENU_DEPTH eq 3}">
											<c:if test="${isParent}">
												<c:set var="isParent" value="false" />
												<ul>
											</c:if>
											<c:set var="isChild"  value="true" />
											<li <c:if test="${pageInfo.PARENT_CD eq left.MENU_CD }">class="active"</c:if>><a href="/ncts/middle/${left.MENU_CD}.do" title="리스트"><span class="menu-item-parent">${left.MENU_NM }</span></a></li>
										</c:when>
									</c:choose>									
								</c:if>
							</c:when>
							<c:when test="${(fn:substring(left.MENU_CD, 0, 5)) eq '11014'}">
								<c:if test="${(fn:substring(left.MENU_CD, 0, 5) eq PAGE_MENU_CD) or (PAGE_MENU_CD eq '11003')}">
									<c:choose>
										<c:when test="${left.MENU_DEPTH eq 2 }">
											<c:if test="${isChild}">
												<c:set var="isChild"  value="false" />
												</ul></li>
											</c:if>
											<c:set var="isParent" value="true" />
											<li class="">
											<a href="#" title="Dashboard">
												<c:choose>
													<c:when test="${left.MENU_CD eq '110030000'}"><i class="fa fa-fw fa-sliders"></i><%-- 교육운영관리 --%></c:when>
													<c:when test="${left.MENU_CD eq '110140000'}"><i class="fa fa-fw fa-graduation-cap"></i><%-- 직무동영상관리 --%></c:when>												
													<c:otherwise><i class="fa fa-lg fa-fw fa-th-list"></i></c:otherwise>
												</c:choose>
												<span class="menu-item-parent">${left.MENU_NM }</span>
											</a>			
										</c:when>
										<c:when test="${left.MENU_DEPTH eq 3}">
											<c:if test="${isParent}">
												<c:set var="isParent" value="false" />
												<ul>
											</c:if>
											<c:set var="isChild"  value="true" />
											<li <c:if test="${pageInfo.PARENT_CD eq left.MENU_CD }">class="active"</c:if>><a href="/ncts/middle/${left.MENU_CD}.do" title="리스트"><span class="menu-item-parent">${left.MENU_NM }</span></a></li>
										</c:when>
									</c:choose>									
								</c:if>
							</c:when>							
						</c:choose>
						
						<c:if test="${idx.last }">
							<c:choose>
								<c:when test="${left.MENU_DEPTH eq 2 }">
									</li>
								</c:when>
								<c:when test="${left.MENU_DEPTH eq 3 }">
									</ul></li>
								</c:when>
							</c:choose>
						</c:if>
					</c:forEach>		
	            </ul>
	         </nav>
			
			<span class="minifyme" id="minifyMenu" data-action="minifyMenu"> 
				<i class="fa fa-arrow-circle-left hit" style="color:#57698e;"></i> 
			</span>
		</aside>
		<!-- END NAVIGATION -->

		<!-- 비밀번호 팝업 -->
		<div>
			<div class="popLayer" id="pass" style="display:none;">
				<div class="popWrap">
					<form id="passForm" name="passForm" method="post">
					<h3>비밀번호 변경</h3>
					<br />
						<table class="table table-bordered tb_type03" style="min-width:320px;width: 320px">
						<colgroup>
							<col width="150" />
							<col width="" />
						</colgroup>
					
							<tr>
								<th scope="row">현재 비밀번호</th>
								<td>
									<input type="password" id="oldpass" name="oldpass" value="" class="form-control" >
								</td>
							</tr>
							<tr>
								<th scope="row">신규 비밀번호</th>
								<td>
									<input type="password" id="newpass1" name="newpass1" value="" class="form-control" >
								</td>
							</tr>
							<tr>
								<th scope="row">비밀번호 다시 입력</th>
								<td>
									<input type="password" id="newpass2" name="newpass2" value="" class="form-control" >					
								</td>
							</tr>
						</table>
					</form>
					<div class="pop_bot_btn">
                        <button class="btn btn-primary ml2" type="button" onclick="passAction();">
                            <i class="fa fa-edit" title="저장"></i> 저장
                        </button>
                        <button class="btn btn-default ml2" type="button" onclick="closePopLayer('pass');">
                            <i class="fa fa-default" title="닫기"></i> 닫기
                        </button>
					</div>
				</div>
			</div>
		</div>
		<!-- 비밀번호 팝업 -->
		
		
		