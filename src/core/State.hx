package core;

//import motion.Actuate;
//import motion.actuators.GenericActuator;
import haxe.Timer;
import haxe.ds.Vector;
import motion.easing.Expo;
import motion.easing.Quad;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.system.System;
import openfl.Lib;
import openfl.text.TextField;
import motion.Actuate;

/**
 * ...
 * @author 
 */
class State extends DisplayObjectContainer
{
	//old state bitmap
	public static var pastBitmap:Bitmap;
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
	//variable used to check for Animation of state between resize call
	public var occupied:Bool = false;
	
	//old mouse postions
	public var omY:Float = 0;
	public var omX:Float = 0;
	//CameraScroll
	public var cameraMinY:Float = 0;
	public var cameraMaxY:Float = 0;
	public var cameraMinX:Float = 0;
	public var cameraMaxX:Float = 0;
	
	public var maxEventY:Void->Void;
	public var minEventY:Void->Void;
	public var maxEventX:Void->Void;
	public var minEventX:Void->Void;
	
	//if camera is scrolling used to have buttons not go off during
	public var scrollPress:Bool = false;
	//start postion of scroll
	public var scrollBool:Bool = false;
	public var slideBool:Bool = false;
	public var dragBool:Bool = true;
	public var dragSlideBool:Bool = true;
	public var moveBool:Bool = false;
	public var dragRect:Rectangle;
	public var mouseDownBool:Bool = false;
	public var camY:Float = 0;
	public var camX:Float = 0;
	//start posistion
	public var spY:Int = 0;
	public var spX:Int = 0;
	//y
	public var scrollSpeed:Float = 0;
	public var slideSpeed:Float = 0;
	//x
	public var scrollDuration:Int = 0;
	public var slideDuration:Int = 0;
	
	private var restrictInt:Int = 0;
	public var scrollInt:Int = 0;
	public var slideInt:Int = 0;
	
	public var vectorY:Vector<Float>;
	public var vectorX:Vector<Float>;
	public static var prev:String = "";
	private var animate:Animation;
	
	public function new(minY:Int=0,maxY:Int=0,minX:Int=0,maxX:Int=0,animation:Animation=Animation.NONE) 
	{
		super();
		@:privateAccess __removeAllListeners();
		//set animation
		animate = animation;
		animation = null;
		//set camera restriction
		cameraMinY = -minY;
		cameraMaxY = -maxY;
		cameraMinX = -minX;
		cameraMaxX = -maxX;
	    dragBool = false;
		dragSlideBool = false;
		App.screen.backExit = false;
		mouseDownBool = false;
		maxEventY = null;
		minEventY = null;
		if(App.network != null)App.network.onMessage = null;
		omY = mouseY;
		vectorY = null;
		vectorX = null;
		camY = 0;
		scrollSpeed = 0;
		moveBool = false;
		scrollBool = false;
		mouseEnabled = false;
		//drag not possible
		dragRect = null;
		//render
		addEventListener(Event.ENTER_FRAME, render);
	}
	
	private function render(_)
	{
		animation();
		resize();
		removeEventListener(Event.ENTER_FRAME, render);
	}
	private function animation()
	{
		App.main.addChild(this);
		if (pastBitmap == null) return;
		occupied = true;
		App.main.addChild(pastBitmap);
		switch(animate)
		{
			case Animation.FADEIN:

			case Animation.SLIDELEFT:
			x = pastBitmap.width + State.px;
			Actuate.tween(App.main, 0.6, {x:-pastBitmap.width - State.px}).ease(Quad.easeInOut).onComplete(function(_)
			{
				completeAnimation();
			});
			case Animation.SLIDERIGHT:
			x = -(pastBitmap.width + State.px);
			Actuate.tween(App.main, 0.6, {x:pastBitmap.width + State.px}).ease(Quad.easeInOut).onComplete(function(_)
			{
				completeAnimation();
			});
			case Animation.SLIDEUP:
			y = (pastBitmap.height + State.py);
			Actuate.tween(App.main, 0.6, {y:-pastBitmap.height - State.py}).ease(Quad.easeInOut).onComplete(function(_)
			{
				completeAnimation();
			});
			case Animation.SLIDEDOWN:
			y = -(pastBitmap.height + State.py);
			Actuate.tween(App.main, 0.6, {y:pastBitmap.height + State.py}).ease(Quad.easeInOut).onComplete(function(_)
			{
				completeAnimation();
			});
			default:
			completeAnimation();
		}
	}
	private function completeAnimation()
	{
		if(!App.main.contains(this)) App.main.addChild(this);
		occupied = false;
		App.main.removeChild(pastBitmap);
		pastBitmap = null;
		App.main.x = 0;
		App.main.y = 0;
		x = 0;
		y = 0;
	}
	public function moveCamera(dx:Float =0, dy:Float =0,frameX:Int=0,frameY:Int=0)
	{
		var disX:Float = 0;
		var disY:Float = 0;
		disX = dx;
		disY = dy;
		mouseDownBool = false;
		scrollDuration = Math.floor(Math.max(frameX, frameY));
		scrollSpeed = Math.floor(disY / frameY);
		scrollInt = 0;
		moveBool = true;
		scrollBool = false;
	}
	
