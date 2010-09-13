package pt.wiz.dorothy.debug
{
		import nl.demonsters.debugger.MonsterDebugger;

        import org.as3commons.logging.ILogger;
        import org.as3commons.logging.ILoggerFactory;

        /**
         * Provides a bridge between the AS3Commons Logging Framework and MonsterDebugger.
         *
         * @author John Reeves
         */
        public class MonsterDebuggerLoggerFactory implements ILoggerFactory
        {
               
               private var logger:MonsterDebugger;
                /**
                 * Initialises MonsterDebugger
                 *
                 * @param target                The Base Object you wisht to start graphing from (usually you will supply the
                 *                                              Display Root DisplayObject).
                 *                                     
                 * @param clearConsole  Clears MonsterDebugger’s Trace Console when the initial connection is made.
                 */
                public function MonsterDebuggerLoggerFactory(target : Object, clearConsole : Boolean = true)
                {
                        logger = new MonsterDebugger(target);
                        if (clearConsole)
                        {
                                MonsterDebugger.clearTraces();
                        }
                }

                /**
                 * Factory Method, used to return an instance of ILogger to the AS3Commons Logging Framework.
                 */
                public function getLogger(name : String) : ILogger
                {
                        return new MonsterDebuggerLogger(name);
                }
        }
}