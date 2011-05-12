package tea.lib{
	import flash.display.BitmapData;
	public class setBitmap{
		public function setBitmap():void{
		}
		static public function blackWhite(bmd:BitmapData,rate:int=172):BitmapData{
			for(var i:int=0;i<bmd.width;i++){
				for(var j:int=0;j<bmd.height;j++){
					var c:int=( bmd.getPixel(i,j) & 0xff )>rate?0xff:0
					bmd.setPixel(i,j,(c<<16)+(c<<8)+c)
				}
			}
			return bmd
		}
	}
}