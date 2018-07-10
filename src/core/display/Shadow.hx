package core.display;

import openfl.display.Shape;
import openfl.geom.Matrix;

class Shadow extends Shape
{
	public function new(sx:Int,sy:Int,setWidth:Int=0,alpha:Bool=true)
	{
		super();
		if (setWidth == 0) setWidth = App.setWidth;
		var mat = new Matrix();
		mat.createGradientBox(400,8,Math.PI/2);
		//16777215,9211020,10197915
		var alphaRatios:Array<Float> = [1, 1, 1];
		if (alpha) alphaRatios = [1,0.4,0];
		
		graphics.beginGradientFill(openfl.display.GradientType.LINEAR, [6579300,9211020, 16777215],alphaRatios, [0, 40, 255],mat);
		graphics.drawRect(0,0,setWidth,8);
		x = sx;
		y = sy;
		cacheAsBitmap = true;
	}
}