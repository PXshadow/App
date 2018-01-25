package src.app;

//import motion.Actuate;
//import motion.actuators.GenericActuator;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Matrix;
import openfl.system.System;
import openfl.system.System.gc;
import src.app.App;
import src.app.Button;

/**
 * ...
 * @author 
 */
class State extends Sprite 
{
	private var initResize:Bool = true;
	//carry over between states
	/**
	 * State scale Y
	 */
	public static var sx:Float = 0;
	/**
	 * State scale Y
	 */
	public static var sy:Float = 0;
	/**
	 * State PosX
	 */
	public static var px:Int = 0;
	/**
	 * State PosY
	 */
	public static var py:Int = 0;
	/**
	 * Public refrence to App class 
	 */
	public var app:src.app.App;
	private var startState:Bool = false;
	/**
	 * Min and Max Camera Scroll Distances Defualt is no Restrictions
	 */
	public function new(minY:Int=0,maxY:Int=0,minX:Int=0,maxX:Int=0) 
	{
		super();
		//set camera restrict
		src.app.App.main.cameraMinY = -minY;
		src.app.App.main.cameraMaxY = -maxY;
		
		src.app.App.main.cameraMinX = -minX;
		src.app.App.main.cameraMaxX = -maxX;
		
		src.app.App.dragBool = false;
		
		Lib.current.stage.frameRate = 61;
		
		app = src.app.App.main;
		src.app.App.mouseDown = false;
		//add
		app.addChild(this);
		src.app.App.omX = mouseX;
		src.app.App.omY = mouseY;
		src.app.App.camY = 0;
		src.app.App.camX = 0;
		src.app.App.scrollSpeedY = 0;
		src.app.App.scrollSpeedX = 0;
		mouseEnabled = false;
	}
	/**
	 * Update State
	 */
	public function update()
	{
		if (initResize)
		{
			initResize = false;
			//set resize for init State
			if (sx > 0 && sy > 0) resize(px, py, sx, sy);
			if (src.app.App.inital) src.app.App.main.initalLoaded();
			
		}
	}
	/**
	 * State mouse/touch is Down
	 */
	public function mouseDown()
	{
		
	}
	/**
	 * State mouse/touch is UP
	 */
	public function mouseUp()
	{
		
	}
	/**
	 * Resize State used Internally 
	 */
	public function resize(prx:Int,pry:Int,ssx:Float, ssy:Float)
	{
		sx = ssx; sy = ssy;
		px = prx; py = pry;
		scaleX = sx;
		scaleY = sy;
		this.x = px;
		this.y = py;
	}
	/**
	 * Remove State
	 */
	public function remove()
	{
		for (i in 0...this.numChildren)
		{
			var child = getChildAt(i);
			if (Std.is(child, src.app.Button))
			{
			cast(child, src.app.Button).removeEvents();
			}
		}
		Lib.current.stage.frameRate = 60;
		Assets.cache.clear();
		src.app.App.main.removeChild(this);
		src.app.App.state = null;
	}
	/**
	 * Reset the State scaling
	 */
	public function resetState()
	{
		for (i in 0...this.numChildren)
		{
			var child = getChildAt(i);
			child.scaleX = 1;
			child.scaleY = 1;
			child.x /= src.app.App.scale;
			child.y /= src.app.App.scale;
		}
	}
	
	/*public function fadeOut(time:Float=1):GenericActuator<Dynamic>
	{
	this.alpha = 1;
	return Actuate.tween(this, time, {alpha:0});
	}
		public function fadeIn(time:Float=1):GenericActuator<Dynamic>
	{
	this.alpha = 0;
	return Actuate.tween(this, time, {alpha:1});
	}*/
}