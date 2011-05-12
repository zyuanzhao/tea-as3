package tea.lib{
	import flash.display.*;
	import flash.events.Event;
	import flash.text.TextField;
	public class setStageBmp extends MovieClip{
		private var stageBMD:BitmapData=new BitmapData(480,320,false,0x0000ff);
		private var stageBMP:Bitmap=new Bitmap(stageBMD);
		private var pastTimer:uint=getTimer();
		public function setStageBmp() {
			stage.quality="low";
			addChild(stageBMP);
			var tf:TextField=new TextField();
			addChild(tf);
			addEventListener(Event.ENTER_FRAME,etf);
		}
		private function etf(e:Event):void {
			pastTimer=getTimer();
			for (var _x:uint=0; _x<stageBMD.width; _x++) {
				for (var _y:uint=0; _y<stageBMD.height; _y++) {
					stageBMD.setPixel(_x,_y,stageBMD.getPixel(_x,_y)+50);
				}
			}
			tf.text=(1000/(getTimer()-pastTimer)).toString();
		}
	}
}