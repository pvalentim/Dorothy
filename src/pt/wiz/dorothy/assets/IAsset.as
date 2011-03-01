package pt.wiz.dorothy.assets
{
	import flash.events.IEventDispatcher;
	/**
	 * @author Pedro Valentim
	 */
	public interface IAsset extends IEventDispatcher
	{
		function load():void;
		function cancel():void;
		function get content():*;
		function get name():String;
		function get id():String;
		function get percentageLoaded():Number;
	}
}
