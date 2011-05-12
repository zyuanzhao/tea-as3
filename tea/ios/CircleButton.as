package tea.ios{
	import flash.geom.Point;
	import flash.utils.getTimer;
	public class CircleButton{
		public var key:String;
		public var center:Point;
		public var minRange:int;
		public var maxRange:int;
		public var priority:int;
		
		public var touch:Boolean;
		public var startTime:int;
		public var currentTouchID:int;
		
		public function CircleButton(pt:Point,n:String="",pr:int=0,r1:int=20,r2:int=35):void {
			center=pt;
			minRange=r1;
			maxRange=r2;
			priority=pr;
			touch=false;
			startTime=0
			key=n;
			currentTouchID=-1;
		}
		public function get holdTime():int{
			return getTimer()-startTime
		}

	}

}