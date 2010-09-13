package pt.wiz.dorothy.assets {
	import pt.wiz.dorothy.debug.Out;
	import flash.net.URLRequest;
	import pt.wiz.dorothy.events.AssetEvent;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.display.Loader;

	/**
	 * @author Pedro Valentim
	 */
	public class Asset extends EventDispatcher {
		
		private var _status: String;
		private var _loader : Loader;
		private var _name : String;
		
		private var _content:*;

		public function Asset(name:String)
		{
			_name = name;
			init();
		}

		private function init() : void {
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loader_progressHandler);			_loader.contentLoaderInfo.addEventListener(Event.OPEN, loader_startHandler);
		}

		private function loader_startHandler(event : Event) : void 
		{
			_status = "loading";
		}

		private function loader_progressHandler(event : ProgressEvent) : void 
		{
			dispatchEvent(new AssetEvent(AssetEvent.PROGRESS, event.bytesLoaded/event.bytesTotal));
		}

		private function loader_errorHandler(event : IOErrorEvent) : void 
		{
			_status = "error";
			Out.debug(_name + " asset error: "+ event.text);
			dispatchEvent(new AssetEvent(AssetEvent.ERROR, 0, event.text));
		}

		private function loader_completeHandler(event : Event) : void 
		{
			_status = "complete";
			// Cache content
			_content = _loader.content;
			dispatchEvent(new AssetEvent(AssetEvent.COMPLETE));
		}
		
		public function load():void
		{
			_loader.load(new URLRequest(_name));
		}
		
		public function get name() : String
		{
			return _name;
		}
		
		public function get loader() : Loader
		{
			return _loader;
		}
		
		public function get content() : *
		{
			return _content;
		}
	}
}
