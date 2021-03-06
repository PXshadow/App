package core.display;
import openfl.display.Shape;
import openfl.geom.Matrix;
import openfl.display.GradientType;
/**
 * ...
 * @author 
 */
class ToggleSlider extends Button
{
    public var circle:Shape;
    public var toggle:Bool->Void;
    public var colorArray = [5131854,65280];
    public var rad:Int = 0;
    var trackDis:Int = 0;
	public var int:Int = 0;
	public function new(?sx:Int=0,?sy:Int=1,?size:Int=80,def:Bool=true)
 {
     super(sx, sy);
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
	 //create track
	 this.bool = def;
	 //set circle postion 
	 if (bool)
	 {
	 circle.x = trackDis; 
	 }else{
	 circle.x = 0;
	 }
	 createTrack();
	 Down = setDown;
 }

 public function createTrack()
 {
     graphics.clear();
     var color:Int = 0;
     //color
     if(!bool)color = colorArray[0];
     if(bool)color = colorArray[1];
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
 
 public function setDown(_)
 {
trace("down");
if(bool)
{
circle.x = 0;
}else{
circle.x = trackDis;
}
bool = !bool;
createTrack();
if(toggle != null)toggle(bool);
}

}