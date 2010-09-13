package pt.wiz.dorothy.util 
{
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenuItem;
	import flash.ui.ContextMenu;

	/**
	 * @author Pedro Valentim
	 */
	public class ContextMenuUtil 
	{
		
		private static var _contextMenu:ContextMenu;
		
		public static function addItem(name:String, enabled:Boolean = true, separator:Boolean = false, eventHandler:Function=null):void
		{
			var item:ContextMenuItem = new ContextMenuItem(name);
			item.separatorBefore = separator;
			item.enabled = enabled;
			if (eventHandler != null)
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, eventHandler);
			_contextMenu.customItems.push(item);
		}
		
		public static function getItemByName(name:String):ContextMenuItem
		{
			for each (var item : ContextMenuItem in _contextMenu.customItems) {
				if (item.caption == name)
					return item;
			}
			return null;
		}
		
		public static function getItemById(id:int):ContextMenuItem
		{
			return _contextMenu.customItems[id];
		}
		
		public static function disableDefaults() : void 
		{
			_contextMenu.hideBuiltInItems();
		}
		
		static public function set contextMenu(contextMenu : ContextMenu) : void
		{
			_contextMenu = contextMenu;
		}
	}
}
