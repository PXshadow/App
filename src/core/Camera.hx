package core;
import camera.Camera as NativeCamera;
#if mobile
import camera.Camera as NativeCamera;
import camera.event.CameraEvent;
#end
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import haxe.io.Bytes;

/**
 * ...
 * @author 
 */
class Camera 
{
	public var getData:Bytes->Void;

	public function new(size:Int=1080,quality:Float=0.9) 
	{
		#if mobile
		NativeCamera.Initialize();
		App.main.stage.addEventListener(CameraEvent.PHOTO_CAPTURED, cameraCaptured);
		App.main.stage.addEventListener(CameraEvent.PHOTO_CANCELLED, cameraCanceled);
		NativeCamera.CapturePhoto(size, quality);
		#end
	}
	#if mobile
	public function cameraCaptured(e:CameraEvent)
	{
        if (getData != null) getData(e.GetImageData());
		remove();
	}
	public function cameraCanceled(e:CameraEvent)
	{
		trace("cancel " + e);
		remove();
	}
	public function remove()
	{
		App.main.stage.removeEventListener(CameraEvent.PHOTO_CAPTURED, cameraCaptured);
		App.main.stage.removeEventListener(CameraEvent.PHOTO_CANCELLED, cameraCanceled);
		getData = null;
	}
	#end
	
}