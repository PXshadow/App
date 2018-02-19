package core;
import core.Button;
import openfl.display.GradientType;
import openfl.display.SpreadMethod;
import openfl.geom.Matrix;
import openfl.display.Shape;
import openfl.events.MouseEvent;
import openfl.events.Event;

class Item 
{

}

class ToggleSlider extends Button
{
    public var circle:Shape;
    public var toggleBool:Bool = false;
    public var toggle:Bool->Void;
    public var colorArray = [16777215,65280];
    public var rad:Int = 0;
    var trackDis:Int = 0;
 public function new(?sx:Int=0,?sy:Int=1,?size:Int=80)
 {
     super(sx,sy);
     rad = Math.floor(size/2);
     circle = new Shape();
     //Circle shadow
    var matrix:Matrix = new Matrix();  
    matrix.createGradientBox(rad * 2,rad * 2,0,0,0); 
     circle.graphics.beginGradientFill(GradientType.RADIAL,[0,0],[1,0.1],[0,255],matrix);
     circle.graphics.drawCircle(rad,rad,rad);
     circle.graphics.endFill();
     //circle
     circle.graphics.lineStyle(1,13158600);
     circle.graphics.beginFill(16777215);
     circle.graphics.drawCircle(rad - 2,rad -2,rad - 4);
     circle.graphics.endFill();
     addChild(circle);
     //set distance
     trackDis = Math.floor(rad * 2);
 }

 public function createTrack()
 {
     graphics.clear();
     var color:Int = 0;
     //color
     if(!toggleBool)color = colorArray[0];
     if(toggleBool)color = colorArray[1];
      graphics.lineStyle(1,13158600);
     //add circles to both side
     graphics.beginFill(color);
     graphics.drawCircle(-2 + rad,-2 + rad,rad + 2);
     graphics.beginFill(color);
     graphics.drawCircle(rad * 3,-2 + rad,rad + 2);
     //rect
     graphics.beginFill(color);
     graphics.drawRect(-2 + rad,- 4,rad * 2 + 2,rad * 2 + 4);
     //create line
    graphics.lineStyle(4,color);
    graphics.moveTo(-2 + rad,-1);graphics.lineTo(-2 + rad,rad * 2 - 3);
    graphics.lineStyle(4,color);
    graphics.moveTo(rad * 3,-1);graphics.lineTo(rad * 3,rad * 2 - 3);
 }
 
 override public function mouseDown(_)
 {
super.mouseDown(_);
if(toggleBool)
{
circle.x += -trackDis;
toggleBool = false;
createTrack();
}else{
circle.x += trackDis;
toggleBool = true;
createTrack();
}
if(toggle != null)toggle(toggleBool);
 }
 override public function mouseUp(_)
 {
super.mouseUp(_);
stopDrag();
 }

}
class ScrollBar extends Button
{
    public var downBool:Bool = false;
    public var moveDistance:Float = 0;
    public var scrollView:Array<openfl.display.DisplayObject> = [];
    public var vertical:Bool;
    private var sx:Int = 0;
    private var sy:Int = 0;

     public function new(?x:Int=0,?y:Int=0,dem:Int = 40,setVertical:Bool=true)
 {
     sx = x;sy = y;
     super(sx,sy);
     vertical = setVertical;
     create(Math.floor(dem/2));
     if(!vertical)rotation = 90;
     addEventListener(Event.ENTER_FRAME,update);
     mouseOut = false;
     scaleX = 0.7;
     scaleY = 0.9;
     App.main.onMouseUp = setRelease;
 }
 private function create(rad:Int)
 {
    var color:Int = 14474460;
     //add circles to both side
     graphics.beginFill(color);
     graphics.drawCircle(rad + 1,rad,rad + 2);
     graphics.beginFill(color);
     graphics.drawCircle(rad + 1,-2 + rad * 5,rad + 2);
     //rect
     graphics.beginFill(color);
     graphics.drawRect(0,rad,rad * 2 + 2,rad * 4 + 4);
     //create line
    graphics.lineStyle(4,color);
    graphics.moveTo(2,rad);graphics.lineTo(rad * 2,rad);
    graphics.lineStyle(4,color);
    graphics.moveTo(2,rad * 5 + 4);graphics.lineTo(rad * 2,rad * 5 + 4);
    App.main.onResize = resize;
 }
 override public function mouseDown(_)
 {
     super.mouseDown(_);
     trace("mouseOut " + mouseOut);
     downBool = true;
     App.dragBool = true;
 }
 public function setRelease(_)
 {
     downBool = false;
     App.scrollCamera();
 }
  public function update(_)
  {
    //move all Objects in Scroll View
    if(vertical)
    {
    if(Math.abs(App.scrollSpeedY) > 0)
    {
    for(obj in scrollView)
    {
        obj.y += App.scrollSpeedY;
    }
    y += App.scrollSpeedY;
    if(y < -height/2)y = App.setHeight - height/2;
    if(y > App.setHeight - height/2)y = -height/2;
    }else{
    if(!downBool)App.dragBool = false;
    }
    }else{
    //horizontal
    if(Math.abs(App.scrollSpeedX) > 0)
    {
    for(obj in scrollView)
    {
        obj.x += App.scrollSpeedX;
    }
    x += App.scrollSpeedX;
    trace("x " + x);
    if(x < width/2)x = App.setWidth + width/2;
    if(x > App.setWidth + width/2)x = width/2;
    }else{
    if(!downBool)App.dragBool = false;
    }
    }
  }
  override public function remove(_)
 {
     super.remove(_);
     removeEventListener(Event.ENTER_FRAME,update);
 }
 public function resize(_)
 {
     if(vertical)
     {
     this.x = (-State.px + openfl.Lib.current.stage.stageWidth) * 1/App.scale - width;
     }else{
    this.x = sx + this.width;
    this.y = sy - this.height;
     }
 }
}

