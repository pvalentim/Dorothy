package pt.wiz.dorothy.assets 
{
	import pt.wiz.dorothy.assets.AssetManager;

	/**
	 * @author Pedro Valentim
	 */
	public class DAssets {
		
		private static var ams:Array = [];
		
		public static function addLoader(am:AssetManager):void
		{
			DAssets.ams.push(am);
		}
		
		public static function getLoader(name:String):AssetManager
		{
			return DAssets.loaderByName(name);
		}
		
		private static function loaderByName(name:String):AssetManager
		{
			var i:int = -1;
			var ln:int = DAssets.ams.length;
			while (++i < ln)
			{
				if (AssetManager(DAssets.ams[i]).name == name)
					return DAssets.ams[i];
			}
			return null;
		}
		
	}
}
