package pt.wiz.dorothy.core.vo
{
	/**
	 * @author Pedro Valentim
	 */
	public class AssetVO
	{
		
		public var src:String;
		public var id:String;
		public var type:String;
		
		public function AssetVO(src:String, id:String, type:String = "")
		{
			this.src = src;
			this.type = type;
			this.id = id;
		}

	}
}
