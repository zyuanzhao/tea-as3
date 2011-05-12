package tea.ios{

	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.display.MovieClip;
	import flash.utils.getTimer;
	import flash.events.TimerEvent;
	import flash.geom.Point;

	import tea.ios.CircleButton;

	public class CrossControler {

		private var directMin:int;
		private var directMax:int;
		private var directOut:int;
		private var mc:MovieClip;
		private var currentTouchList:Array;
		private var removeID:int;
		private var buttonArray:Array;
		private var boxButtonArray:Array;
		private var currentDirectTouchID:int;
		private var repositable:Boolean;
		private var borderSize:uint;
		
		public var directPoint:Point;
		public var direct_distance:Number;
		public var direct_rotation:Number;
		public var direct_X:int;
		public var direct_Y:int;

		static public var shareControl:CrossControler;

		public function CrossControler():void {
			currentDirectTouchID=-1;
			currentTouchList=new Array();
			buttonArray=new Array();
			direct_distance=0;
			direct_rotation=0;
			direct_X=0;
			direct_Y=0;
			repositable=false;
		}
		
		public function setRepositable(bool:Boolean=false,_border:uint=60):void{
			repositable=bool;
			borderSize=_border;
		}
		
		public function setMC(_mc:MovieClip):void {
			mc=_mc;
			Multitouch.inputMode=MultitouchInputMode.TOUCH_POINT;
			mc.stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBegin);
			mc.stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMove);
			mc.stage.addEventListener(TouchEvent.TOUCH_END, touchEnd);
		}

		static public function shareObject():CrossControler {
			if (! shareControl) {
				shareControl = new CrossControler();
			}
			return shareControl;
		}

		public function get containDirect():Boolean {
			return currentDirectTouchID==-1;
		}

		public function initdirect(dx:int,dy:int,min:int=15,max:int=85,out:int=155) {
			directPoint=new Point(dx,dy);
			directMin=min;
			directMax=max;
			directOut=out;
		}

		public function addCircleButton(...arg):void {
			for(var i in arg)buttonArray.push(arg[i]);
		}

		private function touchBegin(e:TouchEvent):void {
			if(repositable){
				if((directMax+directOut)/2<Point.distance(directPoint,stagePoint(e))){// && currentDirectTouchID==-1){
					directPoint=new Point(
						Math.min(Math.max(borderSize,e.stageX),480-borderSize),
						Math.min(Math.max(borderSize,e.stageY),320-borderSize));
				}
			}
			becomeDirect(e)
			setDirect(e);
			currentTouchList.push(e.touchPointID);
			pressBtn(e);
		}
		private function touchMove(e:TouchEvent):void {
			becomeDirect(e)
			if (currentDirectTouchID==e.touchPointID&&Point.distance(directPoint,stagePoint(e))>directOut) {
				clearDirect()
			}
			setDirect(e);
			pressBtn(e);
			outBtn(e);
		}
		private function touchEnd(e:TouchEvent):void {
			if (currentDirectTouchID==e.touchPointID) {
				clearDirect()
			}
			removeID=e.touchPointID;
			currentTouchList=currentTouchList.filter(removeFromCurrentList);
			clearBtn(e.touchPointID);
		}
		private function clearDirect():void{
			currentDirectTouchID=-1;
			direct_distance=0;
			direct_rotation=0;
			direct_X=0;
			direct_Y=0;
		}
		private function removeFromCurrentList(item:int,index:int,array:Array):Boolean {
			return item!=removeID;
		}
		
		private function clearBtn(id:int):void {
			for (var i=0;i<buttonArray.length;i++) {
				var btn=buttonArray[i];
				if (btn.currentTouchID==id && btn.touch) {
					btn.currentTouchID=-1;
					btn.startTime=0;
					btn.touch=false;
				}
			}
		}

		private function outBtn(e:TouchEvent):Boolean {
			var touched:Boolean=false
			for (var i=0;i<buttonArray.length;i++) {
				var btn=buttonArray[i];
				if (btn.touch && btn.currentTouchID==e.touchPointID && Point.distance(btn.center,stagePoint(e))>btn.maxRange) {
					btn.currentTouchID=-1;
					btn.startTime=0;
					btn.touch=false;
					touched=true;
				}
			}
			return touched;
		}

		private function pressBtn(e:TouchEvent):Boolean {
			var touched:Boolean=false
			for (var i=0;i<buttonArray.length;i++) {
				var btn=buttonArray[i];
				if (Point.distance(btn.center,stagePoint(e))<=btn.maxRange && !btn.touch) {
					btn.currentTouchID=e.touchPointID;
					btn.startTime=getTimer();
					btn.touch=true;
					mc.txt2.appendText(buttonArray[i].key);
					touched=true;
				}
			}
			return touched;
		}

		private function becomeDirect(e:TouchEvent):Boolean {
			if (currentDirectTouchID==-1&&Point.distance(directPoint,stagePoint(e))<directMax) {
				currentDirectTouchID=e.touchPointID;
				return true;
			}
			return false;
		}

		private function setDirect(e:TouchEvent):void {
			if (currentDirectTouchID==e.touchPointID) {
				direct_distance=Point.distance(directPoint,stagePoint(e));
				direct_rotation=PointRotate(directPoint,stagePoint(e));
				if (direct_distance<directMin) {
					direct_X=0;
					direct_Y=0;
				} else {
					direct_distance*1.3;
					var d:int=Math.floor(direct_rotation/Math.PI*180);
					if (d>21&&d<159) {
						direct_X=1;
					} else if (d>201 && d<339) {
						direct_X=-1;
					} else {
						direct_X=0;
					}
					if (d<=67||d>=293) {
						direct_Y=-1;
					} else if (d>113 && d<=247) {
						direct_Y=1;
					} else {
						direct_Y=0;
					}
				}
			}
		}

		private function PointRotate(p1:Point,p2:Point):Number {
			if (p1.x==p2.x) {
				if (p1.y>p2.y) {
					return 0;
				} else {
					return Math.PI;
				}
			} else if (p1.y==p2.y) {
				if (p1.x>p2.x) {
					return Math.PI*1.5;
				} else {
					return Math.PI*0.5;
				}
			} else {
				var r=Math.atan((p2.x-p1.x)/(p2.y-p1.y));
				if (p2.x>p1.x&&p2.y<p1.y) {
					return -r;
				} else if (p2.x>p1.x || p2.y>p1.y) {
					return Math.PI-r;
				} else {
					return Math.PI*2-r;
				}
			}
		}

		public function getArrowRotate():int {
			if (direct_X==0&&direct_Y==-1) {
				return 0;
			}
			if (direct_X==1&&direct_Y==-1) {
				return 45;
			}
			if (direct_X==1&&direct_Y==0) {
				return 90;
			}
			if (direct_X==1&&direct_Y==1) {
				return 135;
			}
			if (direct_X==0&&direct_Y==1) {
				return 180;
			}
			if (direct_X==-1&&direct_Y==1) {
				return -135;
			}
			if (direct_X==-1&&direct_Y==0) {
				return -90;
			}
			return -45;
		}

		public function getDirectNum():int {
			if (direct_X==0&&direct_Y==-1) {
				return 8;
			}
			if (direct_X==1&&direct_Y==-1) {
				return 9;
			}
			if (direct_X==1&&direct_Y==0) {
				return 6;
			}
			if (direct_X==1&&direct_Y==1) {
				return 3;
			}
			if (direct_X==0&&direct_Y==1) {
				return 2;
			}
			if (direct_X==-1&&direct_Y==1) {
				return 1;
			}
			if (direct_X==-1&&direct_Y==0) {
				return 4;
			}
			if (direct_X==-1&&direct_Y==-1) {
				return 7;
			}
			return 5;
		}

		private function stagePoint(e:TouchEvent):Point {
			return new Point(e.stageX,e.stageY);
		}

	}

}