package pt.wiz.dorothy.events 
{
	import flash.events.Event;

	/**
	 * @author Pedro Valentim
	 */
	public class DEvent extends Event 
	{
		
		public static const APPLICATION_READY:String = "dorothy_appReady";
		public static const CHANGED_PAGE:String = "dorothy_changedPage";
		
		public var page:String;
		
		public function DEvent(type : String, page:String="", bubbles : Boolean = false, cancelable : Boolean = false)
		{
			this.page = page;
			super(type, bubbles, cancelable);
		}
			
		override public function clone() : Event
		{
			return new DEvent(type, page, bubbles, cancelable);
		}
	}
}
