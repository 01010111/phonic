package util;

import js.html.InputEvent;
import js.html.FocusEvent;
import js.html.InputElement;

class Pomodoro {

	public static var timer_text:InputElement;
	static var last:String;

	public static function init(v:Int) {
		timer_text = cast document.getElementById('timer');
		timer_text.onfocus = (e) -> on_focus(e);
		timer_text.onblur = (e) -> on_blur(e);
		timer_text.addEventListener('input', (e) -> on_input(e));
		last = '$v';
	}

	static function on_focus(e:FocusEvent) {
		trace('focus', e);
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
		else last = '$n';
		timer_text.value = last;
	}

	static function on_blur(e:FocusEvent) {
		trace('blur', e);
		timer_text.value = '$last:00';
		start();
	}

	static function start() {
		var t = timer_text.value.parseInt();
		TimerUtil.start(t * 60, stop);
	}

	public static function stop() {
		Main.stop();
	}

}