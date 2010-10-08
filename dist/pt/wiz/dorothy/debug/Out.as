package pt.wiz.dorothy.debug 
{
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.logging.ILogger;

	/**
	 * @author Pedro Valentim
	 */
	public class Out 
	{	
		private static var _logger:ILogger = LoggerFactory.getLogger("Dorothy");
		
		public static function info(message:String, ...params):void
		{
			_logger.info(message, params);
		}
		
		public static function debug(message:String, ...params):void
		{
			_logger.debug(message, params);
		}
		
		public static function warn(message:String, ...params):void
		{
			_logger.warn(message, params);
		}
		
		public static function error(message:String, ...params):void
		{
			_logger.error(message, params);
		}
		
		public static function fatal(message:String, ...params):void
		{
			_logger.fatal(message, params);
		}
		
		public static function getLogger(name:String):ILogger
		{
			return LoggerFactory.getLogger(name);
		}
		
		public static function get logger():ILogger
		{
			return _logger;
		}
		
		public static function set logger(value:ILogger):void
		{
			_logger = value;
		}
	}
}
