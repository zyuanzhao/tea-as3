package tea.game {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	public class Block2d {
		public function Block2d():void {}
		static public function checkBlock(nPos:Rectangle,BlockList:Array ):Point {
			for (var i in BlockList) {
				if (nPos.intersects(BlockList[i])) {
					nPos = moveRect(nPos, BlockList[i]);
				}
			}
			return new Point(nPos.x, nPos.y);
		}
		static private function moveRect(nPos:Rectangle,b:Rectangle):Rectangle {
			var rs:Rectangle=nPos.intersection(b);
			var m2:Rectangle=nPos.clone();
			var np:Point = new Point(nPos.x < b.x?
				b.x - nPos.width:b.x + b.width,
				nPos.y<b.y?b.y-nPos.height:b.y+b.height);
			if (Math.abs(np.x-m2.x)<Math.abs(np.y-m2.y)) {
				m2.x=np.x;
				if (! m2.intersects(b)) {
					return m2;
				}
				m2.x=nPos.x;
				m2.y=np.y;
				if (! m2.intersects(b)) {
					return m2;
				}
			} else {
				m2.y=np.y;
				if (! m2.intersects(b)) {
					return m2;
				}
				m2.x=nPos.x;
				m2.x=np.x;
				if (! m2.intersects(b)) {
					return m2;
				}
			}
			if (nPos.intersects(b)) {
				trace('夾');
			}
			return nPos;
			//
		}
	}
}