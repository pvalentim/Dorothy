package pt.wiz.dorothy.core
{
	import pt.wiz.dorothy.events.PageEvent;
	import com.greensock.TweenMax;
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
		
		public var assets:Array = [];
		
		public function DPage() {
			alpha = 0;
		}
		
		public function transitionIn() : void
		{
			TweenMax.to(this, .5, {alpha:1});
		}
		
		public function transitionOut() : void
		{
			TweenMax.to(this, .5, {alpha:0, onComplete:transitionOutComplete});	
		}
		
		protected function transitionOutComplete():void
		{
			dispatchEvent(new PageEvent(PageEvent.TRANSITION_OUT_COMPLETE));
		}
		
		protected function transitionInComplete():void
		{
			dispatchEvent(new PageEvent(PageEvent.TRANSITION_IN_COMPLETE));
		}
	}
}
