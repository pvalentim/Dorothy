package pt.wiz.dorothy.util {

	import com.greensock.TweenMax;
	import flash.text.TextFieldAutoSize;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.display.Shape;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	/**
	 * @author wizdesign7
	 */
	public class BrowserStatusBar {
		
		private static var _bgColor:uint = 0xffffff;
		private static var _borderColor:uint = 0xdbdbdb;
		private static var _textColor:uint = 0x000000;
		private static var _textSize:uint = 10;
		
		private static var _status : String;
		private static var _instance:BrowserStatusBar;
				
		private var _root:DisplayObjectContainer;
		private var _textField : TextField;
		private var _textFormat:TextFormat;
		private var _container : Sprite;
		
		public function BrowserStatusBar()
		{
			
		}
		
		public static function init(root:DisplayObjectContainer):void
		{
			if (_instance == null)
				_instance = new BrowserStatusBar();
			
			_instance._root = root;
			_instance.buildUI();
		}
		
		private function buildUI():void {
			_container = new Sprite();
			
			var border:Shape = new Shape();
			border.graphics.beginFill(_borderColor);
			border.graphics.drawRoundRectComplex(0, 0, 401, 16, 0, 10, 0, 0);
			border.graphics.endFill();
			_container.addChild(border);
			
			var bg : Shape = new Shape();
			bg.graphics.beginFill(_bgColor);
			bg.graphics.drawRoundRectComplex(0, 0, 400, 15, 0, 10, 0, 0);
			bg.graphics.endFill();
			bg.y = 1;
			_container.addChild(bg);
			
			_textField = new TextField();
			_textField.x = 2;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			//_textField.embedFonts = true;
			_textField.embedFonts = false;
			_textField.selectable = false;
			
			_textFormat = new TextFormat();
			_textFormat.font = "Verdana";
			_textFormat.size = _textSize;
			_textFormat.color = _textColor;
			
			_container.addChild(_textField);

			_container.y = _root.stage.stageHeight - 16;
			_container.alpha = 0;
			_container.visible = false;
			
			_root.addChild(_container);
			_root.stage.addEventListener(Event.RESIZE, stage_onResize);
		}

		private function stage_onResize(event : Event) : void {
			_container.y = _root.stage.stageHeight - 16;
		}
		
		private function updateUI() : void {
			if (_status != "")
			{
				_textField.text = _status;
				_textField.setTextFormat(_textFormat);
				TweenMax.killTweensOf(_container);
				TweenMax.to(_container, .3, {autoAlpha:1});
			} else {
				TweenMax.to(_container, .3, {autoAlpha:0, delay:.5});
			}
			
		}
		
		public static function set status(status:String):void {
			_status = status;
			if (_instance != null) _instance.updateUI();
		}
		
		public static function get status():String
		{
			return _status;
		}

		static public function get bgColor() : uint {
			return _bgColor;
		}

		static public function set bgColor(bgColor : uint) : void {
			_bgColor = bgColor;
			if (_instance != null)
				_instance.updateUI();
		}

		static public function get textColor() : uint {
			return _textColor;
		}

		static public function set textColor(textColor : uint) : void {
			_textColor = textColor;
			if (_instance != null)
				_instance.updateUI();
		}

		static public function get textSize() : uint {
			return _textSize;
		}

		static public function set textSize(textSize : uint) : void {
			_textSize = textSize;
		}

		static public function get borderColor() : uint {
			return _borderColor;
		}

		static public function set borderColor(borderColor : uint) : void {
			_borderColor = borderColor;
		}
	}
}
