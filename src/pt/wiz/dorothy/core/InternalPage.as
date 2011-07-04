package pt.wiz.dorothy.core
{
	import pt.wiz.dorothy.util.Lib;
	import pt.wiz.dorothy.assets.IAsset;
	import pt.wiz.dorothy.events.AssetEvent;
	import pt.wiz.dorothy.core.vo.AssetVO;
	import pt.wiz.dorothy.assets.AssetManager;
	import pt.wiz.dorothy.core.Page;

	/**
	 * @author Pedro Valentim
	 */
	public class InternalPage extends Page
	{
		public function InternalPage(id:String, src:String, title:String, keepParent:Boolean = false, parent:Page = null)
		{
			super(id, src, title, keepParent, parent, "internal");
		}
			
		override public function load():void
		{
			movie = Lib.createClassObject(src);
						
			if (assets.length > 0)
			{
				pageLoader = new AssetManager();
				
				for each (var asset : AssetVO in assets)
				{
					pageLoader.add(asset.src, "auto", asset.id);
				}
				
				pageLoader.addEventListener(AssetEvent.COMPLETE, pageLoader_completeHandler);
				pageLoader.addEventListener(AssetEvent.PROGRESS_ALL, pageLoader_progressHandler);
				pageLoader.start();
			} else {
				super.pageLoader_completeHandler(null);
			}
		}
			
		override protected function pageLoader_completeHandler(event:AssetEvent):void
		{
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
