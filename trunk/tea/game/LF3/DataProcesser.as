package tea.game.LF3 {
	public class DataProcesser{
		static public var share:DataProcesser;
		public var dataList:XML;
		public var bmpList:XML;
		static public function getInstance():DataProcesser {
			if (share == null) {
				share = new DataProcesser();
			}
			return share;
		}
		public function DataProcesser():void {
			
		}
	}
}