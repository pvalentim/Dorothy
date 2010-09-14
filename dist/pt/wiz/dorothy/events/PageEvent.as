package pt.wiz.dorothy.events
{
	import flash.events.Event;

	/**
	 * @author Pedro Valentim
	 */
	public class PageEvent extends Event
	{
		
		public static const TRANSITION_OUT_COMPLETE:String = "dpage_transitionOutComplete";
		public static const TRANSITION_IN_COMPLETE:String = "dpage_transitionInComplete";
		
		public function PageEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
