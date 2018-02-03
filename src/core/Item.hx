package core;
import core.Button;
import openfl.display.GradientType;
import openfl.display.SpreadMethod;
import openfl.geom.Matrix;
import openfl.display.Shape;
import openfl.events.MouseEvent;

class Item 
{

}

class ToggleSlider extends Button
{
    public var circle:Shape;
    public var track:Shape;
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
       //track
     track = new Shape();
     createTrack();
     addChild(track);
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
     //set track distance
     trackDis = Math.floor(rad * 2);
 }

 public function createTrack()
 {
     track.graphics.clear();
     var color:Int = 0;
     //color
     if(!toggleBool)color = colorArray[0];
     if(toggleBool)color = colorArray[1];
      track.graphics.lineStyle(1,13158600);
     //add circles to both side
     track.graphics.beginFill(color);
     track.graphics.drawCircle(-2 + rad,-2 + rad,rad + 2);
     track.graphics.beginFill(color);
     track.graphics.drawCircle(rad * 3,-2 + rad,rad + 2);
     //rect
     track.graphics.beginFill(color);
     track.graphics.drawRect(-2 + rad,- 4,rad * 2 + 2,rad * 2 + 4);
     //create line
    track.graphics.lineStyle(4,color);
    track.graphics.moveTo(-2 + rad,-1);track.graphics.lineTo(-2 + rad,rad * 2 - 3);
    track.graphics.lineStyle(4,color);
    track.graphics.moveTo(rad * 3,-1);track.graphics.lineTo(rad * 3,rad * 2 - 3);
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
     public function new(?x:Int=0,?y:Int=0,scale:Float=1)
 {
     super(x,y);
     var setWidth:Int = Math.floor(scale * 20);
     var setHeight:Int = Math.floor(scale * 40);
    var matrix:Matrix = new Matrix();  
    matrix.createGradientBox(setWidth,setHeight,0,0,0); 
    graphics.beginGradientFill(GradientType.RADIAL,[0,0],[1,0.1],[0,255],matrix);
    graphics.drawRoundRect(0,0,setWidth,setHeight,50,50);
    graphics.endFill();
 }

}
class ProfileIcon extends Button
{
    public var maskShape:Shape;
    public var outline:Shape;

    public function new(?x:Int=0,?y:Int=0,path:String="",size:Int=90,outlineColor:Int=0)
    {
        super(x,y,path,size,size);
        var line:Int = 4;
        maskShape = new Shape();
        maskShape.graphics.beginFill();
        maskShape.graphics.drawCircle(width/2,width/2,width/2);
        maskShape.graphics.endFill();
        mask = maskShape;
        addChild(maskShape);
        //outline
        outline = new Shape();
        outline.graphics.lineStyle(line,outlineColor);
        outline.graphics.drawCircle(width/2 ,width/2,width/2 - line/2);
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

class PageCounter extends Button
{
    public var color:Int = 0;
    public var activeColor:Int = 0;
    public var size:Int = 20;
    public var spacing:Int = 10;
    public var page:Int=0;
    public var amount:Int=0;
    public var transparency:Float = 1;

    public function new(?x:Int=0,?y:Int=0,pages:Int=3,setSie:Int=19,setSpacing:Int=17,setColor:Int=14607592,setAlpha=1,setActiveColor:Int=5921512,startPage:Int=0)
    {
        super(x + Math.floor(size/2),y);
       // color = setColor;
        color = setColor;
        activeColor = setActiveColor;
        size = setSie;
        amount = pages;
        page = startPage;
        transparency = setAlpha;
        spacing = setSpacing;

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