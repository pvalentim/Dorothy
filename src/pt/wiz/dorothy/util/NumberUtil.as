package pt.wiz.dorothy.util 
{
	import pt.wiz.dorothy.debug.Out;

	/**
	 * @author Pedro Valentim
	 */
	public class NumberUtil 
	{
		/**
		 * Inserts commas every 3 digits.
		 * @return Formatted string (ex1: 2,200, 20,000, 200,000)
		 */
		public static function insertCommas(value:Number):String
		{
			return insertSeparator(",", value);
		}
		
		public static function insertDots(value:Number):String
		{
			return insertSeparator(".", value);
		}
		
		private static function insertSeparator(symbol:String, value:Number):String
		{
			var valueStr:String = value.toString();
			var symbolIndex:int = valueStr.length;
			
			if (valueStr.indexOf(".") > -1)
			{
				symbolIndex = valueStr.indexOf(".");
				if (symbol == ".")
					valueStr = valueStr.replace(".", ",");
			}
				
			while (symbolIndex-3 > 0)
			{
				symbolIndex -= 3;
				valueStr = valueStr.substring(0, symbolIndex) + symbol + valueStr.substring(symbolIndex, valueStr.length);
			}
			return valueStr;
		}
		
	}
}
