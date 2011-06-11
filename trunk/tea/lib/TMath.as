package tea.lib{
	import flash.geom.Point;
	public class TMath {
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
			if (pt.x==_o.x) {
				return 0;
			}
			return Math.atan((pt.y - _o.y) / (pt.x - _o.x));
		}
		static public function limit(num:Number,min:Number=0,max:Number=Infinity,border:Number=0):Number {
			return Math.max(min+border,Math.min(max-border,num));
		}
		static public function crop(num:Number):Number {
			return Math.round(num * 10) / 10;
		}
		static public function flipAngle(r:Number,xy):Number {
			if (xy=='x') {
				return inCircle(2 * Math.PI - r);
			} else if (xy=='y'){
				return inCircle(2 * Math.PI - inCircle(r - Math.PI / 2) + Math.PI / 2);
			}else {
				return inCircle(2 * Math.PI - inCircle(r - xy) + xy);
			}
		}
		static public function inCircle(a:Number):Number {
			return inLoop(a,Math.PI*2);
		}
		static public function inLoop(a:Number, b:Number):Number {
			return a % b < 0?b + (a % b):a % b;
		}
		static public function toR(d:Number):Number{
			return (d * Math.PI) / 180;
		}
		static public function toD(r:Number):Number{
			return Math.round((r / Math.PI) * 180);
		}
		static public function getRot(p1:Point, p2:Point):Number {
			var rot=Math.atan((p1.x-p2.x)/(p1.y-p2.y));
			if(p2.y<=p1.y)rot+=Math.PI;
			return inCircle(rot);
		}
		static public function angleDiff(p1:Number, p2:Number):Number {
			p1 = inCircle(p1);
			p2 = inCircle(p2);
			var r = inCircle(Math.abs(inCircle(p1 - p2))) < Math.PI ? p2 - p1 : p2 - p1;
			return Math.abs(r)>Math.PI ? -((Math.PI*2*abs(r))-r) : r;
			//return inCircle(inCircle(Math.abs(inCircle(p1 - p2))) < Math.PI? p1 - p2 - Math.PI * 2:p1 - p2);
		}
		static public function abs(r) {
			return r / Math.abs(r);
		}
		static function similar(a:Number, b:Number, rate:Number = 0.99):Boolean {
			if(a==b)return true
			return Math.min(a, b) / Math.max(a, b) >= rate;
		}
	}
}