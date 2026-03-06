<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta http-equiv="Expires" content="-1" />
<meta http-equiv="Progma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />

<meta name="description" content="">
<meta name="author" content="">
	
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

<%
    String dummynow = new java.text.SimpleDateFormat("yyyyMMddHHmmssSSS").format(new java.util.Date());
%>

<!-- Basic Styles -->
<link rel="stylesheet" type="text/css" media="screen" href="/bootstrap/css/bootstrap.min.css?v=20211124">
<link rel="stylesheet" type="text/css" media="screen" href="/bootstrap/css/font-awesome.min.css?v=20211124">

<!-- SmartAdmin Styles : Caution! DO NOT change the order -->
<link rel="stylesheet" type="text/css" media="screen" href="/bootstrap/css/smartadmin-production-plugins.min.css?v=20211124">
<link rel="stylesheet" type="text/css" media="screen" href="/bootstrap/css/smartadmin-production.min.css?v=20211124">

<!-- We recommend you use "your_style.css" to override SmartAdmin
     specific styles this will also ensure you retrain your customization with each SmartAdmin update.-->
<link rel="stylesheet" type="text/css" media="screen" href="/bootstrap/css/your_style.css?v=<%=dummynow%>">

<!-- FAVICONS -->
<link rel="shortcut icon" href="/bootstrap/img/favicon/favicon.ico" type="image/x-icon">
<link rel="icon" href="/bootstrap/img/favicon/favicon.ico" type="image/x-icon">


<script src="/bootstrap/js/libs/jquery-2.1.1.min.js"></script>
<script src="/bootstrap/js/libs/jquery-ui-1.10.3.min.js"></script>


<script type="text/javascript" src="/js/egovframework/lib/jquery.validate.min.js?v=20211124"></script>


<script type="text/javascript" src="/js/egovframework/lib/handlebars.min-latest.js?v=20211124"></script>

<script type="text/javascript" src="/js/egovframework/lib/jquery.form.js?v=20211124"></script>
<script type="text/javascript" src="/js/egovframework/lib/jquery.serialObject.js?v=20211124"></script>

<script type="text/javascript" src="/js/egovframework/developer.init.js?v=<%=dummynow%>"></script>
<script type="text/javascript" src="/js/egovframework/userDatePicker.js?v=<%=dummynow%>"></script>
<script type="text/javascript" src="/js/egovframework/file.js?v=<%=dummynow%>"></script>
<script type="text/javascript" src="/js/egovframework/handlebars.Helper.js?v=<%=dummynow%>"></script>


<script type="text/javascript" src="/js/egovframework/moment-with-locales.js?v=20211124"></script>
<!-- Session timer -->
<script type="text/javascript" src="/js/egovframework/counter.js?v=<%=dummynow%>"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/dayjs/1.10.7/dayjs.min.js"></script>
<%-- <script type="text/javascript" src="/js/egovframework/calendar/fullCalendarMain.js"></script>
<script type="text/javascript" src="/js/egovframework/calendar/ko.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="/css/egovframework/fullCalendarMain.css"> --%>

<title>재난 정신건강 교육관리시스템</title>
