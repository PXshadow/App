package core;
import haxe.Constraints.Function;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.display.Bitmap;
import openfl.Assets;
import format.SVG;
import openfl.events.Event;
import openfl.geom.Matrix;

class Button extends Sprite 
{
	//functions 
	public var Down:Dynamic->Void;
	public var Up:Dynamic->Void;
	public var Over:Dynamic->Void;
	public var Out:Dynamic->Void;
	public var outUp:Bool = true;
	public var Click:Dynamic->Void;
	
	public var rectBool:Bool = false;
	@:isVar public var bool(get,set):Bool = false;
	public function get_bool():Bool
	{
		return bool;
	}
	public function set_bool(value:Bool):Bool
	{
		return bool = value;
	}
	public var vector:Bool = true;
	public function new(?xpos:Float=0,?ypos:Float=0,path:String="",sWidth:Int=-1,sHeight:Int=-1,oval:Bool=false) 
	{	
    super();
	buttonMode = true;
	if(path.length > 0)
	{
	updateGraphic(path,sWidth,sHeight,false,oval);
	}else{
	if(sWidth > 0)
	{
	//invis button
	graphics.beginFill(0, 0);
	graphics.drawRect(0, 0, sWidth, sHeight);
	}
	}
	x = xpos;
	y = ypos;
	addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
	addEventListener(Event.ADDED_TO_STAGE, addToStage);
	cacheAsBitmap = true;
	}

	public function updateGraphic(path:String,sWidth:Int=-1,sHeight:Int=-1,clear:Bool=true,oval:Bool=false)
	{
	if(clear)graphics.clear();
	
	if(path.substring(path.length - 4, path.length) == ".png")
	{
	Assets.loadBitmapData(path).onComplete(function(bmd:BitmapData)
	{
	var mat = new Matrix();
	var sx:Float = 1;
	var sy:Float = 1;
	if(sWidth > 0) sx = 1 / bmd.width * sWidth;
	if(sHeight > 0) sy = 1 / bmd.height * sHeight;
	mat.scale(sx, sy);
	graphics.beginBitmapFill(bmd, mat, false, true);
	if(oval)
	{
	graphics.drawEllipse(0,0,sx * bmd.width,sy * bmd.height);
	}else{
	graphics.drawRect(0, 0, sx * bmd.width, sy * bmd.height);
	}
	vector = false;
	});
	}else{
	//svg
	Assets.loadText(path).onComplete(function(string:String)
	{
		new SVG(string).render(graphics, 0, 0, sWidth, sHeight);
		vector = true;
	});
	}
}
  /*
   * Mouse out is true
   * */
	public function addToStage(_)
	{
		if(Down != null)addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
		if(Up != null)addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		if(Click != null)addEventListener(MouseEvent.CLICK, mouseClick);
		if(Over != null)addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
		if (Out != null)
		{
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			if(outUp)addEventListener(MouseEvent.MOUSE_UP, mouseOut);
		}
		removeEventListener(Event.ADDED, addToStage);
	}
    public function removeFromStage(_)
    {
        if(Down != null)removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
        if(Up != null)removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		if(Over != null)removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
		if (Out != null)
		{
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			if(outUp)removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		if(Click != null)removeEventListener(MouseEvent.CLICK, mouseClick);
		removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
    }
	public function mouseDown(e:MouseEvent)
	{
		if (Down != null) Down(e);
	}
	public function mouseUp(e:MouseEvent)
	{
		if (Up != null) Up(e);
	}
	public function mouseClick(e:MouseEvent)
	{
		if (Click != null) Click(e);
	}
	public function mouseOver(e:MouseEvent)
	{
		if (Over != null) Over(e);
	}
	public function mouseOut(e:MouseEvent)
	{
	   if (Out != null) Out(e);
	}
	public function drawRect(setWidth:Float=0,setHeight:Float=0,setX:Int=0,setY:Int=0)
	{
		graphics.endFill();
		graphics.beginFill(0,0);
		if (setWidth <= 0) setWidth = width;
		if (setHeight <= 0) setHeight = height;
		graphics.drawRect(setX,setY, setWidth, setHeight);
		graphics.endFill();
		rectBool = true;
	}

}