package pt.wiz.dorothy 
{
	import pt.wiz.dorothy.core.IPreloader;
	import pt.wiz.dorothy.core.DApplication;
	/**
	 * ...
	 * @author Wiz Interactive
	 */
	public class Dorothy
	{
		
		public static const VERSION:String = "0.1.0";
		
		public static function getParam(name:String):*
		{
			return DApplication.instance.config.getParam(name);
		}
		
		public static function setParam(name:String, value:*):void
		{
			DApplication.instance.config.addParam(name, value);
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
		
	}

}