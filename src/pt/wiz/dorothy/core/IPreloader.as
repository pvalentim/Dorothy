package pt.wiz.dorothy.core
{
	/**
	 * @author Pedro Valentim
	 */
	public interface IPreloader
	{
		function update(bytesLoaded:int, bytesTotal:int):void
		function transitionIn():void
		function transitionOut():void
	}
}
