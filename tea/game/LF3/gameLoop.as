package tea.game.LF3 {
	public class gameLoop 
	{
		static public var share:gameLoop;
		static public function sharedInstance():gameLoop {
			if (share == null) {
				share = new gameLoop();
			}
			return share;
		}
		//var
		//public
		public function gameLoop() :void{
			
		}
		public function runLoop():void {
			/*
			input
			 * user
			 * ai
			 * network
			*/
			
			//input change
			
			//auto change
			
			//hitTest
			//hitchange
			
			//phy
			//phy change
			
			//rule
		}
		//private
		
	}
}