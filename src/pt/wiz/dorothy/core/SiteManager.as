package pt.wiz.dorothy.core 
{
	
	import pt.wiz.dorothy.core.vo.AssetVO;
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
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
		private var _page_holder:MovieClip;
		
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
			
			if (value.indexOf("{") > -1)
			{
				var cleaned_name:String = value.substring(value.indexOf("{")+1, value.indexOf("}"));
				for each (var config : Object in Dorothy.configData) {
					if (config.name == cleaned_name)
						return config.value + value.substring(value.indexOf("}")+1, value.length);
				}
			}
			
			return value;
		}
		
		private function parsePages():void
		{
			_pages = new PagesCollection();
			for each(var p:XML in _siteXML.pages.page)
			{
				parsePage(p);
			}
			
			dispatchEvent(new DEvent(DEvent.APPLICATION_READY));
		}

		private function setupPageManager() : void
		{
			_pageManager = new PageManager(_pages, _page_holder);
		}
		
		private function parsePage(page:XML, parent:* = null):void
		{
			var _page:Page = new Page(page.@id, page.@src, page.@title, (page.attribute("keepParent").toString() == "true"), parent);
			
			_pages.addItem(_page);
			if (page.children())
			{
				for each(var p:XML in page.page)
				{
					parsePage(p, _page);
				}
				
				for each(var a:XML in page.asset)
				{
					_page.assets.push(parseAsset(a));
				}
			}
		}

		private function parseAsset(asset:XML) : AssetVO
		{
			return new AssetVO(parseTokens(asset.@src), asset.@id);
		}

		public function get page_holder() : MovieClip
		{
			return _page_holder;
		}

		public function set page_holder(page_holder:MovieClip) : void
		{
			if (_page_holder == null)
			{
				_page_holder = page_holder;
				setupPageManager();
			}
			
		}
		
	}

}