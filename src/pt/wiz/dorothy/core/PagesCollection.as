package pt.wiz.dorothy.core
{
	
	import pt.wiz.dorothy.debug.Out;
	/**
	 * @author Pedro Valentim
	 */
	public class PagesCollection
	{
		private var _data:Array;

		public function PagesCollection(data:Array = null)
		{
			if (data == null)
				_data = [];
			else
				_data = data;
		}
		
		public function addItem(item:Page):void
		{
			_data.push(item);
		}
		
		public function getItemAt(id:int):Page
		{
			return _data[id];
		}
		
		public function getPageBy(field:String, value:String):Page
		{
			if (_data[0][field] != null)
			{
				for each (var p : Page in _data) {
					if (p[field] == value)
						return p;
				}
				Out.error("No pages returned.");
				return null;
			} else {
				Out.error("Invalid field.");
				return null;
			}
		}
		
		public function getPageByPath(path:String):Page
		{
			var page:Page = getPageBy("path", path);
			if (page != null)
			{
				return page;
			} else {
				var arr:Array;
				arr = path.split("/");
				arr.pop();
				if (arr.length > 0)
				{
					path = arr.join("/");
					return getPageByPath(path);
				} else {
					return null;
				}
			}
			
		}

		public function get data() : Array
		{
			return _data;
		}

		public function get length() : uint
		{
			return _data.length;
		}

	}
}
