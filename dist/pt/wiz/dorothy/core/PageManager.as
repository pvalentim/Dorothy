package pt.wiz.dorothy.core
{
	
	import pt.wiz.dorothy.events.DEvent;
	import pt.wiz.dorothy.Dorothy;
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import pt.wiz.dorothy.events.AssetEvent;
	
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
		private var _nextPage:Page;
		private var _page_holder:MovieClip;

		public function PageManager(pages:PagesCollection, page_holder:MovieClip)
		{
			_pages = pages;
			_page_holder = page_holder;
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
			
			if (_nextPage != null)
			{
				_nextPage.cancel();
			}
			
			_nextPage = _pages.getPageByPath(path);
			if (_nextPage == null)
			{
				//Out.error("No page found");
				// TODO: Show 404
				return;
			} else {
				Out.info("Page " + _nextPage.id + " found");
				var _lastLoadedPage:Page = _curPages.getItemAt(_curPages.length - 1);
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
				var lastLoadedPage:Page = Page(_curPages.getItemAt(_curPages.length - 1));
				if (_nextPage.parent == lastLoadedPage)
				{
					// The new page is child of a current loaded page.
					if (_nextPage.keepParent)
					{
						// Keep all loaded pages and load the new on top.
						_nextPage.load();
					} else {
						// Keep all loaded pages, except the parent of the new page, and load the new one on top.
						if (_curPages.getItemAt(_curPages.length - 1) == _nextPage.parent)
						{
							if (Dorothy.pageFlow == Dorothy.PAGEFLOW_OUT_LOAD_IN)
							{
								_nextPage.parent.movie.transitionOut();
							} else if (Dorothy.pageFlow == Dorothy.PAGEFLOW_LOAD_IN_AND_OUT) {
								loadNextPage();
							}
						}
					}
				} else {
					// The new page is root page. Unload everthing and load the new one on top.
					if (Dorothy.pageFlow == Dorothy.PAGEFLOW_OUT_LOAD_IN)
					{
						for each (var page : Page in _curPages.data)
						{
							page.movie.transitionOut();
						}
					} else if (Dorothy.pageFlow == Dorothy.PAGEFLOW_LOAD_IN_AND_OUT) {
						loadNextPage();
					}
					
				}
			} else {
				// Load Page and TransitionIn.
				loadNextPage();
			}
		}
		
		private function loadNextPage():void
		{
			Dorothy.preloader.transitionIn();
			_nextPage.load();
		}

		private function addPageEventListeners(page:Page):void
		{
			page.addEventListener(PageEvent.LOAD_PROGRESS, page_progressHandler);			page.addEventListener(PageEvent.LOAD_COMPLETE, page_completeHandler);
		}
		
		private function removePageEventListeners(page:Page):void
		{
			page.removeEventListener(PageEvent.LOAD_PROGRESS, page_progressHandler);
			page.removeEventListener(PageEvent.LOAD_COMPLETE, page_completeHandler);
		}

		private function page_completeHandler(event:PageEvent) : void
		{
			var page:Page = event.target as Page;
			

			if (_nextPage == page)
				_nextPage = null;
			
			
			if (Dorothy.pageFlow == Dorothy.PAGEFLOW_LOAD_IN_AND_OUT) {
				var cur:Page = _curPages.getItemAt(_curPages.length - 1);
				if (cur)
					cur.movie.transitionOut();
			}
			
			_curPages.addItem(page);
			removePageEventListeners(page);
			addContentEventListeners(page.movie);
			Out.info("Page " + Page(event.target).id + " Loaded");
			_page_holder.addChild(page.movie);
			Dorothy.preloader.transitionOut();
			page.movie.transitionIn();
			dispatchEvent(new DEvent(DEvent.CHANGED_PAGE, page.id));
		}

		private function page_progressHandler(event:PageEvent) : void
		{
			Dorothy.preloader.update(event.progressInfo.percentageLoaded);
		}
		
		private function addContentEventListeners(content:DPage):void
		{
			content.addEventListener(PageEvent.TRANSITION_OUT_COMPLETE, dpage_transitionOutCompleteHandler);
			content.addEventListener(PageEvent.TRANSITION_IN_COMPLETE, dpage_transitionInCompleteHandler);
		}
		
		private function removeContentEventListeners(content:DPage):void
		{
			content.addEventListener(PageEvent.TRANSITION_OUT_COMPLETE, dpage_transitionOutCompleteHandler);
			content.addEventListener(PageEvent.TRANSITION_IN_COMPLETE, dpage_transitionInCompleteHandler);
		}

		private function dpage_transitionInCompleteHandler(event:PageEvent) : void
		{
			
		}

		private function dpage_transitionOutCompleteHandler(event:PageEvent) : void
		{
			var page:DPage = event.target as DPage;
			removeContentEventListeners(page);
			_page_holder.removeChild(page);
			_curPages.removeItem(_pages.getPageBy("movie", page));
			
			if (_nextPage != null && Dorothy.pageFlow == Dorothy.PAGEFLOW_OUT_LOAD_IN)
				loadNextPage();
		}
		
	}
}