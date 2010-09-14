package pt.wiz.dorothy.assets
{
	import pt.wiz.dorothy.Dorothy;
	import pt.wiz.dorothy.core.DPage;
	/**
	 * @author Pedro Valentim
	 */
	
	public class PageAsset extends MediaAsset
	{
		public var id:String;
		public var src:String;
		public var title : String;
		public var path:String = "";
		public var keepParent:Boolean;
		
		public var children:Array;
		public var parent:PageAsset;

		public function PageAsset(id:String, src:String, title:String, keepParent:Boolean = false, parent:PageAsset = null)
		{
			if (parent != null)
			{
				this.parent = parent;
				path = parent.path + "/" + id;
			} else {
				path = "/" + id;
			}
			this.id = id;
			this.src = src;
			this.title = title;
			this.keepParent = keepParent;
			super(Dorothy.getParam("swf_path") + src);
		}
		
		public function get pageContent():DPage
		{
			return this.content as DPage;
		}

	}
}
