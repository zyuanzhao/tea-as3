package tea.lib{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Matrix;
	import flash.text.TextFieldAutoSize;
	
	public class makePattern {
		private var w:int;
		private var h:int;
		public function makePattern(_w:int=60,_h:int=60):void {
			w=_w;
			h=_h;
		}
/*		public function cropPhoto(bmd:BitmapData):BitmapData {
			var scale=Math.max(w/bmd.width,h/bmd.height)
			trace(w/bmd.width,h/bmd.height)
			var bmp:Bitmap=new Bitmap(bmd)
			bmp.scaleX=bmp.scaleY=scale
			var mc:MovieClip=new MovieClip();
			mc.addChild(bmp);
			trace(scale)
			var bmd2:BitmapData=new BitmapData(w,h,false)
			bmd2.draw(mc,new Matrix(1,0,0,1,))
			return bmd2
		}*/
		public static function text2pattern(str:String):BitmapData {
			var tf:TextField=new TextField();
			tf.text = str;
			var format = new TextFormat('Arial', 16, 0x000000, null, null, null, null, null, 'center', 0, 0, null, 3);
			tf.setTextFormat(format);
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.width = Math.min(120, tf.width+16);
			tf.multiline = true;
			tf.wordWrap = true;
			var mc:MovieClip=new MovieClip();
			mc.addChild(tf);
			var bmd:BitmapData = new BitmapData(mc.width, mc.height, false);
			bmd.draw(mc);
			return bmd;
		}
		//
	}
}