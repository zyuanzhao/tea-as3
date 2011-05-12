package tea.lib{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	public class CropBmp {
		public function CropBmp() {
		}
		public static function crop(bmd:BitmapData,w:int,h:int):BitmapData {
			var bmd2:BitmapData=new BitmapData(w,h,false,0xffffff);
			var bmp:Bitmap=new Bitmap(bmd);
			var scale=Math.max(w/bmd.width,h/bmd.height);
			var m5=-((bmd.width*scale)-w)/2;
			var m6=-((bmd.height*scale)-h)/2;
			var myMatrix:Matrix=new Matrix(scale,0,0,scale,m5,m6);
			bmd2.draw(bmp,myMatrix);
			return bmd2;
		}
	}
}