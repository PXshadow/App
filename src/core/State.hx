package core;

//import motion.Actuate;
//import motion.actuators.GenericActuator;
import haxe.Timer;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Matrix;
import openfl.system.System;
import openfl.system.System.gc;
import openfl.Lib;
import core.Item.ProfileIcon;

/**
 * ...
 * @author 
 */
class State extends DisplayObjectContainer
{
	/**
	 * Used internally for Resize Inital
	 */
	//public var initResize:Bool = true;
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
	public var app:App;
	/**
	 * If resize inital of stage has happened
	 */
	public var resizeBool:Bool = false;
	/**
	 * Min and Max Camera Scroll Distances Defualt is no Restrictions
	 */
	public function new(minY:Int=0,maxY:Int=0,minX:Int=0,maxX:Int=0) 
	{
		super();
		visible = false;
		//set camera restrict
		App.main.cameraMinY = -minY;
		App.main.cameraMaxY = -maxY;
		App.main.cameraMinX = -minX;
		App.main.cameraMaxX = -maxX;
		App.dragBool = false;
		Lib.current.stage.frameRate = 61;
		app = App.main;
		App.mouseDown = false;
		App.main.onResize = null;
		App.main.onMouseUp = null;
		//add
		app.addChild(this);
		App.omX = mouseX;
		App.omY = mouseY;
		App.camY = 0;
		App.camX = 0;
		App.scrollSpeedY = 0;
		App.scrollSpeedX = 0;
		mouseEnabled = false;
		//resize
		var tim = new Timer(1);
		tim.run = function()
		{
		resize(px, py, sx, sy);
		resizeBool = true;
		tim.stop();
		tim = null;
		}
	}
	/**
	 * Update State
	 */
	public function update()
	{
		
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
	 *  State Keyboard is Up
	 * @param	e Keyboard Event
	 */
	public function keyUp(e:openfl.events.KeyboardEvent)
	{
		
	}
	/**
	 *  State Keyboard is Down
	 * @param	e Keyboard Event
	 */
	public function keyDown(e:openfl.events.KeyboardEvent)
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
		for (i in 0...numChildren)
		{
			getChildAt(i).cacheAsBitmap = true;
		}
		visible = true;
	}
	/**
	 * Remove State
	 */
	public function remove()
	{
	//protect against null
	if (this != null)
	{
		Assets.cache.clear();
		App.main.removeChild(this);
		App.state = null;
	}
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
			child.x /= App.scale;
			child.y /= App.scale;
		}
	}
	/**
	 * Snapshots the state and creates a bitmap from it
	 * @return
	 */
	public function createScreenBitmap():Bitmap
	{
		var screen = new BitmapData(Math.floor(App.setWidth), Math.floor(App.setHeight), false);
		screen.draw(this);
		var data = new Bitmap(screen, null, true);
		data.scaleX = 1/scaleX;
		data.scaleY = 1/scaleY;
		return data;
	}
}