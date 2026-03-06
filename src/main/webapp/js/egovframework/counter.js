'use strict';

$.extend(String.prototype, {
	interpolate: function() {
		var args = [].slice.call(arguments), template = this;
		$.each(args, function(i, v) {
			template = template.replace(/\$\{[^{}]*\}/, v);
		});
		return template;
	}
});

var Counter = function(Control) {
	/**
	 * Interval function
	 * @type {function}
	 */
	this.fn;
	
	/**
	 * Target object(jquery object)
	 * @type {Object}
	 */
	this.control = Control;
	
	/**
	 * Session timeout confirm layer
	 * @type {Object}
	 */
	this.modal;
	
	/**
	 * Initial time(Default 60)
	 * @type {Number}
	 */
	this.minute = 30; // 서버는 30분
	
	if(this.control) this.control.html(moment().startOf('day').format('H:mm:ss'));
	
	this.readyModal();
};

Counter.prototype.reset = function() {
	this.stop();
	
	this.set(this.minute);
};

Counter.prototype.stop = function() {
	if(this.fn) clearInterval(this.fn);
	if(this.control) this.control.html(moment().startOf('day').format('H:mm:ss'));
};

Counter.prototype.set = function(Min) {
	this.minute = Min || this.minute;
	
	var c = this;
	var time = c.minute * 60;
	
	if(this.fn) clearInterval(this.fn);
	
	this.fn = setInterval(function() {
		if(c.control) c.control.html(moment().startOf('day').seconds(time).format('H:mm:ss'));
		
		// 세션timeout 5분전 modal 호출
		if(time < 300) {
			c.confirm(moment().startOf('day').seconds(time).format('mm:ss'));
		}
		
		/*console.log(moment().startOf('day').seconds(time).format('H:mm:ss'));*/
		time--;
		
		if(time < 0) {
			c.logout();
		}
	}, 1000);
};

Counter.prototype.readyModal = function() {
	$([	'<div class="modal fade" aria-hidden="true" data-backdrop="static" tabindex="-1" role="dialog" id="ncts-confirm-modal">',
			'<div class="modal-dialog" role="document">',
				'<div style="display: block;" class="dim-layer modal-content">',
					'<div class="dimBg dimBg2"></div>',
					'<div id="layer1" class="logout-con ">',
					'<div class="close_box fClr"></div>',
					'<div class="modal-body file_box"></div>',
						
					'<div class="modal-footer line tRight">',
						'<button type="button" class="b_g btn btn-primary fn-confirm" data-dismiss="modal">연장하기</button>',
						'<button type="button" class="b_w btn btn-light fn-cancel" data-dismiss="modal">로그아웃</button>',
					'</div>',
				'</div>',
				'</div>',
			'</div>',
		'</div>'
	].join('')).appendTo('body');
};

Counter.prototype.confirm = function(time) {
	this.modal = $('#ncts-confirm-modal')
		.off('show.bs.modal')
		.off('shown.bs.modal')
		.off('hide.bs.modal')
		.off('hidden.bs.modal')
		.find('button.close').hide().end()
		.find('.modal-title').text('자동로그아웃 안내').end()
		.find('.modal-body').html(
			[
       			'<div class="form-group m-3">',
       				'<p class="tit">자동 로그아웃 안내</p>',
					'<p class="sub">자동 로그아웃 남은시간 : <span class="fw text-danger">${time}</span><br>로그인 시간을 연장하시겠습니까?</p>'.interpolate(time),
					
				'</div>'
			].join('')
		).end()
		.find('.fn-confirm').off('click').end()
		.find('.fn-cancel').off('click').end();
	
	this.modal.find('.fn-confirm').on('click', this.extendSession.bind(this));
	this.modal.find('.fn-cancel').on('click', this.logout.bind(this));
	
	if(!this.modal.hasClass('in')) this.modal.modal('show');
};

Counter.prototype.extendSession = function() {
	this.stop();
	
	$.getJSON("/ncts/login/extendSession.do");
};

Counter.prototype.logout = function() {
	this.stop();
	
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
};