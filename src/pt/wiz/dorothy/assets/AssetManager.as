package pt.wiz.dorothy.assets 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.Event;
	import pt.wiz.dorothy.events.AssetEvent;
	import pt.wiz.dorothy.debug.Out;
	import pt.wiz.dorothy.assets.DAssets;
	import flash.events.EventDispatcher;

	/**
	 * @author Pedro Valentim
	 */
	 
	/**
	 * Dispatched when all assets finished loading.
	 * 
	 * @eventType pt.wiz.dorothy.events.AssetEvent
	 */
	[Event(name="dorothy_assetComplete", type="pt.wiz.dorothy.events.AssetEvent")] 
	
	/**
	 * Dispatched while the assets are loading.
	 * 
	 * @eventType pt.wiz.dorothy.events.AssetEvent
	 */
	[Event(name="dorothy_assetProgressAll", type="pt.wiz.dorothy.events.AssetEvent")] 
	
	public class AssetManager extends EventDispatcher {
		
		private var assets:Array;
		private var completed_assets:Array;
		private var queue:Array;
		
		private var _name:String;
		private var _loading:Boolean;
		private var _loadingMode:String;
		private var _maxConnections:uint = 5;
		private var _estimatedSize:Number;
		private var _totalLoaded:Number;
		private var _totalAssets:uint;
		private var _progressTimer:Timer;
		
		private var _isCanceled:Boolean = false;
		
		public static const SEQUENTIAL:String = "sequencial";
		public static const PARALLEL:String = "parallel";
		
		public function AssetManager(name:String = "")
		{
			if (name == "")
			{
				_name = "am_"+new Date().time.toString();
			} else {
				_name = name;
			}
			init();
		}

		private function init() : void 
		{
			DAssets.addLoader(this);
			assets = [];
			completed_assets = [];
			_totalAssets = 0;
			_estimatedSize = 30000;
			_loadingMode = AssetManager.PARALLEL;
		}

		public function add(name:String, type:String="auto", id:String = ""):void
		{
			if (!_loading)
			{
				if (assetByName(name) == null)
				{
					type = (type == "auto") ? name.substring(name.lastIndexOf(".")+1, name.length) : type;
					assets.push(getAssetType(name, type, id));
					Out.debug("Dorothy Assets - Added new asset "+name);
				} else {
					Out.debug("Dorothy Assets - Asset "+ name +" already in list. Use get(\""+name+"\") or getContent(\""+name+"\")");
				}
			} else {
				Out.debug("Dorothy Assets - Loader " + _name + " already started.");
			}
		}

		private function getAssetType(name:String, type:String, id:String = "") : IAsset
		{
			switch(type){
				case "auto":
					// TODO: Determine the type of asset.
					break;
				case "swf":
				case "jpg":
				case "gif":
				case "png":
					return new MediaAsset(name, id);
					break;
				case "page":
					return new PageAsset(name, id);
					break;
			}
			return null;
		}
		
		public function start():void
		{
			_loading = true;
			queue = [];
			_totalLoaded = 0;
			_totalAssets = assets.length;
			if (_loadingMode == AssetManager.SEQUENTIAL)
			{
				_maxConnections = 1;
				queue.push(assets.shift() as IAsset);
				setupAsset(IAsset(queue[0]));
			} else {
				for (var i : int = 0;i < _maxConnections;i++)
				{
					if (assets[i] != null)
					{
						var asset:IAsset = assets.shift();
						queue.push(asset);
						setupAsset(asset);
					}
				}
			}
			startProgress();
		}

		private function startProgress():void
		{
			_progressTimer = new Timer(1000 / 30);
			_progressTimer.addEventListener(TimerEvent.TIMER, dispatchProgress);
			_progressTimer.start();
		}
		
		private function dispatchProgress(event:TimerEvent):void
		{
			var tp:Number = 0;
			for each (var asset : IAsset in queue) {
				tp += asset.percentageLoaded;
			}
			for each (var asset2 : IAsset in completed_assets) {
				tp += asset2.percentageLoaded;
			}
			var pl:Number = tp / _totalAssets;
			dispatchEvent(new AssetEvent(AssetEvent.PROGRESS_ALL, Number(pl)));
		}

		private function asset_errorHandler(event : AssetEvent) : void 
		{
			queue.splice(queue.indexOf(event.target), 1);
			if (queue.length < _maxConnections)
			{
				for (var i : int = 0;i < _maxConnections-queue.length;i++)
				{
					if (assets[i] != null)
					{
						var asset:IAsset = assets.shift();
						queue.push(asset);
						setupAsset(asset);
					}
				}
			}
		}

		private function asset_completeHandler(event : AssetEvent) : void 
		{
			if (!_isCanceled)
			{
				completed_assets.push(queue.splice(queue.indexOf(event.target), 1)[0]);
				if (queue.length < _maxConnections)
				{
					for (var i : int = 0;i < _maxConnections-queue.length;i++)
					{
						if (assets[i] != null)
						{
							var asset:IAsset = assets.shift();
							queue.push(asset);
							setupAsset(asset);
						}
					}
				}
				if (queue.length == 0)
				{
					queue = [];
					assets = [];
					_loading = false;
					dispatchEvent(new AssetEvent(AssetEvent.COMPLETE));
					_progressTimer.stop();
				}
			}
		}

		private function setupAsset(asset:IAsset):void
		{
			asset.addEventListener(AssetEvent.COMPLETE, asset_completeHandler);
			asset.addEventListener(AssetEvent.PROGRESS, asset_progressHandler);
			asset.addEventListener(AssetEvent.ERROR, asset_errorHandler);
			asset.load();
		}

		private function asset_progressHandler(event:AssetEvent):void
		{
			if (!_estimatedSize)
			{
				_estimatedSize = event.bytesTotal * _totalAssets;
			}
		}

		public function get(name:String):IAsset
		{
			return assetByName(name);
		}
		
		public function getAt(id:uint):IAsset
		{
			return completed_assets[id] as IAsset;
		}
		
		public function getById(id:String):IAsset
		{
			for each (var a : IAsset in completed_assets)
			{
				if (a.id == id)
					return a;
			}
			return null;
		}
		
		public function getContent(name:String):*
		{
			return assetByName(name).content;
		}
		
		private function assetByName(name:String):IAsset
		{
			var i:int = -1;
			var ln:int = assets.length;
			while (++i < ln)
			{
				if (IAsset(assets[i]).name == name)
					return assets[i];
			}
			return null;
		}
		
		public function get name() : String
		{
			return _name;
		}
		
		public function get mode() : String
		{
			return _loadingMode;
		}
		
		public function set mode(loadingMode : String) : void
		{
			_loadingMode = loadingMode;
		}
		
		public function get maxConnections() : uint
		{
			return _maxConnections;
		}
		
		public function set maxConnections(maxConnections : uint) : void
		{
			_maxConnections = maxConnections;
		}

		public function get readyAssets() : Array
		{
			return completed_assets;
		}

		public function cancel():void
		{			
			_isCanceled = true;
			for each (var asset2 : IAsset in queue) {
				asset2.cancel();
			}
		}
	}
}
