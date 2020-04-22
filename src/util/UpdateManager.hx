package util;

import js.Browser;
import zero.utilities.Timer;

class UpdateManager {

    static var last = 0.0;

    public static function update(?_) {
        var dt = get_dt(get_time());
        Timer.update(dt);
        'update'.dispatch(dt);
        Browser.window.requestAnimationFrame(update);
    }

    static function get_time():Float {
        return Date.now().getTime();
    }

    static function get_dt(time:Float):Float {
        var out = (time - last) / 1000;
        last = time;
        return out;
    }

}