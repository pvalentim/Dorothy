package pt.wiz.dorothy.core 
{
	
	import pt.wiz.dorothy.debug.Out;
	import pt.wiz.dorothy.events.DEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import pt.wiz.dorothy.Dorothy;
	/**
	 * ...
	 * @author Wiz Interactive
	 */
	public class SiteManager extends EventDispatcher
	{
		
		private var _siteXML:XML;
		private var _pages:PagesCollection;
		
		private var _pageManager:PageManager;
		
		public function SiteManager() 
		{
			initSite();
		}
		
		private function initSite():void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loader_onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_onIOError);
			loader.load(new URLRequest(Dorothy.BASEURI + Dorothy.getParam("sitexml")));
		}
		
		private function loader_onComplete(e:Event):void 
		{
			_siteXML = new XML(e.target.data);
			parseSiteXML();
		}
		
		private function loader_onIOError(e:IOErrorEvent):void 
		{
			Out.error("Error at " + this + "::" + e.text);
		}
		
		private function parseSiteXML():void
		{
			Dorothy.setParam("site_title", _siteXML.@title);
			Dorothy.setParam("site_version", _siteXML.@version);
			parseConfig();
			parsePages();
		}
		
		private function parseConfig():void
		{
			for each(var p:XML in _siteXML.config.param)
			{
				Dorothy.setParam(p.@name, parseTokens(p.@value));
			}
			Out.info("Dorothy config initialized.");
		}

		private function parseTokens(value:String) : String
		{
			if (value.indexOf("{BASEURI}") > -1)
				return value.replace("{BASEURI}", Dorothy.BASEURI);
			return "";
		}
		
		private function parsePages():void
		{
			_pages = new PagesCollection();
			for each(var p:XML in _siteXML.pages.page)
			{
				parsePage(p);
			}
			for each (var i : PageAsset in _pages.data) {
				//trace(i.path);
			}
			
			setupPageManager();
			
			dispatchEvent(new DEvent(DEvent.APPLICATION_READY));
		}

		private function setupPageManager() : void
		{
			_pageManager = new PageManager(_pages);
		}
		
		private function parsePage(page:XML, parent:* = null):void
		{
			var _page:PageAsset = new PageAsset(page.@id, page.@src, page.@title, (page.attribute("keepParent").toString() == "true"), parent);
			_pages.addItem(_page);
			
			if (page.children())
			{
				for each(var p in page.page)
				{
					parsePage(p, _page);
				}
			}
		}
		
	}

}