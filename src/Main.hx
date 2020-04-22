class Main {

	static var tracklist_div:DivElement;
	static var data:Array<AudioData>;
	static var active_audio:AudioElement;
	static var active_audio_div:DivElement;
	static var audio:Array<AudioElement> = [];
	static var audio_divs:Array<DivElement> = [];
	static var timer:Timer;
	
	static var gradients = [
		'linear-gradient(8deg, #1CB5E0 0%, #000851 100%)',
		'linear-gradient(8deg, #9ebd13 0%, #008552 100%)',
		'linear-gradient(8deg, #d53369 0%, #daae51 100%)',
		'linear-gradient(8deg, #0700b8 0%, #00ff88 100%)',
	];

	static function main(){}
	@:expose() static function init() {
		tracklist_div = cast document.getElementById('tracklist');
		'audio.json'.fetch(process_json);
		util.UpdateManager.update(0);
		util.Pomodoro.init(45);
	}

	static function process_json(audio_data:String) {
		data = audio_data.parse();
		var id = 0;
		for (a in data) tracklist_div.appendChild(get_sound(a.src, a.title, id++));
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
		a.play();
		e.classList.add('playing');
		active_audio = a;
		active_audio_div = e;
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