package pt.wiz.dorothy.assets
{
	import pt.wiz.dorothy.core.DPage;

	/**
	 * @author Pedro Valentim
	 */
	public class PageAsset extends MediaAsset
	{
		public function PageAsset(name:String, id:String = "")
		{
			super(name, id);
		}
		
		public function get pageContent():DPage
		{
			return this.content as DPage;
		}
	}
}
