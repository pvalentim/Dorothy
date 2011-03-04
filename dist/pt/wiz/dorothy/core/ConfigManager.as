package pt.wiz.dorothy.core
{
	import pt.wiz.dorothy.debug.Out;
	/**
	 * ...
	 * @author Wiz Interactive
	 */
	public class ConfigManager
	{
		
		private var _config:Array;
		
		public function ConfigManager() 
		{
			initConfig();
		}
		
		private function initConfig():void
		{
			_config = [];
		}
		
		public function addParam(name:String, value:*):void
		{
			_config.push({name:name, value:value});
		}
		
		public function getParam(name:String):*
		{
			for each (var config : Object in _config) {
				if (config.name == name)
					return config.value;
			}
			return "Invalid Parameter";
		}
		
		public function dump():void
		{
			for each (var config : Object in _config) {
				Out.debug("Param - name: " + config.name + " - value: " + config.value);
			}
		}

		public function get config() : Array
		{
			return _config;
		}
		
	}

}