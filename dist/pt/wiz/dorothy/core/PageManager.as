package pt.wiz.dorothy.core
{
	import pt.wiz.dorothy.events.AssetEvent;
	import pt.wiz.dorothy.assets.PageAsset;
	import pt.wiz.dorothy.events.PageEvent;
	import pt.wiz.dorothy.debug.Out;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.asual.swfaddress.SWFAddress;

	import flash.events.EventDispatcher;

	/**
	 * ...
	 * @author Wiz Interactive
	 */
	public class PageManager extends EventDispatcher
	{
		private var _pages:PagesCollection;
		private var _curPages:PagesCollection;
		private var _nextPage:PageAsset;

		public function PageManager(pages:PagesCollection)
		{
			_pages = pages;
			initPageManager();
		}

		private function initPageManager() : void
		{
			_curPages = new PagesCollection();
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, swfaddress_changeHandler);
		}

		private function swfaddress_changeHandler(event:SWFAddressEvent) : void
		{
			var path:String = "/"+event.pathNames.join("/");
			//trace(path);
			_nextPage = _pages.getPageByPath(path);
			if (_nextPage == null)
			{
				Out.error("No page found");
				// TODO: Show 404
				return;
			} else {
				Out.info("Page " + _nextPage.id + " found");
				var _lastLoadedPage:PageAsset = _curPages.getItemAt(_curPages.length - 1);
				if (_lastLoadedPage != null)
				{
					if (_nextPage.id != _lastLoadedPage.id)
						changePage();
				} else {
					changePage();
				}
				
			}
		}

		private function changePage() : void
		{
			addPageEventListeners(_nextPage);
			if (_curPages.length > 0)
			{
				var lastLoadedPage:PageAsset = PageAsset(_curPages[_curPages.length - 1]);
				if (_nextPage.parent == lastLoadedPage)
				{
					// The new page is child of a current loaded page.
					if (_nextPage.keepParent)
					{
						// Keep all loaded pages and load the new on top.
					} else {
						// Keep all loaded pages, except the parent of the new page, and load the new one on top.
					}
				} else {
					// The new page is root page. Unload everthing and load the new one on top.
					for each (var page : PageAsset in _curPages.data)
					{
						page.pageContent.transitionOut();
					}
				}
			} else {
				// Load Page and TransitionIn.
				_nextPage.load();
			}
		}
		
		private function addPageEventListeners(page:PageAsset):void
		{
			page.addEventListener(AssetEvent.PROGRESS, page_progressHandler);			page.addEventListener(AssetEvent.COMPLETE, page_completeHandler);
		}

		private function page_completeHandler(event:AssetEvent) : void
		{
			var page:PageAsset = event.target as PageAsset;
			addContentEventListeners(page.pageContent);
			Out.info("Page " + PageAsset(event.target).id + " Loaded");
			// TODO: Add movie to target holder.
		}

		private function page_progressHandler(event:AssetEvent) : void
		{
			// TODO: Update preloader.
		}
		
		private function addContentEventListeners(content:DPage):void
		{
			content.addEventListener(PageEvent.TRANSITION_OUT_COMPLETE, dpage_transitionOutCompleteHandler);
			content.addEventListener(PageEvent.TRANSITION_IN_COMPLETE, dpage_transitionInCompleteHandler);
		}

		private function dpage_transitionInCompleteHandler(event:PageEvent) : void
		{
			
		}

		private function dpage_transitionOutCompleteHandler(event:PageEvent) : void
		{
			// TODO: Remove from display list and dispose.
		}
		
	}
}