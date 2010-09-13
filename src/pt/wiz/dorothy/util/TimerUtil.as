package pt.wiz.dorothy.util 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Pedro Valentim
	 */
	public class TimerUtil
	{
		
		public static function timeOut(miliseconds:uint, callback:Function):void
		{
			var t:Timer = new Timer(miliseconds, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
				callback();
			});
			t.start();
		}
	}
}