	public function scrollCamera()
	{
		//1950 / (1000 / 60) = 117;
		if (dragBool && !moveBool && !occupied)
		{
			if (Math.abs(spY - App.state.mouseY) < 5) scrollPress = true;
			mouseDownBool = false;
			scrollDuration = 117;
			if (Math.abs(scrollSpeed) > 0 && Math.abs(scrollSpeed) < 70) scrollDuration = 80;
			//speed limiter
			var limit = 140;
			if (scrollSpeed > limit) scrollSpeed = limit;
			if (scrollSpeed < -limit) scrollSpeed = -limit;
			vectorY = velocityVector(scrollDuration, scrollSpeed);
			scrollSpeed = 0;
			scrollBool = true;
			scrollInt = 0;
			scrollDuration += -1;
		}
	}
	
	public function slideCamera()
	{
		if (dragSlideBool && !moveBool && !occupied)
		{
			mouseDownBool = false;
			if (Math.abs(spX - mouseX) > 5) scrollPress = true;
			scrollPress = true;
			slideDuration = 117;
			if (Math.abs(slideSpeed) > 0 && Math.abs(slideSpeed) < 70) slideDuration = 80;
			//speed limiter
			var limit = 140;
			if (slideSpeed > limit) slideSpeed = limit;
			if (slideSpeed < -limit) slideSpeed = -limit;
			vectorX = velocityVector(slideDuration, slideSpeed);
			slideSpeed = 0;
			slideBool = true;
			slideInt = 0;
			slideDuration += -1;
		}
	}
	
	public function velocityVector(length:Int, velocity:Float):Vector<Float>
	{
		var vector = new Vector<Float>(length);
		for (i in 0...length)
		{
			velocity *= 0.95;
			vector[i] = velocity;
		}
		return vector;
	}
	public function easeVector(distance:Float):Vector<Float>
	{
		var ease:Array<Float> = [0.05,0.05,0.15,0.15,0.1,0.1, 0.1,0.1, 0.05,0.05, 0.035,0.035,0.015,0.015];
		var vector = new Vector<Float>(ease.length);
		for (i in 0... ease.length)
		{
			vector[i] =  ease.pop() * distance;
		}
		return vector;
	}
	
	
	/**
	 * Update State
	 */
	public function loop(elapsed:Float)
	{
		
	//if move turn off mouseDown
	if (moveBool) mouseDownBool = false;
	//drag and scroll
	if (mouseDownBool)
	{
		scrollSpeed = (mouseY - omY) * elapsed;
		slideSpeed = (mouseX - omX) * elapsed;
		
	}else{
	if (scrollBool || moveBool)
	{
	if(scrollBool)scrollSpeed = vectorY[scrollInt];
	if (scrollInt >= scrollDuration)
	{
	scrollBool = false;
	scrollSpeed = 0;
	moveBool = false;
	vectorY = null;
	}else{
	scrollInt++;
	}
	}
	
	if (slideBool)
	{
		slideSpeed = vectorX[scrollInt];
		if (slideInt >= slideDuration)
		{
			slideBool = false;
			slideSpeed = 0;
			vectorX = null;
		}else{
			slideInt++;
		}
	}
	
	}
	
		if (App.network != null) App.network.update();
		
		//SEND OUT restrict events
		if (restrictInt > 0)
		{
			switch(restrictInt)
			{
				case 1:
				if(minEventY != null)minEventY();
				case 2:
				if (maxEventY != null) maxEventY();
				case 3:
				if (minEventX != null) minEventX();
				case 4:
				if (maxEventX != null) maxEventX();
			}
			//disable movement temp
			scrollBool = false;
			slideBool = false;
			moveBool = false;
			scrollSpeed = 0;
			slideSpeed = 0;
			//reset restrict
			restrictInt = 0;
		}
		
		//RESTRICT Y
		if (camY + scrollSpeed > cameraMinY && scrollSpeed > 0)
		{
		scrollSpeed = -camY + cameraMinY;
		restrictInt = 1;
		}
		if (camY + scrollSpeed < cameraMaxY && scrollSpeed < 0)
		{
		scrollSpeed = -camY + cameraMaxY;
		restrictInt = 2;
		}
		
		if (dragSlideBool)
		{
		//RESTRICT X
		if (camX + slideSpeed > cameraMinX && slideSpeed > 0)
		{
			slideSpeed = -camX + cameraMinX;
			restrictInt = 3;
		}
		if (camX + slideSpeed < cameraMaxX && slideSpeed < 0)
		{
			slideSpeed = -camX + cameraMaxX;
			restrictInt = 4;
		}
		}
		//speed
		camY += scrollSpeed;
		camX += slideSpeed;
		update();
		omY = mouseY;
		omX = mouseX;
	}
	public function update()
	{
		
	}
	
