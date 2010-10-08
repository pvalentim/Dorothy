package pt.wiz.dorothy.core 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import org.as3commons.logging.LoggerFactory;

	import flash.ui.ContextMenu;
	import pt.wiz.dorothy.util.ContextMenuUtil;
	import pt.wiz.dorothy.debug.Out;
	import flash.events.Event;

	import pt.wiz.dorothy.events.DEvent;
	import pt.wiz.dorothy.Dorothy;
	
	/**
	 * ...
	 * @author Wiz Interactive
	 */
	public class DApplication extends MovieClip
	{
		private static var _instance:DApplication;
		
		private var _config:ConfigManager;
		private var _siteManager:SiteManager;
		private var _baseuri:String ="/";
		private var _preloader:IPreloader;
		private var _page_holder:MovieClip;
		
		protected var top_layer:Sprite;
		protected var siteXML:String;
		
		public function DApplication(siteXML:String, baseuri:String = "") 
		{
			_baseuri = baseuri;
			if (siteXML)
			{
				this.siteXML = siteXML;
				initApplication();
			} else {
				throw Error("Dorothy Error - Can't initialize without a site xml path");
			}
		}
		
		private function initApplication():void
		{
			//Out.logger = LoggerFactory.getLogger("Dorothy Logger");
			Out.info("Dorothy Framework v" + Dorothy.VERSION + " initialized");
			
			_instance = this;
			_config = new ConfigManager();
			_config.addParam("sitexml", siteXML);
			
			_siteManager = new SiteManager();
			_siteManager.addEventListener(DEvent.APPLICATION_READY, _appReady);
			
			// Defaults stage align and scaleMode to a more used case.
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.contextMenu = new ContextMenu();
			ContextMenuUtil.contextMenu = this.contextMenu;
			ContextMenuUtil.disableDefaults();
			ContextMenuUtil.addItem("Powered by Dorothy " + Dorothy.VERSION, false);			ContextMenuUtil.addItem("Developed by Wiz Interactive © "+ new Date().fullYear.toString(), false);
			
			/* Check if SWF is running in the browser */
			if (root.loaderInfo.url.indexOf("http") == 0) SystemManager.isOnline = true;
			
			parseFlashvars();
			setupLayers();
			setupPreloader();
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			if (child != top_layer)
				swapChildren(child, top_layer);
			return child;
		}

		private function setupLayers() : void
		{
			top_layer = new Sprite();
			addChild(top_layer);
		}

		private function setupPreloader() : void
		{
			_preloader = new DPreloader();
			top_layer.addChild(_preloader as DisplayObject);
		}

		private function _appReady(event : DEvent) : void 
		{
			if (stage)
			{
				initApp();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, _addedToStage);
			}
		}

		private function _addedToStage(event : Event) : void 
		{
			if (event) removeEventListener(Event.ADDED_TO_STAGE, _addedToStage);
				initApp();
		}
		
		/* INIT FUNCTION (To be overridden) */
		
		protected function initApp():void
		{
			throw new Error("Dorothy init function must be overridden");
		}
		
		protected function setHolder(page_holder:MovieClip):void
		{
			_page_holder = page_holder;
			_siteManager.page_holder = _page_holder;
		}

		private function parseFlashvars():void
		{
			if (SystemManager.isOnline)
			{
				/* Expects a flashvar named 'baseuri' */
				if (root.loaderInfo.parameters["baseuri"] != null && root.loaderInfo.parameters["baseuri"]  != "")
					_baseuri = root.loaderInfo.parameters["baseuri"];
			}
			
		}
		
		public static function get instance():DApplication { return _instance; }
		
		public function get baseuri():String { return _baseuri; }
		
		public function get config():ConfigManager
		{
			return _config;
		}

		public function get preloader() : IPreloader
		{
			return _preloader;
		}

		public function set preloader(preloader:IPreloader) : void
		{
			_preloader = preloader;
		}
	}

}