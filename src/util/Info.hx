package util;

class Info {

	static var info_box:DivElement;
	static var close_btn:DivElement;

	public static function init() {
		info_box = cast document.getElementById('info');
		close_btn = cast document.getElementById('info-close');
		close_btn.onclick = hide;
	}

	public static function show() info_box.classList.remove('hidden');
	public static function hide() {
		info_box.classList.add('hidden');
		window.localStorage.setItem('info_state', 'hidden');
	}

}