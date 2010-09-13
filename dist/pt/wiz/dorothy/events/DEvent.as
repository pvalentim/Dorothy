package pt.wiz.dorothy.events 
{
	import flash.events.Event;

	/**
	 * @author Pedro Valentim
	 */
	public class DEvent extends Event 
	{
		
		public static const APPLICATION_READY:String = "dorothy_appReady";
		
		public function DEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
			
		override public function clone() : Event
		{
			return new DEvent(type, bubbles, cancelable);
		}
	}
}
