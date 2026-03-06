// 헬퍼 등록
Handlebars.registerHelper('safe', function(text) {
	if($.isNullStr(text)) text = "";
    return new Handlebars.SafeString(text);
});

//인덱스 값 +1
Handlebars.registerHelper("inc", function(value, options){
    return parseInt(value) + 1;
});

Handlebars.registerHelper('empty', function (a, options) {
	if(typeof a === "undefined") { return options.fn(this); } 
    return options.inverse(this);
});

Handlebars.registerHelper('notempty', function (a, options) {
	if(typeof a != "undefined") { return options.fn(this); } 
    return options.inverse(this);
});

Handlebars.registerHelper('ifeq', function (a, b, options) {
    if (a == b) { return options.fn(this); }
    return options.inverse(this);
});

Handlebars.registerHelper('ifnoteq', function (a, b, options) {
    if (a != b) { return options.fn(this); }
    return options.inverse(this);
});

Handlebars.registerHelper('iflt', function (a, b, options) {
    if (a < b) { return options.fn(this); }
    return options.inverse(this);
});

Handlebars.registerHelper('ifgt', function (a, b, options) {
    if (a > b) { return options.fn(this); }
    return options.inverse(this);
});

Handlebars.registerHelper('ifle', function (a, b, options) {
    if (a <= b) { return options.fn(this); }
    return options.inverse(this);
});

Handlebars.registerHelper('ifge', function (a, b, options) {
    if (a >= b) { return options.fn(this); }
    return options.inverse(this);
});

Handlebars.registerHelper('ifnull', function (a, options) {
	if(typeof a === "undefined" || a === '') { return options.fn(this); }
    return options.inverse(this);
});

Handlebars.registerHelper('mod', function (a, b, options) {
	var mod = a%b;
	if(mod==0) { return options.fn(this); }
    return options.inverse(this);
});

Handlebars.registerHelper('notmod', function (a, b, options) {
	var mod = a%b;
	if(mod==(b-1)) { return options.fn(this); }
    return options.inverse(this);
});

Handlebars.registerHelper('colspan', function (a, b, options) {
	var col=1;
	col=(b-(a%b))*2-1;
    return col;
});

Handlebars.registerHelper('right', function (a, b, options) {
	var len = a.length-b;
    return a.substr(len,b);
});

Handlebars.registerHelper('notnull', function (a, options) {
	if(a != undefined) { return options.fn(this); } 
	return options.inverse(this);
});

Handlebars.registerHelper('sum', function (a, b, options) {
	var sum = a+b;
    return sum;
});

Handlebars.registerHelper('realAge', function (p1, p2, options) {
	//TODO 만나이 계산 식 주민번호 앞 뒤
	var date = new Date(); 
	var year = date.getFullYear(); 
	var month = new String(date.getMonth()+1); 
	var day = new String(date.getDate()); 
	p2+="";
	
	var today = year + "" + month + "" + day;
	var gender = p2.substring(0,1);
	var birthDayYear;
	if(gender=='1') birthDayYear=19000000;
	else if(gender=='2') birthDayYear=19000000;
	else if(gender=='3') birthDayYear=20000000;
	else if(gender=='4') birthDayYear=20000000;
	else birthDayYear=19000000;
	var birthDay = parseInt(p1)+birthDayYear;
	birthDay+="";
	
	var realAge = parseInt(today.substring(0,4))-parseInt(birthDay.substring(0,4));
	if(today<birthDay) realAge=realAge-1;
	
    return realAge;
});

Handlebars.registerHelper('realTime', function (a, b,c,d, options) {
	var today = new Date();
	
	var oldYear = today.getFullYear();
	var oldMonth = leadingZeros(today.getMonth(),2);
	var oldDay = leadingZeros(today.getDate(),2);
	var oldHour = leadingZeros(a,2);
	var oldMinute = leadingZeros(b,2);
	
	
	var newYear = today.getFullYear();
	var newMonth = leadingZeros(today.getMonth(),2);
	var newDay = leadingZeros(today.getDate(),2);
	var newHour = leadingZeros(c,2);
	var newMinute = leadingZeros(d,2);
	
	
	if($.isNullStr(oldYear)) return ;
	if($.isNullStr(oldMonth)) return ;
	if($.isNullStr(oldDay)) return ;
	if($.isNullStr(oldHour)) return ;
	if($.isNullStr(oldMinute)) return ;
	
	if($.isNullStr(newYear)) return ;
	if($.isNullStr(newMonth)) return ;
	if($.isNullStr(newDay)) return ;
	if($.isNullStr(newHour)) return ;
	if($.isNullStr(newMinute)) return ;
	
	
	var oldDate = new Date(oldYear, oldMonth, oldDay, oldHour, oldMinute, "00");
	var newDate = new Date(newYear, newMonth, newDay, newHour, newMinute, "00");
	
	
	var gap = (newDate.getTime() - oldDate.getTime()) / 1000 / 60;
	return gap;
	
});

$.fn.extend({
	handlerbarsCompile : function(obj, arr){
		var $this = $(this);
		var source = $(obj).html();
		var template = Handlebars.compile(source);
		var html = template(arr);
		$this.html(html);
	},
	handlerbarsAppendCompile : function(obj, arr){
		var $this = $(this);
		var source = $(obj).html();
		var template = Handlebars.compile(source);
		var html = template(arr);
		$this.append(html);
	},
	handlerbarsAfterCompile : function(obj, arr){
		var $this = $(this);
		var source = $(obj).html();
		var template = Handlebars.compile(source);
		var html = template(arr);
		$this.after(html);
	},
	handlerbarsBeforeCompile : function(obj, arr){
		var $this = $(this);
		var source = $(obj).html();
		var template = Handlebars.compile(source);
		var html = template(arr);
		$this.before(html);
	}
	
})