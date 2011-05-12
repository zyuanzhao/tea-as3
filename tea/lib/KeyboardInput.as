package tea.lib{
	import flash.events.KeyboardEvent;
	import flash.display.Stage;

	public class KeyboardInput
	{
		public var direct:Array;
		public var isDown:Array;
		private var IPCode:Object;
		private var _stage:Stage
		
		public function KeyboardInput(__stage:Stage):void {
			IPCode = { UP:87, DOWN:83, LEFT:65, RIGHT:68, JUMP:74 };
			isDown = [];
			direct = [0, 0];
			for (var k:String in IPCode) {
				isDown[k] = false;
			}
			_stage = __stage;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN,kd);
			_stage.addEventListener(KeyboardEvent.KEY_UP,ku);
		}
		private function kd(e:KeyboardEvent):void {
			for (var k:String in IPCode) {
				if (e.keyCode == IPCode[k]) {
					isDown[k] = true;
				}
			}
			isDown[e.keyCode] = true;
			if (e.keyCode==IPCode.UP) {
				direct[1]=-1;
			} else if (e.keyCode==IPCode.DOWN) {
				direct[1]=1;
			}
			if (e.keyCode==IPCode.LEFT) {
				direct[0]=-1;
			} else if (e.keyCode==IPCode.RIGHT) {
				direct[0]=1;
			}
		}
		private function ku(e:KeyboardEvent):void {
			for (var k:String in IPCode) {
				if (e.keyCode == IPCode[k]) {
					isDown[k] = false;
				}
			}
			isDown[e.keyCode] = false;
			if (e.keyCode==IPCode.UP && direct[1]==-1) {
				direct[1]=0;
			} else if (e.keyCode==IPCode.DOWN && direct[1]==1) {
				direct[1]=0;
			}
			if (e.keyCode==IPCode.LEFT && direct[0]==-1) {
				direct[0]=0;
			} else if (e.keyCode==IPCode.RIGHT && direct[0]==1) {
				direct[0]=0;
			}
		}
				
	}
	
}