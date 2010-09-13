package pt.wiz.dorothy.util 
{

	/**
	 * @author Matan Uberstein
	 * 
	 * FlashVarsDynamic class should be extended to a specific representation of what is required by
	 * the new application/webiste. Simply extend the FlashVarsDynamic and add public accessors and they
	 * will be automatically be populated by the embedded flashvars passed.
	 */
	public dynamic class FlashVarsDynamic 
	{

		/**
		 * Evaluates Flash vars, converts strings to specified data type.
		 * @param params LoaderInfo parameters Object.
		 * Type prefix must be separated by underscore "_"
		 * 	<code>	Javascript:
		 * 			var params = {boolean_isLoggedIn:true, array_playerNames:"Matan,Luke,John"};
		 * 			
		 * 			Flash:
		 * 			var _flashvars : FlashVars = new FlashVars(this.stage.loaderInfo.parameters);
		 * 			trace(_flashvars.isLoggedIn);			//true
		 * 			trace(_flashvars.playerNames);			//Matan, Luke, John
		 * 			trace(_flashvars.playerNames is Array);	//true
		 * 	</code>
		 */
		public function FlashVarsDynamic(loaderInfoParams : Object) 
		{
			parse(loaderInfoParams);
		}

		protected function onParseError(key : String, value : String, error : Error) : void 
		{
		}

		protected function parse(params : Object) : void 
		{
			var types : Array = new Array("array", "boolean", "int", "number", "string", "xml");
			
			for(var key : String in params) 
			{
				var value : String = params[key];
				var keySplit : Array = key.split("_");
				var type : String = keySplit[0].toLowerCase();
				var typeIndex : int = types.indexOf(type);
				
				if(typeIndex == -1)
					type = "string";
				else 
					key = keySplit.splice(1).join("_");
				
				try 
				{
					switch (type) 
					{
						case "array" :
							this[key] = value.split(",");
							break;
						case "boolean" :
							this[key] = toBoolean(value);
							break;
						case "int" :
							this[key] = int(value);
							break;
						case "number" :
							this[key] = Number(value);
							break;
						case "string" :
							this[key] = value;
							break;
						case "xml" :
							this[key] = new XML(value);
							break;
					}
				}catch(error : Error) 
				{
					onParseError(key, value, error);
				}
			}
		}

		protected function toBoolean(str : String) : Boolean 
		{
			str = str.toLowerCase();
			if(str == "1" || str == "true")
				return true;
			return false;
		}
	}
}
