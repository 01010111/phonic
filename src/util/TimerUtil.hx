package util;

class TimerUtil {

    static var timer:Timer;

    public static var active(get, never):Bool;
    static function get_active() return timer != null && timer.active && !timer.paused;
    
    public static function start(time:Int, fn:Void -> Void) {
        update.unlisten('update');
        timer = Timer.get(time, () -> fn());
        update.listen('update');
    }

    public static function pause() if (timer != null) timer.pause();
    public static function resume() if (timer != null) timer.unpause();
    public static function cancel() if (timer != null) timer.cancel();

    static var last:Int;
    static function update(?dt:Float) {
        if (timer == null || !timer.active) return;
        Pomodoro.timer_text.value = parse_remaining();
        if (last != timer.get_remaining().round()) window.localStorage.setItem('timer_amt', Pomodoro.timer_text.value);
        last = timer.get_remaining().round();
    }

    public static function parse_remaining() {
		if (timer == null) return '';
		var t = timer.get_remaining().round();
		var min = (t/60).floor();
		var sec = t % 60;
		var m = min < 10 ? '0$min' : '$min';
		var s = sec < 10 ? '0$sec' : '$sec';
		return '$m:$s';
	}

}