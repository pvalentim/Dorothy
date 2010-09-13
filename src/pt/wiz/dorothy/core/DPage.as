package pt.wiz.dorothy.core {
	import flash.display.MovieClip;

	/**
	 * @author Pedro Valentim
	 */
	 
	/**
	 * Dispatched when page is finished the transition out animation.
	 *
	 * @eventType pt.wiz.dorothy.events.PageEvent
	 */
	[Event(name="dpage_transitionOutComplete", type="pt.wiz.dorothy.events.PageEvent")] 
	
	/**
	 * Dispatched when page is finished the transition in animation.
	 *
	 * @eventType pt.wiz.dorothy.events.PageEvent
	 */
	[Event(name="dpage_transitionInComplete", type="pt.wiz.dorothy.events.PageEvent")]
	 
	public class DPage extends MovieClip {
		
		public function DPage() {
			
		}
		
		public function transitionIn() : void
		{
			
		}
		
		public function transitionOut() : void
		{
			
		}
		
		protected function transionOutComplete():void
		{
			
		}
		
		protected function transionInComplete():void
		{
			
		}
	}
}