class ProfileIcon extends Button
{
    public var maskShape:Shape;
    public var outline:Shape;

    public function new(?x:Int=0,?y:Int=0,path:String="",size:Int=90,outlineColor:Int=0,lineSize:Int=4)
    {
        super(x,y,path,size,size);
        maskShape = new Shape();
        maskShape.graphics.beginFill();
        maskShape.graphics.drawCircle(width/2,width/2,width/2);
        maskShape.graphics.endFill();
        mask = maskShape;
        addChild(maskShape);
        //outline
        outline = new Shape();
        outline.graphics.lineStyle(lineSize,outlineColor);
        outline.graphics.drawCircle(width/2 ,width/2,width/2 - lineSize/2);
        outline.visible = false;
        addChild(outline);
    }
	
	override public function mouseDown(_) 
	{
		super.mouseDown(_);
		outline.visible = true;
        alpha = 1;
	}
	
    override public function mouseUp(_)
    {
		super.mouseUp(_);
        outline.visible = false;
    }
}

class NavigationBar extends Button
{
    public var pressedSelection:Int->Void;
    public var selections:Array<String> = new Array<String>();
    public var color:Int;
    public var lineColor:Int;
    public var textColor:Int;
    var barWidth:Int;
    var barHeight:Int;
    public function new(sy:Int=0,selectArray:Array<String>,setBarWidth:Int=160,setBarHeight:Int=80,setColor:Int=16777215,setLineColor:Int=0,setTextColor:Int=0)
    {
        super();
        y = sy;
        barWidth = setBarWidth;
        barHeight = setBarHeight;
        color = setColor;
        lineColor = setLineColor;
        textColor = setLineColor;
        selections = selectArray;
        create();
        //check if maxed scale
        if(width > App.setWidth)
        {
            var dif = scaleX/scaleY;
            scaleX = 1/width * App.setWidth;
            scaleY = scaleX * dif;
        }
        //center
    }
    public function create()
    {
        graphics.beginFill(color);
        graphics.lineStyle(lineColor);

         for(i in 0...selections.length)
        {
        var px = i * barWidth;
        graphics.drawRoundRect(i * barWidth,0,barWidth,barHeight,50,50);
        var text = App.createText(selections[i],px,Math.floor(barHeight/4),Math.floor(barHeight/2),0,openfl.text.TextFormatAlign.CENTER,barWidth);
        addChild(text);
        }
    }
    override public function mouseDown(_)
    {

    }
    override public function mouseUp(_)
    {

    }
}

class Dropdown extends Button
{
    public var pressedSelection:Int->Void;
    public var selections:Array<String> = new Array<String>();
    public var color:Int = 0;
    public var lineColor:Int = 0;
    public function new()
    {
        super();
    }
    override public function mouseDown(_)
    {

    }
    override public function mouseUp(_)
    {

    }
}

class Option extends Button
{
    public var type:Int = 0;
    public var list:Array<String> = new Array<String>();
    public var vertical:Bool;
    /**
    * Type 0 = Check box single select, Type 1 = Check box multi select , Type 2 = option single select, Type 3 = option multi select.
    **/
    public function new(setType:Int=0,?sx:Int=0,?sy:Int=0,array:Array<String>,setVertical:Bool=true)
    {
        type = setType;
        list = array;
        vertical = setVertical;
        super(sx,sy);
        switch(type)
        {
            case 0:
            for(i in 0...list.length)
            {
                
            }
        }
    }
    override public function mouseDown(_)
    {

    }
    override public function mouseUp(_)
    {

    }
}

class PageCounter extends Shape
{
    public var color:Int = 0;
    public var activeColor:Int = 0;
    public var size:Int = 20;
    public var spacing:Int = 10;
   @:isVar public var page(get,set):Int=0;
   function get_page():Int
   {
       return page;
   }
   function set_page(value:Int):Int
   {
       if(value < amount && value >= 0)
       {
       page = value;
       create();
       }
       return page;
   }
    public var amount:Int=0;
    public var transparency:Float = 1;

    public function new(?sx:Int=0,?sy:Int=0,pages:Int=3,setSie:Int=19,setSpacing:Int=17,setColor:Int=14607592,setAlpha=1,setActiveColor:Int=5921512,startPage:Int=0)
    {
        super();
        x = sx + Math.floor(size/2);y = sy;
        color = setColor;
        activeColor = setActiveColor;
        size = setSie;
        amount = pages;
        page = startPage;
        transparency = setAlpha;
        spacing = setSpacing;
    }
    private function create()
    {
        graphics.clear();
        for(i in 0...amount)
        {
        if(page == i)
        {
        graphics.beginFill(activeColor);
        graphics.drawCircle((size + spacing) * i,size/2,size/2);
        graphics.endFill();
        }else{
        graphics.beginFill(color,transparency);
        graphics.drawCircle((size + spacing) * i,size/2,size/2);
        graphics.endFill();
       }
        }
    }
}