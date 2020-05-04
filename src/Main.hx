import util.Pomodoro;
import util.Info;

class Main {

	public static var active_audio:AudioElement;
	static var tracklist_div:DivElement;
	static var data:Array<AudioData>;
	static var active_audio_div:DivElement;
	static var audio:Array<AudioElement> = [];
	static var audio_divs:Array<DivElement> = [];
	static var timer:Timer;
	static var last = 0;
	
	static var gradients = [
		'linear-gradient(8deg, #1CB5E0 0%, #000851 100%)',
		'linear-gradient(8deg, #9ebd13 0%, #008552 100%)',
		'linear-gradient(8deg, #d53369 0%, #daae51 100%)',
		'linear-gradient(8deg, #0700b8 0%, #00ff88 100%)',
	];

	static function main(){}
	@:expose() static function init(?config:String) {
		if (config != null) var config_object:ConfigObject = config.parse();
		if (window.localStorage.getItem('last') != null) last = window.localStorage.getItem('last').parseInt();
		tracklist_div = cast document.getElementById('tracklist');
		'audio.json'.fetch(process_json);
		util.UpdateManager.update(0);
		util.Info.init();
	}
	
	static function process_json(audio_data:String) {
		data = audio_data.parse();
		var id = 0;
		for (a in data) tracklist_div.appendChild(get_sound(a.src, a.title, id++));
		load();
	}
	
	static function load() {
		Pomodoro.init(45);
		
		var info_state = window.localStorage.getItem('info_state');
		var was_active = window.localStorage.getItem('active');
		
		if (info_state == null) Info.show();
		if (was_active == 'true') {
			play_last();
			Pomodoro.check_persistence();
		}
	}

	static function get_sound(src:String, title:String, id:Int) {
		var e = document.createDivElement();
		var a = get_audio_element(src);
		e.appendChild(a);
		e.classList.add('audio');
		e.innerText = title;
		e.onclick = () -> {
			if (!a.paused) stop();
			else {
				stop();
				play(a, e);
			}
			document.body.style.backgroundImage = 'url("images/bg${id % 4}.png")';
		}
		audio_divs.push(e);
		return e;
	}

	static function get_audio_element(src:String):AudioElement {
		var e = document.createAudioElement();
		e.src = src;
		e.loop = true;
		audio.push(e);
		return e;
	}

	static function play(a:AudioElement, e:DivElement) {
		a.currentTime = 0;
		e.classList.add('playing');
		active_audio = a;
		active_audio_div = e;
		a.onpause = () -> window.localStorage.setItem('active', 'false');
		window.localStorage.setItem('last', '${audio.indexOf(a)}');
		window.localStorage.setItem('active', 'true');
		a.play().catchError((e) -> {
			trace(e);
			window.parent.addEventListener('click', play_on_click);
		});
	}

	static function play_on_click() {
		active_audio.play();
		window.parent.removeEventListener('click', play_on_click);
	}

	public static function play_last() {
		stop();
		play(audio[last], audio_divs[last]);
	}

	public static function stop() {
		if (active_audio != null) active_audio.pause();
		if (active_audio_div != null) active_audio_div.classList.remove('playing');
		active_audio = null;
		active_audio_div = null;
	}

}

typedef AudioData = {
	src:String,
	title:String,
}

typedef ConfigObject = {
	?tracklist:Array<AudioData>,
	?pomo_default_time:Int,
}