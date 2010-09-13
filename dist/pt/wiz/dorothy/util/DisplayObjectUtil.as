package pt.wiz.dorothy.util 
{
	import flash.display.DisplayObjectContainer;

	/**
	 * @author Pedro Valentim
	 */
	public class DisplayObjectUtil 
	{
		public static function empty(object:DisplayObjectContainer):void
		{
			while (object.numChildren)
				object.removeChildAt(0);
		}
	}
}