	public function enableCameraMovement()
	{
		dragBool = true;
	}
	public function disableCameraMovment()
	{
		dragBool = false;
		scrollBool = false;
		scrollDuration = 0;
		scrollSpeed = 0;
		moveBool = false;
	}
	
	/**
	 * State mouse/touch is Down
	 */
	public function mouseDown()
	{
		if(occupied) return;
		if (dragRect == null || App.pointRect(mouseX, mouseY, dragRect))
		{
			scrollPress = false;
			mouseDownBool = true;
			spY = Math.round(mouseY);
			omY = spY;
			spX = Math.round(mouseX);
			omX = spX;
		}
	}
	/**
	 * State mouse/touch is UP
	 */
	public function mouseUp()
	{
		if(occupied) return;
		mouseDownBool = false;
	}
	/**
	 *  State Keyboard is Up
	 * @param	e KeyboardEvent
	 */
	public function keyUp(e:KeyboardEvent)
	{
		
	}
	/**
	 *  State Keyboard is Down
	 * @param	e KeyboardEvent
	 */
	public function keyDown(e:KeyboardEvent)
	{
		
	}
	/**
	 *  State mouse wheel
	 * @param	e
	 */
	public function mouseWheel(e:MouseEvent)
	{
		moveCamera(0, e.delta, 0, 5);
	}
	public function mouseWheelDown(e:MouseEvent)
	{
		mouseDown();
	}
	public function mouseWheelUp(e:MouseEvent)
	{
		mouseUp();
	}
	public function mouseRightDown(e:MouseEvent)
	{
		
	}
	public function mouseRightUp(e:MouseEvent)
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
	public function resize()
	{
		if (App.state != this) return;
	}
	/**
	 * Remove State
	 */
	public function remove()
	{
	//protect against non main state getting removed
	if (this != App.state) throw("This state is not equal to App.state please set it to that in order to properly use the state");
	//protect against null
	if (this != null)
	{
		//take screenshot of last state for animations
		pastBitmap = createScreenBitmap();
		//set prev
		prev = App.getStateName();
		//Assets.cache.clear();
		App.main.removeChild(this);
		App.state = null;
		//input text focus out
		#if mobile
		nativetext.NativeTextField.returnKey = null;
		nativetext.NativeTextField.focusOut = null;
		nativetext.NativeTextField.focusIn = null;
		nativetext.NativeTextField.change = null;
		#end
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
	
	public function setHeader(obj:DisplayObject,widthBool:Bool=true,yBool:Bool=true)
	{
		if (App.state == this)
		{
			if (yBool) obj.y = -py * 1/App.scale;
			obj.x = -px * 1/App.scale;
			if (widthBool) obj.width = Lib.current.stage.stageWidth * 1 / App.scale;
		}
	}
	public function setStage(obj:DisplayObject)
	{
		if(App.state == this)
		{
			obj.x = -px * 1/App.scale;
			obj.y = -py * 1/App.scale;
			obj.width = Lib.current.stage.stageWidth * 1 / App.scale;
			obj.height = Lib.current.stage.stageHeight * 1 / App.scale;
		}
	}
	
	/**
	 * Snapshots the state and creates a bitmap from it
	 * @return
	 */
	public function createScreenBitmap(background:UInt=0xFFFFFF):Bitmap
	{
		var screen = new BitmapData(Math.floor(App.setWidth), Math.floor(App.setHeight), false,background);
		var mat = new Matrix();
		screen.draw(this,mat,null,null,null,true);
		var data = new Bitmap(screen, null, true);
		return data;
	}
}