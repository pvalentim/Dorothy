package pt.wiz.dorothy.events 
{
	import flash.events.Event;

	/**
	 * @author Pedro Valentim
	 */
	public class AssetEvent extends Event 
	{
		
		public static const COMPLETE:String = "dorothy_assetComplete";		public static const PROGRESS:String = "dorothy_assetProgress";
		public static const PROGRESS_ALL:String = "dorothy_assetProgressAll";
		public static const ERROR:String = "dorothy_assetError";
		
		public var percentLoaded:Number;
		public var error:String;
		
		public function AssetEvent(type : String, percentLoaded:Number = 0, error:String = "", bubbles : Boolean = false, cancelable : Boolean = false)
		{
			this.percentLoaded = percentLoaded;
			this.error = error;
			super(type, bubbles, cancelable);
		}
			
		override public function clone() : Event
		{
			return new AssetEvent(type, percentLoaded, error, bubbles, cancelable);
		}
	}
}
