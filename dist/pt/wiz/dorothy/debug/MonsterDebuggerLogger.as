package pt.wiz.dorothy.debug
{
	import org.as3commons.logging.util.MessageUtil;
        import nl.demonsters.debugger.MonsterDebugger;

        import org.as3commons.logging.LogLevel;
        import org.as3commons.logging.impl.AbstractLogger;

        /**
         * Provides a bridge between the AS3 Commons Logging implementation and Monster Debugger; it’s not perfect but it
         * works for the most part.
         *
         * The Target of the log message will always be the name of the logger.
         *
         * The Object of the log message will vary depending on the parameters passed.  If the message string is empty
         * then the params Array will be logged.  If the message string is not empty, the params Array will be used to
         * tokenise the message string.
         *
         * Usage:
         *              LOGGER.debug("Hello World");            // Outputs message: "(String) Hello World"
         *              LOGGER.debug("Hello {0} {1}, "Jonny", "Reeves");        // Outputs message: "(String) Hello Jonny Reeves"
         *              LOGGER.debug("", [ 1, 2, 3 ]);          // Outputs message: "(Array)…" (which can then be inspected)
         *             
         * Incorrect usage:
         *              LOGGER.debug("Some Array", [1, 2, 3]);  // Outputs message: "(String) Some Array" (which can’t be inspected)
         *
         * @author John Reeves
         */
        public class MonsterDebuggerLogger extends AbstractLogger
        {
                public var level : int = LogLevel.DEBUG;

                public function MonsterDebuggerLogger(name : String)
                {
                        super(name);
                }

                override protected function log(level : uint, message : String, params : Array) : void
                {
                        if (level >= this.level)
                        {
                                var target : Object = name;
                                var object : Object = getLogObject(message, params);
                                var colour : uint = getLogMessageColour(level);
                                MonsterDebugger.trace(target, object, colour);
                        }
                }

                private function getLogObject(message : String, params : Array) : Object
                {
                        if (message == "")
                        {
                                // If the user only supplied a single param to log, we remove the params array which is enclosing it.
                                return (params.length == 1) ? params.pop() : params;
                        }
                        else
                        {
                                return MessageUtil.toString(message, params);
                        }
                }

                private function getLogMessageColour(level : int) : uint
                {
                        var colour : int;
                        switch (level)
                        {
                                case LogLevel.FATAL:
                                case LogLevel.ERROR:
                                        colour = MonsterDebugger.COLOR_ERROR;
                                        break;
                                       
                                case LogLevel.WARN:
                                        colour = MonsterDebugger.COLOR_WARNING;
                                        break;
                               
                                default:
                                        colour = MonsterDebugger.COLOR_NORMAL;
                                        break;
                        }
                        return colour;
                }

                override public function get debugEnabled() : Boolean
                {
                        return LogLevel.DEBUG >= level;
                }

                override public function get errorEnabled() : Boolean
                {
                        return LogLevel.ERROR >= level;
                }

                override public function get infoEnabled() : Boolean
                {
                        return LogLevel.INFO >= level;
                }

                override public function get warnEnabled() : Boolean
                {
                        return LogLevel.WARN >= level;
                }

                override public function get fatalEnabled() : Boolean
                {
                        return LogLevel.FATAL >= level;
                }
        }
}