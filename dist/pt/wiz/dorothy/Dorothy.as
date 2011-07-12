package pt.wiz.dorothy 
{
	import pt.wiz.dorothy.core.IPreloader;
	import pt.wiz.dorothy.core.DApplication;
	/**
	 * ...
	 * @author Wiz Interactive UI
	 */
	public class Dorothy
	{
		
		public static const VERSION:String = "0.3.1";
		public static const PAGEFLOW_OUT_LOAD_IN:String = "dorothy_pageflow_outloadin";
		public static const PAGEFLOW_LOAD_OUT_IN:String = "dorothy_pageflow_loadoutin";
		public static const PAGEFLOW_LOAD_IN_OUT:String = "dorothy_pageflow_loadinout";
		public static const PAGEFLOW_LOAD_IN_AND_OUT:String = "dorothy_pageflow_loadinandout";
		
		public static function getParam(name:String):*
		{
			return DApplication.instance.config.getParam(name);
		}
		
		public static function setParam(name:String, value:*):void
		{
			DApplication.instance.config.addParam(name, value);
		}
		
		public static function get configData():Array
		{
			return DApplication.instance.config.config;
		}
		
		public static function configDump():void
		{
			DApplication.instance.config.dump();
		}
		
		public static function get BASEURI():String 
		{
			return DApplication.instance.baseuri;
		}
		
		public static function get preloader():IPreloader
		{
			return DApplication.instance.preloader;
		}
		
		public static function set preloader(preloader:IPreloader):void
		{
			DApplication.instance.preloader = preloader;
		}
		
		public static function get pageFlow():String
		{
			return DApplication.instance.pageFlow;
		}
		
		public static function set pageFlow(pageFlow:String):void
		{
			DApplication.instance.pageFlow = pageFlow;
		}
		
	}

}