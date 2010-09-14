package pt.wiz.dorothy.assets 
{
	import pt.wiz.dorothy.events.AssetEvent;
	import pt.wiz.dorothy.debug.Out;
	import pt.wiz.dorothy.assets.DAssets;
	import flash.events.EventDispatcher;

	/**
	 * @author Pedro Valentim
	 */
	public class AssetManager extends EventDispatcher {
		
		private var assets:Array;
		
		private var queue:Array;
		
		private var _name:String;
		private var _loading:Boolean;
		private var _loadingMode:String;
		private var _maxConnections:uint = 5;
		
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
			_loadingMode = AssetManager.PARALLEL;
		}

		public function add(name:String, type:String="auto"):void
		{
			if (!_loading)
			{
				if (assetByName(name) == null)
				{
					
					assets.push(getAssetType(name, type));
					Out.debug("Dorothy Assets - Added new asset "+name);
				} else {
					Out.debug("Dorothy Assets - Asset "+ name +" already in list. Use get(\""+name+"\") or getContent(\""+name+"\")");
				}
			} else {
				Out.debug("Dorothy Assets - Loader " + _name + " already started.");
			}
		}

		private function getAssetType(name:String, type:String) : IAsset
		{
			switch(type){
				case "auto":
					// TODO: Determine the type of asset.
					break;
				case "swf":
				case "jpg":
				case "gif":
				case "png":
					return new MediaAsset(name);
					break;
			}
			return null;
		}
		
		public function start():void
		{
			_loading = true;
			queue = [];
			if (_loadingMode == AssetManager.SEQUENTIAL)
			{
				_maxConnections = 1;
				queue.push(assets.shift());
				setupAsset(MediaAsset(queue[0]));
			} else {
				for (var i : int = 0;i < _maxConnections;i++)
				{
					if (assets[i] != null)
					{
						var asset:MediaAsset = assets.shift();
						queue.push(asset);
						setupAsset(asset);
					}
				}
			}
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
						var asset:MediaAsset = assets.shift();
						queue.push(asset);
						setupAsset(asset);
					}
				}
			}
		}

		private function asset_completeHandler(event : AssetEvent) : void 
		{
			queue.splice(queue.indexOf(event.target), 1);
			if (queue.length < _maxConnections)
			{
				for (var i : int = 0;i < _maxConnections-queue.length;i++)
				{
					if (assets[i] != null)
					{
						var asset:MediaAsset = assets.shift();
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
			}
		}

		private function setupAsset(asset:MediaAsset):void
		{
			asset.addEventListener(AssetEvent.COMPLETE, asset_completeHandler);
			asset.addEventListener(AssetEvent.ERROR, asset_errorHandler);
			asset.load();
		}

		public function get(name:String):MediaAsset
		{
			return assetByName(name);
		}
		
		public function getContent(name:String):*
		{
			return assetByName(name).content;
		}
		
		private function assetByName(name:String):MediaAsset
		{
			var i:int = -1;
			var ln:int = assets.length;
			while (++i < ln)
			{
				if (MediaAsset(assets[i]).name == name)
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
	}
}
