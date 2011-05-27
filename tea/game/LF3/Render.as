package tea.game.LF3 {
	import flash.display.BitmapData;
	class Render {
		static public var share:Render;
		static public function sharedInstance():Render {
			if (share == null) {
				share = new gameLoop();
			}
			return share;
		}
		
		public var stageWidth:uint = 960;
		public var stageHeight:uint = 600;
		public var stagefps:Number = 30;
		
		private var MCgame:MovieClip;
		private var MainGameBMD:BitmapData;
		private var MainGameBMP:Bitmap;
		public function Render() {
			MCgame = new MovieClip();
			MainGameBMD = new BitmapData(stageWidth, stageHeight, true, 0);
			MainGameBMP = new Bitmap(MainGameBMD, "auto", true);
			MCgame.addChild(MainGameBMP);
		}
		
	}
}