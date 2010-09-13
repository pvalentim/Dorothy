package pt.wiz.dorothy.core
{
	import pt.wiz.dorothy.debug.Out;
	/**
	 * ...
	 * @author Wiz Interactive
	 */
	public class ConfigManager
	{
		
		private var _config:Object;
		
		public function ConfigManager() 
		{
			initConfig();
		}
		
		private function initConfig():void
		{
			_config = new Object();
		}
		
		public function parseXMLConfig(config:XMLList):void
		{
			for each( var param in config )
			{
				_config[param.@name] = param.@value;
			}
		}
		
		public function addParam(name:String, value:*):void
		{
			_config[name] = value;
		}
		
		public function getParam(name:String):*
		{
			if (_config[name] != undefined)
				return _config[name];
			else
				return "Invalid Parameter";
		}
		
		public function dump():void
		{
			for (var prop in _config)
			{
				Out.debug("Param - name: " + prop + " - value: " + _config[prop]);
			}
		}
		
	}

}