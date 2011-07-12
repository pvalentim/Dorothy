package pt.wiz.dorothy.layout
{
	import flash.geom.Point;
	import flash.display.DisplayObject;
	/**
	 * @author Pedro Valentim
	 */
	public class LayoutObject
	{
		public var obj:DisplayObject;
		public var pinPoint:Point;
		public var offsetX:Number;
		public var offsetY:Number;
		public var halfWidth:Number;
		// Cached half width of object for better perfomance when calculating the center.
		public var halfHeight:Number;
		// Cached half height of object for better perfomance when calculating the center.
		public var pinToCenter:Boolean;

		public function LayoutObject(obj:DisplayObject, pinPoint:Point, offsetX:Number, offsetY:Number, pinToCenter:Boolean)
		{
			this.pinToCenter = pinToCenter;
			this.offsetY = offsetY;
			this.offsetX = offsetX;
			this.pinPoint = pinPoint;
			this.obj = obj;
			init();
		}

		private function init():void
		{
			halfWidth = obj.width * .5;
			halfHeight = obj.height * .5;
			if (pinToCenter)
			{
				offsetX = Math.abs(offsetX) - halfWidth;
				offsetY = Math.abs(offsetY) - halfHeight;
			}
//			trace(obj.y, pinPoint.y, "y");
//			trace(obj.x, pinPoint.x, "x");
//			trace(offsetY, obj.name, "offsetY");
//			trace(offsetX, obj.name, "offsetX");
		}

	}
}
