package tea.lib{
	import flash.display.BitmapData;
	public class hsv {
		public function hsv() {
			// constructor code
		}
		static public function getH(c:uint):Number {
			var r:uint=c>>16&0xff;
			var g:uint=c>>8&0xff;
			var b:uint=c&0xff;
			var max:uint=Math.max(r,g,b);
			var min:uint=Math.min(r,g,b);
			var h:Number=0;
			if (max==min) {
				h=0;
			} else if (max==r) {
				if (g>=b) {
					h=60*(g-b)/(max-min);
				} else {
					h=60*(g-b)/(max-min)+360;
				}
			} else if (max==g) {
				h=60*(b-r)/(max-min)+120;
			} else {
				h=60*(r-g)/(max-min)+240;
			}
			return h/180*Math.PI;
		}
		static public function getV(c:uint):uint {
			return Math.max((c>>16&0xff),(c>>8&0xff),(c&0xff));
		}
		static public function getS(c:uint):Number {

			if (getV(c)>10) {
				return 1-Math.min((c>>16&0xff),(c>>8&0xff),(c&0xff))/getV(c);
			}
			return 0;
		}
		static public function rgb2hsv(c:uint):Array {
			var r:uint=c>>16&0xff;
			var g:uint=c>>8&0xff;
			var b:uint=c&0xff;
			var max:uint=Math.max(r,g,b);
			var min:uint=Math.min(r,g,b);
			var h:Number=0;
			var s:Number=0;
			if (max==min) {
				h=0;
			} else if (max==r) {
				if (g>=b) {
					h=60*(g-b)/(max-min);
				} else {
					h=60*(g-b)/(max-min)+360;
				}
			} else if (max==g) {
				h=60*(b-r)/(max-min)+120;
			} else {
				h=60*(r-g)/(max-min)+240;
			}
			if (max!=0) {
				s=1-min/max;
			} else {
				s=0;
			}
			return [Math.PI*h/180,s,max/255];
		}
		static public function hsv2rgb(arr:Array):uint {
			var h=Math.round(arr[0]/Math.PI*180);
			var s=arr[1];
			var v:Number=255*arr[2];
			var hi:uint=Math.floor(h/60)%6;
			var f:Number=h/60-hi;
			var p:uint=Math.round(v*(1-s));
			var q:uint=Math.round(v*(1-f*s));
			var t:uint=Math.round(v*(1-(1-f)*s));
			if (hi==0) {
				return (v<<16)+(t<<8)+p;
			} else if (hi==1) {
				return (q<<16)+(v<<8)+p;
			} else if (hi==2) {
				return (p<<16)+(v<<8)+t;
			} else if (hi==3) {
				return (p<<16)+(q<<8)+v;
			} else if (hi==4) {
				return (t<<16)+(p<<8)+v;
			}
			return (v<<16)+(p<<8)+q;
		}
		static public function hChannel(bmp:BitmapData):BitmapData {
			var bmp2:BitmapData=bmp.clone();
			var temp:Array;
			for (var w:uint=0; w<bmp.width; w++) {
				for (var h:uint=0; h<bmp.height; h++) {
					temp=rgb2hsv(bmp.getPixel(w,h))
					if(temp[1]<0.01){
					   bmp2.setPixel(w,h,bmp.getPixel(w,h));
					}else{
						bmp2.setPixel(w,h,hsv2rgb([temp[0],1,1]));
					}
					
				}
			}
			return bmp2;
		}
		static public function sChannel(bmp:BitmapData):BitmapData {
			var bmp2:BitmapData=bmp.clone();
			var c:uint;
			for (var w:uint=0; w<bmp.width; w++) {
				for (var h:uint=0; h<bmp.height; h++) {
					c=255-Math.floor(getS(bmp.getPixel(w,h))*255)
					//bmp2.setPixel(w,h,(c<<8)+(c<<16)+c);
					bmp2.setPixel(w,h,hsv2rgb([0,1-c/255,1]));
					//bmp2.setPixel(w,h,hsv2rgb([0,getS(bmp.getPixel(w,h)),1]));
				}
			}
			return bmp2;
		}
		static public function vChannel(bmp:BitmapData):BitmapData {
			var bmp2:BitmapData=bmp.clone();
			var c:uint;
			for (var w:uint=0; w<bmp.width; w++) {
				for (var h:uint=0; h<bmp.height; h++) {
					c=getV(bmp.getPixel(w,h))
					bmp2.setPixel(w,h,(c<<8)+(c<<16)+c);
					//bmp2.setPixel(w,h,0xffffff-hsv2rgb([0,0,(c<<8)+(c<<16)+c]));
				}
			}
			return bmp2;
		}
		static public function combine(bmp1:BitmapData,bmp2:BitmapData,bmp3:BitmapData):BitmapData {
			var bmp0:BitmapData=bmp1.clone();
			for (var w:uint=0; w<bmp0.width; w++) {
				for (var h:uint=0; h<bmp0.height; h++) {
					//trace(getH(bmp1.getPixel(w,h)),getS(bmp2.getPixel(w,h)),getV(bmp3.getPixel(w,h)))
					bmp0.setPixel(w,h,
					  hsv2rgb([
						getH(bmp1.getPixel(w,h)),
						getS(bmp2.getPixel(w,h)),
					 	//Math.max(0,Math.min((1-getV(bmp2.getPixel(w,h))/255),1)),
					 	Math.max((getV(bmp3.getPixel(w,h))/255),0)
						//1-getS(bmp3.getPixel(w,h)),
					]));
				}
			}
			return bmp0;
		}
	}
}