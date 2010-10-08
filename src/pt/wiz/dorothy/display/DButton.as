package pt.wiz.dorothy.display {
	import com.asual.swfaddress.SWFAddress;
	import pt.wiz.dorothy.util.BrowserStatusBar;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;

	/**
	 * @author Pedro Valentim
	 */
	public class DButton extends EventDispatcher {
		
		protected var _mc:MovieClip;
		private var _externalLink:String = "";
		private var _externalLinkTarget:String = "";
		private var _internalLink:String = "";
		
		public function DButton(mc:MovieClip) {
			_mc = mc;
			initButton();
		}

		private function initButton() : void {
			_mc.buttonMode = true;
			_mc.tabEnabled = false;

			setupButtonEvents();
		}

		private function setupButtonEvents() : void {
			_mc.addEventListener(MouseEvent.CLICK, clickHandler);			_mc.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);			_mc.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}

		private function external_rollOverHandler() : void
		{
			BrowserStatusBar.status = _externalLink;
		}

		private function external_rollOutHandler() : void
		{
			BrowserStatusBar.status = "";
		}

		private function external_clickHandler() : void
		{
			navigateToURL(new URLRequest(_externalLink), _externalLinkTarget);
		}
		
		private function internal_rollOverHandler() : void
		{
			
		}

		private function internal_rollOutHandler() : void
		{
			
		}

		private function internal_clickHandler() : void
		{
			// TODO: Change this to the centralized address manager.
			SWFAddress.setValue(_internalLink);
		}
		
		protected function rollOverHandler(event:MouseEvent):void
		{
			if (_externalLink != "")
			{
				external_rollOverHandler();
			} else if (_internalLink != "") {
				internal_rollOverHandler();
			}
		}
		
		protected function rollOutHandler(event:MouseEvent):void
		{
			if (_externalLink != "")
			{
				external_rollOutHandler();
			} else if (_internalLink != "") {
				internal_rollOutHandler();
			}
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			if (_externalLink != "")
			{
				external_clickHandler();
			} else if (_internalLink != "") {
				internal_clickHandler();
			}
		}
		
		public function setExternal(externalLink:String, target:String = "_blank"):void
		{
			_externalLink = externalLink;
			_externalLinkTarget = target;
		}
		
		public function setInternal(internalLink:String):void
		{
			_internalLink = internalLink;
		}

		public function get mc() : MovieClip {
			return _mc;
		}
	}
}
