package pt.wiz.dorothy.core
{
	import pt.wiz.dorothy.events.PageEvent;
	import pt.wiz.dorothy.assets.IAsset;
	import pt.wiz.dorothy.assets.PageAsset;
	import pt.wiz.dorothy.events.AssetEvent;
	import pt.wiz.dorothy.core.vo.AssetVO;
	import pt.wiz.dorothy.Dorothy;
	import pt.wiz.dorothy.assets.AssetManager;
	import pt.wiz.dorothy.core.Page;

	/**
	 * @author Pedro Valentim
	 */
	public class ExternalPage extends Page
	{
		public function ExternalPage(id:String, src:String, title:String, keepParent:Boolean = false, parent:Page = null)
		{
			super(id, src, title, keepParent, parent);
		}
			
		override public function load():void
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
			
		override protected function pageLoader_completeHandler(event:AssetEvent):void
		{
			movie = PageAsset(pageLoader.getById(id)).pageContent;
			for (var i:int = 0; i < pageLoader.readyAssets.length; i++)
			{
				var a:IAsset = pageLoader.getAt(i);
				if (a.id != id)
					movie.assets.push(a);
			}
			pageLoader = null;
			super.pageLoader_completeHandler(event);
		}
	}
}
