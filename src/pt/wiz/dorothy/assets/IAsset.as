package pt.wiz.dorothy.assets
{
	/**
	 * @author Pedro Valentim
	 */
	public interface IAsset
	{
		function load():void;
		function cancel():void;
		function destroy():void;
	}
}
