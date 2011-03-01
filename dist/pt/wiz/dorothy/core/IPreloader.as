package pt.wiz.dorothy.core
{
	/**
	 * @author Pedro Valentim
	 */
	public interface IPreloader
	{
		function update(percentage:Number):void
		function transitionIn():void
		function transitionOut():void
	}
}
