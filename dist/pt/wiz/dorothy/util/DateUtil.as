package pt.wiz.dorothy.util 
{

	/**
	 * @author Pedro Valentim
	 */
	public class DateUtil 
	{
		private static const european_regex:RegExp = new RegExp("^([1-9]|0[1-9]|1[0-9]|2[0-9]|3[01])[/._-](0[1-9]|1[0-2])[/._-](19[0-9][0-9]|20[0-9][0-9])$");
		
		public static function stringToDate(str:String):Date
		{
			var arr:Array = european_regex.exec(str);
			if (arr != null)
			{
				return new Date(arr[3], int(arr[2])-1, arr[1]);
			} else {
				return new Date();
			}
		}
	}
}