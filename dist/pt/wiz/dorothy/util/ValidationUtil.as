package pt.wiz.dorothy.util
{

	/**
	 * ...
	 * @author Wiz
	 */
	public class ValidationUtil
	{
		public static function isEmail($string:String):Boolean {
			var validemail:RegExp = /^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)+)@(([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)*)){2,}\.([A-Za-z]){2,4}+$/g;
			return validemail.test($string);
		}
		
		public static function isDate($string:String):Boolean {
			/*
			 * TEMPORARY SOLUTION - Works width american formats.
			 * ex: mm/dd/yyyy | 25 Dec 2010 | more at -> http://www.adobe.com/livedocs/flash/9.0/ActionScriptLangRefV3/Date.html#parse%28%29
			 */
			
			var d:Date = Date($string);
			if (d.toString() != "Invalid Date")
				return true;
			else
				return false;
		}
		
		public static function isPostalCode($string:String):Boolean {
			var validpostalcode:RegExp = /^\d{4}[-\s]\d{3}$/g;
			return validpostalcode.test($string);
		}
		
	}
	
}