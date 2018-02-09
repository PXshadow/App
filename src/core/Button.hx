package core;
import haxe.Constraints.Function;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.display.Bitmap;
import openfl.Assets;
import format.SVG;
import openfl.events.Event;

class Button extends Sprite 
{

    public var bitmap:Bitmap;
	//functions 
	public var Down:Dynamic->Void;
	public var Up:Dynamic->Void;
	public var Click:Dynamic->Void;
	public var mouseOut:Bool = true;
	public var pathString:String;
	public var rectBool:Bool = false;
	public var bool:Bool = false;
                                                                             //invis button
	public function new(?xpos:Int=0,?ypos:Int=0,path:String="",sWidth:Int=-1,sHeight:Int=-1) 
{	
    super();
bitmap = new Bitmap();
bitmap.smoothing = true;
buttonMode = true;
if(path.length > 0)
{
if(path.substring(path.length - 4, path.length) == ".png")
{
bitmap.bitmapData = Assets.getBitmapData(path);
if(sWidth > 0)bitmap.width = sWidth;
if(sHeight > 0)bitmap.height = sHeight;
}else{
//svg
new SVG(Assets.getText(path)).render(this.graphics, 0, 0, sWidth, sHeight);
pathString = path.substring(0,path.length - 4);
}
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
addChild(bitmap);
addEventListener(Event.REMOVED_FROM_STAGE, remove);
addEventListener(Event.ADDED, add);
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
	public function drawRect(setWidth:Float=0,setHeight:Float=0)
	{
		graphics.beginFill(0, 0);
		if (setWidth <= 0) setWidth = width;
		if (setHeight <= 0) setHeight = height;
		graphics.drawRect(0, 0, setWidth, setHeight);
		graphics.endFill();
		rectBool = true;
	}
	public function pressed(stg:String)
	{
		graphics.clear();
		new SVG(Assets.getText(stg + ".svg")).render(graphics);
		if (rectBool) drawRect();
	}
	public function unPressed()
	{
		graphics.clear();
		new SVG(Assets.getText(pathString + ".svg")).render(graphics);
		if (rectBool) drawRect();
	}
	



}