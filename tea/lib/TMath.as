package tea.lib{
	import flash.geom.Point;
	public class TMath
	{
		static public function avg(...args):Number {
			var tempnum:Number=0;
			for (var i:uint=0; i<args.length; i++) {
				tempnum+=args[i];
			}
			return tempnum/args.length;
		}
		static public function slope(p1:Point, p2:Point):Number {
			return (p2.y - p1.y) / (p2.x - p1.x);
		}
		static public function tan(_o:Point, pt:Point):Number {
			if (pt.x == _o.x) return 0;
			return Math.atan((pt.y - _o.y) / (pt.x - _o.x));
		}
		static public function limit(num:Number,min:Number,max:Number=Infinity,border:Number=0):Number{
			return Math.max(min+border,Math.min(max-border,num));
		}
		static public function crop(num:Number):Number{
			return Math.round(num * 10) / 10;
		}
	}
	
}