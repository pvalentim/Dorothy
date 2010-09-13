package pt.wiz.dorothy.core
{
	import pt.wiz.dorothy.events.PageEvent;
	import flash.events.EventDispatcher;
	import pt.wiz.dorothy.events.AssetEvent;
	import pt.wiz.dorothy.Dorothy;
	import pt.wiz.dorothy.assets.Asset;
	/**
	 * @author Pedro Valentim
	 */
	
	/**
	 * Dispatched when the page is finished loading.
	 * 
	 * @eventType pt.wiz.dorothy.events.PageEvent
	 */
	[Event(name="dpage_loadComplete", type="pt.wiz.dorothy.events.PageEvent")] 
	
	/**
	 * Dispatched while the page is loading.
	 * 
	 * @eventType pt.wiz.dorothy.events.PageEvent
	 */
	[Event(name="dpage_loadProgress", type="pt.wiz.dorothy.events.PageEvent")] 
	
	public class Page extends EventDispatcher
	{
		public var id:String;
		public var src:String;
		public var title : String;
		public var path:String = "";
		public var keepParent:Boolean;
		
		public var children:Array;
		public var parent:Page;
		
		public var movie:DPage;
		private var movieAsset:Asset;

		public function Page(id:String, src:String, title:String, keepParent:Boolean = false, parent:Page = null)
		{
			if (parent != null)
			{
				this.parent = parent;
				path = parent.path + "/" + id;
			} else {
				path = "/" + id;
			}
			this.id = id;
			this.src = src;
			this.title = title;
			this.keepParent = keepParent;
		}
		
		public function load():void
		{
			movieAsset = new Asset(Dorothy.getParam("swf_path") + src);
			movieAsset.addEventListener(AssetEvent.COMPLETE, asset_completeHandler);
			movieAsset.addEventListener(AssetEvent.PROGRESS, asset_progressHandler);
			movieAsset.load();
		}

		private function asset_progressHandler(event:AssetEvent) : void
		{
			
		}

		private function asset_completeHandler(event:AssetEvent) : void
		{
			movie = movieAsset.content as DPage;
			movieAsset = null;
			dispatchEvent(new PageEvent(PageEvent.LOAD_COMPLETE));
		}

	}
}
