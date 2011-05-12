/*
import flash.errors.IOError;
import flash.net.URLRequest;
import tea.lib.loadAllPhoto
var myLoadAllPhoto=new loadAllPhoto(Array contain list of URLequest[,totalPhotoSize])

myLoadAllPhoto.percentpercent loaded range 0~1
myLoadAllPhoto.loadednum of photos finish loading
myLoadAllPhoto.totalnum of photos total
myLoadAllPhoto.bmpList[]array of loaded bitmap data
*/
package tea.lib
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.*;
	import flash.system.LoaderContext;
	
	import flash.net.URLRequest;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Matrix;
	
	import flash.external.ExternalInterface;
	
	import tea.lib.makePattern;
	import tea.lib.setBitmap;
	
	public class loadAllPhoto
	{
		private var pathList:Array;
		private var bytesloadedList:Array=new Array();
		private var loaderList:Array=new Array();
		private var totalSize;
		private var index = [];
		public var loaded:int = 0;
		public var bmpList:Array=new Array();
		public var total:int = 0;
		private var lc:LoaderContext = new LoaderContext(true);
		public function loadAllPhoto(p,_totalSize=null):void
		{
			if (p.length == 0)
			{
				trace('no pd');
				return;
			}
			pathList = p;
			totalSize = _totalSize;
			for (var i in pathList)
			{
				index.push(i);
				total++;
				var url:String = (pathList[i] as URLRequest).url;
				var ext:String = url.toLowerCase().substr(url.length - 3);

				if(ext=="jpg" || ext=="gif" || ext=="png" || ext=="bmp"){
					loaderList[i]=new Loader();
					loaderList[i].contentLoaderInfo.addEventListener(Event.INIT, initDo);
					loaderList[i].contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
					/*loaderList[i].contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
					loaderList[i].contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
					loaderList[i].contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);*/
					loaderList[i].x = i;
					loaderList[i].load(pathList[i], lc);
				}else {
					loaded++;
					bmpList[i] = setBitmap.blackWhite(makePattern.text2pattern(url),165);
				}
			}
			//var t=index.shift;//loaderList[t].load(pathList[t],lc)
		}
		public function get percent():Number
		{
			if (loaded == total)
			{
				return 1;
			}
			if (totalSize == null)
			{
				return loaded/total;
			}
			else
			{
				var totalbytesloaded:int = 0;
				for (var i in bytesloadedList)
				{
					totalbytesloaded +=  bytesloadedList[i];
				}
				if (totalbytesloaded >= totalSize && loaded != total)
				{
					return 0.99;
				}
				else
				{
					return totalbytesloaded/totalSize;
				}
			}
		}
		private function initDo(e)
		{
			loaded++;
			bmpList[e.currentTarget.loader.x] = e.currentTarget.loader.content.bitmapData;
		}
		
		private function onHTTPStatus(e:HTTPStatusEvent):void
		{
			if (e.status == 404) {
				loaded++;
				//bmpList[e.currentTarget.loader.x] = bmpList[0];
				//bmpList[e.currentTarget.loader.x] = text2pattern((e.currentTarget as LoaderInfo).url);
			}
			//ExternalInterface.call("console.log","HTTPStatusEvent: "+e.toString());
		}
		
		/*private function onComplete(e:Event):void
		{
			ExternalInterface.call("console.log","onComplete: "+e.toString());
		}
		
		private function onHTTPStatus(e:HTTPStatusEvent):void
		{
			if (e.status == 404) {
				loaded++;
				bmpList[e.currentTarget.loader.x] = text2pattern((e.currentTarget as LoaderInfo).url);
			}
			ExternalInterface.call("console.log","HTTPStatusEvent: "+e.toString());
		}

		private function onIOError(e:IOErrorEvent):void
		{
			loaded++;
			bmpList[e.currentTarget.loader.x] = text2pattern((e.currentTarget as LoaderInfo).url);
			ExternalInterface.call("console.log","onIOError: "+e.toString());
		}*/
	}
}