package core.display;
import motion.easing.Quint;
import openfl.display.Shape;

/**
 * ...
 * @author 
 */
class Pie extends Shape
{
	public var _color:UInt;
	public var radius:Float = 0;

	public function new(x:Float,y:Float,color:UInt,setSize:Float) 
	{
		_color = color;
		radius = setSize/2;
		super();
		this.x = x;
		this.y = y;
		//animate(1);
	}
	
	public function drawWedge(arc:Float,startAngle:Int=0,clear:Bool=true)
	{
	if(clear)graphics.clear();
	var startX:Int = 0;
	var startY:Int = 0;
	
   var segAngle:Float;
   var angle:Float;
   var angleMid:Float;
   var numOfSegs:Int;
   var ax:Float;
   var ay:Float;
   var bx:Float;
   var by:Float;
   var cx:Float;
   var cy:Float;
   
   graphics.beginFill(_color);

   // Move the pen.
   graphics.moveTo(startX, startY);

   // No need to draw more than 360.
   if (Math.abs(arc) > 360)
   {
      arc = 360;
   }

   numOfSegs = Math.ceil(Math.abs(arc) / 45);
   segAngle = arc / numOfSegs;
   segAngle = (segAngle / 180) * Math.PI;
   angle = (startAngle / 180) * Math.PI;

   // Calculate the start point.
   ax = startX + Math.cos(angle) * radius;
   ay = startY + Math.sin(angle) * radius;

   // Draw the first line.
   graphics.lineTo(ax, ay);

   // Draw the wedge.
   for (i in 0...numOfSegs)
   {
      angle += segAngle;
      angleMid = angle - (segAngle * .5);
      bx = startX + Math.cos(angle) * radius;
      by = startY + Math.sin(angle) * radius;
      cx = startX + Math.cos(angleMid) * (radius / Math.cos(segAngle * .5));
      cy = startY + Math.sin(angleMid) * (radius / Math.cos(segAngle * .5));
      graphics.curveTo(cx, cy, bx, by);
   }

   // Close the wedge.
   graphics.lineTo(startX, startY);
}
	
}