package pt.wiz.dorothy.display {
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
		private var _externalLink:String;
		private var _externalLinkTarget:String;
		
		public function DButton(mc:MovieClip, externalLink:String = "", target:String = "_blank") {
			_mc = mc;
			_externalLink = externalLink;
			_externalLinkTarget = target;
			initButton();
		}

		private function initButton() : void {
			_mc.buttonMode = true;
			_mc.tabEnabled = false;

			if (_externalLink != "")
				setupExternalButton();
		}

		private function setupExternalButton() : void {
			_mc.addEventListener(MouseEvent.CLICK, mc_external_clickHandler);			_mc.addEventListener(MouseEvent.ROLL_OVER, mc_external_rollOverHandler);			_mc.addEventListener(MouseEvent.ROLL_OUT, mc_external_rollOutHandler);
		}

		protected function mc_external_rollOverHandler(event : MouseEvent) : void {
			BrowserStatusBar.status = _externalLink;
		}

		protected function mc_external_rollOutHandler(event : MouseEvent) : void {
			BrowserStatusBar.status = "";
		}

		protected function mc_external_clickHandler(event : MouseEvent) : void {
			navigateToURL(new URLRequest(_externalLink), _externalLinkTarget);
		}

		public function get mc() : MovieClip {
			return _mc;
		}
	}
}
