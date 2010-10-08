package pt.wiz.dorothy.assets {
	import flash.events.HTTPStatusEvent;
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
	 
	 /**
	 * Dispatched when the asset is finished loading.
	 * 
	 * @eventType pt.wiz.dorothy.events.AssetEvent
	 */
	[Event(name="dorothy_assetComplete", type="pt.wiz.dorothy.events.AssetEvent")] 
	
	/**
	 * Dispatched while the asset is loading.
	 * 
	 * @eventType pt.wiz.dorothy.events.AssetEvent
	 */
	[Event(name="dorothy_assetProgress", type="pt.wiz.dorothy.events.AssetEvent")] 
	
	public class MediaAsset extends EventDispatcher implements IAsset {
		
		private var _status: String;
		private var _loader : Loader;
		private var _name : String;
		private var _id:String;
		
		private var _content:*;

		public function MediaAsset(name:String, id:String = "")
		{
			_id = id;
			_name = name;
			init();
		}

		private function init() : void {
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);			_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, loader_httpStatusHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loader_progressHandler);			_loader.contentLoaderInfo.addEventListener(Event.OPEN, loader_startHandler);
		}

		private function loader_httpStatusHandler(event:HTTPStatusEvent):void
		{
			trace(id, event.status);
			if (event.status == 200)
			{
				_status = "ok";
			}
		}

		protected function loader_startHandler(event : Event) : void 
		{
			_status = "loading";
		}

		protected function loader_progressHandler(event : ProgressEvent) : void 
		{
			dispatchEvent(new AssetEvent(AssetEvent.PROGRESS, event.bytesLoaded/event.bytesTotal));
		}

		protected function loader_errorHandler(event : IOErrorEvent) : void 
		{
			_status = "error";
			Out.debug(_name + " asset error: "+ event.text);
			dispatchEvent(new AssetEvent(AssetEvent.ERROR, 0, event.text));
		}

		protected function loader_completeHandler(event : Event) : void 
		{
			_status = "complete";
			// Cache content
			_content = _loader.content;
			dispatchEvent(new AssetEvent(AssetEvent.COMPLETE));
		}
		
		public function load():void
		{
			if (_status != "loading")
			{
				_loader.load(new URLRequest(_name));
			} else {
				Out.warn("Asset " + _name + " already loading");
			}
		}
		
		public function cancel():void
		{
			if (_status == "loading")
			{
				try {
					_loader.close();
				} catch (e:Error) {
					Out.error(e.message);
				}
				
				_status = "canceled";
			}
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

		public function get id() : String
		{
			return _id;
		}
	}
}
