package pt.wiz.dorothy.core
{
	import pt.wiz.dorothy.debug.Out;
	import pt.wiz.dorothy.assets.IAsset;
	import pt.wiz.dorothy.core.vo.AssetVO;
	import pt.wiz.dorothy.assets.PageAsset;
	import pt.wiz.dorothy.events.PageEvent;
	import pt.wiz.dorothy.events.AssetEvent;
	import flash.events.EventDispatcher;
	import pt.wiz.dorothy.assets.AssetManager;
	import pt.wiz.dorothy.Dorothy;
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
		public var assets:Array = [];
		public var keepParent:Boolean;
		public var children:Array;
		public var parent:Page;
		public var movie:DPage;
		
		private var pageLoader:AssetManager;

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
			pageLoader = new AssetManager();
			pageLoader.add(Dorothy.getParam("swf_path")+src, "page", id);
			
			for each (var asset : AssetVO in assets)
			{
				pageLoader.add(asset.src, "auto", asset.id);
			}
			
			pageLoader.addEventListener(AssetEvent.COMPLETE, pageLoader_completeHandler);
			pageLoader.addEventListener(AssetEvent.PROGRESS_ALL, pageLoader_progressHandler);
			pageLoader.start();
		}

		private function pageLoader_progressHandler(event:AssetEvent) : void
		{
		}

		private function pageLoader_completeHandler(event:AssetEvent) : void
		{
			movie = PageAsset(pageLoader.getById(id)).pageContent;
			for (var i:int = 0; i < pageLoader.readyAssets.length; i++)
			{
				var a:IAsset = pageLoader.getAt(i);
				if (a.id != id)
					movie.assets.push(a);
			}
			pageLoader = null;
			dispatchEvent(new PageEvent(PageEvent.LOAD_COMPLETE));
		}

		public function cancel():void
		{
			Out.debug("We called cancel.");
			if (pageLoader != null)
				pageLoader.cancel();
		}

	}
}
