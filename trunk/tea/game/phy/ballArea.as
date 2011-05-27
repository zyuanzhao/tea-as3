package tea.game.phy{
	public class ballArea implements IballArea
	{
		public var r:Number;
		public var mass:Number=60;
		public var xsp:Number=0;
		public var ysp:Number=0;
		public function ballArea(_r:Number) {
			r = _r;
		}
	}
}