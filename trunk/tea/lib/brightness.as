package tea.lib
{
    import flash.display.*;
    import flash.geom.*;

    public class brightness extends Object
    {

        public function brightness()
        {
            return;
		}

        public static function setBrightness(mc:MovieClip, rate:int) : void
        {
            var storeAlpha:int = mc.alpha;
            var _loc_4:ColorTransform = new ColorTransform();
          	_loc_4.blueOffset = rate
            _loc_4.greenOffset = rate;
            _loc_4.redOffset = rate;
            mc.transform.colorTransform = _loc_4;
            mc.alpha = storeAlpha;
            return;
        }// end function

    }
}
