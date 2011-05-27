package tea.lib{
	import flash.utils.ByteArray;

	public class Lf2data {

		private var keyArray:ByteArray;
		
		public function Lf2data() {
			// constructor code
		}

		static public function decode(dat:ByteArray, codekey:String = 'SiuHungIsAGoodBearBecauseHeIsVeryGood', beginPos:int = 123):ByteArray {
			keyArray = new ByteArray();
			for (var i:uint = 0; i < codekey.length; i++ ) {
				keyArray[i] = codekey.charCodeAt(i);
			}
			dat.position=beginPos;
			var code:ByteArray=new ByteArray();
			while (dat.position<dat.length) {
				//var cs:int=dat.readUnsignedByte()-codekey.charCodeAt((dat.position-1)%codekey.length);
				//code.writeByte(cs<0?cs+=256:cs);
				code.writeByte(dat.readUnsignedByte() - keyArray[(dat.position - 1) % codekey.length]);
			}
			return code;
		}
		
		static public function encode(dat:ByteArray,codekey:String='SiuHungIsAGoodBearBecauseHeIsVeryGood',beginPos:int=123):ByteArray {
			var code:ByteArray=new ByteArray();
			for(var i=0;i<beginPos;i++){
				code.writeByte(0);
			}
			dat.position=0;
			while (dat.position<dat.length) {
				var cs:int=dat.readUnsignedByte()+codekey.charCodeAt(code.position%codekey.length);
				code.writeByte(cs>255?cs-=256:cs);
			}
			return code;
		}
		
		static public function toXML(dat:ByteArray):XML{
			
		}
		
	}

}