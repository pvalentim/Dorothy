/*
 * Copyright (c) 2008-2009-2010 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.logging.util {
	
	/**
	 * Utilities for working with log messages.
	 *
	 * @author Christophe Herreman
	 */
	public class MessageUtil {

		// --------------------------------------------------------------------
		//
		// Private Static Variables
		//
		// --------------------------------------------------------------------

		private static var _regExps:Array = [];

		// --------------------------------------------------------------------
		//
		// Public Static Methods
		//
		// --------------------------------------------------------------------
		
		/**
		 * Returns a string with the parameters replaced.
		 */
		public static function toString(message:String, params:Array):String {
			var result:String = message;
			const numParams:int = params.length;
			
			for (var i:int = 0; i < numParams; i++) {
				result = result.replace(getRegExp(i), params[i]);
			}
			
			return result;
		}

		// --------------------------------------------------------------------
		//
		// Private Static Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Returns (and caches) a regular expression to replace the placeholder with the given index.
		 *
		 * @param index
		 * @return
		 */
		private static function getRegExp(index:uint):RegExp {
			if (!_regExps[index]) {
				_regExps[index] = new RegExp("\\{" + index + "\\}", "g");
			}
			return _regExps[index];
		}

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function MessageUtil() {
		}
	}
}