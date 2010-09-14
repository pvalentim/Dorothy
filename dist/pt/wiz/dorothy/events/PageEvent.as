package pt.wiz.dorothy.events
{
	import flash.events.Event;

	/**
	 * @author Pedro Valentim
	 */
	public class PageEvent extends Event
	{
		public static const LOAD_COMPLETE:String = "dpage_loadComplete";		public static const LOAD_PROGRESS:String = "dpage_loadProgress";
		public static const TRANSITION_OUT_COMPLETE:String = "dpage_transitionOutComplete";
		public static const TRANSITION_IN_COMPLETE:String = "dpage_transitionInComplete";
		
		public var progressInfo:Object;
		
		public function PageEvent(type:String, progressInfo:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.progressInfo = progressInfo;
			super(type, bubbles, cancelable);
		}
			
		override public function clone() : Event
		{
			return new PageEvent(type, progressInfo, bubbles, cancelable);
		}
	}
}
