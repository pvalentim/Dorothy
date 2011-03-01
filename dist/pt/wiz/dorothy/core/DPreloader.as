package pt.wiz.dorothy.core
{
	import flash.filters.BlurFilter;
	import com.greensock.TweenMax;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.filters.DropShadowFilter;
	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author Pedro Valentim
	 */
	public class DPreloader extends Sprite implements IPreloader
	{
		
		private var _progressBar:Shape;
		private var _progressShadow:Shape;
		private var _bg:Sprite;
		private var _info:TextField;
		
		public function DPreloader()
		{
			if (stage)
				initPreloader(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, initPreloader);
		}

		private function initPreloader(event:Event) : void
		{
			drawPreloader();
			stage.addEventListener(Event.RESIZE, stage_onResize);
			stage_onResize(null);
		}

		private function drawPreloader() : void
		{
			this.alpha = 0;
			this.visible = false;
			drawBG();
			drawInfo();
			drawProgress();
		}

		private function drawProgress() : void
		{
			// BG
			var progressBG:Shape = new Shape();
			progressBG.graphics.beginFill(0xe4e4e4);
			progressBG.graphics.lineStyle(1, 0x000000, .16);
			progressBG.graphics.drawRect(0, 0, 324, 33);
			progressBG.graphics.endFill();
			progressBG.x = 12;
			progressBG.y = 30;
			addChild(progressBG);
			// BAR
			_progressBar = new Shape();
			var m:Matrix = new Matrix();
			m.createGradientBox(324, 32, Math.PI / 2);
			_progressBar.graphics.beginGradientFill(GradientType.LINEAR, [0xe3e3e3, 0xc7c7c7], [1, 1], [0,255], m);
			_progressBar.graphics.drawRect(0, 0, 324, 32);
			_progressBar.graphics.endFill();
			_progressBar.x = 13;
			_progressBar.y = 31;
			
			// SHADOW
			_progressShadow = new Shape();
			_progressShadow.graphics.beginFill(0x000000);
			_progressShadow.graphics.drawRect(0, 0, 3, 29);
			_progressShadow.x = 13;
			_progressShadow.y = 33;
			_progressShadow.alpha = .5;
			var blur:BlurFilter = new BlurFilter(3, 3, 3);
			_progressShadow.filters = [blur];
			// ADD CHILDs
			addChild(_progressShadow);			addChild(_progressBar);
		}

		private function drawInfo() : void
		{
			_info = new TextField();
			_info.antiAliasType = AntiAliasType.ADVANCED;
			_info.autoSize = TextFieldAutoSize.LEFT;
			_info.x = 10;
			_info.y = 6;
			_info.selectable = false;
			var f:TextFormat = new TextFormat();
			f.font = "Lucida Grande";
			f.size = 12;
			f.color = 0x585858;
			_info.defaultTextFormat = f;
			_info.text = "Loading - 0%";
			addChild(_info);
		}

		private function drawBG() : void
		{
			_bg = new Sprite;
			_bg.graphics.beginFill(0xffffff);
			_bg.graphics.drawRect(0, 0, 350, 75);
			_bg.graphics.endFill();
			var shadow:DropShadowFilter = new DropShadowFilter(0, 45, 0x000000, .4, 21, 21, 1, 3);
			_bg.filters = [shadow];
			addChild(_bg);
		}

		private function stage_onResize(event:Event) : void
		{
			this.x = Math.round(stage.stageWidth * .5 - this.width * .5);
			this.y = Math.round(stage.stageHeight * .5 - this.height * .5);
		}

		public function update(percentage:Number) : void
		{
			var p:Number = percentage * 323;
			_info.text = "Loading - "+ Math.round(percentage*100) +"%";
			_progressBar.width = Math.round(p);
			_progressShadow.x = _progressBar.width + 10;
		}

		public function transitionIn() : void
		{
			TweenMax.to(this, .3, {autoAlpha:1});
		}

		public function transitionOut() : void
		{
			TweenMax.to(this, .3, {autoAlpha:0});
		}
	}
}
