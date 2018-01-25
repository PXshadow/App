package src.app;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import format.SVG;

class Button extends Sprite 
{

    var bitmap:Bitmap;
	public var mouseDown:Dynamic->Void;
	public var mouseUp:Dynamic->Void;
	public var mouseClick:Dynamic->Void;
	private var mo:Bool = true;
	public var pathString:String;
	public var rectBool:Bool = false;
	public var bool:Bool = false;
                                                                             //invis button
	public function new(?xpos:Int=0,?ypos:Int=0,path:String="",sWidth:Int=-1,sHeight:Int=-1) 
	{
    super();
buttonMode = true;
cacheAsBitmap = true;
if(path.length > 0)
{
if(path.substring(path.length - 4, path.length) == ".png")
{
bitmap = new Bitmap(Assets.getBitmapData(path));
this.addChild(bitmap);
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
   }
  /*
   * Mouse out is true
   * */
	public function createEvents(mouseOut:Bool=true)
	{

if(mouseDown != null)addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
if(mouseUp != null)addEventListener(MouseEvent.MOUSE_UP, mouseUp);
if(mouseClick != null)addEventListener(MouseEvent.CLICK, mouseClick);
mo = mouseOut;
if(mo && mouseUp != null) addEventListener(MouseEvent.MOUSE_OUT, mouseUp);
	}

    public function removeEvents()
    {
        if(mouseDown != null)removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
        if(mouseUp != null)removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		if (mo && mouseUp != null) removeEventListener(MouseEvent.MOUSE_OUT, mouseUp);
		if(mouseClick != null)removeEventListener(MouseEvent.CLICK, mouseClick);
    }
	
	public function drawRect()
	{
		graphics.beginFill(0, 0);
		graphics.drawRect(0, 0, width, height);
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