package core;
import haxe.Constraints.Function;
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
	public var Click:Dynamic->Void;
	public var mouseOut:Bool = true;
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
                                                                             //invis button
	public function new(?xpos:Int=0,?ypos:Int=0,path:String="",sWidth:Int=-1,sHeight:Int=-1) 
{	
    super();
buttonMode = true;
if(path.length > 0)
{
updateGraphic(path,sWidth,sHeight,false);
}else{
if(sWidth > 0)
{
//invis button
this.graphics.beginFill(0, 0);
this.graphics.drawRect(0, 0, sWidth, sHeight);
}
}
x = xpos;
y = ypos;
addEventListener(Event.REMOVED_FROM_STAGE, remove);
addEventListener(Event.ADDED, add);
}

public function updateGraphic(path:String,sWidth:Int=-1,sHeight:Int=-1,clear:Bool=true)
{
	if(clear)graphics.clear();
	
if(path.substring(path.length - 4, path.length) == ".png")
{
var bmd = Assets.getBitmapData(path);
var mat = new Matrix();
var sx:Float = 1;
var sy:Float = 1;
if(sWidth > 0) sx = 1 / bmd.width * sWidth;
if(sHeight > 0) sy = 1 / bmd.height * sHeight;
mat.scale(sx, sy);
graphics.beginBitmapFill(bmd,mat, false, true);
graphics.drawRect(0, 0, sx * bmd.width, sy * bmd.height);
vector = false;
}else{
//svg
new SVG(Assets.getText(path)).render(graphics, 0, 0, sWidth, sHeight);
vector = true;
}
	
}
  /*
   * Mouse out is true
   * */
	public function add(_)
	{
		addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
		addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		addEventListener(MouseEvent.CLICK, mouseClick);
		if(mouseOut)addEventListener(MouseEvent.MOUSE_OUT, mouseUp);
		removeEventListener(Event.ADDED, add);
	}
    public function remove(_)
    {
        removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
        removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		if(mouseOut)removeEventListener(MouseEvent.MOUSE_OUT, mouseUp);
		removeEventListener(MouseEvent.CLICK, mouseClick);
		removeEventListener(Event.REMOVED_FROM_STAGE, remove);
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
	public function drawRect(setWidth:Float=0,setHeight:Float=0,setX:Int=0,setY:Int=0)
	{
		graphics.endFill();
		graphics.beginFill(0, 0);
		if (setWidth <= 0) setWidth = width;
		if (setHeight <= 0) setHeight = height;
		graphics.drawRect(setX,setY, setWidth, setHeight);
		graphics.endFill();
		rectBool = true;
	}

}