package core.display;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import haxe.io.Bytes;
import openfl.Assets;
/**
 * ...
 * @author 
 */
class ProfileIcon extends Button
{
	public var id:Int;
	private var _size:Int;
	public var icon:Bitmap;

    public function new(?x:Int=0,?y:Int=0,path:String="",size:Int=90,setId:Int=0)
    {
        super(x, y,"",size, size,true);
		id = setId;
		_size = size;
		icon = new Bitmap();
		addChild(icon);
		loadIcon(path);
    }
	
	public function updateBase(data:String)
	{
		BitmapData.loadFromBase64(data, "image/png").onComplete(function(bmd:BitmapData)
		{
			setBitmapData(bmd);
		});
	}
public function updateBytes(data:Bytes)
{
BitmapData.loadFromBytes(data).onComplete(function(bmd:BitmapData)
{
	setBitmapData(bmd);
});
}

public function setBitmapData(bmd:BitmapData)
{
	/*graphics.clear();
	var mat = new Matrix();
	var sx:Float = 1;
	var sy:Float = 1;
	sx = 1 / bmd.width * _size;
	sy = 1 / bmd.height * _size;
	mat.scale(sx, sy);
	graphics.beginBitmapFill(bmd, mat, false, true);*/
}

public function loadIcon(string:String)
{
	if(icon.bitmapData != null)icon.bitmapData.dispose();
	Assets.loadBitmapData(string, false).onComplete(function(bmd:BitmapData)
	{
		icon.bitmapData = bmd;
		icon.smoothing = true;
		icon.width = _size;
		icon.height = _size;
	});
}

}