package pt.wiz.dorothy.layout
{
	import flash.events.Event;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	/**
	 * @author Pedro Valentim
	 */
	public class DLiquidLayout
	{
		
		public var TOP_LEFT:Point;
		public var TOP_CENTER:Point;
		public var TOP_RIGHT:Point;
		public var BOTTOM_LEFT:Point;
		public var BOTTOM_CENTER:Point;
		public var BOTTOM_RIGHT:Point;
		public var CENTER_LEFT:Point;
		public var CENTER_CENTER:Point;
		public var CENTER_RIGHT:Point;
		
		private var objects:Array;
		private var stage:Stage;
		private var stageHalfWidth:Number; // Cached half width of stage for better performance.
		private var stageHalfHeight:Number; // Cached half height of stage for better performance.
		private var startWidth:Number;
		private var startHeight:Number;
		private var _roundProps:Boolean;

		// Cached half height of stage for better performance.
		
		public function DLiquidLayout(stage:Stage, startWidth:Number, startHeight:Number)
		{
			this.startHeight = startHeight;
			this.startWidth = startWidth;
			this.stage = stage;
			init();
		}

		private function init():void
		{
			initPinPoints();
			objects = [];
			//stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		}
		private function initPinPoints() : void
		{
			TOP_LEFT = new Point();
			TOP_CENTER = new Point();
			TOP_RIGHT = new Point();
			BOTTOM_LEFT = new Point();
			BOTTOM_CENTER = new Point();
			BOTTOM_RIGHT = new Point();
			CENTER_LEFT = new Point();
			CENTER_CENTER = new Point();
			CENTER_RIGHT = new Point();
			updatePinPoints();
		}

		private function updatePinPoints(start:Boolean = false):void
		{
			if (!start)
			{
				stageHalfHeight = stage.stageHeight * .5;
				stageHalfWidth = stage.stageWidth * .5;
				CENTER_LEFT.y = CENTER_CENTER.y = CENTER_RIGHT.y = stageHalfHeight;
				CENTER_CENTER.x = BOTTOM_CENTER.x = TOP_CENTER.x = stageHalfWidth;
				CENTER_RIGHT.x = BOTTOM_RIGHT.x = TOP_RIGHT.x = stage.stageWidth;
				BOTTOM_LEFT.y = BOTTOM_CENTER.y = BOTTOM_RIGHT.y = stage.stageHeight;
			} else {
				stageHalfHeight = startHeight * .5;
				stageHalfWidth = startWidth * .5;
				CENTER_LEFT.y = CENTER_CENTER.y = CENTER_RIGHT.y = stageHalfHeight;
				CENTER_CENTER.x = BOTTOM_CENTER.x = TOP_CENTER.x = stageHalfWidth;
				CENTER_RIGHT.x = BOTTOM_RIGHT.x = TOP_RIGHT.x = startWidth;
				BOTTOM_LEFT.y = BOTTOM_CENTER.y = BOTTOM_RIGHT.y = startHeight;
			}
		}

		private function stage_resizeHandler(event:Event):void
		{
			update();
		}

		public function update():void
		{
			updatePinPoints();
			for each (var obj : LayoutObject in objects) {
				updateObject(obj);
			}
		}

		private function updateObject(layoutObject:LayoutObject):void
		{
			var x:Number = layoutObject.pinPoint.x + layoutObject.offsetX;
			var y:Number = layoutObject.pinPoint.y + layoutObject.offsetY;
			
			if (_roundProps){
				x = Math.round(x);
				y = Math.round(y);
			}
	
			layoutObject.obj.x = x;
			layoutObject.obj.y = y;
		}
		
		public function pinObject(obj:DisplayObject, pinPoint:Point, pinToCenter:Boolean=false, useCurrentOffset:Boolean = true, offsetX:Number = 0, offsetY:Number = 0):void
		{
			if (useCurrentOffset)
			{
				updatePinPoints(true);
				offsetY = obj.y - pinPoint.y;
				offsetX = obj.x - pinPoint.x;
			}
			objects.push(new LayoutObject(obj, pinPoint, offsetX, offsetY, pinToCenter));
		}

		public function get roundProps():Boolean
		{
			return _roundProps;
		}

		public function set roundProps(roundProps:Boolean):void
		{
			_roundProps = roundProps;
		}
	}
}
