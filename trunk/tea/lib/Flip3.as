package tea.lib
{
	import flash.display.*;
	import flash.geom.Point;
	import flash.events.*;
	import flash.geom.ColorTransform;
	public class Flip3 extends Sprite
	{
		private var container:Sprite;
		private var bmd:BitmapData;
		private var auto:Boolean = false;
		private var _xcut:int;
		private var _ycut:int;
		private var drawtype:int = 1;
		private var fourPoint=[]
		private var targetPoint=[]
		//1 photo,2line,3mix
		private var autoChange:Boolean = false;
		private var _brightness:int=0;
		public function Flip3(_bmp:BitmapData):void {
			bmd = _bmp;
			container = new Sprite();
			addChild(container);
			flipIt(0, 0, bmd.width, 0, 0, bmd.height, bmd.width,bmd.height);
		}
		public function flipIt(x1, y1, x2, y2, x3, y3, x4, y4):void {
			var i;
			fourPoint[0]=new Point(x1, y1);
			fourPoint[1]=new Point(x2, y2);
			fourPoint[2]=new Point(x3, y3);
			fourPoint[3]=new Point(x4, y4);
			var vertices = new Vector.<Number>();
			var uvt = new Vector.<Number>();
			var xcut = 2//Math.max(1,int(Math.min(Point.distance(new Point(x2, y2), new Point(x1, y1)), Point.distance(new Point(x4, y4), new Point(x3, y3))) / 50));
			var ycut = 2//Math.max(1,int(Math.min(Point.distance(new Point(x4, y4), new Point(x3, y3)), Point.distance(new Point(x4, y4), new Point(x3, y3))) / 50));
			var pointList = new Array();
			for (i = 0; i <= xcut; i++) {
				pointList[i] = new Array();
				var rate:Number = i / (xcut);
				var p1:Point = Point.interpolate(new Point(x2, y2),new Point(x1, y1), rate);
				var p2:Point = Point.interpolate(new Point(x4, y4),new Point(x3, y3), rate);
				for (var j = 0; j <= ycut; j++) {
					var rate2:Number = j / (ycut);
					pointList[i][j] = Point.interpolate(p2,p1, rate2);
				}
			}			
			for (i = 0; i < xcut; i++) {
				for (j = 0; j < ycut; j++) {
					var p5list=[]
					p5list.push(
						new Point(pointList[i][j].x, pointList[i][j].y),
						new Point(pointList[i+1][j].x, pointList[i+1][j].y),
						new Point(pointList[i][j + 1].x, pointList[i][j + 1].y),
						new Point(pointList[i + 1][j + 1].x, pointList[i + 1][j + 1].y)
					)
					p5list.push(Point.interpolate(Point.interpolate(p5list[0], p5list[1], 0.5),Point.interpolate(p5list[2], p5list[3], 0.5),0.5));
					vertices.push(	
						p5list[0].x, p5list[0].y,
						p5list[1].x, p5list[1].y,
						p5list[4].x, p5list[4].y,
						
						p5list[0].x, p5list[0].y,
						p5list[2].x, p5list[2].y,
						p5list[4].x, p5list[4].y,
						
						p5list[1].x, p5list[1].y,
						p5list[3].x, p5list[3].y,
						p5list[4].x, p5list[4].y,
						
						p5list[2].x, p5list[2].y,
						p5list[3].x, p5list[3].y,
						p5list[4].x, p5list[4].y
					);
					var u5list = []
					u5list.push(
						new Point(i / (xcut), j / (ycut)),
						new Point((i+1) / (xcut), j / (ycut)),
						new Point(i / (xcut), (j + 1) / (ycut)),
						new Point((i + 1) / (xcut), (j + 1) / (ycut)),
						new Point((i + 0.5) / (xcut), (j + 0.5) / (ycut))
					)
					uvt.push(
						u5list[0].x, u5list[0].y,
						u5list[1].x, u5list[1].y,
						u5list[4].x, u5list[4].y,
						
						u5list[0].x, u5list[0].y,
						u5list[2].x, u5list[2].y,
						u5list[4].x, u5list[4].y,
						
						u5list[1].x, u5list[1].y,
						u5list[3].x, u5list[3].y,
						u5list[4].x, u5list[4].y,
						
						u5list[2].x, u5list[2].y,
						u5list[3].x, u5list[3].y,
						u5list[4].x, u5list[4].y
					);
					
				}
			}
			container.graphics.clear();
			if(drawtype!=2){
				container.graphics.beginBitmapFill(bmd);
				container.graphics.drawTriangles(vertices, null, uvt, TriangleCulling.NONE);
				container.graphics.endFill();
			}
			if(drawtype>1){
				container.graphics.lineStyle(1, 0xFF0000);				
				for (i = 0; i < vertices.length; i+=6) 
				{
					container.graphics.moveTo(vertices[i], vertices[i+1]);
					container.graphics.lineTo(vertices[i + 2], vertices[i + 3]);
					container.graphics.lineTo(vertices[i + 4], vertices[i + 5]);
					container.graphics.lineTo(vertices[i], vertices[i+1]);
				}
			}
		}
		//
		public function tweener(nextPoint){
			addEventListener(Event.ENTER_FRAME,etftweener)
			targetPoint=nextPoint;
		}
		public function etftweener(e){
			var max=0
			for(var i=0;i<4;i++){
				fourPoint[i].x+=(targetPoint[i].x-fourPoint[i].x)*0.2
				fourPoint[i].y+=(targetPoint[i].y-fourPoint[i].y)*0.2
				max=Math.max(max,Math.abs(targetPoint[i].x-fourPoint[i].x))
			}
			i=0
			flipIt(fourPoint[i].x,fourPoint[i++].y,fourPoint[i].x,fourPoint[i++].y,fourPoint[i].x,fourPoint[i++].y,fourPoint[i].x,fourPoint[i++].y)
			if(max<1)removeEventListener(Event.ENTER_FRAME,etftweener);
		}
		public function set brightness(r):void{
			var t=alpha
			if(r>255)r=255;
			else if(r<-255)r=-255;
			_brightness=int(r);
			var myColor:ColorTransform = new ColorTransform();
			myColor.redOffset = myColor.greenOffset=myColor.blueOffset = _brightness;
			transform.colorTransform = myColor;
			alpha=t
		}
		public function get brightness():int{
			return _brightness;
		}
	}
}