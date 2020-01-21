package {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.setTimeout;
	import flash.utils.setInterval;
	import flash.geom.Point;
	import flash.display.StageScaleMode;
	import flash.utils.getDefinitionByName;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TransformGestureEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.SharedObject;


	public class main extends MovieClip {

		private var bg: MovieClip;
		private var mainbg: MovieClip;
		private var hero: MovieClip;
		private var fire: MovieClip;
		private var reload: MovieClip;
		private var reloadImg: MovieClip;
		private var gameover: MovieClip;
		private var instraction: MovieClip;
		private var fireStore: Array = new Array();
		var ff: Array = new Array;
		var speed: Number = 25;
		var angle: Number;
		private var vector: Point;
		var snd: Sound;
		var myS: SoundChannel;
		var timer: Timer;
		var insects: Array = new Array();
		var fireSize: int;
		var score: int;
		var CoinScore: int;
		var HighestCoinScore: int;
		var HighestScore: int;
		private var SO:SharedObject;
		private var gw: NetConnection;
		private var get_responder: Responder;
		private var get_responderInsert: Responder;
		private static var gateway_url: String = "https://konokmahamud21.000webhostapp.com/Amfphp/";

		public function main() {
			trace("Bismillah");
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			Multitouch.inputMode = MultitouchInputMode.GESTURE;

			gw = new NetConnection();
			gw.connect(gateway_url);
				get_responder = new Responder(get_responder_success, get_responder_failed);
					gw.call('FiringService.getUser', get_responder);
			

			SO= SharedObject.getLocal('fireGun');
			if(SO.data['HighestCoinScore']!=undefined){
				HighestCoinScore=SO.data['HighestCoinScore'];
				}else{
					HighestCoinScore=0;
				}
			 
			bg = new Bg();
			this.addChild(bg);
			bg.visible = false;
			mainbg = new MainBG();
			this.addChild(mainbg);
			mainbg.plyBtn.addEventListener(MouseEvent.CLICK, startgame);

			gameover = new GameOver();
			this.addChild(gameover);
			gameover.visible = false;
			gameover.gameOverOk.addEventListener(MouseEvent.CLICK, playAgain);
			gameover.mainmanu.addEventListener(MouseEvent.CLICK, mainmenu);

			instraction = new Instractionpage();
			this.addChild(instraction);
			instraction.visible = false;
			mainbg.instructBtn.addEventListener(MouseEvent.CLICK, instruction);
			instraction.InsOk.addEventListener(MouseEvent.CLICK, function () {
				instraction.visible = false;
			});
			timer = new Timer(700);
			timer.addEventListener(TimerEvent.TIMER, createFruit);


		}

		private function get_responder_success(res:Object): void {
			HighestScore=res[0][1];
			trace(res[0][1]);
			
		}
		private function get_responder_success_for_insert(res:Object): void {
			trace(res );
			
		}
		private function get_responder_failed(err: Object): void {
			trace(err);
		}
		private function startgame(e: MouseEvent): void {
			mainbg.visible = false;
			gameover.visible = false;
			bg.visible = true;
			trace("d");
			score = 0;
			//CoinScore=0;
			fireSize = 20;
			bg.scoretxt.text = score;
			bg.remainTxt.text = fireSize;

			timer.start();
			CreateHero();
			reloadImg = new ReloadIMG();
			bg.addChild(reloadImg);
			reloadImg.x = stage.width / 2 - 100;
			reloadImg.y = stage.height / 2;
			reloadImg.visible = false;

			reload.addEventListener(MouseEvent.CLICK, reloadFire);
			hero.addEventListener(TransformGestureEvent.GESTURE_SWIPE, swapHero);

			stage.addEventListener(Event.ENTER_FRAME, efh2);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, fireFunction);
			stage.addEventListener(MouseEvent.MOUSE_UP, RemovefireFunction);


		}
		private function instruction(e: MouseEvent): void {
			instraction.visible = true;

		}
		private function CreateHero(): void {
			if (!hero) {

				hero = new Hero();
				bg.addChild(hero);
				hero.x = stage.width / 2 + 200;
				hero.y = (stage.height - hero.height);

				fire = new Fire();

				reload = new Reload();
				bg.addChild(reload);
				reload.x = 20;
				reload.y = 560;
			}

		}
		private function swapHero(e: TransformGestureEvent): void {
			//trace(e);
			if (e.offsetX == 1) {
				trace("right");
				hero.x += hero.width;
			}
			if (e.offsetX == -1) {
				hero.x -= hero.width;
			}
		}

		private function reloadFire(e: MouseEvent): void {
			reloadImg.visible = false;
			var cls: Class = getDefinitionByName("Loadgun") as Class;
				snd = new cls();
				myS=snd.play(1000);
			fireSize = 20;
			bg.remainTxt.text = fireSize;
		}

		private function createFruit(e: TimerEvent): void {
			var ins: MovieClip;
			var ranvalue: Number = Math.random();
			//trace("ran: "+ranvalue);
			if (ranvalue <= .30) {
				ins = new Banana();
				ins.speedY = 8;
				ins.Score = 1;
				ins.dead = 0;
			} else if (ranvalue > .30 && ranvalue < .70) {
				ins = new Apple();
				ins.speedY = 5;
				ins.Score = 1;
				ins.dead = 0;
			} else {
				ins = new RedApple();
				ins.speedY = 7;
				ins.Score = -2;
				ins.dead = 1;
			}
			bg.addChild(ins);
			ins.x = Math.random() * 1120;
			ins.y = 0 - ins.height;
			insects.push(ins);



		}
		private function fireFunction(e: MouseEvent): void {

			addEventListener(Event.ENTER_FRAME, check);
			if (fireSize <= 0) {
				reloadImg.visible = true;
			}

		}

		private function check(e: Event): void {
			

			setTimeout(function () {
				if (mouseY < 500) {
					if (fireSize > 0) {
						var cls: Class = getDefinitionByName("GUN") as Class;
						snd = new cls();
						myS=snd.play(1000);
						
						fire = new Fire();
						bg.addChild(fire);
						fire.x = hero.x - 50;
						fire.y = (hero.y - 100);
						angle = Math.atan2(mouseY - hero.y, mouseX - hero.x);
						var vector1: Point = new Point(Math.cos(angle) * speed, Math.sin(angle) * speed);
					 
						var vct: Array = [];
						vct.push(vector1);
						var fr: Array = [];
						fireStore.push(fire);
						fr.push(fire);
						//var degrees: Number = angle * (145 / Math.PI);
						//hero.rotation = degrees;

						addEventListener(Event.ENTER_FRAME, function (e: Event): void {
							efh(e, fr, vct)
						});
						
						trace("fireLength: " + fireStore.length);
						removeFire();
						fireSize--;
						bg.remainTxt.text = fireSize;
					} else {
						trace("konk");

					}
				}

			}, 1);

		}

		private function efh(e: Event, ff: Array, vct: Array): void {
			for (var i: int = 0; i < ff.length; i++) {
				ff[i].y += vct[i].y;
				ff[i].x += vct[i].x;
			}
		}
		
		
		private function RemovefireFunction(e: MouseEvent): void {
			removeEventListener(Event.ENTER_FRAME, check);
			if (fireSize <= 0) {
				reloadImg.visible = false;
			}
		}



		private function efh2(e: Event): void {
				
			for (var i: int = 0; i < insects.length; i++) {
				var ins: MovieClip = insects[i] as MovieClip;
				ins.y += ins.speedY;
				if (fire.hitTestObject(ins)) {
					bg.removeChild(ins);
					score += ins.Score;
					if (score > 0 && score % 50 == 0) {
						HighestCoinScore+=5
						bg.coinTxt.text=HighestCoinScore;
					}
					trace(score);
					bg.scoretxt.text = score;
				
					insects.removeAt(i);

				}
				if (ins.dead == 1) {

					if ((hero.hitTestObject(ins))) {

						gameover.visible = true;
						if (score < 0) {
							score = 0;
						}
						if(HighestScore<score){
							get_responderInsert = new Responder(get_responder_success_for_insert, get_responder_failed);
							gw.call('FiringService.insertscore', get_responderInsert,score);
							HighestScore=score;
							}
					
						gameover.gameoverScore.text = score;
						gameover.gameoverHighScore.text = HighestScore;
						bg.visible = false;
						timer.stop();
						score = 0;
						removeEventListener(Event.ENTER_FRAME, efh);
						removeEventListener(Event.ENTER_FRAME, check);
						reload.removeEventListener(MouseEvent.CLICK, reloadFire);
						hero.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, swapHero);
						stage.removeEventListener(Event.ENTER_FRAME, efh2);
						stage.removeEventListener(MouseEvent.MOUSE_DOWN, fireFunction);
						stage.removeEventListener(MouseEvent.MOUSE_UP, RemovefireFunction);
					}
				}

				if (score < 0) {

					gameover.visible = true;
					if (score < 0) {
						score = 0;
					}
						if(HighestScore<score){
							get_responderInsert = new Responder(get_responder_success_for_insert, get_responder_failed);
							gw.call('FiringService.insertscore', get_responderInsert,score);
							HighestScore=score;
							}
					gameover.gameoverHighScore.text = HighestScore;
					gameover.gameoverScore.text = score;
					bg.visible = false;
					timer.stop();
					score = 0;
					removeEventListener(Event.ENTER_FRAME, efh);
					removeEventListener(Event.ENTER_FRAME, check);
					reload.removeEventListener(MouseEvent.CLICK, reloadFire);
					hero.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, swapHero);
					stage.removeEventListener(Event.ENTER_FRAME, efh2);
					stage.removeEventListener(MouseEvent.MOUSE_DOWN, fireFunction);
					stage.removeEventListener(MouseEvent.MOUSE_UP, RemovefireFunction);
				}
			}
		}

		private function playAgain(e: MouseEvent): void {


			gameover.visible = false;
			for (var i: int = 0; i < insects.length; i++) {
				bg.removeChild(insects[i]);
				insects.splice(i, 1);
				i--;
				trace(insects.length + " " + i);
			}
			for (var j: int = 0; j < fireStore.length; j++) {
				bg.removeChild(fireStore[j]);
				fireStore.splice(j, 1);
				j--;
				trace(fireStore.length + " " + j);
			}


			trace("check");
			startgame(e);
		}
		private function mainmenu(e: MouseEvent): void {
			for (var i: int = 0; i < insects.length; i++) {
				bg.removeChild(insects[i]);
				insects.splice(i, 1);
				i--;
				trace(insects.length + " " + i);
			}
			for (var j: int = 0; j < fireStore.length; j++) {
				bg.removeChild(fireStore[j]);
				fireStore.splice(j, 1);
				j--;
				trace(fireStore.length + " " + j);
			}
			gameover.visible = false;
			mainbg.visible = true;

		}
		
		private function removeFire(): void {
			for (var i: int = 0; i < fireStore.length; i++) {
				if (fireStore[i].y < 0) {
					bg.removeChild(fireStore[i]);
					fireStore.removeAt(i);
					trace("kkk: " + fireStore.length);
				}
				if (fireStore[i].x < 0 || fireStore[i].x > 1136) {
					bg.removeChild(fireStore[i]);
					fireStore.removeAt(i);
					trace("k111: " + fireStore.length);
				}
			}
		}

	
	}

}