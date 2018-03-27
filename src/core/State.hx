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
import openfl.geom.Rectangle;
import openfl.system.System;
import openfl.system.System.gc;
import openfl.Lib;
import core.Item.ProfileIcon;
import openfl.text.TextField;

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
	 * If resize inital of stage has happened
	 */
	public var resizeBool:Bool = false;
	/**
	 * Min and Max Camera Scroll Distances Defualt is no Restrictions
	 */
	/**
	 *  Object that is below the entire state can be any display object
	 */
	public var background:DisplayObject;
	
	public function new(minY:Int=0,maxY:Int=0,minX:Int=0,maxX:Int=0) 
	{
		super();
		if (background != null)addChild(background);
		
		visible = false;
		//set camera restrict
		App.main.cameraMinY = -minY;
		App.main.cameraMaxY = -maxY;
		App.main.cameraMinX = -minX;
		App.main.cameraMaxX = -maxX;
		App.dragBool = false;
		App.main.backExit = false;
		App.dragRect = new Rectangle(0, 0,App.setWidth,App.setHeight);
		App.mouseDown = false;
		App.main.onResize = null;
		App.main.onMouseUp = null;
		App.main.maxEventX = null;
		App.main.maxEventY = null;
		App.main.minEventX = null;
		App.main.minEventY = null;
		if(App.network != null)App.network.onMessage = null;
		//add
		App.main.addChild(this);
		App.omX = mouseX;
		App.omY = mouseY;
		App.camY = 0;
		App.camX = 0;
		App.scrollSpeedY = 0;
		App.scrollSpeedX = 0;
		App.scrollBool = false;
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
	 * @param	e KeyboardEvent
	 */
	public function keyUp(e:openfl.events.KeyboardEvent)
	{
		
	}
	/**
	 *  State Keyboard is Down
	 * @param	e KeyboardEvent
	 */
	public function keyDown(e:openfl.events.KeyboardEvent)
	{
		
	}
	/**
	 * When Android back button, escape are pressed
	 * @param	e KeyboardEvent
	 */
	public function back(e:openfl.events.KeyboardEvent)
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
		if (!Std.is(getChildAt(i), openfl.display.Tilemap) 
		&&!Std.is(getChildAt(i), openfl.display.Bitmap) 
		//&& !Std.is(getChildAt(i), TextField)
		)getChildAt(i).cacheAsBitmap = true;
		}
		//background sizing
		if (background != null)
		{
		background.x = -State.px * 1 / App.scale;
		background.width = Lib.current.stage.stageWidth * 1 / App.scale;
		background.height = Lib.current.stage.stageHeight * 1 / App.scale;
		}
		visible = true;
		
		
		#if html5
		//trace("640 by 1136 | " + Std.string(App.setWidth * App.scale) + " by " + Std.string(App.setHeight * App.scale) + " -> " + js.Browser.window.innerWidth + " by " + js.Browser.window.innerHeight);
		#end
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