package util;

import js.html.InputEvent;
import js.html.FocusEvent;
import js.html.InputElement;

class Pomodoro {

	public static var timer_text:InputElement;
	public static var play_btn:DivElement;
	public static var timer_icon:DivElement;
	static var last:String;

	public static function init(v:Int) {
		timer_text = cast document.getElementById('timer');
		timer_text.onfocus = (e) -> on_focus(e);
		timer_text.onblur = (e) -> on_blur(e);
		timer_text.addEventListener('input', (e) -> on_input(e));

		play_btn = cast document.getElementById('pomo-start');
		play_btn.onclick = (e) -> play_btn_click(e);

		timer_icon = cast document.getElementById('pomo-icon');
		timer_icon.onclick = (e) -> {
			var cont = TimerUtil.active;
			pause();
			timer_text.value = '$last:00';
			cont ? start() : stop();
		}

		last = '$v';
		timer_text.value = '$last:00';
	}

	public static function check_persistence() {
		var was_active = window.localStorage.getItem('timer_active');
		var last_time = window.localStorage.getItem('timer_amt');
		if (was_active == 'true') {
			timer_text.value = last_time;
			start();
		}
	}

	static function on_focus(e:FocusEvent) {
		trace('focus', e);
		pause();
		TimerUtil.cancel();
		parse_input();
	}

	static function on_input(e:InputEvent) {
		trace('input', e);
		parse_input();
	}

	static function parse_input() {
		var n = Std.parseInt(timer_text.value);
		trace(n);
		if (n == null && timer_text.value.length == 0) last = '0';
		else last = '${n.min(720).max(0)}';
		timer_text.value = last;
	}

	static function on_blur(e:FocusEvent) {
		trace('blur', e);
		timer_text.value = '$last:00';
	}

	static function play_btn_click(e) {
		TimerUtil.active ? pause() : start();
	}

	static function start() {
		var m = timer_text.value.split(':')[0];
		var s = timer_text.value.split(':')[1];
		var t = 0;
		if (m.parseInt() != null) t += m.parseInt() * 60;
		if (s.parseInt() != null) t += s.parseInt();
		TimerUtil.start(t, stop);
		play_btn.classList.add('active');
		window.localStorage.setItem('timer_active', 'true');
		Main.play_last();
	}

	public static function pause() {
		TimerUtil.pause();
		play_btn.classList.remove('active');
		window.localStorage.setItem('timer_active', 'false');
		Main.stop();
	}
	
	public static function stop() {
		TimerUtil.cancel();
		Main.stop();
		play_btn.classList.remove('active');
		window.localStorage.setItem('timer_active', 'false');
	}

}